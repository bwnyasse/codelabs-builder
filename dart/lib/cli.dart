import 'dart:async';

import 'package:logging/logging.dart';
import 'package:path/path.dart';

import 'io.dart' as io show listInputFiles, writeToDocument, read;
import 'models.dart';
import 'parser.dart' as parser show parse;
import 'renderer.dart' as renderer show render;

final log = Logger('builder:cli');

// Execute the process  for the given [inputPath] and the given [outputPath]
// And generate a md.json file that represents all the .md files that have been process
Future<void> run({
  required String inputPath,
  required String outputPath,
}) async {
  final inputFiles = await io.listInputFiles(inputPath);

  await Future.wait(
      inputFiles.map((file) => _processFile(file, outputPath)));

}


Future<Metadata> _processFile(
  String inputFile,
  String outputPath,
) async {
  final outputFileName = getOutputFile(inputFile);
  final mdDocument = await io.read(inputFile);
  final codelab = parser.parse(mdDocument.html, outputFileName);
  final renderedAsHtml = renderer.render(codelab);

  final outputFilePath = getOutputFilePath(inputFile, outputPath);

  final file = await io.writeToDocument(outputFilePath, renderedAsHtml);
  if (await file.exists()) {
    log.log(Level.SEVERE, "No generate file for $outputFilePath");
  }

  return codelab.metadata;
}

String getOutputFilePath(
  String inputFile,
  String outputPath,
) =>
    outputPath + "/" + getOutputFile(inputFile);

String getOutputFile(
  String inputFile,
) =>
    basename(inputFile).replaceAll(".md", "") + ".html";
