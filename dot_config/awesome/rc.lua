pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Define theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/default/theme.lua")

-- Get correct locales
os.setlocale(os.getenv("LANG"))

-- Define applications
apps = {
    network_manager = "", -- recommended: nm-connection-editor
    power_manager = "",   -- recommended: xfce4-power-manager
    terminal = "kitty",
    launcher = "rofi -show drun",
    lock = "i3lock",
    screenshot = "flameshot gui",
    filebrowser = "thunar",
    browser = "com.brave.Browser",
    browser2 = "firefox",
}

-- ==============
-- INITIALIZATION
-- ==============

-- define layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

-- Init Keybindings
local keys = require("keys")
root.keys(keys.globalkeys)

-- Init Rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Init Panel
local panel = require("panel")
panel.init()

-- Mouse Bindings
root.buttons(gears.table.join(
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Set wallpaper
local wallpaper = require("wallpaper")
wallpaper.set()
screen.connect_signal("property::geometry", wallpaper.set)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- Autostart Applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
