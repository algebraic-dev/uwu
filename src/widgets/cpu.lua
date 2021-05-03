--[[
    Instanciação do comando de pegar CPU
]]


local utils = require("src.widgets")

local cpu_text =  utils.text("12%", 9)
local cpu_icon = utils.icon('  ')

local cpu = wibox.container.margin(wibox.widget({
    cpu_icon,
    cpu_text,
    layout = wibox.layout.fixed.horizontal,
}),10, 10)

-- Sinal do uso de cpu usado 
awesome.connect_signal("widgets::cpu", function(usage)
    cpu_text.text = tostring( usage ) .. "%"
end)


awful.widget.watch("sh -c \"vmstat | tail -1 | awk '{printf $15}'\"", 5, function(xe, stdout, y)
    cpu_text.text = tostring( 100 - tonumber(stdout) ) .. "%"
end)

return utils.round(cpu)