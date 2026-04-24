ResName = GetCurrentResourceName() -- Ehh please don't touch this
Config = {} -- Ehh please don't touch this

Config.Locale = 'en' -- Set language option here, supported options: 'en', 'fr'

-- Ehh please don't touch this, please don't touch any of this below
_LR = Locales[Config.Locale]
if not _LR then _LR = Locales['en']; print('No Locale Reference found for ', Config.Locale); end
-- Ehh please don't touch this, please don't touch any of this above

Config.InteractDist = 2.0 -- Distance to interact with poles

Config.InteractKey = 51 -- Key used to interact with poles, default E ~INPUT_CONTEXT~

Config.Notify = function(text)
  print(text) -- Call your notification system here
end

Config.Poles = { -- Set Pole options below
  pole1 = { -- Just a name you set
    pos = vector3(-594.739, -1145.233, 27.5487), -- Position of the pole
    startPos = vector3(-594.7892, -1144.496, 27.5487), -- Position player ped starts animations at
    startDir = 180.0, -- Direction player ped starts animations facing
    attachOffset = vector3(0.0, -0.7, 0.0), -- Offset to attach player ped to pole at
    attachRotation = vector3(0.0, 0.0, 0.0) -- Rotation to attach player ped to pole with
  },
  pole2 = {
    pos = vector3(-596.7717, -1145.26, 27.5487),
    startPos = vector3(-596.7735, -1144.482, 27.5487),
    startDir = 180.0,
    attachOffset = vector3(0.0, -0.7, 0.0),
    attachRotation = vector3(0.0, 0.0, 0.0)
  },
  pole3 = {
    pos = vector3(-598.7426, -1145.223, 27.54871),
    startPos = vector3(-598.8099, -1144.502, 27.54866),
    startDir = 180.0,
    attachOffset = vector3(0.0, -0.7, 0.0),
    attachRotation = vector3(0.0, 0.0, 0.0)
  },
}

-- Shared function(s) --
RoundFloat = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end