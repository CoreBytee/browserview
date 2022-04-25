local Paths = {
    ["win32"] = "BrowserView\\browserview-win32-x64\\browserview.exe",
    ["darwin"] = "browserview/browserview-darwin-x64/browserview.app/Contents/MacOS/browserview"
}

local Window = Import("ga.corebyte.browserview"):new(
    {
        ExecutablePath = Paths[require("los").type()],
    }
)
p(Window)
Window:Run(

)

require("timer").sleep(2000)
