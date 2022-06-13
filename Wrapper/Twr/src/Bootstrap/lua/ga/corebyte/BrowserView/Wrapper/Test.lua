local Window = Import("ga.corebyte.BrowserView.Wrapper").Download().LoadAll().NewWindow(
    {
        Stdio = false,
        Options = {
            frame = false
        }
    }
)
p("a")
Window:Start()

--Window:OnAny(
--    function (Name, ...)
--        TypeWriter.Logger.Info(Name)
--    end
--)
p("a")
Window:LoadURL("https://dashboard.sugar.corebyte.ga")