local awful           = require("awful")
local wibox           = require("wibox")
local gears           = require("gears")
local beautiful       = require("beautiful")
local dpi             = require("beautiful.xresources").apply_dpi
local lain            = require("lain")
local markup          = lain.util.markup
local panel           = {}

-- Clock
local date            = wibox.widget.textclock("%a, %d de %B")
local clock           = wibox.widget.textclock("%H:%M")

-- Separator
local spacer          = wibox.widget.textbox(" ")
local separator       = wibox.widget.textbox(markup(beautiful.bg_alt, "|"))

-- Battery Widget
local battery         = require("widgets.battery") {
  ac = "AC",
  adapter = "BAT0",
  ac_prefix = " ",
  battery_prefix = {
    { 25,  "  " },
    { 50,  "  " },
    { 75,  "  " },
    { 100, "  " }
  },
  percent_colors = {
    { 25,  beautiful.fg_urgent },
    { 50,  beautiful.fg_normal },
    { 999, beautiful.fg_normal },
  },
  listen = true,
  timeout = 10,
  widget_text = "${AC_BAT}${percent}%",
  tooltip_text = "Battery ${state}${time_est}\nCapacity: ${capacity_percent}%",
  alert_threshold = 5,
  alert_timeout = 0,
  alert_title = "Low battery !",
  alert_text = "${AC_BAT}${time_est}"
}

-- Spotify Widget
local spotify         = require("widgets.spotify") {
  font = beautiful.font,
  play_icon = "",
  pause_icon = ""
}

-- Volume Widget
local volume          = require("widgets.volume") {
  font = beautiful.font,
  fg_normal = beautiful.fg_normal,
  fg_muted = beautiful.fg_urgent
}

-- Microphone Widget
local microphone      = require("widgets.microphone") {
  font = beautiful.font,
  fg_normal = beautiful.fg_alt,
  fg_muted = beautiful.fg_urgent
}

-- Wireless Widget
local wireless        = require("widgets.wireless") {
  font = beautiful.font,
  fg_connected = beautiful.fg_normal,
  fg_disconnected = beautiful.fg_dim,
  icon_connected = " ",
  icon_disconnected = "󰤮 ",
  icon_color = beautiful.fg_alt
}

-- VPN Widget
local vpn_widget      = require("widgets.vpn") {
  font = beautiful.font,
  color_active = beautiful.fg_normal,
  color_inactive = beautiful.fg_normal,
  icon_active_color = beautiful.fg_alt,
  icon_inactive_color = beautiful.fg_urgent
}

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)


panel.init = function()
  awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(1) end),
      awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      buttons = taglist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(20) })

    -- Add widgets to the wibox
    s.mywibox:setup {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        expand = none,
        {
          -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          s.mylayoutbox,
          spacer,
          separator,
          spacer,
          date,
          spacer,
          separator,
          spacer,
          clock,
          spacer,
          separator,
          spacer,
          spotify,
        },
        nil,
        {
          -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          vpn_widget,
          spacer,
          separator,
          spacer,
          battery,
          spacer,
          separator,
          spacer,
          wireless,
          spacer,
          separator,
          spacer,
          microphone,
          spacer,
          separator,
          spacer,
          volume,
          spacer,
          separator,
          spacer,
          wibox.widget.systray(),
        }
      },
      {
        s.mytaglist,
        layout = wibox.container.place,
        valign = "center",
        halign = "center",
      }
    }
  end)
end

return panel
