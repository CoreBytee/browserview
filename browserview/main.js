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

        const ws = new WebSocket(
            'ws://localhost:25623/abc')
        ;

        console.log("hi")
    }
)

app.on('window-all-closed', function () {
    app.quit()
})

