/datum/asset_pack/spritesheet/robot_iconsets
	name = "roboticonsets"

/datum/asset_pack/spritesheet/robot_iconsets/generate()
	for(var/datum/prototype/robot_iconset/iconset as anything in RSrobot_iconsets.fetch_subtypes_immutable(/datum/prototype/robot_iconset))
		for(var/dir in GLOB.cardinal)
			insert("[iconset.id]-[dir]", iconset.icon, iconset.icon_state, dir)
