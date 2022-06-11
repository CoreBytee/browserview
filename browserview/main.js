const {app, BrowserWindow} = require('electron')

app.on(
    'ready',
     function () {
        const Window = new BrowserWindow(
            {
            
            }
        )

        var Socket = require('./Socket')
        Socket.RegisterCallback(
            "Function",
            async function (Data, Return) {
                Return(await Window[Data.Name](...Data.Arguments))
            }
        )
        Socket.Connect()

        Window.setMenu(null)

        //Window.loadURL('https://google.com')

    }
)

app.on('window-all-closed', function () {
    app.quit()
})

