TypeWriter.Runtime.LoadInternal("BetterEmitter")
local WebHelper = Import("ga.corebyte.BetterEmitter"):extend()

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

	Wrap( function () for Message in Result.stdout.read do self:emit("stdout", Message) TypeWriter.Logger.Info("WebHelper > " .. Message) end end )()
	Wrap( function () for Message in Result.stderr.read do self:emit("stderr", Message) TypeWriter.Logger.Info("WebHelper > " .. Message) end end )()

	self.ProcessResult = Result

	self:On(
		"stdout",
		function (Message)
			local Decoded, _, Error = Json.decode(Message)

			if Decoded == nil then
				return
			end

			if Decoded.Type == "Message" then
				self:emit("Message", Decoded.Message, Decoded.ConnectionId)
			end
		end
	)
end

function WebHelper:Write(EndPoint, Message)
	local Sequence = math.random(1, 1000000000)
	local Data = {
		Type = "Message",
		Sequence = Sequence,
		Data = {
			EndPoint = EndPoint,
			Message = Message
		}
	}
	self.ProcessResult.stdin.write(Json.encode(Data))
	local _, a = self:WaitFor(
		"Message",
		nil,
		function (Message)
			return Message.Sequence == Sequence
		end
	)
end

function WebHelper:CallFunction(FunctionName, ...)
	self:Write(
		"Main", 
		{
			Type = "CallFunction",
			FunctionName = FunctionName,
			Parameters = {...}
		}
	)
end

function WebHelper:Stop()
	Uv.process_kill(self.ProcessResult.handle, Uv.constants.SIGINT)
end

return WebHelper