local layout_margin = 3

-- The clock widget
local text_clock = wibox.widget.textclock("%R")

local clock_icon = wibox.widget{
    markup = '  ',
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

-- Battery widget
local bat_text =  wibox.widget.textbox("12%")

local bat_icon = wibox.widget{
    text = '  ',
    font = "Ionicons 11",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}


awesome.connect_signal("widgets::battery", function(vol, charging)
    if charging then
        bat_text.text = "A/C"
        bat_icon.text = "  "
    else 
        bat_text.text = vol .. "%"
        bat_icon.text = "  "
    end
end)

local bat = wibox.container.margin(wibox.widget(
    {
        bat_icon,
        bat_text,
        layout = wibox.layout.fixed.horizontal,
    }
),10, 10)


-- CPU widget
local cpu_text =  wibox.widget.textbox("12%")

local cpu_icon = wibox.widget{
    markup = '  ',
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

-- I changed the wall folder cause it's easier to set a new
-- wallpaper 'with' nautilus now lul.
local function set_wallpaper(s)
    local wallpaper = os.getenv("HOME") .. "/wall.jpg"
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, false)
end

-- Re-set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    s.mywibox = awful.wibar({ position = "top", screen = s, height = 25 })


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
            --wibox.container.margin(s.mylayoutbox, layout_margin, layout_margin, layout_margin, layout_margin),
        },
    }
end)




-- }}}
