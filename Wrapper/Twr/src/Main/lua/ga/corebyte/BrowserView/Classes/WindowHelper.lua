local WindowHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Uv = require("uv")

function WindowHelper:initialize(Path, SessionId, Port)
    self.Path = Path
    self.SessionId = SessionId
    self.Port = Port
end

function WindowHelper:Start()
    local Result, Error = Spawn(
        self.Path,
        {
            stdio = {
                process.stdin.handle,
                process.stdout.handle,
                process.stderr.handle
            },
            args = {
                self.SessionId,
                self.Port
            }
        }
    )
    self.Result = Result
end

function WindowHelper:Stop()
	Uv.process_kill(self.Result.handle, Uv.constants.SIGINT)
end

return WindowHelper