local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local microphone_widget = {}
local script_dir = os.getenv("HOME") .. "/.config/scripts/"
local local_bin = os.getenv("HOME") .. "/.local/bin/"

local function worker(user_args)
  local args = user_args or {}

  -- Define the volume widget
  microphone_widget = wibox.widget.textbox()
  microphone_widget.font = args.font or "RobotoMono Nerd Font Mono 12"
  local color_normal = args.fg_normal or "#FFFFFF" -- Color for normal volume
  local color_muted = args.fg_muted or "#999999"   -- Color for muted volume


  -- Set the initial foreground color
  microphone_widget:set_markup('<span foreground="' .. color_normal .. '">N/A</span>')

  -- Function to update the microphone widget text and foreground color
  local function update_microphone_widget(widget, mute)
    if mute then
      widget:set_markup('<span foreground="' .. color_muted .. '">  </span>')
    else
      widget:set_markup('<span foreground="' .. color_normal .. '">  </span>')
    end
  end

  -- Function to get the current microphone mute status
  local function get_microphone()
    awful.spawn.easy_async_with_shell("pamixer --default-source --get-mute",
      function(mute_stdout)
        local mute = string.gsub(mute_stdout, "\n", "") == "true"
        update_microphone_widget(microphone_widget, mute)
      end
    )
  end

  -- Function to toggle mute
  local function toggle_mute()
    awful.spawn.easy_async_with_shell(local_bin .. "micvolume mute")
    get_microphone()
  end

  -- Update the volume widget on mouse click
  microphone_widget:buttons(
    gears.table.join(
      awful.button({}, 1, function() toggle_mute() end)
    )
  )

  -- Create a timer to update the volume widget periodically
  local microphone_timer = gears.timer({ timeout = 1 })
  microphone_timer:connect_signal("timeout", get_microphone)
  microphone_timer:start()

  return microphone_widget
end

return setmetatable(microphone_widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
