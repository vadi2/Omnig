#!/usr/bin/env lua

local argparse = require "argparse"

local parser = argparse("download-igs.lua", "Ensures given FHIR Implementation Guides are available at a given location.")

parser:option("-o --output-location", "Output folder location", "output")

local args = parser:parse()