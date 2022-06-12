local FS = require("fs")

return function ()
    _G.BVAD = TypeWriter.Folder .. "/ApplicationData/BrowserView/"
    FS.mkdirSync(BVAD)

    Import("ga.corebyte.BrowserView.Wrapper.Downloaders.BrowserView")
    Import("ga.corebyte.BrowserView.Wrapper.Downloaders.Wrapper")

    return Import("ga.corebyte.BrowserView.Wrapper")
end