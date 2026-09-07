/area/space
	name = "\improper Space"
	icon_state = "space"

	allow_worldgen_overwrite = TRUE

	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	has_gravity = FALSE
	power_light = 0
	has_gravity = 0
	power_equip = 0
	power_environ = 0
	ambience = AMBIENCE_SPACE
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_ERODING
	is_outside = OUTSIDE_YES
	nightshift_level = NONE

/area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return
