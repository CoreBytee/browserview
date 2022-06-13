local WindowWrapper = Import("ga.corebyte.BetterEmitter"):extend()

local WebHelper = Import("ga.corebyte.BrowserView.Classes.WebHelper")
local WindowHelper = Import("ga.corebyte.BrowserView.Classes.WindowHelper")

local Spawn = require("coro-spawn")

function WindowWrapper:initialize(Parent, ExecutablePath, WebHelperPath, Stdio, Options)
    self.Parent = Parent
    self.SessionId = string.random(16)
    self.Port = 25675
    self.WebHelper = WebHelper:new(self.SessionId, self.Port, WebHelperPath, Stdio)
    self.WindowHelper = WindowHelper:new(ExecutablePath, self.SessionId, self.Port, Stdio, Options)
    Parent:On("closed", function ()
        if self.WebHelper.Connection then
            self.WebHelper:Emit("Response", {}, true)
            self.WebHelper.Connection.Write()
        end
    end)
end

function WindowWrapper:Start()
    self.WebHelper:Start()
    self.WindowHelper:Start()

    self.WebHelper:On(
        "Message",
        function (Data)
            if Data.Name == "WindowEvent" then
                local EventData = Data.Data
                self.Parent:Emit(
                    EventData[1],
                    EventData[2]
                )
            end
        end
    )
end

function WindowWrapper:Stop()
    self.WindowHelper:Stop()
    self.Parent:Emit("closed")
end

function WindowWrapper:Send(To, Name, ...)
    return self.WebHelper:Send(To, Name, ...)    
end

return WindowWrapper