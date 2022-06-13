local Request = Import("ga.corebyte.BrowserView.Wrapper.Request")
local FS = require("fs")

local FileNames = {
    ["win32"] = "browserView-win32-x64",
    ["darwin"] = "BrowserView-darwin-x64"
}

local FileName = FileNames[TypeWriter.Os]
local InputFile = BVAD .. "/" .. FileName .. ".tar"
if not FS.existsSync(InputFile) then
    TypeWriter.Logger.Info("Downloading %s", FileName)
    local Response, Body = Request(
        "GET",
        "https://github.com/CoreBytee/browserview/releases/latest/download/" .. FileName .. ".tar"
    )


    FS.writeFileSync(
        InputFile,
        Body
    )
end

if not FS.existsSync(BVAD .. "/BrowserView/") then
    TypeWriter.Logger.Info("Unpacking %s", FileName)
    Import("ga.corebyte.BrowserView.Wrapper.Unzip")(
        InputFile,
        BVAD
    )
    FS.renameSync(BVAD .. "/" .. FileName .. "/", BVAD .. "/BrowserView/")
end
