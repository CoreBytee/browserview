local WindowHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Uv = require("uv")
local Json = require("json")
local Base = require("base64")

function WindowHelper:initialize(Path, SessionId, Port, Stdio, Options)
    self.Path = Path
    self.SessionId = SessionId
    self.Port = Port
    self.Options = Options or {}
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
                self.Port,
                Base.encode(Json.encode(self.Options))
            }
        }
    )
    p(Result)
    self.Result = Result
end

function WindowHelper:Stop()
	p(Uv.process_kill(self.Result.handle, Uv.constants.SIGINT))
end

return WindowHelper