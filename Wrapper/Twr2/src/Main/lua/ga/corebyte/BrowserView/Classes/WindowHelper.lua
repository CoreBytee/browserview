local WindowHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Uv = require("uv")

function WindowHelper:initialize(Path)
    self.Path = Path
end

function WindowHelper:Start()
    local Result, Error = Spawn(
        self.Path,
        {}
    )
    self.Result = Result
end

function WindowHelper:Stop()
	Uv.process_kill(self.Result.handle, Uv.constants.SIGINT)
end

return WindowHelper