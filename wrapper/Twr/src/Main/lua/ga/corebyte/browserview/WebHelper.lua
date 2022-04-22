local WebHelper = Emitter:extend()

local Wrap = coroutine.wrap
local Spawn = require("coro-spawn")
local Uv = require("uv")
local Json = require("json")

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

	Wrap( function () for Message in Result.stdout.read do self:emit("stdout", Message) print(Message) end end )()
	Wrap( function () for Message in Result.stderr.read do self:emit("stderr", Message) print(Message) end end )()

	self.ProcessResult = Result
end

function WebHelper:Write(EndPoint, Message)
	local Data = {
		Type = "Message",
		Data = {
			EndPoint = EndPoint,
			Message = Message
		}
	}
	self.ProcessResult.stdin.write(Json.encode(Data))
end

function WebHelper:Stop()
	Uv.process_kill(self.ProcessResult.handle, Uv.constants.SIGINT)
end

return WebHelper