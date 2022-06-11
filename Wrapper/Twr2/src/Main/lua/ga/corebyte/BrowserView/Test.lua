local Paths = {
    ["win32"] = "BrowserView\\browserview-win32-x64\\browserview.exe",
    ["darwin"] = "browserview/browserview-darwin-x64/browserview.app/Contents/MacOS/browserview"
}

local Window = Import("ga.corebyte.BrowserView"):new(
    {
        ExecutablePath = Paths[require("los").type()],
    }
)

Window:Start()
Sleep(1000)
p(Window:SetClosable(false))