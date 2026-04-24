description 'Benzz NHS Ambulance Station'
name 'Benzz NHS Ambulance Station'
author '[Benzz] - https://discord.gg/nrCDyGyyUn'

this_is_a_map 'yes'

data_file 'TIMECYCLEMOD_FILE' 'benzz-nhs.xml'

files {
	'benzz-nhs.xml'
}


escrow_ignore {
  'stream/*.ydr', -- Works for any file, stream or code
  'stream/*.yft'  -- Ignore all .yft files in any subfolder
}


fx_version 'adamant'
games {'gta5'}
dependency '/assetpacks'