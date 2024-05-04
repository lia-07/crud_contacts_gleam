import gleam/list
import gleam/string_builder
import crud_contacts/contact.{type Contact}

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

pub fn home_page(contacts: List(Contact)) {
  base_page(title: "Contacts: Home", content: "<h1>Contacts</h1>
  <br>
  <h2>Create a new contact</h2>
  <form action=\"/contacts\" method=\"post\">
      <label for=\"name\">Name:</label><br>
      <input type=\"text\" id=\"name\" name=\"name\" required><br><br>
      <label for=\"fav_colour\">Favourite Colour:</label><br>
      <input type=\"text\" id=\"fav_colour\" name=\"fav_colour\"><br><br>
      <label for=\"phone\">Phone:</label><br>
      <input type=\"text\" id=\"phone\" name=\"phone\"><br><br>
      <label for=\"email\">Email:</label><br>
      <input type=\"text\" id=\"email\" name=\"email\"><br><br>
      
      <button type=\"submit\" value=\"Submit\">Create</button>
  </form>
  <br>
  <br>
  <ul>
  " <> list.map(contacts, fn(contact: Contact) {
      "<li>" <> contact.name <> "</li>\n"
    })
    |> string_builder.from_strings()
    |> string_builder.to_string() <> "</ul>")
}
