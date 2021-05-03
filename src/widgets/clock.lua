local utils = require("src.widgets")

local text_clock = utils.textclock("%R", 9)

local clock_icon = utils.icon("  ")
local clock = wibox.container.margin(wibox.widget({
    clock_icon, 
    text_clock,
    layout = wibox.layout.fixed.horizontal,
}),10, 10)

return utils.round(clock)