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

  <link href="bootstrap-5.2.1-dist/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
  </head>
]]

local body =
  {'body', {
    {'div', class="col-lg-8 mx-auto p-4 py-md-5", {
      {'header', class="d-flex align-items-center pb-3 mb-5 border-bottom", {
        'Omnig'
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

  --   <footer class="pt-5 my-5 text-muted border-top">
  --     Created by Vadim Peretokin &middot; &copy; 2022
  --   </footer>
  -- </div>
