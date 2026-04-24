-- Locales
function L(path, args)
    local translation = Locales[Config.Language][path] or Locales.en[path] or path

    if args then
        for k, v in pairs(args) do
            local safe_v = tostring(v):gsub("%%", "%%%%")

            translation = translation:gsub("{" .. k .. "}", safe_v)
        end
    end

    return translation
end

-- Debug print
function debugprint(...)
    if not Config.Debug then
        return
    end

    print("^5[DEBUG]^7: ", ...)
end

---@param resource string
---@return boolean
local function IsResourceStartedOrStarting(resource)
	local state = GetResourceState(resource)

	return state == "started" or state == "starting"
end

if Config.Framework == "auto" then
    if IsResourceStartedOrStarting("es_extended") then
        Config.Framework = "esx"
    elseif IsResourceStartedOrStarting("qbx_core") then
        Config.Framework = "qbox"
    elseif IsResourceStartedOrStarting("qb-core") then
        Config.Framework = "qb-core"
    else
        Config.Framework = "custom"

        print("^3[WARNING]^7: Failed to automatically set framework. Please set it manually in loaf_bankrobbery/shared/config.lua.")
        return
    end

    debugprint("Detected framework:", Config.Framework)
end

local targetLookup = {
	["qtarget"] = true,
	["qb-target"] = true,
	["ox_target"] = true,
}

if Config.InteractSystem == "auto" then
	if IsResourceStartedOrStarting("qtarget") or IsResourceStartedOrStarting("qb-target") then
		Config.InteractSystem = "target"
	else
		Config.InteractSystem = "native"
	end
elseif targetLookup[Config.InteractSystem] then
	Config.InteractSystem = "target"
end
