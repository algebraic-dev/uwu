--[[
    Criação do popup de brightness 
]]

local utils = require("src.widgets")

local popup = require("src.widgets.popup")

local text = popup.text("0")
local popup = popup.gen(" ", text)

local last = os.time(os.date("!*t"))

awesome.connect_signal("widgets::brightnesschange", function()
    last = os.time(os.date("!*t"))
    volume = io.popen("brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'"):read("*all*")
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