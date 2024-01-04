
import 'models.dart';

String renderContent(Codelab codelab) {
  StringBuffer buffer = StringBuffer();

  buffer.write("<google-codelab codelab-title=\"${codelab.title}\">");

  codelab.steps.forEach((step) {
    buffer.write(
        """<google-codelab-step label="${step?.label}" duration="${step?.minutes}">${step?.content.innerHtml.toString()}</google-codelab-step>""");
  });

  buffer.write("</google-codelab>");
  return buffer.toString();
}

//
// Render Document  given the [title] and the [content]
// and return the document according to the inspiration from google codelabs
// https://github.com/googlecodelabs/tools/tree/master/codelab-elements
//
String render(Codelab codelab) => 
    '''
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, minimum-scale=1.0,initial-scale=1.0, user-scalable=yes">
<title>${codelab.metadata.longTitle}</title>

<meta name="title" content="${codelab.metadata.name}"/>
<meta name="description" content="${codelab.metadata.description}"/>

<meta name="twitter:card" content="summary"/>
<meta name="twitter:title" content="${codelab.metadata.name}"/>
<meta name="twitter:description" content="${codelab.metadata.description}"/>
<meta property="twitter:image" content="${codelab.metadata.image}">
<meta property="og:title" content="${codelab.metadata.name}"/>
<meta property="og:description" content="${codelab.metadata.description}"/>
<meta property="og:type" content="article" />
<meta property="og:url" content="${codelab.metadata.post}">
<meta property="article:modified_time" content="${codelab.metadata.lastModified}" />
<meta property="og:site_name" content="Title" />
<meta property="og:image" content="${codelab.metadata.image}">

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="robots" content="index,follow">

<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Code+Pro:400|Roboto:400,300,400italic,500,700|Roboto+Mono">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://storage.googleapis.com/codelab-elements-tmp/codelab-elements.css">
</head>
<body>
${renderContent(codelab)}
<script type="application/javascript">
var doNotTrack = false;
if (!doNotTrack) {
	window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
	ga('create', '${codelab.metadata.googleUA}', 'auto');
	
	ga('send', 'pageview');
}
</script>
<script async src='https://www.google-analytics.com/analytics.js'></script>
<script src="https://storage.googleapis.com/codelab-elements-tmp/native-shim.js"></script>
<script src="https://storage.googleapis.com/codelab-elements-tmp/custom-elements.min.js"></script>
<script src="https://storage.googleapis.com/codelab-elements-tmp/prettify.js"></script>
<script src="https://storage.googleapis.com/codelab-elements-tmp/codelab-elements.js"></script>
</body>
</html>
''';

