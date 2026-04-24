if Config.Framework ~= "qb-core" then
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
    QB.Functions.Notify(text)
end

function GetItemLabel(item)
    local itemData = QB.Shared.Items[item]

    return itemData?.label or item
end

local function GetRequiredItems(items)
    local requiredItems = {}

    for i = 1, #items do
        local item = items[i].item

        requiredItems[#requiredItems+1] = {
            name = item,
            image = QB.Shared.Items[item].image
        }
    end

    return requiredItems
end

function ShowItemPrompt(items)
    local requiredItems = GetRequiredItems(items)

    if #requiredItems > 0 then
        TriggerEvent("inventory:client:requiredItems", requiredItems, true)
    end
end

function HideItemPrompt(items)
    local requiredItems = GetRequiredItems(items)

    if #requiredItems > 0 then
        TriggerEvent("inventory:client:requiredItems", requiredItems, false)
    end
end

CreateThread(function()
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
end)
