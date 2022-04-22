local SocketProvider = Emitter:extend()

function SocketProvider:initialize(Port)
    self.App = require("weblit").app
    local App = self.App
    self.Port = Port

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
            p(Request.params)

            for Message in Read do
                if #Message.payload ~= 0 then
                    self:emit("Message", Message.payload, Request.params.Name)
                else
                    break
                end
            end
            Write()
        end
    )
    
end

function SocketProvider:Start()
    self.App.start()
end

return SocketProvider