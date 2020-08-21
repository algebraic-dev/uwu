pcall(require, "luarocks.loader")

gears = require("gears")
awful = require("awful")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")
actual_dir = os.getenv("HOME") .. "/.config/awesome/"

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

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

beautiful.init(actual_dir .. "/theme.lua")

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

require("screen")
require("keys")
require("widgets/init")


menubar.utils.terminal = terminal
mykeyboardlayout = awful.widget.keyboardlayout()
root.keys(globalkeys)

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
    { rule = { class = "firefox" }, properties = { screen = 1, tag = "3" } },
    { rule = { class = "discord" }, properties = { screen = 1, tag = "2" } },
    { rule = { class = "Code" }, properties = { screen = 1, tag = "1" } },
}

client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.easy_async_with_shell("picom --conf $HOME/.config/picom.conf", function(out) end)