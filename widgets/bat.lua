charging = false

awful.spawn.easy_async_with_shell("find /sys/class/power_supply/BAT?/capacity", function (file, _, __, code)
    if not (code == 0) then
        return
    end
    awful.widget.watch("cat ".. file, 5, function(_, stdout)
        awesome.emit_signal("widgets::battery", tonumber(stdout), charging)
    end)
end)

awful.spawn.easy_async_with_shell("find /sys/class/power_supply/*/online", function (file, _, __, code)
    awful.widget.watch("cat ".. file, 5, function(_, stdout)
        charging = tonumber(stdout) == 1
    end)
end)