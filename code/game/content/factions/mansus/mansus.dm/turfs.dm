/datum/prototype/material/alienalloy/rusted
	id = "rusted"
	name = "rusted"

	// Becomes "[display_name] wall" in the UI.
	display_name = "rusted"

	icon_base = 'code/game/content/factions/mansus/mansus.dmi/turf.dmi/rusted_walls.dmi'
	icon_colour = "#faf9f981"
	wall_stripe_icon = null // leave null

	door_icon_base = "rusted" // For doors.

// Walls

/turf/simulated/wall/mansus/rusted_wall
	icon = 'code/game/content/factions/mansus/mansus.dmi/turf.dmi/rusted_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/rusted
	name = "rusted wall"
	desc = "A rusted wall. You'd expect it to crumble upon a touch, but it does not."
	description_info = "Something's off. Is the rust crawling across the surface?"
	block_tele = TRUE
	integrity_enabled = 0

// Floors

/turf/simulated/flooring/mansus
	icon = 'code/game/content/factions/mansus/mansus.dmi/turf.dmi/floors.dmi'
	integrity_enabled = 0


/turf/simulated/flooring/mansus/cosmic
	name = "Cosmic Tear"
	desc = "It glows and hums with unknowable amounts of power."
	icon_state = "cosmic_carpet"

/turf/simulated/flooring/mansus/reality_crack
	name = "???"
	desc = "You cannot comprehend what is occuring here."
	icon_state = "realitycrack"

/turf/simulated/flooring/mansus/dark_ice
	name = "Ice"
	desc = "Cold, dark ice. Something is wrong about it."
	icon_state = "ice_dark"

/turf/simulated/flooring/mansus/dark_ice_smooth
	name = "Smooth Ice"
	desc = "Smooth dark ice. It makes you feel so, so cold. No matter the gear you wear."
	icon_state = "ice_dark_smooth"

/turf/simulated/flooring/mansus/dark_rock
	name = "Rock"
	desc = "Hardened rock, dark in color."
	icon_state = "rock_dark"

/turf/simulated/flooring/mansus/dark_mud
	name = "Mud"
	desc = "Compacted mud. Pretty hardy."
	icon_state = "mud_dark"

/turf/simulated/flooring/mansus/light_mud
	name = "Mud"
	desc = "Soft mud. Probably recently formed"
	icon_state = "mud_light"

/turf/simulated/flooring/mansus/snow
	name = "Snow"
	desc = "Soft snow. It crunches under your feet. Why aren't you making any footprints in it?"
	icon_state = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/turf/simulated/flooring/mansus/warped
	name = "?!"
	desc = "...What the fuck?"
	icon_state = "warped"

/turf/simulated/flooring/mansus/anomalous1
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous1"

/turf/simulated/flooring/mansus/anomalous2
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous2"

/turf/simulated/flooring/mansus/anomalous3
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous3"

/turf/simulated/flooring/mansus/anomalous4
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous4"

/turf/simulated/flooring/mansus/anomalous5
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous5"

/turf/simulated/flooring/mansus/anomalous6
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous6"

/turf/simulated/flooring/mansus/anomalous7
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous7"

/turf/simulated/flooring/mansus/anomalous8
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous8"

/turf/simulated/flooring/mansus/anomalous9
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous9"

/turf/simulated/flooring/mansus/darkness
	name = "Darkness"
	desc = "Darkness. Pure, unyielding darkness. It calls for you."
	icon_state = "dark"
