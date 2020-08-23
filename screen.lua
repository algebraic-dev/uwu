--[[
    Criação da wibar
]]

local layout_margin = 3

-- Widget de relógio

local text_clock = wibox.widget.textclock("%R")

local clock_icon = wibox.widget{
    markup = "<span color='#cf6dd6'>  </span>",
    font = "Ionicons 11",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local clock = wibox.container.margin(wibox.widget(
    {
        clock_icon, 
        text_clock,
        layout = wibox.layout.fixed.horizontal,
    }
),10, 10)

-- Widget de Bat

local bat_text =  wibox.widget.textbox("12%")

local bat_icon = wibox.widget{
    markup = "<span color='#7dafff'>  </span>",
    font = "Ionicons 11",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local bat = wibox.container.margin(wibox.widget(
    {
        bat_icon,
        bat_text,
        layout = wibox.layout.fixed.horizontal,
    }
),10, 10)

awesome.connect_signal("widgets::battery", function(vol, charging)
    if charging then
        bat_text.text = "A/C"
        bat_icon.markup = "<span color='#7dafff'>  </span>"
    else 
        bat_text.text = vol .. "%"
        if vol > 20 then
            bat_icon.markup = "<span color='#7dafff'>  </span>"
        else 
            bat_icon.markup = "<span color='#7dafff'>  </span>"
        end
    end
end)

-- Widget de CPU

local cpu_text =  wibox.widget.textbox("12%")

local cpu_icon = wibox.widget{
    markup = '<span color="#6dd676">  </span>',
    font = "Ionicons 11",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local cpu = wibox.container.margin(wibox.widget(
    {
        cpu_icon,
        cpu_text,
        layout = wibox.layout.fixed.horizontal,
    }
),10, 10)

-- Sinal do uso de cpu usado 
awesome.connect_signal("widgets::cpu", function(usage)
    cpu_text.text = tostring( usage ) .. " %"
end)

-- Função para criação do wallpaper para uma tela
local function set_wallpaper(s)
    local wallpaper = beautiful.wallpaper
    if wallpaper then 
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    -- Tags para cada workspace
    awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    -- Prompt para chamar os aplicativos
    s.mypromptbox = awful.widget.prompt()

    -- Inicio da wibar
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 25 })

    -- Setup da wibar
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mypromptbox,
        },
        nil,
        { 
            layout = wibox.layout.fixed.horizontal,
            wibox.container.background(cpu,"#212121"), 
            wibox.container.background(bat,"#1c1c1c"),
            wibox.container.background(clock,"#121212"),
        },
    }
end)