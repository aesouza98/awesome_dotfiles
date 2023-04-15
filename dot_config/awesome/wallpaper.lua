local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful")

local wallpaper = {}

wallpaper.set   = function()
  gears.wallpaper.maximized(beautiful.wallpaper)
end

return wallpaper
