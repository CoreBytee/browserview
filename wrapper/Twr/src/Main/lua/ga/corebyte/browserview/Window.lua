TypeWriter.Runtime.LoadInternal("BetterEmitter")
local Window = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Wrap = coroutine.wrap
local Uv = require("uv")

function Window:initialize(Options)
    self.ExecutablePath = Options.ExecutablePath
    self.WebHelper = Import("ga.corebyte.browserview.WebHelper"):new(Options.Port or 25623)
end

function Window:Run(WindowOptions)
    self.WebHelper:Start()

    local Result, Error = Spawn(
        self.ExecutablePath,
        {
            
        }
    )

    self.ProcessResult = Result

    -- Output stdin and stdout to the emitter
    Wrap( function () for Message in Result.stdout.read do self:emit("stdout", Message) TypeWriter.Logger.Info("Electron > " .. Message) end end )()
    Wrap( function () for Message in Result.stderr.read do self:emit("stderr", Message) TypeWriter.Logger.Info("Electron > " .. Message) end end )()
    Wrap(function ()
        Result.waitExit()
        self:emit("exit")
        self.WebHelper:Stop()
    end)()

    self.WebHelper:Write("a", "b")
end

function Window:Stop()
	Uv.process_kill(self.ProcessResult.handle, Uv.constants.SIGINT)
end

function Window:SetSize(Width, Height, Animate)
    self.WebHelper:CallFunction("SetSize", Width, Height, Animate)
end

return Window