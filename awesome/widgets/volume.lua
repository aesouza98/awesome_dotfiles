local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local volume_widget = {}
local function worker(user_args)
  local args = user_args or {}

  -- Define the volume widget
  volume_widget = wibox.widget.textbox()
  volume_widget.font = args.font or "RobotoMono Nerd Font Mono 12"
  local color_normal = args.fg_normal or "#FFFFFF" -- Color for normal volume
  local color_muted = args.fg_muted or "#999999"   -- Color for muted volume


  -- Set the initial foreground color
  volume_widget:set_markup('<span foreground="#FFFFFF">Vol: N/A</span>')

  -- Function to update the volume widget text and foreground color
  local function update_volume_widget(widget, stdout, mute)
    local volume = tonumber(stdout)
    if mute then
      widget:set_markup('<span foreground="' .. color_muted .. '">󰖁 Muted</span>')
    elseif volume then
      widget:set_markup('<span foreground="' .. color_normal .. '">󰕾 ' .. math.floor(volume) .. '%</span>')
    else
      widget:set_markup('<span foreground="' .. color_normal .. '">󰕾 </span>')
    end
  end

  -- Function to get the current volume level and mute status
  local function get_volume()
    awful.spawn.easy_async_with_shell("pamixer --get-volume",
      function(stdout)
        awful.spawn.easy_async_with_shell("pamixer --get-mute",
          function(mute_stdout)
            local mute = string.gsub(mute_stdout, "\n", "") == "true"
            update_volume_widget(volume_widget, stdout, mute)
          end
        )
      end
    )
  end

  -- Update the volume widget initially
  get_volume()

  -- Function to increase volume
  local function increase_volume()
    awful.spawn("pamixer --increase 5")
    get_volume()
  end

  -- Function to decrease volume
  local function decrease_volume()
    awful.spawn("pamixer --decrease 5")
    get_volume()
  end

  -- Function to toggle mute
  local function toggle_mute()
    awful.spawn("pamixer --toggle-mute")
    get_volume()
  end

  -- Update the volume widget on mouse click
  volume_widget:buttons(
    gears.table.join(
      awful.button({}, 1, function() toggle_mute() end),
      awful.button({}, 4, function() increase_volume() end),
      awful.button({}, 5, function() decrease_volume() end)
    )
  )

  -- Create a timer to update the volume widget periodically
  local volume_timer = gears.timer({ timeout = 1 })
  volume_timer:connect_signal("timeout", get_volume)
  volume_timer:start()

  return volume_widget
end

return setmetatable(volume_widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
