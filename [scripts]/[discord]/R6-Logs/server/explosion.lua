
local explosionTags = {
    [0] = "GRENADE", [1] = "GRENADELAUNCHER", [2] = "STICKYBOMB", [3] = "MOLOTOV",
    [4] = "ROCKET", [5] = "TANKSHELL", [6] = "HI_OCTANE", [7] = "CAR",
    [8] = "PLANE", [9] = "PETROL_PUMP", [10] = "BIKE", [11] = "DIR_STEAM",
    [12] = "DIR_FLAME", [13] = "DIR_WATER_HYDRANT", [14] = "DIR_GAS_CANISTER", [15] = "BOAT",
    [16] = "SHIP_DESTROY", [17] = "TRUCK", [18] = "BULLET", [19] = "SMOKEGRENADELAUNCHER",
    [20] = "SMOKEGRENADE", [21] = "BZGAS", [22] = "FLARE", [23] = "GAS_CANISTER",
    [24] = "EXTINGUISHER", [25] = "_0x988620B8", [26] = "TRAIN", [27] = "BARREL",
    [28] = "PROPANE", [29] = "BLIMP", [30] = "DIR_FLAME_EXPLODE", [31] = "TANKER",
    [32] = "PLANE_ROCKET", [33] = "VEHICLE_BULLET", [34] = "GAS_TANK", [35] = "BIRD_CRAP",
    [36] = "RAILGUN", [37] = "BLIMP2", [38] = "FIREWORK", [39] = "SNOWBALL",
    [40] = "PROXMINE", [41] = "VALKYRIE_CANNON", [42] = "AIR_DEFENCE", [43] = "PIPEBOMB",
    [44] = "VEHICLEMINE", [45] = "EXPLOSIVEAMMO", [46] = "APCSHELL", [47] = "BOMB_CLUSTER",
    [48] = "BOMB_GAS", [49] = "BOMB_INCENDIARY", [50] = "BOMB_STANDARD", [51] = "TORPEDO",
    [52] = "TORPEDO_UNDERWATER", [53] = "BOMBUSHKA_CANNON", [54] = "BOMB_CLUSTER_SECONDARY",
    [55] = "HUNTER_BARRAGE", [56] = "HUNTER_CANNON", [57] = "ROGUE_CANNON", [58] = "MINE_UNDERWATER",
    [59] = "ORBITAL_CANNON", [60] = "BOMB_STANDARD_WIDE", [61] = "EXPLOSIVEAMMO_SHOTGUN",
    [62] = "OPPRESSOR2_CANNON", [63] = "MORTAR_KINETIC", [64] = "VEHICLEMINE_KINETIC",
    [65] = "VEHICLEMINE_EMP", [66] = "VEHICLEMINE_SPIKE", [67] = "VEHICLEMINE_SLICK",
    [68] = "VEHICLEMINE_TAR", [69] = "SCRIPT_DRONE", [70] = "RAYGUN", [71] = "BURIEDMINE",
    [72] = "SCRIPT_MISSILE", [73] = "RCTANK_ROCKET", [74] = "BOMB_WATER",
    [75] = "BOMB_WATER_SECONDARY", [76] = "_0xF728C4A9", [77] = "_0xBAEC056F",
    [78] = "FLASHGRENADE", [79] = "STUNGRENADE", [80] = "_0x763D3B3B",
    [81] = "SCRIPT_MISSILE_LARGE", [82] = "SUBMARINE_BIG",
}

local explosionDangerLevels = {
    low = {
        [6] = true,   -- HI_OCTANE
        [7] = true,   -- CAR
        [8] = true,   -- PLANE
        [9] = true,   -- PETROL_PUMP
        [10] = true,  -- BIKE
        [11] = true,  -- DIR_STEAM
        [12] = true,  -- DIR_FLAME
        [13] = true,  -- DIR_WATER_HYDRANT
        [14] = true,  -- DIR_GAS_CANISTER
        [15] = true,  -- BOAT
        [16] = true,  -- SHIP_DESTROY
        [17] = true,  -- TRUCK
        [22] = true,  -- FLARE
        [23] = true,  -- GAS_CANISTER
        [24] = true,  -- EXTINGUISHER
        [26] = true,  -- TRAIN
        [27] = true,  -- BARREL
        [28] = true,  -- PROPANE
        [29] = true,  -- BLIMP
        [30] = true,  -- DIR_FLAME_EXPLODE
        [31] = true,  -- TANKER
        [34] = true,  -- GAS_TANK
        [35] = true,  -- BIRD_CRAP
        [37] = true,  -- BLIMP2
        [38] = true,  -- FIREWORK
        [39] = true,  -- SNOWBALL
    },
    
    medium = {
        [0] = true,   -- GRENADE
        [18] = true,  -- BULLET
        [19] = true,  -- SMOKEGRENADELAUNCHER
        [20] = true,  -- SMOKEGRENADE
        [21] = true,  -- BZGAS
        [25] = true,  -- _0x988620B8
        [33] = true,  -- VEHICLE_BULLET
        [74] = true,  -- BOMB_WATER
        [75] = true,  -- BOMB_WATER_SECONDARY
        [76] = true,  -- _0xF728C4A9
        [77] = true,  -- _0xBAEC056F
        [78] = true,  -- FLASHGRENADE
        [79] = true,  -- STUNGRENADE
        [80] = true,  -- _0x763D3B3B
    },
    
    high = {
        [1] = true,   -- GRENADELAUNCHER
        [2] = true,   -- STICKYBOMB
        [3] = true,   -- MOLOTOV
        [4] = true,   -- ROCKET
        [32] = true,  -- PLANE_ROCKET
        [40] = true,  -- PROXMINE
        [43] = true,  -- PIPEBOMB
        [44] = true,  -- VEHICLEMINE
        [45] = true,  -- EXPLOSIVEAMMO
        [47] = true,  -- BOMB_CLUSTER
        [48] = true,  -- BOMB_GAS
        [49] = true,  -- BOMB_INCENDIARY
        [50] = true,  -- BOMB_STANDARD
        [51] = true,  -- TORPEDO
        [52] = true,  -- TORPEDO_UNDERWATER
        [54] = true,  -- BOMB_CLUSTER_SECONDARY
        [58] = true,  -- MINE_UNDERWATER
        [60] = true,  -- BOMB_STANDARD_WIDE
        [61] = true,  -- EXPLOSIVEAMMO_SHOTGUN
        [63] = true,  -- MORTAR_KINETIC
        [64] = true,  -- VEHICLEMINE_KINETIC
        [65] = true,  -- VEHICLEMINE_EMP
        [66] = true,  -- VEHICLEMINE_SPIKE
        [67] = true,  -- VEHICLEMINE_SLICK
        [68] = true,  -- VEHICLEMINE_TAR
        [71] = true,  -- BURIEDMINE
        [73] = true,  -- RCTANK_ROCKET
    },
    
    critical = {
        [5] = true,   -- TANKSHELL
        [36] = true,  -- RAILGUN
        [41] = true,  -- VALKYRIE_CANNON
        [42] = true,  -- AIR_DEFENCE
        [46] = true,  -- APCSHELL
        [53] = true,  -- BOMBUSHKA_CANNON
        [55] = true,  -- HUNTER_BARRAGE
        [56] = true,  -- HUNTER_CANNON
        [57] = true,  -- ROGUE_CANNON
        [59] = true,  -- ORBITAL_CANNON
        [62] = true,  -- OPPRESSOR2_CANNON
        [69] = true,  -- SCRIPT_DRONE
        [70] = true,  -- RAYGUN
        [72] = true,  -- SCRIPT_MISSILE
        [81] = true,  -- SCRIPT_MISSILE_LARGE
        [82] = true,  -- SUBMARINE_BIG
    }
}


local function GetDangerLevel(explosionType)
    if explosionDangerLevels.critical[explosionType] then
        return "🔴 CRITICAL", "darkred"
    elseif explosionDangerLevels.high[explosionType] then
        return "🟠 HIGH", "red"
    elseif explosionDangerLevels.medium[explosionType] then
        return "🟡 MEDIUM", "orange"
    elseif explosionDangerLevels.low[explosionType] then
        return "🟢 LOW", "yellow"
    else
        return "⚪ UNKNOWN", "grey"
    end
end

local explosionSpamTracker = {}
local EXPLOSION_SPAM_THRESHOLD = 5 
local EXPLOSION_SPAM_TIME = 10 

AddEventHandler("explosionEvent", function(source, explosion)
    local playerName = GetPlayerName(source) or 'Unknown'
    local explosionType = tonumber(explosion.explosionType)
    local explosionName = explosionTags[explosionType] or "Unknown"
    local dangerLevel, dangerColor = GetDangerLevel(explosionType)
    
    local license = GetPlayerIdentifierByType(source, 'license') or GetPlayerIdentifierByType(source, 'license2') or 'Unknown'
    local steam = GetPlayerIdentifierByType(source, 'steam') or 'Not Linked'
    
    local coords = explosion.posX and vector3(explosion.posX, explosion.posY, explosion.posZ) or nil
    local coordsText = coords and string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z) or "Unknown"
    
    local currentTime = os.time()
    if not explosionSpamTracker[source] then
        explosionSpamTracker[source] = { count = 0, firstTime = currentTime }
    end
    
    if currentTime - explosionSpamTracker[source].firstTime > EXPLOSION_SPAM_TIME then
        explosionSpamTracker[source] = { count = 1, firstTime = currentTime }
    else
        explosionSpamTracker[source].count = explosionSpamTracker[source].count + 1
    end
    
    local isSpamming = explosionSpamTracker[source].count >= EXPLOSION_SPAM_THRESHOLD
    
    local logColor = isSpamming and "darkred" or dangerColor
    local actionText = isSpamming and "Explosion Spam Detected" or "Explosion Detected"
    
    local extraSections = {
        {
            title = "Explosion Properties",
            data = {
                { name = "Damage Scale", value = "x" .. (explosion.damageScale or 1.0) },
                { name = "Camera Shake", value = "x" .. (explosion.cameraShake or 1.0) },
                { name = "Silent", value = not explosion.isAudible and "Yes" or "No" },
                { name = "Invisible", value = explosion.isInvisible and "Yes" or "No" },
            }
        },
        {
            title = "Location Information",
            data = {
                { name = "Coordinates", value = coordsText },
                { name = "Timestamp", value = os.date('%Y-%m-%d %H:%M:%S') },
            }
        }
    }
    
    if isSpamming then
        table.insert(extraSections, {
            title = "⚠️ Spam Detection",
            data = {
                { name = "Explosions Count", value = explosionSpamTracker[source].count .. " in " .. EXPLOSION_SPAM_TIME .. " seconds" },
                { name = "Status", value = "🚨 POTENTIAL CHEATER" },
            }
        })
    end
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = "explosions",
        title = "Explosion Logs",
        action = actionText,
        color = logColor,
        players = {
            { id = source, role = "Source" },
        },
        info = {
            { name = "Player Name", value = playerName },
            { name = "Explosion Type", value = explosionName .. " (" .. explosionType .. ")" },
            { name = "Danger Level", value = dangerLevel },
        },
        extra = extraSections,
        takeScreenshot = true
    })
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if explosionSpamTracker[src] then
        explosionSpamTracker[src] = nil
    end
end)
