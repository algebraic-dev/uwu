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

local text = wibox.widget{
    text = '56%',
    font = "raleway 7",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local margin = wibox.widget {
    {
        {
            progress,
            forced_height = 200,
            forced_width  = 20,
            direction     = 'east',
            layout        = wibox.container.rotate,
        },            
        {
            text,
            top = 10,
            bottom = 5,
            layout     = wibox.container.margin
        },
        forced_height = 230,
        forced_width  = 20,
        layout = wibox.layout.fixed.vertical,
    },
    margins = 8,
    widget  = wibox.container.margin
}

local popup = awful.popup {
    widget = margin,
    placement    = function(popup) 
        return awful.placement.right(popup, { margins = { right = 5 } })
    end,
    shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,100)
    end,
    x = 20,
    bg = "#222222",
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
    text.markup = num .. "%"
    progress.value = num/100
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