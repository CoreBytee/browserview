local WindowHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Uv = require("uv")

function WindowHelper:initialize(Path, SessionId, Port, Stdio)
    self.Path = Path
    self.SessionId = SessionId
    self.Port = Port
    if Stdio == true then
        self.Stdio = {
            process.stdin.handle,
            process.stdout.handle,
            process.stderr.handle
        }
    end
end

function WindowHelper:Start()
    local Result, Error = Spawn(
        self.Path,
        {
            stdio = self.Stdio,
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