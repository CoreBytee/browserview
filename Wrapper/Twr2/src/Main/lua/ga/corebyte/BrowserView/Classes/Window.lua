local Window = Import("ga.corebyte.BetterEmitter"):extend()

local WindowWrapper = Import("ga.corebyte.BrowserView.Classes.WindowWrapper")

function Window:initialize(Settings)
    self.ExecutablePath = Settings.ExecutablePath

    self.WindowWrapper = WindowWrapper:new(self.ExecutablePath)
end

function Window:Start()
    return self.WindowWrapper:Start()
end

return Window