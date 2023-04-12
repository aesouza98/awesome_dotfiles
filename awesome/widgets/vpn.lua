-- vpn.lua

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")

local vpn_widget = {}

local function worker(user_args)
  local args = user_args or {}

  -- Default settings
  vpn_widget = wibox.widget.textbox()
  vpn_widget.font = args.font or "FontAwesome 12"
  local color_active = args.color_active or "#00FF00"     -- Icon color when VPN is active
  local color_inactive = args.color_inactive or "#FF0000" -- Icon color when VPN is inactive
  local icon_active = args.icon_active or " "
  local icon_inactive = args.icon_inactive or " "
  local text_active = "connected"
  local text_inactive = "down"
  local icon_active_color = args.icon_active_color or "blue"
  local icon_inactive_color = args.icon_inactive_color or "red"

  -- Function to update VPN widget
  local function update_vpn_widget(widget, status)
    awful.spawn.easy_async_with_shell("pgrep -a ^openvpn ", function(stdout, stderr)
      if stdout ~= "" then
        -- VPN process is running
        widget.markup = string.format("<span foreground='" ..
          color_active ..
          "'>" ..
          "<span foreground='" ..
          icon_active_color ..
          "'>" ..
          icon_active .. "</span>" .. "<span foreground='" .. color_active .. "'>" .. text_active .. "</span></span>")
      else
        -- VPN process is not running
        widget.markup = string.format("<span foreground='" ..
          color_inactive ..
          "'>" ..
          "<span foreground='" ..
          icon_inactive_color ..
          "'>" ..
          icon_inactive ..
          "</span>" .. "<span foreground='" .. color_inactive .. "'>" .. text_inactive .. "</span></span>")
      end
    end)
  end

  -- Function to get the current microphone mute status
  local function get_vpn()
    awful.spawn.easy_async_with_shell("pgrep -a ^openvpn",
      function(vpn_stdout)
        local status = string.gsub(vpn_stdout, "\n", "") == "true"
        update_vpn_widget(vpn_widget)
      end
    )
  end

  -- Kill VPN
  local function kill_vpn()
    awful.spawn.easy_async_with_shell("sudo killall openvpn", function(stdout, stderr)
      naughty.notification({
        title = "VPN Disconnected",
        text = "VPN process killed",
        preset = naughty.config.presets.info,
        timeout = 5,
      })
    end)
  end

  -- Update widget on mouse button press
  vpn_widget:buttons(
    gears.table.join(
      awful.button({}, 3, function() kill_vpn() end)
    )
  )

  -- Initial update
  update_vpn_widget(vpn_widget)

  -- Create a timer to update the volume widget periodically
  local vpn_timer = gears.timer({ timeout = 1 })
  vpn_timer:connect_signal("timeout", get_vpn)
  vpn_timer:start()

  return vpn_widget
end

return setmetatable(vpn_widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
