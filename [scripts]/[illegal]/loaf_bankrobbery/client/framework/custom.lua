if Config.Framework ~= "custom" then
    return
end

function IsPolice()
    return false
end

function Notify(text, errType)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(true, true)
end

function GetItemLabel(item)
    return item
end

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end

    Loaded = true
end)
