-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- cal
local lain      = require("lain")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

--CurrentTag is initialized to nill
local ctag = nil

--Rounded corners for clients/window
local rc = 5

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/nord/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "alacritty" or "x-terminal-emulator"
editor = "vim" or os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- my widgets
local cpu_widget = require("widgets/cpu")
local vol_widget = require("widgets/pulseaudio")
local disk_widget = require("widgets/disk")
local apt_widget = require("widgets/aptPackages")
local ram_widget = require("widgets/ram")
local netspeed_widget = require("widgets/netspeed")
local brightness_widget = require("widgets/brightness")
local battery_widget = require("widgets/battery")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
  }

power_options = {
  { "Lock" ,    function() awful.util.spawn("i3lock -ec 282a36")  end                  , "/usr/share/icons/Dracula/actions/24/system-lock-screen.svg" },
  { "Logout",   function() awesome.quit()                         end                  , "/usr/share/icons/Dracula/actions/24/system-log-out.svg" },
  { "Sleep",    function() awful.util.spawn("systemctl suspend")  end                  , "/usr/share/icons/Dracula/actions/24/system-suspend.svg" },
  { "Reboot",   function() awful.util.spawn("systemctl reboot")   end                  , "/usr/share/icons/Dracula/actions/24/system-reboot.svg" },
  { "Shutdown", function() awful.util.spawn("systemctl poweroff") end                  , "/usr/share/icons/Dracula/actions/24/system-shutdown.svg"},
}

local menu_awesome          = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal         = { "Launch Terminal", terminal , "/usr/share/icons/Dracula/apps/scalable/terminal.svg"}
local menu_chromium         = { "Launch Chromium", "flatpak run org.chromium.Chromium", "/usr/share/icons/Dracula/apps/scalable/chromium-browser.svg" }
local menu_calc             = { "Launch Calculator", "mate-calc", "/usr/share/icons/Dracula/apps/scalable/calc.svg" }
local menu_fileBrowser      = { "Launch Files", "caja", "/usr/share/icons/Dracula/apps/scalable/file-manager.svg" }
local menu_writer           = { "Launch Libre Writer", "lowriter", "/usr/share/icons/Dracula/apps/scalable/ooo-writer.svg" }
local menu_excel            = { "Launch Libre Calc", "localc", "/usr/share/icons/Dracula/apps/scalable/ooo-calc.svg" }
--local menu_KQMP             = { "Launch KQMP", "flatpak run org.chromium.Chromium 192.168.8.100/kingQuality", "/home/kqpi/Pictures/.kqmp.png" }
--local menu_KQMP_Pricelist   = { "Launch KQMP Price list", "atril Documents/KQMP.PRICELIST.24.12.20.pdf", "/usr/share/icons/Dracula/apps/scalable/adobe-reader.svg" }
local menu_power_options    = { "Power options", power_options , "/usr/share/icons/Dracula/actions/24/system-shutdown.svg" }

if has_fdo then
  mymainmenu = freedesktop.menu.build({
    after = { menu_awesome, menu_power_options  },
    before =  { --[[menu_KQMP, menu_KQMP_Pricelist,]] menu_terminal, menu_chromium, menu_writer, menu_excel, menu_fileBrowser, menu_calc  }
  })
else
  mymainmenu = awful.menu({
    items = {
      menu_terminal, 
      { "Debian", debian.menu.Debian_menu.Debian },
      menu_awesome,
      }
  })
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- old conf
--[[myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

power_options = {
   { "Lock",      function() awful.util.spawn("i3lock -ec 22232e")  end , "/usr/share/icons/Dracula/actions/24/system-lock-screen.svg" },
   { "Logout",    function() awesome.quit()                         end , "/usr/share/icons/Dracula/actions/24/system-log-out.svg"     },
   { "Sleep",     function() awful.util.spawn("systemctl suspend")  end , "/usr/share/icons/Dracula/actions/24/system-suspend.svg"     },
   { "Reboot",    function() awful.util.spawn("systemctl reboot")   end , "/usr/share/icons/Dracula/actions/24/system-reboot.svg"      },
   { "Shutdown",  function() awful.util.spawn("systemctl poweroff") end , "/usr/share/icons/Dracula/actions/24/system-shutdown.svg"    },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "Launch terminal", terminal, "/usr/share/icons/Dracula/apps/scalable/terminal.svg" }
local menu_power_options = { "Power options", power_options, "/usr/share/icons/Dracula/actions/24/system-shutdown.svg" }

if has_fdo then
  mymainmenu = freedesktop.menu.build({
    before = { menu_terminal },
    after =  { menu_awesome, menu_power_options }
  })
else
  mymainmenu = awful.menu({
    items = {
      menu_awesome,
      { "Debian", debian.menu.Debian_menu.Debian },
      menu_terminal,
    }
  })
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
]]
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications", "/usr/local/share/applications" , "/var/lib/snapd/desktop/applications", }
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
textclock_cont = wibox.widget.background()
mytextclock = wibox.widget.textclock(" %a %d %b, %H:%M:%S",1)
mytextclock.font = "JetBrains Mono Bold 10" --"Ubuntu Mono Bold 9"
textclock_cont:set_widget(mytextclock)
textclock_cont:set_fg(beautiful.bg_normal)
textclock_cont:set_bg(beautiful.taglist_fg_focus)

-- Lain Widgets
-- Calendar
local cal = lain.widget.cal({
	cal = "cal --color=always",
	attach_to = { mytextclock },
	notification_preset = {
		font = "Ubuntu Mono 14",
		fg   = beautiful.taglist_fg_focus,
		bg   = beautiful.bg_normal,
		position = "top_right", --"top_middle",
	},
    icons = os.getenv("HOME") .. "/.config/awesome/lain/icons/cal/yellow/"
})

-- My widgets with awesome watch
-- APT packages
local aptPackages_con = wibox.widget.background()
local aptPackages = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/aptGetUpdate"',3600)
aptPackages:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
			
	  end),]]
	awful.button({ }, 3, --right click to launch  
	  function() 
        awful.util.spawn(terminal .. " --class floatcenter -e sudo apt upgrade")
	  end)
	)
)
aptPackages_con:set_widget(aptPackages)
aptPackages_con:set_fg(beautiful.bg_normal)
aptPackages_con:set_bg(beautiful.taglist_fg_focus)

-- RAM MEMORY
local ram = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/ram.sh"',5)
 ram:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
			
	  end),]]
	awful.button({ }, 3, --right click to launch  
	  function() 
		awful.util.spawn(terminal .. " -e htop")
	  end)
	)
)

--CPU Usauge
local cpu = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/cpu.sh"',5)
 cpu:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
			
	  end),]]
	awful.button({ }, 3, --right click to launch  
	  function() 
		awful.util.spawn(terminal .. " -e htop")
	  end)
	)
)
--cpu.font="Ubuntu Mono 20,Font Awesome 5 Free Solid"

-- HDD space 
local disk = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/disk.sh nvme0n1p3"',1800)
 disk:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
			
	  end),]]
	awful.button({ }, 3, --right click to launch  
	  function() 
		awful.util.spawn(terminal .. " -e htop")
	  end)
	)
)

-- Volume
local volume = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/volume.sh"',0)
 volume:buttons(awful.util.table.join(
	awful.button({ }, 1,  --Left click to toggle mute
	  function() 
      awful.util.spawn("pulsemixer --toggle-mute")
	  end),
	awful.button({ }, 3, --Right click to launch pulse mixer
	  function() 
      awful.util.spawn(terminal .. " --class floatcenter -e pulsemixer")
	  end),
	awful.button({ }, 4, --Scroll up to increase volume
	  function() 
      awful.util.spawn("pulsemixer --change-volume +5")
	  end),
	awful.button({ }, 5, --Scroll down to lower volume
	  function() 
      awful.util.spawn("pulsemixer --change-volume -5")
	  end)
	)
)

-- Brightness
local brightness = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/brightness.sh"',1)
 brightness:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
      awful.util.spawn("pulsemixer --toggle-mute")
	  end),
	awful.button({ }, 3, --right click to launch  
	  function() 
      awful.util.spawn(terminal .. " -e pulsemixer")
	  end),]]
	awful.button({ }, 4, --right click to launch  
	  function() 
      awful.util.spawn("brightnessctl s 10+")
    end),
	awful.button({ }, 5, --right click to launch  
	  function() 
      awful.util.spawn("brightnessctl s 10-")
	  end)
	)
)

-- Battery
local battery = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/battery.sh"',10)
 battery:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
			
	  end),]]
	awful.button({ }, 3, --right click to launch  
	  function() 
      awful.util.spawn("xfce4-power-manager-settings")
	  end)
	)
)

-- Net speed 
local netspeed = awful.widget.watch('bash -c ' .. os.getenv("HOME") .. '"/.local/bin/netspeed.sh wlp3s0"',0)
 netspeed:buttons(awful.util.table.join(
	--[[awful.button({ }, 1, 
	  function() 
			
	  end),
	awful.button({ }, 3, --right click to launch  
	  function() 
		awful.util.spawn(terminal .. " -e htop")
	  end)]]
	)
)

--mocp audio player
local musicLogo = wibox.widget{
	markup  = "  ",
	font    = "Font Awesome 5 Free Solid Bold 14",
	widget  = wibox.widget.textbox,
}
musicLogo.font="Font Awesome 5 Free Solid Bold 12"
musicLogo.fg=beautiful.fg_urgent

musicLogo:buttons(awful.util.table.join(
	awful.button({ }, 1, 
	  function() 
      awful.util.spawn("mocp -G")
	  end),
	awful.button({ }, 3, 
	  function() 
		awful.util.spawn(terminal .. " --class floatcenter --title mocp -e mocp")
	  end)
	)
)

--mocp previous
local mocpPrevious = wibox.widget{
	markup  = " ",
	font    = "Font Awesome 5 Free Solid Bold 14",
	widget  = wibox.widget.textbox,
}
mocpPrevious.font="Font Awesome 5 Free Solid Bold 12"

mocpPrevious:buttons(awful.util.table.join(
	awful.button({ }, 1, 
	  function() 
      awful.util.spawn("mocp -r")
	  end),
	awful.button({ }, 3, 
	  function() 
		awful.util.spawn(terminal .. " --class floatcenter --title mocp -e mocp")
	  end)
	)
)

--[[
--mocp pause
local mocpPause = wibox.widget{
	markup  = " ",
	font    = "Font Awesome 5 Free Solid Bold 14",
	widget  = wibox.widget.textbox,
}
mocpPause.font="Font Awesome 5 Free Solid Bold 12"

mocpPause:buttons(awful.util.table.join(
	awful.button({ }, 1, 
	  function() 
      awful.util.spawn("mocp -G")
	  end),
	awful.button({ }, 3, 
	  function() 
		awful.util.spawn(terminal .. " --class floatcenter --title mocp -e mocp")
	  end)
	)
)
]]

--mocp next
local mocpNext = wibox.widget{
	markup  = " ",
	font    = "Font Awesome 5 Free Solid Bold 14",
	widget  = wibox.widget.textbox,
}
mocpNext.font="Font Awesome 5 Free Solid Bold 12"

mocpNext:buttons(awful.util.table.join(
	awful.button({ }, 1, 
	  function() 
      awful.util.spawn("mocp -f")
	  end),
	awful.button({ }, 3, 
	  function() 
		awful.util.spawn(terminal .. " --class floatcenter --title mocp -e mocp")
	  end)
	)
)

local mocp, mocp_timer = awful.widget.watch(
	"mocp -i", 1,
	function (widget, stdout)
		local mocp_now = {
            State   = "N/A",
            Artist  = "N/A",
            Title   = "N/A",
            Album   = "N/A",
            ctime   = "00:00",
            ttime   = "00:00"
		}

		for w in string.gmatch(stdout, "[^\r\n]+") do --(.-)tag \n  [^\r\n]+
			if string.match(w, "^.-:") == "State:" then 
				mocp_now.State = string.sub(string.match(w, ": .*"),3)
			end

			if string.match(w, "^.-:") == "Artist:" then 
				mocp_now.Artist = string.sub(string.match(w, ": .*"),3)
			end

			if string.match(w, "^.-:") == "Album:" then 
				mocp_now.Album = string.sub(string.match(w, ": .*"),3)
			end

			if string.match(w, "^.-:") == "SongTitle:" then 
				mocp_now.Title = string.sub(string.match(w, ": .*"),3,30)

        if string.len(mocp_now.Title) > 26 then
          mocp_now.Title = mocp_now.Title .. "..."
        end
			end
			
      if string.match(w, "^.-:") == "CurrentTime:" then 
				mocp_now.ctime = string.sub(string.match(w, ": .*"),3)
			end
      
      if string.match(w, "^.-:") == "TotalTime:" then 
				mocp_now.ttime = string.sub(string.match(w, ": .*"),3)
			end
		end
		
		font = "Ubuntu Mono Bold 22"
		if mocp_now.State=="PLAY" then
			widget:set_text(" " .. mocp_now.Artist .. " - " .. mocp_now.Title .. " (" .. mocp_now.ctime .. "/" .. mocp_now.ttime .. ")")
		elseif mocp_now.State=="PAUSE" then
			widget:set_text(" " .. mocp_now.Artist .. " - " .. mocp_now.Title .. " - ")
    else
			widget:set_text("") -- Not playing  
		end
    
    if mocp_now.State=="PLAY" and mocp_now.ctime=="00:00" then
      naughty.notify({title = "MOC Playing", text = "Artist: " .. mocp_now.Artist .. "\nAlbum: " .. mocp_now.Album .. "\nTitle: " .. mocp_now.Title, icon = os.getenv("HOME") .. "/.config/awesome/themes/music.yellow.png"})
    end
	end
)

mocp:buttons(awful.util.table.join(
	awful.button({ }, 1, 
	  function() 
      awful.util.spawn("mocp -G")
	  end),
	awful.button({ }, 3, 
	  function() 
		awful.util.spawn(terminal .. " --class floatcenter --title mocp -e mocp")
	  end)
	)
)

local vert_sep = wibox.widget {
  widget = wibox.widget.separator,
  orientation = "vertical",
  forced_width = 2,
  color = beautiful.bg_normal,
}

-- background to yellow
local start_left_sep_con = wibox.widget.background()
local start_left_sep = wibox.widget {
  widget = wibox.widget.textbox,
  font = "PowerlineSymbols 16 bold",
  text = "",
}

start_left_sep_con:set_widget(start_left_sep)
start_left_sep_con:set_fg(beautiful.taglist_fg_focus)
start_left_sep_con:set_bg(beautiful.taglist_bg_focus)

-- yellow to the blue
local left_yellow_to_blue_sep_con = wibox.widget.background()
local left_yellow_to_blue_sep = wibox.widget {
  widget = wibox.widget.textbox,
  font = "PowerlineSymbols 16 bold",
  text = "",
}

left_yellow_to_blue_sep_con:set_widget(left_yellow_to_blue_sep)
left_yellow_to_blue_sep_con:set_fg(beautiful.taglist_fg_empty)
left_yellow_to_blue_sep_con:set_bg(beautiful.taglist_fg_focus)

-- blue to the green
local left_blue_to_green_sep_con = wibox.widget.background()
local left_blue_to_green_sep = wibox.widget {
  widget = wibox.widget.textbox,
  font = "PowerlineSymbols 16 bold",
  text = "",
}

left_blue_to_green_sep_con:set_widget(left_blue_to_green_sep)
left_blue_to_green_sep_con:set_fg(beautiful.taglist_fg_occupied)
left_blue_to_green_sep_con:set_bg(beautiful.taglist_fg_empty)

-- green to the red
local left_green_to_red_sep_con = wibox.widget.background()
local left_green_to_red_sep = wibox.widget {
  widget = wibox.widget.textbox,
  font = "PowerlineSymbols 16 bold",
  text = "",
}

left_green_to_red_sep_con:set_widget(left_green_to_red_sep)
left_green_to_red_sep_con:set_fg(beautiful.fg_urgent)
left_green_to_red_sep_con:set_bg(beautiful.taglist_fg_occupied)

-- red to yellow
local left_red_to_yellow_sep_con = wibox.widget.background()
local left_red_to_yellow_sep = wibox.widget {
  widget = wibox.widget.textbox,
  font = "PowerlineSymbols 16 bold",
  text = "",
}

left_red_to_yellow_sep_con:set_widget(left_red_to_yellow_sep)
left_red_to_yellow_sep_con:set_fg(beautiful.taglist_fg_focus)
left_red_to_yellow_sep_con:set_bg(beautiful.fg_urgent)

-- red to yellow
local left_yellow_to_bg_sep_con = wibox.widget.background()
local left_yellow_to_bg_sep = wibox.widget {
  widget = wibox.widget.textbox,
  font = "PowerlineSymbols 16 bold",
  text = "",
}

left_yellow_to_bg_sep_con:set_widget(left_yellow_to_bg_sep)
--left_yellow_to_bg_sep_con:set_bg(beautiful.taglist_fg_focus)
left_yellow_to_bg_sep_con:set_bg(beautiful.taglist_fg_focus)
left_yellow_to_bg_sep_con:set_fg(beautiful.bg_normal)

--local systray_con = wibox.widget.background() 
--systray_con:set_widget(wibox.widget.systray())
--systray_con:set_fg(beautiful.fb_normal)
--systray_con:set_bg(beautiful.taglist_fg_focus)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
                            if client.focus then
                                client.focus:move_to_tag(t)
                            end
                        end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
                            if client.focus then
                                client.focus:toggle_tag(t)
                            end
                        end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
 awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal(
            "request::activate",
            "tasklist",
            {raise = true}
        )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))

local function set_wallpaper(s)
    -- Wallpaper
  --[[  if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end]]
    --awful.util.spawn("feh --randomize /home/avdzm/Pictures/Wallpapers/alternate/ --bg-fill");
    awful.util.spawn("feh --randomize /home/avdzm/Pictures/Wallpapers/nord/nord-wallpapers --bg-fill");
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    beautiful.taglist_font = "Font Awesome 5 Free Solid Bold 12"
    --awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag({ "", "", "", "", "", "" , "", "", ""}, s, awful.layout.layouts[1])
    
    -- Create a promptbox for each screen
    -- s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

		--Bottom panel having the running apps
		--s.bottombox = awful.wibar({ position = "bottom", screen = s })

		--Layout for the bottom panel and adding the running apps
		--s.bottombox:setup {
		--	layout = wibox.layout.flex.horizontal, --layout.align.horizontal,
			
		--}
    
    -- Add widgets to the wibox
    s.mywibox:setup {
      --layout = wibox.layout.align.horizontal,
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            --s.mylayoutbox,
            --musicLogo,
            --mocpPrevious,
            --mocpPause,
            --mocpNext,
            --mocp,
            --s.mypromptbox,
        },
        s.mytasklist,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mocp,
            musicLogo,
            vert_sep,
            start_left_sep_con,
            apt_widget,
            left_yellow_to_blue_sep_con,
            cpu_widget,
            left_blue_to_green_sep_con,
            ram_widget,
            left_green_to_red_sep_con, 
            disk_widget,
            left_red_to_yellow_sep_con,
            netspeed_widget,
            left_yellow_to_blue_sep_con,
            vol_widget,
            left_blue_to_green_sep_con,
            brightness_widget,
            left_green_to_red_sep_con, 
            battery_widget,
            left_red_to_yellow_sep_con,
            --vert_sep,
            --aptPackages_con, --working
            --aptPackages,
            --vert_sep,
            --cpu,
            --vert_sep,
            --ram,
            --vert_sep,
            --disk,
            --vert_sep,
            --netspeed,
            --vert_sep,
            --volume,
            --vert_sep,
            --brightness,
            --vert_sep,
            --battery,
            --vert_sep,
            textclock_cont,
           -- mytextclock,
            --systray_con,
            left_yellow_to_bg_sep_con,
            mykeyboardlayout,
            wibox.widget.systray(),
            s.mylayoutbox,
        },
      },
      --{
      --  --
      --  valign = "center",
      --  halign = "center",
      --  layout = wibox.container.place
      --}
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ modkey, }, 3, function () mymainmenu:toggle() end),
    awful.button({ modkey, }, 4, awful.tag.viewnext),
    awful.button({ modkey, }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

  
    awful.key({ modkey,           }, "a",
        function ()
          naughty.notify({title="Testing",text=awful.screen.focused().index})
        end,
        {description = "get focused screen", group = "client"}
    ),

    awful.key({ "Mod1",           }, "Shift_L",
        function ()
          awful.spawn(os.getenv("HOME") .. "/.local/bin/keyboardlayoutswitcher.sh us el")
        end,
        {description = "Change keyboard layout", group = "awesome"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

		-- Rofi Launcher
		awful.key({ modkey,"Shift" }, "Return",     function () awful.util.spawn("rofi -modi \"drun,calc:qalc +u8 -nocurrencies,ssh\" -show drun -show-icons -lines 5 -width 40" ) end, 
		--awful.screen.focused().mypromptbox:run() end,
		          {description = "Rofi Launcher", group = "launcher"}),
		-- Dmenu Launcher
		--awful.key({ modkey,			}, "d",			function () awful.util.spawn("dmenu_run -nb '#22232e' -nf '#CAA9FA' -sb '#BD93F9' -sf '#22232e' -fn UbuntuMono:pixelsize=23 -p 'Launch'") end, 
		--awful.key({ modkey,			}, "d",			function () awful.util.spawn("dmenu_run -nb '".. beautiful.bg_normal.. "' -nf '" .. beautiful.fg_normal.. "' -sb '" .. beautiful.fg_normal.. "' -sf '" .. beautiful.bg_normal .. "' -fn UbuntuMono:pixelsize=23 -p 'Launch'") end, 
		--awful.screen.focused().mypromptbox:run() end,
		--		  {description = "Dmenu Launcher", group = "launcher"}),
		
    --Document launcher
    awful.key({ modkey,			}, "d",			function () awful.util.spawn(os.getenv("HOME") .. "/.rofi_scripts/rofi_documents.sh") end, 
          {description = "Document Launcher", group = "launcher"}),

		--1337x Launcher			      
		awful.key({ modkey, 		}, "x",			function () awful.spawn(os.getenv("HOME") .. "/.rofi_scripts/rofi_1337x.sh") end,
				  {description = "xtorrent search", group = "launcher"}),

		--Pass Launcher			      
		awful.key({ modkey, 		}, "z",			function () awful.spawn(os.getenv("HOME") .. "/.rofi_scripts/rofi-pass/rofi-pass") end,
				  {description = "Pass", group = "launcher"}),
		       
		--Internet Radio Launcher			      
    awful.key({ modkey, 		}, "i",			function () awful.spawn('bash -c '..os.getenv("HOME") .. "/.rofi_scripts/rofi_online_radio.sh") end,
				  {description = "Internet Radio Launcher", group = "launcher"}),
		
          --MPV Launcher			      
    awful.key({ modkey, 		}, "v",			function () awful.spawn(os.getenv("HOME") .. "/.rofi_scripts/rofi_video_player.sh") end,
				  {description = "MPV Launcher", group = "launcher"}),
		
    --Logout menu	      
    awful.key({ "Control", 		}, "Escape",			function () awful.spawn(os.getenv("HOME") .. "/.rofi_scripts/power.sh") end,
				  {description = "Power session options", group = "launcher"}),

    -- Prompt
    --[[awful.key({ modkey },      "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
              ]]

	  -- Brightness
		awful.key({ }, "XF86Display",		function () awful.util.spawn("~.rofi_scripts/set_screens.sh") end,
				  {description = "Set External Moniter",	group="screen"}),
		awful.key({ }, "XF86MonBrightnessDown",		function () awful.util.spawn("brightnessctl s 15-") end,
				  {description = "Lower the screen brightness",		group="screen"}),
		awful.key({ }, "XF86MonBrightnessUp",		function () awful.util.spawn("brightnessctl s 15+") end,
				  {description = "Brighten the screen brightness",	group="screen"}),
		
		--Print screen
		awful.key({}, "Print",			function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/'") end,
				  {description = "Printscreen",	group="screen"}),
		awful.key({"Shift",}, "Print",	function () awful.util.spawn("scrot -u -e 'mv $f ~/Pictures/'") end,
				  {description = "Printscreen selected window",	group="screen"}),
		awful.key({"Control"}, "Print",	function () awful.spawn.with_shell("sleep 0.4 && scrot -s -e 'mv $f ~/Pictures/'") end,
				  {description = "Printscreen select area",	group="screen"}),

		-- Audio    
		awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -D pulse sset Master 5%+", false) end,
				  {description = "Raise the audio volume",	group="audio"}),
		awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -D pulse sset Master 5%-", false) end,
				  {description = "Lower the audio volume",	group="audio"}),
		awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -D pulse sset Master toggle", false) end,
				  {description = "Toggule the audio mute/unmute",	group="audio"}),
		
		--Media Buttons
		awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell("mocp --toggle-pause") end,
				  {description = "Toggle Play on moc",	group="audio"}),
		awful.key({ }, "XF86AudioNext", function () awful.util.spawn_with_shell("mocp --next") end,
				  {description = "Play next on moc",	group="audio"}),
		awful.key({ }, "XF86AudioPrev", function () awful.util.spawn_with_shell("mocp --previous") end,
				  {description = "Toggle Previous on moc",	group="audio"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()

            -- Checks if client/window is full screen
            --if not c.fullscreen then
            --  -- Clients have rounded corners
            --    c.shape = function(cr,w,h)
            --      gears.shape.rounded_rect(cr,w,h,rc)
            --    end
            --else
            --  -- Clients have square corners
            --    c.shape = function(cr,w,h)
            --      gears.shape.rounded_rect(cr,w,h,0)
            --    end
            --end
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey   }, "q",               function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  function (c) c.floating = not c.floating c.ontop = not c.ontop end , --awful.client.floating.toggle
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    
		awful.key({ modkey, "Shift" }, "t",      function (c) awful.titlebar.toggle(c) end,
		          {description = "toggle titlebar for window", group = "client"}),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
            -- Checks if client/window is maximized
            --if not c.maximized then
            --  -- Clients have rounded corners
            --    c.shape = function(cr,w,h)
            --      gears.shape.rounded_rect(cr,w,h,rc)
            --    end
            --else
            --  -- Clients have square corners
            --    c.shape = function(cr,w,h)
            --      gears.shape.rounded_rect(cr,w,h,0)
            --    end
            --end
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        --s.bottombox.visible= not s.bottombox.visible

        --Checks if there's bottom panel
        if s.bottombox then
          s.bottombox.visible = not s.bottombox.visible
        end
      end
      end,
    {description = "toggle wibox", group = "awesome"}),

    --Makes window sticky to show in all tags
    awful.key({ modkey, "Shift"   }, "s",
    function (c)
      c.sticky = not c.sticky
      c:raise()
    end ,
    {description = "Sticky Window", group = "client"}),    

    --Show all clients/windows from all tags from the screen
    awful.key({ modkey }, 0,
      function ()
        --naughty.notify({text="button pressed"})
        if not ctag then 
          --naughty.notify({text="ctag is nil"})
          ctag = awful.screen.focused().selected_tag
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          for i = 1, 9 do
            if tag then
              if not tag.selected then
                 awful.tag.viewtoggle(tag)
                 --tag:view_only()
              end
            end
          end
        else
          --awful.tag.viewidx(ctag.index-1)
          --naughty.notify({text="ctag is not nil"})
          ctag:view_only()
          --awful.tag.viewtoggle(ctag)
          ctag = nil --Unsets ctag after restored to previous tag
        end
      end ,
      {description = "View all tags", group = "tag"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           ctag = nil
                           tag:view_only()
                           --Unsets the ctag when move to another tag
                           --if ctag then
                             --naughty.notify({text="ctag "})
                           --end
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
        --
        if not c.floating then
          awful.client.floating.toggle(c)
          c.ontop = not c.ontop
        end
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
					"riseup-vpn",
					"gcr-prompter",
          "system-config",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
					"Gnome-Calculator", -- Gnome calculator
					"RiseupVPN",        -- Riseup VPN indicator
					"Gcr-prompter",
          "System-config-printer.py",
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
					"Calculator",
					"Copying files",
					"Moving files","Confirm",
					"Torrent Options",
					"Creating New Folder",
					"Error",
          "LibreOffice 7.1 Document Recovery",
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          --"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        },
      }, properties = { floating = true, placement = awful.placement.centered }},


      { rule_any = { 
        class = {
          "mpv",
          "vlc",
          "zoom",
      },
      instance = {
          "floatcenter",
      },
    },
    properties = { floating = true,  placement = awful.placement.centered , ontop = true, sticky = true  }
    },

		--[[	rule_any = {
      instance = {
          --"gl",
          "mocp,"
      },
      instance = {"mocp"},
      class = {"mocp"},
      --name = {"mocp"}, -- working
    },
    properties = { floating = true,  placement = awful.placement.centered , ontop = true, sticky = true  }
    },]]

		-- Set Firefox/Google Chrome/Chromium to always map on the tag named "3" on screen 1.
		-- { rule = { class = "Firefox" },
		--   properties = { screen = 1, tag = "2" } },
		{	rule_any = {class	   = {"Firefox", "google-chrome", "Google-chrome","Brave-browser","brave-browser"},
							    name  	 = {"Mozilla Firefox"},
							    instance = {"Navigator"},
							    role		 = {"browser"},
			},
			except = { role = "browser-window" },
				--,"chromium-browser", "Chromium-browser", "google-chrome", "Google-chrome"
	  		properties = { tag = "" } --""  tags[1][3]
		},

		{	rule_any =	{name	 = {"Transmission"},
							     role	 = {"tr-main"},
							     class = {"Transmission-gtk","transmission-gtk" },
	  		},

			properties = { tag = "" } --"" tags[9]
		},

		-- Set Atom/Sublime to tag 2
		{	rule_any = {class	= {"Atom"},
							role	    = {"browser-window"},
							class	 	  = {"sublime_text"},
							name 		  = {"Sublime_text"},
							class 		= {"Sublime_text"},
							class		  = {"Apache NetBeans IDE 12.4"},
							instance	= {"java-lang-Thread"},
							class		  = {"Brackets"},
							class		  = {"Geany "},
			},
	  		properties = { tag = "" }
		},
		
		-- Set PCManFM/Thunar/Nautilus to tag 5
		{	rule_any = {instance= {"pcmanfm","thunar"},
							    class	 	= {"Pcmanfm","Thunar"},
							    --instance	= {"thunar"},
							    role		= {"Thunar-"},
							    --class	 = {"Thunar"},
							    instance= {"org.gnome.Nautilus"},
							    class		= {"Org.gnome.Nautilus"},
			},
	  		properties = { tag = "" }
		},

		-- Set Rhythmbox to tag 6
		{	rule_any = {instance= {"rhythmbox"},
							    class	 	= {"Rhythmbox"},
			},
	  		properties = { tag = "" }
		},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    -- Clients have rounded corners
    c.shape = function(cr,w,h)
      gears.shape.rounded_rect(cr,w,h,rc)
    end
end)

client.connect_signal("property::maximized", function (c)
    -- Checks if client/window is maximized
    if not c.maximized then
      -- Clients have rounded corners
	c.shape = function(cr,w,h)
	  gears.shape.rounded_rect(cr,w,h,rc)
	end
    else
      -- Clients have square corners
	c.shape = function(cr,w,h)
	  gears.shape.rounded_rect(cr,w,h,0)
	end
    end
end)

client.connect_signal("property::fullscreen", function (c)
    -- Checks if client/window is fullscreen
    if not c.fullscreen then
      -- Clients have rounded corners
	c.shape = function(cr,w,h)
	  gears.shape.rounded_rect(cr,w,h,rc)
	end
    else
      -- Clients have square corners
	c.shape = function(cr,w,h)
	  gears.shape.rounded_rect(cr,w,h,0)
	end
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.minimizebutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Clients have rounded corners
client.connect_signal("manage", function (c) 
  if not c.maximized then
    c.shape = function(cr,w,h)
      gears.shape.rounded_rect(cr,w,h,rc)
    end
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus --[[ c.opacity = 1 ]] ctag = client.focus and client.focus.first_tag or nil end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal --[[ c.opacity = 0.85 ]] end)
-- }}}

-- Hotkeys list, set font size.
beautiful.get().hotkeys_font = "Ubuntu Mono Bold 16"
beautiful.get().hotkeys_description_font = "Ubuntu Mono Bold 14"

awful.util.spawn(os.getenv("HOME") .. "/.config/awesome/autostart.sh")
