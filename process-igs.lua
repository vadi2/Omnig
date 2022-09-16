#!/usr/bin/env lua

local lth = require "lua_to_html"
local argparse = require "argparse"
local lfs = require "lfs"
local inspect = require "inspect"
local lunajson = require "lunajson"
local util = require "util"


local parser = argparse("process-igs.lua",
  "Concatenate IGs together.")

parser:argument("igs", "List of IGs to process")
   :args "+"

local args = parser:parse()

local package_extract_location = os.getenv("HOME").."/.fhir/implementation-guides/unzipped"
local output_location = "output/"

local packageindex
local ig_resources = {}
local amalagmated_html = ""

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

local mainpage =
{'div', class="col-md-6", {
  {'h2', 'Quick actions'},
  {'p', 'A few ideas to get started with:'},
  {'ul', class="icon-list ps-0", {
    {'li', class="d-flex align-items-start mb-1", {
      {'a', href="amalagmated.html", {
       "Amalgamated mega-page of all IGs. Searchable with Ctrl+F"}
      }}
    },
    {'li', class="d-flex align-items-start mb-1", "List of all profiles"},
    {'li', class="d-flex align-items-start mb-1", "List of all extensions"},
    {'li', class="d-flex align-items-start mb-1", "List of all valuesets"},
    {'li', class="d-flex align-items-start mb-1", "List of all codesystems"},
  }}
}}

local body = function(insert)
  return
  {'body', {
    {'div', class="col-lg-8 mx-auto p-4 py-md-5", {
      {'header', class="d-flex align-items-center pb-3 mb-5 border-bottom", {
        'Omnig'
      }},

      insert,

      {'footer', class="pt-5 my-5 text-muted border-top", {
        "Omnig by Vadim Peretokin &middot; &copy; 2022"
      }}
    }}
  }
}
end

local footer = [[
  <script src="bootstrap-5.2.1-dist/bootstrap.bundle.min.js" integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8" crossorigin="anonymous"></script>

      
  </body>
</html>
]]


function load_ig(name)
  local path = package_extract_location.."/"..name.."/site/ImplementationGuide-"..name..".json"
  if not (path) then
    error("IG resource doesn't exist at:\n" ..path)
  end

  return lunajson.decode(read_file(path))
end

function parse_page(ig, page)
  local path = package_extract_location.."/"..ig.."/site/"..page.nameUrl
  amalagmated_html = amalagmated_html.."\n"..read_file(path)

  if page.page then
    for _, innerpage in ipairs(page.page) do
      parse_page(ig, innerpage) end
    end
end

function parse_resource(ig, resource)
  local path = package_extract_location.."/"..ig.."/site/"..resource.reference.reference:gsub('/', '-')..".html"
  amalagmated_html = amalagmated_html.."\n"..read_file(path)
end

function parse_igs()
  for _, ig in ipairs(args.igs) do
    ig_resources[ig] = load_ig(ig)
    print("Processing "..ig_resources[ig].title.."...")

    parse_page(ig, ig_resources[ig].definition.page)
    for _, resource in ipairs(ig_resources[ig].definition.resource) do
      parse_resource(ig, resource)
    end
  end
end

function copy_css()
  for _, cssfile in ipairs{"fhir.css", "prism.css"} do
    local css_path = package_extract_location.."/"..args.igs[1].."/site/"..cssfile
    if not util.io_exists(css_path) then error("CSS file missing: "..css_path) end
    if not util.io_exists(cssfile) then
      local file = io.open(output_location..cssfile, "w+")
      file:write(read_file(css_path))
      file:close()
    end
  end

  for _, tocopy in ipairs{"assets", "*.png", "*.gif", "*.js"} do
    local fullpath = package_extract_location.."/"..args.igs[1].."/site/"..tocopy
    util.os_capture("cp -r -n "..fullpath.." "..output_location)
  end

  util.os_capture("cp -r -n bootstrap-5.2.1-dist "..output_location)
end

function generate_index()
  local index = {
    header,
    body(mainpage),
    footer
  }

  if not util.io_exists(output_location) then lfs.mkdir(output_location) end
  file = io.open(output_location.."/index.html", "w+")
  file:write(lth:translate(index, true))
  file:close()
end

function generate_amalgamated_header()
  local output = {}
  for _, ig in ipairs(args.igs) do
    output[#output+1] = {'li', 
        {ig_resources[ig].title}
      }
  end

  return output
end

function generate_amalgamated()
  local test = 
  {'div', {
    {'p', "Page generated from an amalagmation of:"},
    {'ul', 
      generate_amalgamated_header()
      
    }
  }}

  local amalagmatedpage =
    {
      test,
      amalagmated_html
    }

  file = io.open(output_location.."/amalagmated.html", "w+")
  file:write(lth:translate(amalagmatedpage, true))
  file:close()
  copy_css()
end

function generate_output()
  print("Saving result...")
  generate_index()

  generate_amalgamated()
end

packageindex = util.load_package_index(util.download_index())
util.validate_package_names(packageindex, args.igs)

parse_igs()
generate_output()
