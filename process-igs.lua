#!/usr/bin/env lua

local lth = require('lua_to_html')







local header = [[
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Vadim Peretokin">
    <meta name="generator" content="Omnig">
    <title>Omnig</title>

    <style>
    .icon-list li::before {
      display: block;
      flex-shrink: 0;
      width: 1.5em;
      height: 1.5em;
      margin-right: .5rem;
      content: "";
      background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%23212529' viewBox='0 0 16 16'%3E%3Cpath d='M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0zM4.5 7.5a.5.5 0 0 0 0 1h5.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H4.5z'/%3E%3C/svg%3E") no-repeat center center / 100% auto;
    }
    </style>


    <link href="bootstrap-5.2.1-dist/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
  </head>
]]

local body =
  {'body', {
    {'div', class="col-lg-8 mx-auto p-4 py-md-5", {
      {'header', class="d-flex align-items-center pb-3 mb-5 border-bottom", {
        'Omnig'
      }},

      {'div', class="col-md-6", {
        {'h2', 'Quick actions'},
        {'p', 'A few ideas to get started with:'},
        {'ul', class="icon-list ps-0", {
          {'li', class="d-flex align-items-start mb-1", "Amalgamated mega-page of all IGs. Searchable with Ctrl+F"},
          {'li', class="d-flex align-items-start mb-1", "List of all profiles"},
          {'li', class="d-flex align-items-start mb-1", "List of all extensions"},
          {'li', class="d-flex align-items-start mb-1", "List of all valuesets"},
          {'li', class="d-flex align-items-start mb-1", "List of all codesystems"},
        }}
      }},

      {'footer', class="pt-5 my-5 text-muted border-top", {
        "Created by Vadim Peretokin &middot; &copy; 2022"
      }}
    }}
  }
}

local footer = [[
  <script src="bootstrap-5.2.1-dist/bootstrap.bundle.min.js" integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8" crossorigin="anonymous"></script>

      
  </body>
</html>
]]

local index = {
	header,
  body,
	footer
}

file = io.open("output.html", "w+")

-- Write text to the file
file:write(lth:translate(index, true))
file:close()

