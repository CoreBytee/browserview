local WebHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Json = require("json")
local Wrap = coroutine.wrap

function WebHelper:initialize()
    self.Port = 25675

    self:On(
        "stdout",
        function (Message)
            local Decoded, _, Error = Json.decode(Message)
            if Decoded == nil then
                return
            end

            self:Emit("JsonData", Decoded)
        end
    )
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
    self.Result = Result

    Wrap( function () for Message in Result.stdout.read do self:emit("stdout", Message) TypeWriter.Logger.Info("WebHelper > " .. Message) end end )()
	Wrap( function () for Message in Result.stderr.read do self:emit("stderr", Message) TypeWriter.Logger.Info("WebHelper > " .. Message) end end )()

   
end

function WebHelper:Stop()
	Uv.process_kill(self.Result.handle, Uv.constants.SIGINT)
end

return WebHelper