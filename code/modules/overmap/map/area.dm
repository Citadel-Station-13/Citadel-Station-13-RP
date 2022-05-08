/area/overmap
	name = "ERROR"
	#warn make icons
	icon = 'icons/overmap/area.dmi'
	icon_state = ""
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	unique = FALSE

/area/overmap/instance
	name = "Overmap"
	icon_state = "map"
	/// our overmap ref
	var/datum/overmap/our_map

/area/overmap/border
	name = "Overmap Border"
	icon_state = "border"
