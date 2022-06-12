local PathLib = require("path")

local Paths = {
    ["win32"] = "BrowserView\\browserview.exe",
    ["darwin"] = "BrowserView/browserview.app/Contents/MacOS/browserview"
}

return function (Settings)
    local Settings = Settings or {}
    Settings.ExecutablePath = PathLib.resolve(BVAD .. Paths[TypeWriter.Os])
    Settings.WebHelper = PathLib.resolve(BVAD .. "/WebHelper.twr")
    return Import("ga.corebyte.BrowserView"):new(Settings)
end