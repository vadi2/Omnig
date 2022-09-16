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
function validate_package_names(packageindex, packages_to_download)
  assert(packageindex, "No package index to compare against available")
  assert(packages_to_download, "No packages names to validate given")

  print(packageindex)
end

-- unzips a given package
function unpack_package(packagename, output)

end

packageindex = load_package_index()
validate_package_names(load_package_index, args.igs)