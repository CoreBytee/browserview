local WebSocketServer = Import("ga.corebyte.BetterEmitter"):extend()

require("weblit-websocket")
local Weblit = require("weblit")
local Json = require("json")

function WebSocketServer:initialize(Port)
    self.Port = Port
    self.Connections = {}
    local LastDisconnection = string.random(16)
    local App = Weblit.app
    local C = table.count

    App.bind(
        {
            host = "127.0.0.1",
            port = self.Port
        }
    )
    
    App.use(require('weblit-auto-headers'))
    
    App.websocket(
        {
            path = "/:Type/:Name"
        },
        function (Request, Read, Write)
            local Name = Request.params.Name
            local Type = Request.params.Type
            print("Connection " .. Type .. "@" .. Name)
            if self.Connections[Name] == nil then self.Connections[Name] = {} end
            self.Connections[Name][Type] = {
                Read = Read,
                Write = Write
            }
            self:Emit("Connection", Name, Type)
            for Message in Read do
                local Payload = Message.payload 
                local Decoded = Json.decode(Payload)
                if Decoded ~= nil then
                    if self.Connections[Name][Decoded.To] == nil then
                        TypeWriter.Logger.Warn("No connection for %s waiting...", Decoded.To)
                        self:WaitFor("Connection", nil,
                            function (IncomingName, IncomingType)
                                return IncomingName == Name, Decoded.To == IncomingType
                            end
                        )
                    end
                    Decoded.From = Type
                    self.Connections[Name][Decoded.To].Write(
                        {
                            payload = Json.encode(
                                Decoded
                            )
                        }
                    )
                end
            end
            Write()
            print("Disconnection " .. Type .. "@" .. Name)
            self.Connections[Name][Type] = nil
            if C(self.Connections[Name]) == 0 then
                self.Connections[Name] = nil
            end
            if C(self.Connections) == 0 then
                print("No more connections, shutting down in 1 minute")
                local DisconnectionId = string.random(16)
                LastDisconnection = DisconnectionId
                coroutine.wrap(function ()
                    Wait(60)
                    if DisconnectionId ~= LastDisconnection then
                        print("New disconnection came in")
                        return
                    end
                    if C(self.Connections) ~= 0 then
                        print("A new connection came in")
                        return
                    end
                    print("Shutting down")
                    process:exit()
                end)()
            end
            
        end
    )
    
    App.start()
end

return WebSocketServer