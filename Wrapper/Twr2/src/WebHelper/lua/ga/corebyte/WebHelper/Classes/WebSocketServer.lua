local WebSocketServer = Import("ga.corebyte.BetterEmitter"):extend()

require("weblit-websocket")
local Weblit = require("weblit")

function WebSocketServer:initialize(Port)
    self.Port = Port
    local App = Weblit.app

    App.bind(
        {
            host = "127.0.0.1",
            port = self.Port
        }
    )
    
    App.use(require('weblit-auto-headers'))
    
    App.websocket(
        {
            path = "/:Name"
        },
        function (Request, Read, Write)
            p(Request.params)
            -- Log and echo all messages
            for Message in Read do
                Write(message)
            end
            -- End the stream
            Write()
        end
    )
    
    App.start()
end

return WebSocketServer