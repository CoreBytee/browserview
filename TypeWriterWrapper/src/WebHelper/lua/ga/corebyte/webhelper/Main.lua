local SocketProvider = Import("ga.corebyte.webhelper.SocketProvider"):new(TypeWriter.ArgumentParser:GetArgument("port", "p", 1))

p("hi")


SocketProvider:Start()

SocketProvider:on(
    "Message",
    function (Message, Name)
        p(Message)
        p(Name)
    end
)
