local QBCore = exports['qb-core']:GetCoreObject()
local BOLOVehicles = {}

QBCore.Commands.Add("bolo", "Flag vehicle", {
    {name="plate", help="Plate"},
    {name="reason", help="Reason"}
}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name ~= "police" then return end

    local plate = string.upper(args[1])
    local reason = table.concat(args, " ", 2)

    BOLOVehicles[plate] = {reason = reason}
    TriggerClientEvent('QBCore:Notify', source, "BOLO added: "..plate)
end)

QBCore.Commands.Add("clearbolo", "Remove BOLO", {
    {name="plate", help="Plate"}
}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name ~= "police" then return end

    local plate = string.upper(args[1])
    BOLOVehicles[plate] = nil
    TriggerClientEvent('QBCore:Notify', source, "BOLO cleared: "..plate)
end)

RegisterNetEvent("qb-plate-reader:checkPlate", function(plate)
    local src = source

    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        local motValid, insuranceValid = false, false

        if result[1] then
            local veh = result[1]
            local today = os.time()

            if veh.mot_expiry then
                local t = os.time({
                    year = tonumber(string.sub(veh.mot_expiry,1,4)),
                    month = tonumber(string.sub(veh.mot_expiry,6,7)),
                    day = tonumber(string.sub(veh.mot_expiry,9,10))
                })
                motValid = t >= today
            end

            if veh.insurance_expiry then
                local t = os.time({
                    year = tonumber(string.sub(veh.insurance_expiry,1,4)),
                    month = tonumber(string.sub(veh.insurance_expiry,6,7)),
                    day = tonumber(string.sub(veh.insurance_expiry,9,10))
                })
                insuranceValid = t >= today
            end
        end

        TriggerClientEvent("qb-plate-reader:motResult", src, plate, motValid, insuranceValid)

        local bolo = BOLOVehicles[plate]
        if bolo then
            TriggerClientEvent("qb-plate-reader:alert", src, plate, "BOLO: "..bolo.reason)
        end
    end)
end)

RegisterNetEvent("qb-anpr:scanVehicle", function(plate, coords)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        if not result[1] then return end

        local veh = result[1]
        local today = os.time()
        local motValid, insuranceValid = false, false

        if veh.mot_expiry then
            local t = os.time({
                year = tonumber(string.sub(veh.mot_expiry,1,4)),
                month = tonumber(string.sub(veh.mot_expiry,6,7)),
                day = tonumber(string.sub(veh.mot_expiry,9,10))
            })
            motValid = t >= today
        end

        if veh.insurance_expiry then
            local t = os.time({
                year = tonumber(string.sub(veh.insurance_expiry,1,4)),
                month = tonumber(string.sub(veh.insurance_expiry,6,7)),
                day = tonumber(string.sub(veh.insurance_expiry,9,10))
            })
            insuranceValid = t >= today
        end

        local bolo = BOLOVehicles[plate]

        if not motValid or not insuranceValid or bolo then
            local reason = ""

            if not motValid then reason = reason .. "No MOT " end
            if not insuranceValid then reason = reason .. "No Insurance " end
            if bolo then reason = reason .. "BOLO: "..bolo.reason end

            exports['ps-dispatch']:CustomAlert({
                coords = coords,
                message = "ANPR HIT: "..plate.." | "..reason,
                dispatchCode = "10-60",
                description = "ANPR Camera Hit",
                radius = 0,
                sprite = 161,
                color = 1,
                scale = 1.0,
                length = 3,
                jobs = {"police"}
            })
        end
    end)
end)