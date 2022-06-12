local Request = Import("ga.corebyte.BrowserView.Wrapper.Request")
local FS = require("fs")

local FileNames = {
    ["win32"] = "browserView-win32-x64",
    ["darwin"] = "BrowserView-darwin-x64"
}

local FileName = FileNames[TypeWriter.Os]
local InputFile = BVAD .. "/" .. FileName .. ".tar"
if not FS.existsSync(InputFile) then
    local Response, Body = Request(
        "GET",
        "https://github.com/CoreBytee/browserview/releases/latest/download/BrowserView-win32-x64.tar"
    )


    FS.writeFileSync(
        InputFile,
        Body
    )
end

if not FS.existsSync(BVAD .. "/BrowserView/") then
    Import("ga.corebyte.BrowserView.Wrapper.Unzip")(
        InputFile,
        BVAD
    )
    FS.renameSync(BVAD .. "/" .. FileName .. "/", BVAD .. "/BrowserView/")
end
