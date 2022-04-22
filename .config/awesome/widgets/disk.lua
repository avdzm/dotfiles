-----------------------------------------------
-- Volume Pulse widget
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")  -- Provides the widgets
local watch = require("awful.widget.watch")  -- For periodic command execution
local beautiful = require("beautiful")

-- Create the text widget
local disk_text = wibox.widget{
  font = "JetBrains Mono Bold 10",
  widget = wibox.widget.textbox,
}

-- Create the background widget
local disk_widget = wibox.widget.background()
disk_widget:set_widget(disk_text)

-- Set the base colors
disk_widget:set_bg(beautiful.fg_urgent)
disk_widget:set_fg(beautiful.fg_focus)

-- Sets mouse clicks
disk_widget:buttons(
  awful.util.table.join(
  --  awful.button({ }, 1, --left click to toggle mute
  --    function()
  --      awful.util.spawn("pulsemixer --toggle-mute")
  --    end
  --  ),
    awful.button({ }, 3, --right click to launch
      function()
        awful.util.spawn(terminal .. " --class floatcenter -e htop")
      end
    )
  --  awful.button({ }, 4, --Scroll up to increase diskume
  --    function()
  --      awful.util.spawn("pulsemixer --change-diskume +5")
  --    end
  --  ),
  --  awful.button({ }, 5, --Scroll down to lower diskume
  --    function()
  --      awful.util.spawn("pulsemixer --change-diskume -5")
  --    end
  --  )
  )
)

function update()
  watch(
    os.getenv("HOME") .. "/.local/bin/disk.sh nvme0n1p2", 1800,
    function(_, stdout, stderr, exitreason, exitcode)
      local disk = nil

      -- This loop matches the groups number(s).number(s)
      -- each pair is converted to a number and saved on `temp`
      -- (Only the last group is kept)
      --for str in string.gmatch(stdout, "([0-9]+.[0-9]+)") do
      -- temp = tonumber(str)
      --end
      
      disk = stdout

      disk_text:set_text(disk)
      --disk_widget:set_bg(beautiful.bg_focus) -- Working
      --disk_widget:set_fg(beautiful.fg_focus) -- Working
      
      --naughty.notify({text=beautiful.bg_normal})
      -- Set colors depending on the temperature
      --if (temp < 70) then
      --  disk_widget:set_bg("#008800")
      --  disk_widget:set_fg("#ffffff")
      --elseif (temp < 80) then
      --  disk_widget:set_bg("#AB7300")
      --  disk_widget:set_fg("#ffffff")
      --  was_down = true
      --else
      --  disk_widget:set_bg("#880000")
      --  disk_widget:set_fg("#ffffff")
      --  was_down = true
      --end

      -- Launch the garbage collector, this only has to be on one
      -- widget (no problem if there's more though).
      -- See: https://github.com/awesomeWM/awesome/issues/2858#issuecomment-980489840
      collectgarbage()

    end,
    disk_widget
  )
end

update()
disk_text:set_text(" N/A ")

-- Export the widget
return disk_widget
