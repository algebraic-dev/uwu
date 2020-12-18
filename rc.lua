
-- Carrega o luarocks caso tenha dentro do sistema.
pcall(require, "luarocks.loader")

-- Algumas dependências padrões do awesomeWM
gears = require("gears")
awful = require("awful")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- Error handling 

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, there were errors during startup!", text = awesome.startup_errors })
end

local in_error = false

awesome.connect_signal("debug::error", function (err)
  if in_error then return end
  in_error = true
  naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, an error happened!", text = tostring(err) })
  in_error = false
end)

-- Carrega o tema do "beautiful"
actual_dir = os.getenv("HOME") .. "/.config/awesome/"
beautiful.init(actual_dir .. "/theme.lua")

-- Configurações padrões do usuário
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
}

-- Inicia os módulos
require("screen")
require("keys")
require("widgets")

-- Algumas outras configurações
menubar.utils.terminal = terminal
mykeyboardlayout = awful.widget.keyboardlayout()
root.keys(globalkeys)

-- Regras das janelas que vão ser criadas 
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen}
    },
    { rule_any = {
        instance = {
          "DTA",
          "copyq", 
          "pinentry",
        },
        class = {
          "Sxiv",
          "Tor Browser",
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},
        name = {
          "Event Tester",  
        },
        role = {
          "AlarmWindow",
          "ConfigManager",
          "pop-up",   
        }
      }, properties = { floating = true }},
    -- Regra para 3 aplicações serem criadas em janelas distintas.
    { rule = { class = "firefox" }, properties = { screen = 1, tag = "3" } },
    { rule = { class = "discord" }, properties = { screen = 1, tag = "2" } },
    { rule = { class = "Code" }, properties = { screen = 1, tag = "1" } },
}

-- Faz as janelas que estão fora do awesomeWM voltarem pra tela.
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Ativa o foco "sloppy" nas janelas
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
 
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- Inicia o compositor
awful.spawn.easy_async_with_shell("picom --experimental-backends --backend glx", function(out) end)