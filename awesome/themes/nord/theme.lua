-------------------------------
--  "Nord" awesome theme     --
--  by hmix adapted from     --
--  zenburn theme            --
--    By Adrian C. (anrxc)   --
-------------------------------
local gears = require("gears")
local themes_path = require("gears.filesystem").get_themes_dir()
local current_theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/nord"
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local nconf = naughty.config


-- {{{ Main
local theme = {}
theme.wallpaper = current_theme_dir .. "/nord-background.png"
-- }}}

-- {{{ Styles
-- theme.font      = "sans 8"
theme.font      = "JetBrains Mono Bold 9"

-- {{{ Colors
theme.fg_normal  = "#88C0D0" --"#ECEFF4"
theme.fg_urgent  = "#BF616A" --"#D08770"
theme.bg_normal  = "#2E3440"
theme.fg_focus   = theme.bg_normal -- "#8FBCBB"
theme.bg_focus   = theme.fg_normal --"#3B4252"
theme.fg_focus   = theme.bg_normal 
theme.bg_urgent  = "#3B4252"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(6)
theme.border_width  = dpi(3)
theme.border_normal = "#3B4252"
theme.border_focus  = theme.fg_normal --"#4C566A"
theme.border_marked = "#D08770"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus   = "#3B4252"
theme.titlebar_bg_normal  = "#2E3440"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#D08770"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#A3BE8C"
--theme.fg_center_widget = "#8FBCBB"
--theme.fg_end_widget    = "#BF616A"
--theme.bg_widget        = "#434C5E"
--theme.border_widget    = "#3B4252"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#D08770"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(25)
theme.menu_width  = dpi(250)
-- }}}

-- {{{ Icons
-- {{{ Taglist

theme.taglist_fg_empty = theme.fg_normal --"#EBCB8B" --"#88C0D0"
theme.taglist_fg_focus = "#EBCB8B" --"#88C0D0"
theme.taglist_fg_occupied = "#A3BE8C"  --"#D08770" --"#5E81AC"
theme.taglist_bg_focus = theme.bg_normal
theme.taglist_squares_sel   = current_theme_dir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = current_theme_dir .. "/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = current_theme_dir .. "/awesome-icon.png"
--theme.menu_submenu_icon      = current_theme_dir .. "default/submenu.png"
theme.menu_submenu_icon      =nil
theme.menu_submenu = " "
-- }}}

-- {{{ Layout
theme.layout_tile       = current_theme_dir .. "/layouts/tile.png"
theme.layout_tileleft   = current_theme_dir .. "/layouts/tileleft.png"
theme.layout_tilebottom = current_theme_dir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = current_theme_dir .. "/layouts/tiletop.png"
theme.layout_fairv      = current_theme_dir .. "/layouts/fairv.png"
theme.layout_fairh      = current_theme_dir .. "/layouts/fairh.png"
theme.layout_spiral     = current_theme_dir .. "/layouts/spiral.png"
theme.layout_dwindle    = current_theme_dir .. "/layouts/dwindle.png"
theme.layout_max        = current_theme_dir .. "/layouts/max.png"
theme.layout_fullscreen = current_theme_dir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = current_theme_dir .. "/layouts/magnifier.png"
theme.layout_floating   = current_theme_dir .. "/layouts/floating.png"
theme.layout_cornernw   = current_theme_dir .. "/layouts/cornernw.png"
theme.layout_cornerne   = current_theme_dir .. "/layouts/cornerne.png"
theme.layout_cornersw   = current_theme_dir .. "/layouts/cornersw.png"
theme.layout_cornerse   = current_theme_dir .. "/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = current_theme_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = current_theme_dir .. "/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = current_theme_dir .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = current_theme_dir .. "default/titlebar/minimize_focus.png"

theme.titlebar_maximized_button_focus_active  = current_theme_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = current_theme_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = current_theme_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = current_theme_dir .. "/titlebar/maximized_normal_inactive.png"

theme.titlebar_ontop_button_focus_active  = current_theme_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = current_theme_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = current_theme_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = current_theme_dir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = current_theme_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = current_theme_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = current_theme_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = current_theme_dir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = current_theme_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = current_theme_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = current_theme_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = current_theme_dir .. "/titlebar/floating_normal_inactive.png"

-- }}}
-- }}}

-- {{{ batteryarc_widget
theme.widget_main_color = "#88C0D0"
theme.widget_red = "#BF616A"
theme.widget_yellow = "#EBCB8B"
theme.widget_green = "#A3BE8C"
theme.widget_black = "#000000"
theme.widget_transparent = "#00000000"
-- }}}

--theme.bg_systray = theme.fg_urgent

-- Notifications presets
theme.notification_shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end
nconf.presets.critical.bg = "#BF616A"
nconf.presets.critical.fg = "#2E3440"
theme.notification_font="Ubuntu Mono 14"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
