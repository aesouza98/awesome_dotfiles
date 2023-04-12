---------------------------
-- Default awesome theme --
---------------------------

local gfs                  = require("gears.filesystem")
local themes_path          = gfs.get_configuration_dir() .. "/themes/default"

local theme                = {}
theme.wallpaper            = themes_path .. "/Landscape.jpg"

-- Fonts & Wallpaper
theme.font                 = "JetBrainsMono NerdFont 10"

-- Background
theme.bg_normal            = "#161616B5"
theme.bg_alt               = "#373B41B5"

-- Foreground
theme.fg_normal            = "#979EAB"
theme.fg_focus             = "#979EAB"
theme.fg_urgent            = "#ff7a93"
theme.fg_minimize          = "#979EAB"
theme.fg_alt               = "#56B6C2"
theme.fg_dim               = "#343B3a"

-- Tooltips
theme.tooltip_bg           = theme.bg_normal
theme.tooltip_fg           = theme.fg_normal

-- Taglist
theme.taglist_fg_focus     = "#CCD0D0"
theme.taglist_fg_occupied  = "#686c69"
theme.taglist_fg_empty     = "#343b3a"
theme.taglist_spacing      = 15

-- Gaps and Borders
theme.useless_gap          = 7
theme.border_width         = 2
theme.border_normal        = theme.bg_normal
theme.border_focus         = theme.fg_alt
theme.border_marked        = "#ccd0d0"

-- Systray
theme.bg_systray           = theme.bg_normal
theme.systray_icon_spacing = 5

-- Layout icons
theme.layout_floating      = themes_path .. "/layouts/floatingw.png"
theme.layout_max           = themes_path .. "/layouts/maxw.png"
theme.layout_tile          = themes_path .. "/layouts/tilew.png"

return theme
