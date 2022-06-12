local Window = Import("ga.corebyte.BrowserView.Wrapper").Download().LoadAll().NewWindow({Stdio = true})
Window:Start()

Window:LoadURL("http://google.com")