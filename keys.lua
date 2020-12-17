
-- Funções do lado do awesomeWM para modificação do layout,
-- do foco das janelas e outros.

root.buttons(gears.table.join(
    awful.button({ }, 3, function () end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

function screenshot() awful.spawn("flameshot gui") end
function focus_next() awful.client.focus.byidx( 1) end
function focus_previous() awful.client.focus.byidx(-1) end
function swap_next() awful.client.swap.byidx(  1)    end
function swap_previous() awful.client.swap.byidx( -1)    end
function focus_next_screen() awful.screen.focus_relative( 1) end
function focus_previous_screen() awful.screen.focus_relative(-1) end
function spawn_terminal() awful.spawn(terminal) end
function increase_width() awful.tag.incmwfact( 0.05) end
function decrease_width() awful.tag.incmwfact( -0.05) end
function increase_master() awful.tag.incnmaster( 1, nil, true) end
function decrease_master() awful.tag.incnmaster(-1, nil, true) end
function increase_columns() awful.tag.incncol( 1, nil, true) end
function decrease_columns() awful.tag.incncol(-1, nil, true) end
function next_layout() awful.layout.inc( 1) end
function prev_layout() awful.layout.inc( 1) end
function run_prompt() awful.screen.focused().mypromptbox:run() end
function show_prompt() menubar.show() end


function go_back()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end

function restore_minimized()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
      )
    end
end

function run_lua_prompt()
    awful.prompt.run {
      prompt       = "Run Lua code: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
end

function volume_up()
    os.execute("pactl -- set-sink-volume 0 +1%")
    awesome.emit_signal("widgets::volumechange")
end

function volume_down()
    os.execute("pactl -- set-sink-volume 0 -1%")
    awesome.emit_signal("widgets::volumechange")
end

-- Criação da tabela global 

globalkeys = gears.table.join(
    awful.key({                   }, "XF86AudioLowerVolume", volume_down),
    awful.key({                   }, "XF86AudioRaiseVolume", volume_up),
    awful.key({                   }, "Print", screenshot),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key({ modkey,           }, "j",      focus_next,{description = "focus next by index", group = "client"}),
    awful.key({ modkey,           }, "k",      focus_previous,   {description = "focus previous by index", group = "client"}),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",      swap_next,        {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k",      swap_previous,    {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j",      focus_next_screen,{description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k",      focus_previous_screen, {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u",      awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",    go_back,          {description = "go back", group = "client"}),
    awful.key({ modkey,           }, "Return", spawn_terminal,   {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r",      awesome.restart,  {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit,     {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",      increase_width,   {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",      decrease_width,   {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",      increase_master,  {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",      decrease_master,  {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",      increase_columns, {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",      decrease_columns, {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space",  next_layout,      {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space",  prev_layout,      {description = "select previous", group = "layout"}),
    awful.key({ modkey, "Control" }, "n",      restore_minimized,{description = "restore minimized", group = "client"}),
    awful.key({ modkey }, "r", run_prompt, {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x", run_lua_prompt, {description = "lua execute prompt", group = "awesome"}),

    awful.key({ modkey }, "p", show_prompt, {description = "show the menubar", group = "launcher"})
)

-- Funções da janela

function kill_client(c) c:kill() end
function move_to_master(c) c:swap(awful.client.getmaster()) end
function move_to_screen(c) c:move_to_screen() end
function keep_on_top(c) c.ontop = not c.ontop end

function minimize(c) c.minimized = true end 

function maximize(c)
    c.maximized = not c.maximized
    c:raise()
end 
function maximize_vertically(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
end 


function maximize_horizontally(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
end 

function toogle_fullscreen(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end

-- Instanciação das telas com as funções
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",      toogle_fullscreen, {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "c",      kill_client, {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", move_to_master,{description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      move_to_screen,{description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      keep_on_top,{description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",      minimize,{description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",      maximize,{description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",      maximize_vertically, {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",      maximize_horizontally, {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
