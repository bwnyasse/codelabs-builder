library io;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:logging/logging.dart';
import 'models.dart';

final log = Logger('codelabs-builder:io');

bool _isSupportedFiles(String entry) => _isMd(entry) || _isConfigFile(entry);

bool _isMd(String entry) => entry.endsWith(".md");

bool _isConfigFile(String entry) =>
    (entry == 'config.yaml' || entry == 'config.yml');

Future<File> writeToDocument(String filename, String content) =>
    File(filename).writeAsString(content, encoding: utf8);

/* 
 * List inputs [ .md ] files for a given [path]
 * and retrieve their full path
 */
Future<List<String>> listInputFiles(String path) async {
  final directory = Directory(path);
  final exist = await directory.exists();
  if (!exist) {
    log.log(Level.SEVERE, "Directory with path $path does not exist");
    return [];
  }
  return directory
      .listSync(recursive: false, followLinks: false)
      .where((entity) => _isSupportedFiles(entity.path))
      .map((entity) => entity.path)
      .toList();
}

/// Read the content [inputFile] of the supported input file
/// and retrieve a document model
Future<MdDocument> read(String inputFile) async {
  final content = await File(inputFile).readAsString(encoding: utf8);
  final asHtml = markdownToHtml(content, inlineSyntaxes: [
    InlineHtmlSyntax(),
  ], blockSyntaxes: [
    const TableSyntax(),
    const FencedCodeBlockSyntax(),
  ]);
  return MdDocument(html: asHtml);
}
