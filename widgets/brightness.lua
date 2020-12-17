--[[
    Criação do popup de brightness 
]]

local brightness_icon = wibox.widget{
    markup = "<span color='#cf6dd6'> </span>",
    font = "Ionicons 25",
    valign = 'center',
    widget = wibox.widget.textbox
}

local text = wibox.widget{
    text = '0',
    font = "raleway 22",
    valign = 'center',
    align = 'center',
    widget = wibox.widget.textbox
}

local margin = wibox.widget {
    {         
        {
            {
                brightness_icon,
                text,
                layout = wibox.layout.fixed.horizontal
            },
            top = 10,
            left = 20,
            bottom = 10,
            align = 'center',
            layout     = wibox.container.margin
        },
        forced_height = 60,
        forced_width  = 120,
        layout = wibox.layout.fixed.vertical,
    },
    margins = 8,
    align = 'center',
    widget  = wibox.container.margin
}

local popup = awful.popup {
    widget = margin,
    placement = function(popup) 
        return awful.placement.left_top(popup, {})
    end,
    shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,20)
    end,
    x = 25,
    y = 25,
    bg = "#111",
    ontop = true,
    visible = false,
    hide_on_right_click = true,
    offset = {
        y = 10,
        x = 10
    }
}

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