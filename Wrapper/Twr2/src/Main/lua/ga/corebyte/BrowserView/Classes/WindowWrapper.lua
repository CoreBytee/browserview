local WindowWrapper = Import("ga.corebyte.BetterEmitter"):extend()

local WebHelper = Import("ga.corebyte.BrowserView.Classes.WebHelper")
local WindowHelper = Import("ga.corebyte.BrowserView.Classes.WindowHelper")

local Spawn = require("coro-spawn")

function WindowWrapper:initialize(ExecutablePath)
    self.WebHelper = WebHelper:new()
    self.WindowHelper = WindowHelper:new(ExecutablePath)
end

function WindowWrapper:Start()
    self.WebHelper:Start()
    self.WindowHelper:Start()
end

return WindowWrapper