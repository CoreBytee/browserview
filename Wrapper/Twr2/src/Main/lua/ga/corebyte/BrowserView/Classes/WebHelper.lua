local WebHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Json = require("json")
local Wrap = coroutine.wrap

function WebHelper:initialize(SessionId, Port)
    self.Port = Port
    self.SessionId = SessionId

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

local function SpawnProcess(self)
    local Result, Error = Spawn(
		TypeWriter.This,
		{
			args = {
				"execute",
				"--input=" .. TypeWriter.Here .. "/./webhelper.twr",
				"--port=" .. self.Port
			},
            stdio = {
                process.stdin.handle,
                process.stdout.handle,
                process.stderr.handle
            }
            --detached = true,
            --hide = true
		}
	)
    return Result, Error
end

local function Connect(self)
    local Connection
    while Connection == nil do
        local Response, Read, Write = require("coro-websocket").connect(
            require("coro-websocket").parseUrl(
                string.format(
                    "%s://%s:%s/%s",
                    "ws",
                    "localhost",
                    self.Port,
                    string.format(
                        "%s/%s",
                        "backend",
                        self.SessionId
                    )
                )
            )
        )
        if Response ~= nil then
            Connection = {
                Read = Read,
                Write = Write
            }
        end
        Sleep(50)
    end
    return Connection
end

function WebHelper:Start()
    local Result, Error = SpawnProcess(self)

    local Connection = Connect(self)
    self.Connection = Connection
    self:Emit("Connected")
    coroutine.wrap(
        function ()
            for Message in Connection.Read do
                local Payload = Message.payload
                local Decoded = Json.decode(Payload)
                if Decoded ~= nil then
                    if Decoded.Type == "Response" then
                        self:Emit("Response", Decoded)
                    end
                end
            end
        end
    )()
end

function WebHelper:Send(To, Name, ...)
    if not self.Connection then
        self:WaitFor("Connected")
    end
    local Sequence = string.random(16)
    self.Connection.Write(
        {
            payload = Json.encode(
                {
                    Sequence = Sequence,
                    To = To,
                    Type = "Message",
                    Name = Name,
                    Data = {...}
                },
                {
                    indent = true
                }
            )   
        }
    )
    local _, ResponseData = self:WaitFor(
        "Response",
        nil,
        function (Response)
            return Response.Sequence == Sequence
        end
    )
    return ResponseData.Data
end

return WebHelper