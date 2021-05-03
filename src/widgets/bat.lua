--[[
    Chamada de comandos relativos a bateria
]]

local utils = require("src.widgets")

local charging = false

local bat_text = utils.text("12%", 8)

local bat_icon = utils.icon("  ")

local bat = wibox.container.margin(wibox.widget(
    {
        bat_icon,
        bat_text,
        layout = wibox.layout.fixed.horizontal,
    }
),10, 10)

function adjust_widget(vol, charging) 
    if charging then
        bat_text.text = "A/C"
        bat_icon.markup =  utils.span("  ")
    else 
        bat_text.text = vol .. "%"
        if vol > 20 then
            bat_icon.markup = utils.span("  ")
        else 
            bat_icon.markup = utils.span("  ")
        end
    end
end

awful.spawn.easy_async_with_shell("find /sys/class/power_supply/BAT?/capacity", function (file, _, __, code)
    if not (code == 0) then
        return
    end
    awful.widget.watch("cat ".. file, 5, function(_, stdout)
        adjust_widget(tonumber(stdout), charging)
    end)
end)

awful.spawn.easy_async_with_shell("find /sys/class/power_supply/*/online", function (file, _, __, code)
    awful.widget.watch("cat ".. file, 5, function(_, stdout)
        charging = tonumber(stdout) == 1
    end)
end)

return utils.round(bat)