--[[
    Instanciação do comando de pegar CPU
]]
awful.widget.watch("sh -c \"vmstat | tail -1 | awk '{printf $15}'\"", 5, function(xe, stdout, y)
    awesome.emit_signal("widgets::cpu", 100 - tonumber(stdout))
end)