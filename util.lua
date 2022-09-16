local http_request = require "http.request"
local lunajson = require "lunajson"
local inspect = require "inspect"

local _M = {}

_M.read_file = function(path)
  local file = io.open(path, "rb")
  if not file then return nil end
  local content = file:read "*a"
  file:close()
  return content
end

_M.io_exists = function (item)
  return lfs.attributes(item) and true or false
end

_M.os_capture = function(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

-- download the list of available packages
_M.download_index = function()
  local location = "https://build.fhir.org/ig/qas.json"
  local headers, stream = assert(http_request.new_from_uri(location):go(3))
  local body = assert(stream:get_body_as_string(3))
  if headers:get ":status" ~= "200" then
    error("error downloading "..location..":"..body)
  end

  return body
end

_M.load_package_index = function(qas_content)
  return lunajson.decode(qas_content)
end

-- ensure that all of the requested packages for download are valid
_M.validate_package_names = function(index, packages_to_download)
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

  if next(invalid_packages) then 
  	error("invalid packages names given: " .. inspect(invalid_packages))
  end
end

return _M
