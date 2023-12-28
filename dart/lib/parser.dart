import 'dart:convert';

import 'package:html/parser.dart' as html5parser;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:yaml/yaml.dart';
import 'models.dart';

const String metadata = "metadata";
const String duration = "duration";
const String alterSuccess = "alert-success";
const String alterInfo = "alert-info";
const String alterWarning = "alert-warning";
const String alterDanger = "alert-danger";

/// Check if the given [node] is a metadata
bool isMetadata(Element node) => node.localName == metadata;

/// Check if the given [node] is a duration
bool isDuration(Element node) => node.localName == duration;

/// Check if the given [node] is an info success
bool isAlertSuccess(Element node) => node.localName == alterSuccess;

/// Check if the given [node] is an info alert
bool isAlertInfo(Element node) => node.localName == alterInfo;

/// Check if the given [node] is a warning alert
bool isAlertWarning(Element node) => node.localName == alterWarning;

/// Check if the given [node] is a danger alert
bool isAlertDanger(Element node) => node.localName == alterDanger;

/// Get the define duration (H:mm) form the given [innerHtml] in minutes
int toMinute(String innerHtml) {
  final format = DateFormat("H:mm");
  final datetime = format.parse(innerHtml.trim());

  return datetime.hour * 60 + datetime.minute;
}

/// Get the define metadata form the given [innerHtml]
String toMetadata(String innerHtml) => innerHtml.trim();

enum AlertType { success, info, warning, danger }

/// Get the defined alert from a given [innerHtml] and [alertType]
String toAlert(AlertType alertType, String innerHtml) {
  String alertClass, title, iconClass;

  switch (alertType) {
    case AlertType.success:
      alertClass = "alert-success";
      title = "Success";
      iconClass = "oi-check";
      break;
    case AlertType.info:
      alertClass = "alert-primary";
      title = "Note";
      iconClass = "oi-info";
      break;
    case AlertType.warning:
      alertClass = "alert-warning";
      title = "Warning";
      iconClass = "oi-warning";
      break;
    case AlertType.danger:
      alertClass = "alert-danger";
      title = "Important";
      iconClass = "oi-fire";
      break;
  }

  return """
    <div class="alert $alertClass flexbox-it" role="alert">
      <div><span title="$title" class="oi $iconClass oi-custom"></span></div>
      <div>$innerHtml</div>
    </div>
  """;
}

///
/// Valid metadata are the one with the following value
/// - id [String] (required) (auto-generated) : will be the name of the file without extension
/// - minutes [String] (required) (auto-generated)
/// - name [String] (required) (fill by the codelab creator)
/// - description [String] (required) (fill by the codelab creator)
/// - emails [array] (optional to restrict the access of the codelabs to users with theses emails)
///
/// If the metadata is valid, return the corresponding [map]
Metadata validateMetadata({
  required String outputFile,
  required YamlMap metadata,
}) {
  if (quiver_strings.isEmpty(outputFile)) {
    throw FormatException("No outputfile value found to parse file metadata ");
  }
  String asJson = json.encode(metadata.value);
  return Metadata.fromJson(json.decode(asJson));
}

/// Parse the given [htmlContent] to a codelab
Codelab parse(String htmlContent, String outputFileName) {
  final body = html5parser.parse(htmlContent).body;
  final h1Element = body?.querySelector("h1");
  if (h1Element == null) {
    throw FormatException(
        "no H1 head find to generate file $outputFileName. You must provide one !");
  }

  final title = h1Element.innerHtml;
  final stepSize = body?.querySelectorAll("h2").length;

  int index = 0;
  Step? currentStep;
  List<Step?> steps = [];
  String metadataAsString = "";

  body?.nodes.forEach((node) {
    if (node is Element) {
      if (isMetadata(node)) {
        metadataAsString = toMetadata(node.innerHtml);
      } else {
        //
        // H2 == New Step
        //
        if (node.localName == "h2") {
          index++;

          currentStep = Step(
            order: index,
            label: node.innerHtml,
            isLast: index == stepSize,
          );

          steps.add(currentStep);

          //
          // Nodes for the current Step
          //
        } else if (currentStep != null) {
          if (isDuration(node)) {
            currentStep?.minutes = toMinute(node.innerHtml);
          } else {
            // alert success
            if (isAlertSuccess(node)) {
              node.innerHtml = toAlert(AlertType.success, node.innerHtml);
            }
            // alert info
            if (isAlertInfo(node)) {
              node.innerHtml = toAlert(AlertType.info, node.innerHtml);
            }
            // alert warning
            if (isAlertWarning(node)) {
              node.innerHtml = toAlert(AlertType.warning, node.innerHtml);
            }
            // alert danger
            if (isAlertDanger(node)) {
              node.innerHtml = toAlert(AlertType.danger, node.innerHtml);
            }

            //
            // Populate content of the current step
            //
            currentStep?.content.append(node.clone(true));
          }
        }
      }
    }
  });

  const initialValue = 0;

  final totalMinutes =
      steps.fold(initialValue, (curr, next) => curr + (next?.minutes ?? 0));

  final validMetadata = validateMetadata(
    outputFile: outputFileName,
    metadata: loadYaml(metadataAsString),
  );
  return Codelab(
    metadata: validMetadata,
    title: title,
    steps: steps,
    minutes: totalMinutes,
  );
}
