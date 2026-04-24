local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isLoggedIn = false
local pedsSpawned = false
local blips = {}

local function getClosestHall(coords)
    local closest = 1
    local dist = #(coords - Config.Cityhalls[1].coords)
    for i = 2, #Config.Cityhalls do
        local d = #(coords - Config.Cityhalls[i].coords)
        if d < dist then
            dist = d
            closest = i
        end
    end
    return closest
end

local function getClosestSchool(coords)
    local closest = 1
    local dist = #(coords - Config.DrivingSchools[1].coords)
    for i = 2, #Config.DrivingSchools do
        local d = #(coords - Config.DrivingSchools[i].coords)
        if d < dist then
            dist = d
            closest = i
        end
    end
    return closest
end

local function createBlip(data)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.title)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function initBlips()
    for i = 1, #Config.Cityhalls do
        local c = Config.Cityhalls[i]
        if c.showBlip then
            blips[#blips+1] = createBlip({
                coords = c.coords,
                sprite = c.blipData.sprite,
                scale = c.blipData.scale,
                colour = c.blipData.colour,
                title = c.blipData.title
            })
        end
    end
    for i = 1, #Config.DrivingSchools do
        local c = Config.DrivingSchools[i]
        if c.showBlip then
            blips[#blips+1] = createBlip({
                coords = c.coords,
                sprite = c.blipData.sprite,
                scale = c.blipData.scale,
                colour = c.blipData.colour,
                title = c.blipData.title
            })
        end
    end
end

local function openCityhallMenu()
    local menu = {
        { header = 'City Hall', isMenuHeader = true },
        { header = 'ID Card', txt = 'Get your ID Card', params = { event = 'qb-cityhall:client:openIdentityMenu' } },
        { header = 'Job Center', txt = 'Available Jobs', params = { event = 'qb-cityhall:client:openJobMenu' } },
        { header = 'Close', params = { event = 'qb-menu:client:closeMenu' } }
    }
    TriggerEvent('qb-menu:client:openMenu', menu)
end

local function openIdentityMenu()
    local coords = GetEntityCoords(PlayerPedId())
    local closestCityhall = getClosestHall(coords)
    QBCore.Functions.TriggerCallback('qb-cityhall:server:getIdentityData', function(licenses)
        local menu = {
            { header = 'Identity', isMenuHeader = true },
            { header = '← Back', params = { event = 'qb-cityhall:client:openCityhallMenu' } }
        }
        for k, v in pairs(licenses) do
            menu[#menu+1] = {
                header = v.label,
                txt = 'Cost: $'..v.cost,
                params = { event = 'qb-cityhall:client:requestId', args = { type = k, cost = v.cost, hall = closestCityhall } }
            }
        end
        TriggerEvent('qb-menu:client:openMenu', menu)
    end, closestCityhall)
end

local function openJobMenu()
    QBCore.Functions.TriggerCallback('qb-cityhall:server:receiveJobs', function(jobs)
        local menu = {
            { header = 'Job Center', isMenuHeader = true },
            { header = '← Back', params = { event = 'qb-cityhall:client:openCityhallMenu' } }
        }
        for job, data in pairs(jobs) do
            menu[#menu+1] = {
                header = data.label,
                txt = 'Apply for this job',
                params = { event = 'qb-cityhall:client:applyJob', args = { job = job } }
            }
        end
        TriggerEvent('qb-menu:client:openMenu', menu)
    end)
end

local function spawnPeds()
    if pedsSpawned then return end
    for i = 1, #Config.Peds do
        local p = Config.Peds[i]
        local model = type(p.model) == 'string' and joaat(p.model) or p.model
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        local ped = CreatePed(0, model, p.coords.x, p.coords.y, p.coords.z, p.coords.w, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, p.scenario, true, true)
        p.pedHandle = ped

        if Config.UseTarget then
            local opt
            if p.cityhall then
                opt = {
                    label = 'Open Cityhall',
                    icon = 'fa-solid fa-city',
                    action = function()
                        openCityhallMenu()
                    end
                }
            elseif p.drivingschool then
                opt = {
                    label = 'Take Driving Lessons',
                    icon = 'fa-solid fa-car-side',
                    action = function()
                        local coords = GetEntityCoords(PlayerPedId())
                        local closestDrivingSchool = getClosestSchool(coords)
                        TriggerServerEvent('qb-cityhall:server:sendDriverTest', Config.DrivingSchools[closestDrivingSchool].instructors)
                    end
                }
            end
            if opt then
                exports['qb-target']:AddTargetEntity(ped, { options = { opt }, distance = 2.0 })
            end
        else
            local options = p.zoneOptions
            if options then
                local zone = BoxZone:Create(p.coords.xyz, options.length, options.width, {
                    name = 'zone_cityhall_'..i,
                    heading = p.coords.w,
                    debugPoly = options.debugPoly,
                    minZ = p.coords.z - 3.0,
                    maxZ = p.coords.z + 2.0
                })
                zone:onPlayerInOut(function(inside)
                    if not isLoggedIn then return end
                    if inside then
                        if p.cityhall then
                            exports['qb-core']:DrawText('[E] Open Cityhall')
                        elseif p.drivingschool then
                            exports['qb-core']:DrawText('[E] Take Driving Lessons')
                        end
                    else
                        exports['qb-core']:HideText()
                    end
                end)
            end
        end
    end
    pedsSpawned = true
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
    initBlips()
    spawnPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    isLoggedIn = false
end)

RegisterNetEvent('qb-cityhall:client:openCityhallMenu', openCityhallMenu)
RegisterNetEvent('qb-cityhall:client:openIdentityMenu', openIdentityMenu)
RegisterNetEvent('qb-cityhall:client:openJobMenu', openJobMenu)

RegisterNetEvent('qb-cityhall:client:requestId', function(data)
    local hall = data.hall or getClosestHall(GetEntityCoords(PlayerPedId()))
    TriggerServerEvent('qb-cityhall:server:requestId', data.type, hall, data.cost)
end)

RegisterNetEvent('qb-cityhall:client:applyJob', function(data)
    local coords = GetEntityCoords(PlayerPedId())
    local hall = getClosestHall(coords)
    TriggerServerEvent('qb-cityhall:server:ApplyJob', data.job, Config.Cityhalls[hall].coords)
end)

RegisterNetEvent('qb-cityhall:client:sendDriverEmail', function(charinfo)
    SetTimeout(math.random(2500, 4000), function()
        local gender = 'Mr.'
        if PlayerData.charinfo and PlayerData.charinfo.gender == 1 then
            gender = 'Mrs.'
        end
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = 'Driving School',
            subject = 'Driving Lessons',
            message = ('Hello %s %s %s, please contact us at %s to schedule your driving test.'):format(gender, charinfo.lastname, charinfo.firstname, charinfo.phone),
            button = {}
        })
    end)
end)

CreateThread(function()
    if Config.UseTarget then return end
    while true do
        local sleep = 1000
        if isLoggedIn then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local hall = getClosestHall(coords)
            local school = getClosestSchool(coords)
            local hallDist = #(coords - Config.Cityhalls[hall].coords)
            local schoolDist = #(coords - Config.DrivingSchools[school].coords)

            if hallDist < 2.0 then
                sleep = 0
                if IsControlJustPressed(0, 38) then
                    openCityhallMenu()
                    exports['qb-core']:HideText()
                    Wait(500)
                end
            elseif schoolDist < 2.0 then
                sleep = 0
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('qb-cityhall:server:sendDriverTest', Config.DrivingSchools[school].instructors)
                    exports['qb-core']:HideText()
                    Wait(500)
                end
            end
        end
        Wait(sleep)
    end
end)
