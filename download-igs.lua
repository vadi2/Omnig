#!/usr/bin/env lua

local argparse = require "argparse"
local lunajson = require "lunajson"
local inspect = require "inspect"
local lfs = require "lfs"
local http_request = require "http.request"
local util = require "util"

local parser = argparse("download-igs.lua",
  "Ensures given FHIR Implementation Guides are available at a given location.")

parser:argument("igs", "List of IGs to download")
   :args "+"
parser:option("-o --output-location", "Output folder location", "output")

local args = parser:parse()

local package_download_location = os.getenv("HOME").."/.fhir/implementation-guides/raw"
local package_extract_location = os.getenv("HOME").."/.fhir/implementation-guides/unzipped"
local packageindex

function download_package(packagename)
  -- figure out repo location from qas
end

-- unzips a given package
function unpack_package(packagename)
  local input_path = package_download_location.."/"..packagename.."/full-ig.zip"
  local output_path = package_extract_location.."/"..packagename
  if not util.io_exists(input_path) then
    error(packagename.." hasn't yet been downloaded into the cache, is '"..input_path.."' available?")
  end

  if util.io_exists(output_path) then
    print("skipping as it is already extracted: "..packagename)
    return
  end

  lfs.mkdir(output_path)

  local command = "aunpack --extract-to="..output_path.. " " .. input_path
  print("Extracting "..packagename.."...")
  local output = util.os_capture(command)
end

packageindex = util.load_package_index(util.download_index())
util.validate_package_names(packageindex, args.igs)

if not util.io_exists(package_extract_location) then
  lfs.mkdir(package_extract_location)
end

for _, packagename in pairs(args.igs) do
  unpack_package(packagename)
end
