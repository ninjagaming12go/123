---@type { [number]: any }
local policeAlerts = {}

local lastFetchedPolice = 0
local policeOnline = 0

lib.callback.register("loaf_bankrobbery:getPolice", function()
	if os.time() - lastFetchedPolice > 30 then
		lastFetchedPolice = os.time()
		policeOnline = GetPolice()
	end

	return policeOnline
end)

function AlertPolice(bankId)
    local bank = Config.Banks[bankId]

    if GetResourceState("qs-dispatch") == "started" then
        return TriggerEvent("qs-dispatch:server:CreateDispatchCall", {
            job = Config.PoliceJobs,
            callLocation = bank.coords,
            callCode = {
                code = L("dispatch_label"),
                snippet = L("dispatch_brevity_code")
            },
            message = L("dispatch_description", {
                bank = bank.name
            }),
            flashes = true,
            image = nil,
            blip = {
                sprite = 108,
                scale = 1.5,
                colour = 1,
                flashes = true,
                text = L("dispatch_label"),
                time = 5 * 60 * 1000,
            }
        })
    elseif GetResourceState("ps-dispatch") == "started" then
        return TriggerEvent("ps-dispatch:server:notify", {
            message = L("dispatch_description", {
                bank = bank.name
            }),
            codeName = L("dispatch_label"),
            code = L("dispatch_brevity_code"),
            icon = "fas fa-vault",
            priority = 1,
            coords = bank.coords,
            jobs = Config.PoliceJobs,
            -- blip
            blipSprite = 108,
            blipColour = 32,
            blipScale = 1.5,
            blipLength = 3,
        })
    elseif GetResourceState("cd_dispatch") == "started" then
        return TriggerClientEvent("cd_dispatch:AddNotification", -1, {
            job_table = Config.PoliceJobs,
            coords = bank.coords,
            title = L("dispatch_label"),
            message = L("dispatch_description", {
                bank = bank.name
            }),
            flash = 0,
            unique_id = tostring(math.random(0000000, 9999999)),
            sound = 1,
            blip = {
                sprite = 108,
                scale = 1.5,
                colour = 1,
                flashes = false,
                text = L("dispatch_label"),
                time = 5,
                radius = 0,
            }
        })
    elseif GetResourceState("lb-tablet") == "started" then
        local dispatchData = {
			job = "police",
			priority = "high",
			code = L("dispatch_brevity_code"),
			title = L("dispatch_label"),
			description = L("dispatch_description", {
                bank = bank.name
            }),
			location = {
				label = bank.name,
				coords = {
					x = bank.coords.x,
					y = bank.coords.y
				}
			},
			time = 300
		}

		if policeAlerts[bankId] then
			dispatchData.id = policeAlerts[bankId]
			exports["lb-tablet"]:UpdateDispatch(dispatchData)
		else
			policeAlerts[bankId] = exports["lb-tablet"]:AddDispatch(dispatchData)
		end

        return
    end

    if not policeAlerts[bankId] then
        policeAlerts[bankId] = true
    end

    TriggerClientEvent("loaf_bankrobbery:alertPolice", -1, bankId)
end

RegisterNetEvent("loaf_bankrobbery:getPoliceAlerts", function()
    local src = source

    for bankId, alert in pairs(policeAlerts) do
        if alert then
            debugprint("alerting police for bank " .. bankId)
		    TriggerClientEvent("loaf_bankrobbery:alertPolice", src, bankId)
        end
	end
end)

function RemovePoliceAlert(bankId)
    if not policeAlerts[bankId] then
        return
    end

    policeAlerts[bankId] = nil

    TriggerClientEvent("loaf_bankrobbery:removePoliceAlert", -1, bankId)
end

function PossibleCheater(source, reason, ...)
    if reason == "create_object_not_enabled" then
        print("^1[CHEATER]^7: Possible cheater", source, "(tried to create object via server, but it's not enabled)", ...)
    elseif reason == "create_object_not_allowed" then
        print("^1[CHEATER]^7: Possible cheater", source, "(tried to create object when they are not doing anything)", ...)
    elseif reason == "finish_looting_not_looting" then
        print("^1[CHEATER]^7: Possible cheater", source, "(tried to get loot)", ...)
    end
end
