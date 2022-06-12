local Request = require("coro-http").request

function BetterRequest(Method, URL, Headers, Body)
    local Success, Response, Body = pcall(Request, Method, URL, Headers, Body)

    if Success == true and Response.code == 200 then
        return Response, Body
    elseif Success == false then
        TypeWriter.Logger.Error("Error %s", Response)
    elseif Response.code ~= 200 then
        TypeWriter.Logger.Error("Received code %s, %s", Response.code, Body)
    end
    Sleep(3000)
    p("Retrying...")
    return BetterRequest(Method, URL, Headers, Body)
end

return BetterRequest