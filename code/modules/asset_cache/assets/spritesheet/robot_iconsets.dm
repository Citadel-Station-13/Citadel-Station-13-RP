/datum/asset_pack/spritesheet/robot_iconsets
	name = "robot-iconsets"

/datum/asset_pack/spritesheet/robot_iconsets/generate()
	for(var/datum/prototype/robot_iconset/iconset as anything in RSrobot_iconsets.fetch_subtypes_immutable(/datum/prototype/robot_iconset))
		// render
	#warn impl
