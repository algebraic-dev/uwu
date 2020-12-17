--[[
    Criação do popup de volume 
]]

local progress = wibox.widget {
    max_value     = 1,
    value         = 0.33,
    widget        = wibox.widget.progressbar,
    background_color = "#444",
    color = "#333",
    shape =  function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,200)
    end
}

local volume_icon = wibox.widget{
    markup = "<span color='#cf6dd6'> </span>",
    font = "Ionicons 25",
    valign = 'center',
    widget = wibox.widget.textbox
}

local text = wibox.widget{
    text = '0',
    font = "raleway 22",
    valign = 'center',
    widget = wibox.widget.textbox
}

local margin = wibox.widget {
    {         
        {
            {
                volume_icon,
                text,
                layout = wibox.layout.fixed.horizontal
            },
            top = 10,
            left = 20,
            bottom = 10,
            layout     = wibox.container.margin
        },
        forced_height = 60,
        forced_width  = 110,
        layout = wibox.layout.fixed.vertical,
    },
    margins = 8,
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