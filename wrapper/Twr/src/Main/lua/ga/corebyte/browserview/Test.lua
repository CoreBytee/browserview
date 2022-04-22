local Window = Import("ga.corebyte.browserview"):new(
    {
        ExecutablePath = "browserview/browserview-darwin-x64/browserview.app/Contents/MacOS/browserview",
    }
)
Window:Run(

)

require("timer").sleep(2000)
