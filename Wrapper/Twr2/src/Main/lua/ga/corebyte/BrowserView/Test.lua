local Paths = {
    ["win32"] = "BrowserView\\browserview-win32-x64\\browserview.exe",
    ["darwin"] = "browserview/browserview-darwin-x64/browserview.app/Contents/MacOS/browserview"
}

print()
TypeWriter.Logger.Info("This is a test session")

local Window = Import("ga.corebyte.BrowserView"):new(
    {
        ExecutablePath = Paths[require("los").type()],
    }
)

Window:Start()