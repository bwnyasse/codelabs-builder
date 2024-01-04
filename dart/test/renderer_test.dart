import 'package:codelabs_builder/models.dart';
import 'package:test/test.dart';
import 'package:html/dom.dart';
import 'package:codelabs_builder/renderer.dart';

void main() {
  group('Codelab Renderer Tests', () {
    late Codelab testCodelab;

    setUp(() {
      // Initialize test data for Codelab
      var metadata = Metadata(
          longTitle: "Test Codelab Long Title",
          name: "test-codelab",
          description: "A test codelab description.",
          lastModified: "2023-01-01",
          image: "test_image.png",
          post: "test_post",
          googleUA: "UA-12345678-1");

      var step1 = Step(
        order: 1,
        label: "Introduction",
        isLast: false,
        minutes: 10,
      )..content.append(Element.html("<p>Step 1 content</p>"));

      var step2 = Step(
        order: 2,
        label: "Conclusion",
        isLast: true,
        minutes: 5,
      )..content.append(Element.html("<p>Step 2 content</p>"));

      testCodelab = Codelab(
          metadata: metadata,
          title: "Test Codelab",
          steps: [step1, step2],
          minutes: 15);
    });

    test('renderContent generates correct step HTML', () {
      var result = renderContent(testCodelab);
      expect(result, contains('<google-codelab codelab-title="Test Codelab">'));
      expect(result, contains('<google-codelab-step label="Introduction"'));
      // Further checks for the steps content
    });

    test(
        'render generates full HTML document with correct metadata and content',
        () {
      var result = render(testCodelab);
      expect(result, contains('<!doctype html>'));
      expect(result, contains('<html>'));
      expect(result, contains('<head>'));
      expect(result, contains('<title>Test Codelab Long Title</title>'));
      expect(result, contains('<body>'));
      expect(result, contains('google-codelab-step'));
      // Further checks for meta tags, scripts, and other parts of the document
    });

  });
}
