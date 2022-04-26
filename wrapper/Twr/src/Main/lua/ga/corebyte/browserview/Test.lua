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

while true do
    require("timer").sleep(2000)
    Window:SetSize(800, 600, true)
    require("timer").sleep(2000)
    Window:SetSize(800, 500, true)
end
