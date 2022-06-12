local Window = Import("ga.corebyte.BrowserView.Wrapper").Download().LoadAll().NewWindow({Stdio = true})
Window:Start()

Window:OnAny(
    function (Name, ...)
        TypeWriter.Logger.Info(Name)
    end
)
Window:LoadURL("http://google.com")