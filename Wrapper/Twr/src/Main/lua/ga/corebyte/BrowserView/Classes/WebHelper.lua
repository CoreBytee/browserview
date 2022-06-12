local WebHelper = Import("ga.corebyte.BetterEmitter"):extend()

local Spawn = require("coro-spawn")
local Json = require("json")
local Wrap = coroutine.wrap

function WebHelper:initialize(SessionId, Port, WebHelperPath, Stdio)
    self.Port = Port
    self.SessionId = SessionId
    self.WebHelperPath = WebHelperPath
    if Stdio == true then
        self.Stdio = {
            process.stdin.handle,
            process.stdout.handle,
            process.stderr.handle
        }
    end
end

local function SpawnProcess(self)
    local Result, Error = Spawn(
		TypeWriter.This,
		{
			args = {
				"execute",
				"--input=" .. self.WebHelperPath,
				"--port=" .. self.Port
			},
            stdio = self.Stdio
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
                    if Decoded.Type == "Message" then
                        self:Emit("Message", Decoded)
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
    return table.unpack(ResponseData.Data)
end

return WebHelper