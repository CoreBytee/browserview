local Window = Emitter:extend()

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
    Wrap( function () for Message in Result.stdout.read do self:emit("stdout", Message) print(Message) end end )()
    Wrap( function () for Message in Result.stderr.read do self:emit("stderr", Message) print(Message) end end )()
    Wrap(function ()
        Result.waitExit()
        self:emit("exit")
        self.WebHelper:Stop()
    end)()

    self.WebHelper:Write("a", "b")


    p(Error)
end

function Window:Stop()
	Uv.process_kill(self.ProcessResult.handle, Uv.constants.SIGINT)
end

return Window