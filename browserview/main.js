const {app, BrowserWindow} = require('electron')
const {WebSocket} = require('ws')

app.on(
    'ready',
    function () {
        const Window = new BrowserWindow(
            {
            
            }
        )

        //Window.setMenu(null)

        Window.loadURL('https://google.com')

        const ConnectedSocket = new WebSocket(
            'ws://localhost:25623/Main')
        ;

        ConnectedSocket.on(
            'open',
            function() {
                console.log("Connected to server")
            }
        );

        ConnectedSocket.on(
            'message',
            function(MessageData) {
                console.log('received: %s', MessageData);
            }
        );

        console.log("hi")
    }
)

app.on('window-all-closed', function () {
    app.quit()
})

