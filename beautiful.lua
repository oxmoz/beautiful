-- Get package name
local P = {}
if _REQUIREDNAME == nil then
    beautiful = P
else
    _G[_REQUIREDNAME] = P
end

-- Grab environment
local string = string
local table = table
local os = os
local io = io

-- Local variable
local theme_path = ""

-- Global variable
theme = {}

-- Split line in two if it  contains the '=' character.  Return nil if
-- the '='  character is not in  the string if the  string begins with
-- '#' which is a comment
function split_line(line)
   local values = {}
   local split_val = string.find(line, '=')

   if split_val ~= nil and string.sub(line, 1, 1) ~= '#' then
      values[1] = string.sub(line, 1, split_val-1)
      values[2] = string.sub(line, split_val+1, -1)
   else
      values[1] = nil
   end

   return values
end

-- Read the theme file and feed the table
function load_theme()
   if theme_path ~= "" then
      local f = io.open(theme_path)
      
      for line in f:lines() do
	 line = split_line(line)
	 
	 if line[1] ~= nil then
	    theme[line[1]] = line[2]
	 end
      end
   end
end

-- Run  the given  command to  set the  wallpaper.  If  'cmd' optional
-- parameter is  given, it  runs that command,  otherwise it  runs the
-- 'wallpaper_cmd' option if specified
function set_wallpaper(cmd)
   if cmd == nil then
      if theme["wallpaper_cmd"] then
	 os.execute(theme["wallpaper_cmd"] .. '&')
      end
   else
      os.execute(cmd .. '&')
   end
end

-- Init function, should be runned at the beginning of rc.lua
function init(path)
   theme_path = path
   load_theme()
end

-- Get a value
function get(opt)
   return theme[opt]
end

-- Build function list
P.load_theme = load_theme
P.set_wallpaper = set_wallpaper
P.init = init
P.get = get

return P
