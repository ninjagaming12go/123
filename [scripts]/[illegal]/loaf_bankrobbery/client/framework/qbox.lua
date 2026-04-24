if Config.Framework ~= "qbox" then
    return
end

local QB = exports["qb-core"]:GetCoreObject()
local PlayerJob = {}

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(jobInfo)
    local wasPolice = IsPolice()

    PlayerJob = jobInfo

    if not wasPolice and IsPolice() then
        TriggerServerEvent("loaf_bankrobbery:getPoliceAlerts")
    end

    RefreshAllMarkers()
end)

function IsPolice()
    local job = PlayerJob.name

    for i = 1, #Config.PoliceJobs do
        if Config.PoliceJobs[i] == job then
            return true
        end
    end

    return false
end

function Notify(text, errType)
    QB.Functions.Notify(text, errType)
end

function GetItemLabel(item)
    return exports.ox_inventory:Items(item)?.label or item
end

while not LocalPlayer.state.isLoggedIn do
    Wait(500)
end

Loaded = true

PlayerJob = QB.Functions.GetPlayerData().job

-- since qb-core has custom code for death, we need to override the IsPedDeadOrDying native
local isPedDeadOrDying = IsPedDeadOrDying

function IsPedDeadOrDying(ped, p1)
    local metadata = QB.Functions.GetPlayerData().metadata

    if metadata.ishandcuffed or metadata.isdead or metadata.inlaststand then
        return true
    end

    return isPedDeadOrDying(ped, p1)
end
