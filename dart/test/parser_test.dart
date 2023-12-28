import 'package:codelabs_builder/models.dart';
import 'package:test/test.dart';
import 'package:codelabs_builder/parser.dart';
import 'package:yaml/yaml.dart'; // Adjust the import path as needed

void main() {
  group('Utility Functions', () {
    test('toMinute correctly converts time string to minutes', () {
      expect(toMinute('1:30'), equals(90));
      expect(toMinute('0:15'), equals(15));
    });

    test('validateMetadata returns Metadata for valid input', () {
      String outputFile = 'test_output';
      YamlMap validMetadataYaml = loadYaml('''
        longTitle: "Example Long Title"
        name: "Example Name"
        description: "This is an example description."
        lastModified: "2023-01-01"
        image: "example_image.png"
        post: "example_post"
        googleUA: "UA-12345678-1"
      ''');

      Metadata result =
          validateMetadata(outputFile: outputFile, metadata: validMetadataYaml);

      expect(result, isA<Metadata>());
      expect(result.longTitle, equals("Example Long Title"));
      expect(result.name, equals("Example Name"));
      expect(result.description, equals("This is an example description."));
      expect(result.lastModified, equals("2023-01-01"));
      expect(result.image, equals("example_image.png"));
      expect(result.post, equals("example_post"));
      expect(result.googleUA, equals("UA-12345678-1"));
      // Validate other properties as needed
    });

    test('validateMetadata throws FormatException for empty outputFile', () {
      YamlMap validMetadataYaml = loadYaml('''
        longTitle: "Example Long Title"
        name: "Example Name"
        description: "This is an example description."
        lastModified: "2023-01-01"
        image: "example_image.png"
        post: "example_post"
        googleUA: "UA-12345678-1"
      ''');

      expect(
          () => validateMetadata(outputFile: '', metadata: validMetadataYaml),
          throwsFormatException);
    });
  });

  group('HTML Parsing', () {
    test('parse successfully parses valid HTML content into Codelab', () {
      String htmlContent = '''
<metadata>
longTitle: "Test Codelab"
name: "test-codelab"
description: "A test codelab to demonstrate functionality."
lastModified: "2023-01-01"
image: "test_image.png"
post: "test_post"
googleUA: "UA-12345678-1"
</metadata>

<h1 id="introduction-to-test-codelab">Introduction to Test Codelab</h1>
<p>This is an introductory paragraph for the test codelab.</p>
<h2 id="step-1-initial-step">Step 1: Initial Step</h2>
<p>Content for the first step of the test codelab.</p>
<h2 id="step-2-next-step">Step 2: Next Step</h2>
<p>Content for the second step of the test codelab.</p>
    ''';

      String outputFileName = 'test_output';
      final result = parse(htmlContent, outputFileName);

      expect(result, isA<Codelab>());
      expect(result.metadata.longTitle, equals("Test Codelab"));
      expect(result.metadata.name, equals("test-codelab"));
      expect(result.metadata.description,
          equals("A test codelab to demonstrate functionality."));
      expect(result.metadata.lastModified, equals("2023-01-01"));
      expect(result.metadata.image, equals("test_image.png"));
      expect(result.metadata.post, equals("test_post"));
      expect(result.metadata.googleUA, equals("UA-12345678-1"));

      expect(result.title, equals("Introduction to Test Codelab"));
      expect(result.steps.length, equals(2));
      expect(result.steps[0]?.label, equals("Step 1: Initial Step"));
      expect(result.steps[1]?.label, equals("Step 2: Next Step"));
      // Further detailed checks on the content of steps can be added
    });

    // Add more tests as needed
  });
}
