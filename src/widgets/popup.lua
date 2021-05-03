
local utils = require("src.widgets")
local config = require("src.utils").config
local popup = {}

function popup.text(text)
    return utils.text(text, 22)
end

function popup.gen(icon_text, text)
    local icon = wibox.widget{
        markup = utils.span(icon_text),
        font = "Ionicons 25",
        valign = 'center',
        widget = wibox.widget.textbox
    }
    
    local popup = awful.popup {
        widget = wibox.widget {
            {         
                {
                    {
                        icon,
                        text,
                        layout = wibox.layout.fixed.horizontal
                    },
                    top = 10,
                    left = 20,
                    bottom = 10,
                    layout     = wibox.container.margin
                },
                forced_height = 60,
                forced_width  = 120,
                layout = wibox.layout.fixed.vertical,
            },
            margins = 8,
            widget  = wibox.container.margin
        },
        placement = function(popup) 
            return awful.placement.left_top(popup, {})
        end,
        shape = function(cr,w,h)
            gears.shape.rounded_rect(cr,w,h,20)
        end,
        x = 25,
        y = 25,
        bg = config.theme.widget_bg_color,
        ontop = true,
        visible = false,
        hide_on_right_click = true,
        offset = {
            y = 10,
            x = 10
        }
    }

    return popup    
end

return popup