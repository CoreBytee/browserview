local WebHelper = Emitter:extend()

local Wrap = coroutine.wrap
local Spawn = require("coro-spawn")
local Uv = require("uv")

function WebHelper:initialize(Port)
    self.Port = Port
end

function WebHelper:Start()
    local Result, Error = Spawn(
        TypeWriter.This,
        {
            args = {
                "execute",
                "--input=" .. TypeWriter.Here .. "/./webhelper.twr",
                "--port=" .. self.Port
            }
        }
    )

    p(Error)
    Wrap( function () for Message in Result.stdout.read do self:emit("stdout", Message) print(Message) end end )()
    Wrap( function () for Message in Result.stderr.read do self:emit("stderr", Message) print(Message) end end )()

    self.Result = Result
end

function WebHelper:Stop()
    p("Stopping")
    p(Uv.process_kill(self.Result.handle, 0))
end

return WebHelper