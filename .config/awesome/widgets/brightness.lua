-----------------------------------------------
-- Volume Pulse widget
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")  -- Provides the widgets
local watch = require("awful.widget.watch")  -- For periodic command execution
local beautiful = require("beautiful")

-- Create the text widget
local vol_text = wibox.widget{
  font = "JetBrains Mono Bold 9",
  widget = wibox.widget.textbox,
}

-- Create the background widget
local vol_widget = wibox.widget.background()
vol_widget:set_widget(vol_text)

-- Set the base colors
vol_widget:set_bg(beautiful.taglist_fg_occupied)
vol_widget:set_fg(beautiful.fg_focus)

-- Sets mouse clicks
vol_widget:buttons(
  awful.util.table.join(
  --  awful.button({ }, 1, --left click to toggle mute
  --    function()
  --      awful.util.spawn("pulsemixer --toggle-mute")
  --    end
  --  ),
  --  awful.button({ }, 3, --right click to launch
  --    function()
  --      awful.util.spawn(terminal .. " --class floatcenter -e pulsemixer")
  --    end
  --  ),
    awful.button({ }, 4, --Scroll up to increase volume
      function()
        awful.util.spawn("brightnessctl s 10+")
      end
    ),
    awful.button({ }, 5, --Scroll down to lower volume
      function()
        awful.util.spawn("brightnessctl s 10-")
      end
    )
  )
)

function update()
  watch(
    os.getenv("HOME") .. "/.local/bin/brightness.sh", 0,
    function(_, stdout, stderr, exitreason, exitcode)
      local vol = nil

      -- This loop matches the groups number(s).number(s)
      -- each pair is converted to a number and saved on `temp`
      -- (Only the last group is kept)
      --for str in string.gmatch(stdout, "([0-9]+.[0-9]+)") do
      -- temp = tonumber(str)
      --end
      
      vol = stdout

      vol_text:set_text(vol)
      --vol_widget:set_bg(beautiful.bg_focus) -- Working
      --vol_widget:set_fg(beautiful.fg_focus) -- Working
      
      --naughty.notify({text=beautiful.bg_normal})
      -- Set colors depending on the temperature
      --if (temp < 70) then
      --  vol_widget:set_bg("#008800")
      --  vol_widget:set_fg("#ffffff")
      --elseif (temp < 80) then
      --  vol_widget:set_bg("#AB7300")
      --  vol_widget:set_fg("#ffffff")
      --  was_down = true
      --else
      --  vol_widget:set_bg("#880000")
      --  vol_widget:set_fg("#ffffff")
      --  was_down = true
      --end

      -- Launch the garbage collector, this only has to be on one
      -- widget (no problem if there's more though).
      -- See: https://github.com/awesomeWM/awesome/issues/2858#issuecomment-980489840
      collectgarbage()

    end,
    vol_widget
  )
end

update()
vol_text:set_text(" N/A ")

-- Export the widget
return vol_widget
