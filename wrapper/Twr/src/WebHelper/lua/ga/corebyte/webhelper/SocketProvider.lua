TypeWriter.Runtime.LoadInternal("BetterEmitter")
local SocketProvider = Import("ga.corebyte.BetterEmitter"):extend()

function SocketProvider:initialize(Port)
    self.App = require("weblit").app
    local App = self.App
    self.Port = Port

    self.Connections = {}

    App.bind(
        {
            host = "0.0.0.0",
            port = Port
        }
    )
    
    App.use(require('weblit-auto-headers'))
    require("weblit-websocket")
    
    App.route(
        {
            method = "GET",
            path = "/",
        },
        function (Request, Response)
            Response.body = "Hello World"
            Response.code = 200
        end
    )

    App.websocket(
        {
            path = "/:Name"
        },
        function (Request, Read, Write)
            local ConnectionId = Request.params.Name
            print("Accepted connection: " .. ConnectionId)
            self.Connections[ConnectionId] = {
                Read = Read,
                Write = Write
            }

            for Message in Read do
                if #Message.payload ~= 0 then
                    self:emit("Message", Message.payload, ConnectionId)
                else
                    break
                end
            end

            self.Connections[ConnectionId] = nil
            Write()
        end
    )
    
end

function SocketProvider:Send(Message, ConnectionId)
    if self.Connections[ConnectionId] ~= nil then
        self.Connections[ConnectionId].Write(Message)
    end
end

function SocketProvider:Start()
    self.App.start()
end

return SocketProvider