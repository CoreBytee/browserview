return function ()
    TypeWriter.Runtime.LoadFile(BVAD .. "/BrowserView.twr")
    TypeWriter.Runtime.LoadFile(BVAD .. "/Static.twr")
    return Import("ga.corebyte.BrowserView.Wrapper")
end