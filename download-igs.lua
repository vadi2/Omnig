#!/usr/bin/env lua

local argparse = require "argparse"
local lunajson = require "lunajson"
local inspect = require "inspect"

local parser = argparse("download-igs.lua", "Ensures given FHIR Implementation Guides are available at a given location.")

parser:argument("igs", "List of IGs to download")
   :args "+"
parser:option("-o --output-location", "Output folder location", "output")

local args = parser:parse()

local packageindex = {}




function os_capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function read_file(path)
  local file = io.open(path, "rb")
  if not file then return nil end
  local content = file:read "*a"
  file:close()
  return content
end

function load_package_index()
  local qas_content = read_file("/Users/phnl320128457/Downloads/qas.json")

  return lunajson.decode(qas_content)
end

-- download the list of available packages
function download_index()

end

-- ensure that all of the requested packages for download are valid
function validate_package_names(index, packages_to_download)
  assert(type(packages_to_download) == "table", "No package index to compare against available")
  assert(type(packages_to_download) == "table", "No packages names to validate given")

  local available_packages, invalid_packages = {}, {}

  for _, packageinfo in pairs(index) do
    available_packages[packageinfo["package-id"]] = true
  end

  for _, name in pairs(packages_to_download) do
    if not available_packages[name] then
      invalid_packages[#invalid_packages+1] = name
    end
  end

  if next(invalid_packages) then error("invalid packages names given: " .. inspect(invalid_packages)) end
end

-- unzips a given package
function unpack_package(packagename, output)

end

packageindex = load_package_index()
validate_package_names(packageindex, args.igs)