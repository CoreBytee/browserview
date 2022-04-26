local SocketProvider = Import("ga.corebyte.webhelper.SocketProvider"):new(TypeWriter.ArgumentParser:GetArgument("port", "p", 1))

print("Webhelper is loading...")

SocketProvider:Start()

SocketProvider:on(
    "Message",
    function (Message, Name)
        p(Message)
        p(Name)
    end
)

process.stdin:on(
    "data",
    function (dat)
        print(dat)
    end
)

print("Webhelper is ready.")
