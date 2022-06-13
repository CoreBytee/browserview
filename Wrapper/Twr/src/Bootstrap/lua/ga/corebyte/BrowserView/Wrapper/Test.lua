local Window = Import("ga.corebyte.BrowserView.Wrapper").Download().LoadAll().NewWindow({Stdio = false})
Window:Start()

Window:OnAny(
    function (Name, ...)
        TypeWriter.Logger.Info(Name)
    end
)
Window:LoadURL("https://dashboard.sugar.corebyte.ga")