import 'package:html/dom.dart';

import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

/// Model wrapper for the
/// html content related to the markdown content
class MdDocument {
  final String html;

  MdDocument({
    required this.html,
  });
}

@JsonSerializable()
class Metadata {
  final String longTitle;
  final String name;
  final String description;
  final String lastModified;
  final String image;
  final String post;
  final String googleUA;

  Metadata({
    required this.longTitle,
    required this.name,
    required this.description,
    required this.lastModified,
    required this.image,
    required this.post,
    required this.googleUA,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

/// Model related to
/// [google codelab definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab.html)
class Codelab {

  // Metadata read in the file as String
  final Metadata metadata;

  /// Codelab title
  final String title;

  /// Steps of the codelab
  final List<Step?> steps;

  /// Total minutes
  final int minutes;

  Codelab({
    required this.metadata,
    required this.title,
    required this.steps,
    required this.minutes,
  });

  @override
  String toString() => """
  {
    "metadata": "$metadata",
    "title": "$title",
    "steps": $steps
  }
  """;
}

/// Model related to
/// [google codelab step definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab-step.html).
class Step {
  final int order;

  /// Title of this step.
  final String label;

  /// How long, on average in minutes, it takes to complete the step.
  int minutes;

  /// Indicate if it is the last of the codelab.
  final bool isLast;

  /// The content as HTMLElement
  final Element content = Element.html("<br/>");

  Step({
    required this.order,
    required this.label,
    required this.isLast,
    this.minutes = 0,
  });

  @override
  String toString() => """
  {
    "order": "$order",
    "label": "$label",
    "minutes": "$minutes",
    "content": "${content.innerHtml}",
    "isLast": "$isLast",
  }
""";
}
