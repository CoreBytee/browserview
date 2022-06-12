local WindowWrapper = Import("ga.corebyte.BetterEmitter"):extend()

local WebHelper = Import("ga.corebyte.BrowserView.Classes.WebHelper")
local WindowHelper = Import("ga.corebyte.BrowserView.Classes.WindowHelper")

local Spawn = require("coro-spawn")

function WindowWrapper:initialize(ExecutablePath, WebHelperPath)
    self.SessionId = string.random(16)
    self.Port = 25675
    self.WebHelper = WebHelper:new(self.SessionId, self.Port, WebHelperPath)
    self.WindowHelper = WindowHelper:new(ExecutablePath, self.SessionId, self.Port)
end

function WindowWrapper:Start()
    self.WebHelper:Start()
    self.WindowHelper:Start()
end

function WindowWrapper:Stop()
    self.WindowHelper:Stop()
end

function WindowWrapper:Send(To, Name, ...)
    return self.WebHelper:Send(To, Name, ...)    
end

return WindowWrapper