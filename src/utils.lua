-- Toml config
TOML  = require(".../libs.lua-toml.toml")

-- Alguns paths pra facilitar a vida
home = os.getenv("HOME")
actual_dir = home .. "/.config/awesome/"

function readAll(file_name)
    local f = io.open(file_name, "rb")
    if f ~= nil then
        local content = f:read("*all")
        f:close()
        return content
    else
        return ""
    end
end
  
config = TOML.parse(readAll(actual_dir .. "/config.toml"))

return {config = config}