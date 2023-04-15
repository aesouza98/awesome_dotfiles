local awful = require("awful")
local wibox = require("wibox")

local wireless_widget = {}
local function worker(user_args)
  local args = user_args or {}
  -- Create a wireless SSID widget
  wireless_widget = wibox.widget.textbox()
  wireless_widget.font = args.font or "RobotoMono Nerd Font Mono 12"
  local connected_color = args.fg_connected or "#FFFFFF"       -- Color for normal volume
  local disconnected_color = args.fg_disconnected or "#999999" -- Color for muted volume
  local connected_icon = args.icon_connected or " "         -- Icon for connected state
  local disconnected_icon = args.icon_disconnected or " "   -- Icon for disconnected state
  local icon_color = args.icon_color or "blue"

  -- Function to update the wireless status
  local function update_wireless_status()
    awful.spawn.easy_async("iwgetid -r", function(stdout, _, _, _)
      local ssid = string.gsub(stdout, "\n", "") -- Remove trailing newline
      if ssid and ssid ~= "" then
        wireless_widget.markup = "<span foreground='" ..
        connected_color ..
        "'>" ..
        "<span foreground='" ..
        icon_color ..
        "'>" ..
        connected_icon .. "</span> " .. "<span foreground='" .. connected_color .. "'>" .. ssid .. "</span></span>"
      else
        wireless_widget.markup = "<span foreground='" ..
            disconnected_color ..
            "'>" .. "<span foreground='" .. icon_color .. "'>" .. disconnected_icon .. "</span> Disconnected</span>"
      end
    end)
  end

  -- Update the wireless SSID status initially
  update_wireless_status()

  -- Set up a timer to update the wireless SSID status every 5 seconds
  local wireless_timer = timer({ timeout = 10 })
  wireless_timer:connect_signal("timeout", update_wireless_status)
  wireless_timer:start()

  return wireless_widget
end

return setmetatable(wireless_widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
