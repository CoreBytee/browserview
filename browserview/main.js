const {app, BrowserWindow} = require('electron')

async function PatchEmitter(Emitter, OnAny) {
    let OriginalEmit = Emitter.emit
    Emitter.emit = function(...Data) {
        if (OnAny) {
            OnAny(...Data)
        }
        OriginalEmit.apply(Emitter, Data)
    }
}

app.on(
    'ready',
    async function () {
        const Window = new BrowserWindow(
            {
            
            }
        )
        console.log(Window.emit)

        var Socket = require('./Socket')
        Socket.RegisterCallback(
            "Function",
            async function (Data, Return) {
                Return(await Window[Data.Name](...Data.Arguments))
            }
        )
        Socket.Connect()
        await PatchEmitter(Window, function(Event, ...Data) {
            console.log(`Window event: ${Event} ${Data}`)
            Data[0] = null
            Socket.Send("backend", "WindowEvent", Event, Data)
        })
        Window.setMenu(null)

        //Window.loadURL('https://google.com')

    }
)

app.on('window-all-closed', function () {
    app.quit()
})

