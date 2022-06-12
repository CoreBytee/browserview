const {WebSocket} = require('ws')

var Callbacks = {}
let ConnectedSocket

async function RegisterCallback(CallbackName, Callback) {
    Callbacks[CallbackName] = Callback
}

async function Send(To, Name, ...Data) {
    if (ConnectedSocket.readyState != 1) {
        console.log("Not connected, dropping")
        return
    }
    ConnectedSocket.send(JSON.stringify({
        Type: "Message",
        To: To,
        Name: Name,
        Data: Data
    }))
}

async function Connect() {
    ConnectedSocket = new WebSocket(
        `ws://localhost:${process.argv[2]}/front/${process.argv[1]}`
    );

    ConnectedSocket.on(
        'open',
        function() {
            console.log("Connected to server")
        }
    );

    ConnectedSocket.on(
        'message',
        function(MessageData) {
            var Decoded = JSON.parse(MessageData)
            if (Decoded.Type != "Message") {return}
            if (Callbacks[Decoded.Name]) {
                Callbacks[Decoded.Name](...Decoded.Data,
                    function(...Data) {
                        ConnectedSocket.send(JSON.stringify({
                            Type: "Response",
                            Sequence: Decoded.Sequence,
                            To: Decoded.From,
                            Data: Data
                        }))
                    }
                )
            } else
            {
                console.log(`Callback for ${Decoded.Name} not found`)
            }
        }
    );
}

module.exports = {
    RegisterCallback: RegisterCallback,
    Connect: Connect,
    Send: Send
}