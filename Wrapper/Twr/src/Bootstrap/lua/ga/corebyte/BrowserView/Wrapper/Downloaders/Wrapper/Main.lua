local Request = Import("ga.corebyte.BrowserView.Wrapper.Request")
local FS = require("fs")

local InputFile = BVAD .. "/Libraries.tar"
if not FS.existsSync(InputFile) then
    local Response, Body = Request(
    "GET",
    "https://github.com/CoreBytee/browserview/releases/latest/download/Wrapper-Twr-Libraries.tar"
    )

    FS.writeFileSync(
        InputFile,
        Body
    )
end

if not FS.existsSync(BVAD .. "/BrowserView.twr") then
    Import("ga.corebyte.BrowserView.Wrapper.Unzip")(
        InputFile,
        BVAD
    )
end