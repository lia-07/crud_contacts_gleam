pub fn base_page(title title: String, content content: String) {
  "<!DOCTYPE html>
<html lang=\"
  en
 \">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"
  viewport
  \" content=\"width=device-width, initial-scale=1.0
    \">
    <title>" <> title <> "</title>

    <style>
    * {
      font-family: sans-serif;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      background-color: #eee;
      padding: 2rem 3rem;
    }
    </style>
</head>
<body><div class=\"container\">" <> content <> "</div></body>
</html>"
}
