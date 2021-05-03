
local utils = require("src.widgets")
local popup = require("src.widgets.popup")

local text = popup.text("0")
local popup = popup.gen(" ", text)

local last = os.time(os.date("!*t"))

awesome.connect_signal("widgets::volumechange", function()
    last = os.time(os.date("!*t"))
    volume = io.popen("pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \\([0-9][0-9]*\\)%.*,\\1,'"):read("*all*")
    num = tonumber(volume)
    text.markup = num
    popup.visible = true
    gears.timer({
        timeout   = 3,
        autostart = true,
        single_shot = true,
        callback  = function()
            delta = os.time(os.date("!*t")) - last
            if delta >= 2.5 then
                popup.visible = false
            end
        end
    })
end)