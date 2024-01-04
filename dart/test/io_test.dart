import 'package:test/test.dart';
import 'package:codelabs_builder/io.dart'; // adjust the import path as needed
import 'dart:io';

import 'package:path/path.dart' as path;

void main() {
  group('Listing Input Files', () {
    test('Lists only supported files in a directory', () async {
      // Assuming your test directory is structured as follows:
      // test/
      //   io_test.dart
      //   input/
      //     fake.mo
      //     test.md

      // Construct the path to the test input directory
      var testInputDir = path.join(Directory.current.path, 'test', 'input');

      var result = await listInputFiles(testInputDir);

      // Verify that the result contains only 'test.md'
      expect(result, contains(path.join(testInputDir, 'test.md')));

      // Verify that the result does not contain 'fake.mo'
      expect(result, isNot(contains(path.join(testInputDir, 'fake.mo'))));

      // Optionally, check the length of the result
      expect(result.length, equals(1));
    });
  });

  // Other test groups

  group('File Writing', () {
    test('Writes content to a file', () async {
      var testFilename = 'test_output.txt';
      await writeToDocument(testFilename, 'Test Content');

      var file = File(testFilename);
      expect(await file.exists(), isTrue);
      expect(await file.readAsString(), 'Test Content');

      await file.delete(); // Cleanup
    });
  });


  group('Reading Markdown Files', () {
    test('Correctly reads and converts Markdown to HTML', () async {
      // Create a test Markdown file

      // Call read function and verify the HTML output
    });
  });

  // Add more tests as needed
}
