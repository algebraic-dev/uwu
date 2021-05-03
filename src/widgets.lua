local utils = {}

function utils.span(text)
    return "<span color='" .. config.theme.widget_color .. "'>" .. text .. "</span>";
end

function utils.icon(text) 
    return wibox.widget{
        markup = utils.span(text),
        font = "Ionicons 11",
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

function utils.text(text, size) 
    return wibox.widget{
        text = text,
        font = "ubuntu " .. tostring(size),
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

function utils.textclock(text, size) 
    return wibox.widget{
        format = text,
        font = "ubuntu " .. tostring(size),
        valign = 'center',
        halign = 'center',
        widget = wibox.widget.textclock
    }
end

function utils.round(widget) 
    local shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,10)
    end
    return wibox.container.margin(
        wibox.container.background(widget, config.theme.widget_bg_color, shape),0,10,5,0)
end

return utils