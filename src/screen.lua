--[[
    Criação da wibar
]]

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local config = require("src.utils").config
local layout_margin = 3
local utils = require("src.widgets")

local clock = require("src.widgets.clock")
local bat = require("src.widgets.bat")
local cpu = require("src.widgets.cpu")
require("src.widgets.volume")
require("src.widgets.brightness")

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

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then c.minimized = true else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () wful.client.focus.byidx(-1) end))

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    -- Tags para cada workspace
    awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    -- Prompt para chamar os aplicativos
    s.mypromptbox = awful.widget.prompt()
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        layout   = {
            spacing = 8,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        
                            {
                                id     = 'index_role',
                                forced_width = 4,
                                forced_height = 4,
                                widget = wibox.widget.textbox,
                            },
                        shape  = gears.shape.circle,
                        widget = wibox.container.background,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 6,
                right = 6,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = ""
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#ff0000' then
                        self.backup     = self.bg
                        self.has_backup = true
                    end
                    self.bg = '#ff0000'
                end)
                self:connect_signal('mouse::leave', function()
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
        },
        buttons = taglist_buttons
    }

    -- Inicio da wibar
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 30 })

    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = {
            bg_normal = config_toml.theme.widget_bg_color,
            bg_focus = config_toml.theme.widget_bg_color,
            bg_minimize = config_toml.theme.widget_bg_color,
            shape  = function(cr,w,h)
                wibox.container.margin(
                gears.shape.rounded_rect(cr,w,h,10),10,10,10,10)
            end,
        },
        layout   = {
            spacing = 10,
            spacing_widget = {
                forced_width = 5,
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id     = 'icon_role',
                                widget = wibox.widget.imagebox,
                            },
                            right = 5,
                            left = 3,
                            widget  = wibox.container.margin,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    margins = 5,
                    widget = wibox.container.margin
                },
                id = 'background_role',
                bg = "#F00",
                widget = wibox.container.background
            },
            left = 10,
            widget = wibox.container.margin
        }
    }


    -- Setup da wibar
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            wibox.container.margin(utils.round( wibox.container.margin(s.mytaglist, 10, 10)), 5, 10),
            layout = wibox.layout.fixed.horizontal,
            s.mypromptbox,
        },
        {
            s.mytasklist,
            top = 5,
            widget = wibox.container.margin
        },
        { 
            layout = wibox.layout.fixed.horizontal,
            bat,
            cpu,
            clock
        },
    }

end)