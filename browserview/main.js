// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')
const path = require('path')

console.log(process.argv)

function createWindow () {
    // Create the browser window.
    const Arguments = process.argv
    const Size = process.argv[3].split("x")
    const MainWindow = new BrowserWindow({
        width: parseInt(Size[0]),
        height: parseInt(Size[1]),
        x: parseInt(Size[2]),
        y: parseInt(Size[3]),

    })

    MainWindow.loadURL('https://google.com')
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
    createWindow()
})

app.on('window-all-closed', function () {
    app.quit()
})