/datum/prototype/material/alienalloy/rusted
	id = "rusted"
	name = "rusted"

	// Becomes "[display_name] wall" in the UI.
	display_name = "rusted"

	icon_base = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/rusted_walls.dmi'
	icon_colour = "#faf9f981"
	wall_stripe_icon = null // leave null

	door_icon_base = "rusted" // For doors.

// Walls

/turf/simulated/wall/eldritch/rusted_wall
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/rusted_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/rusted
	name = "rusted wall"
	desc = "A rusted wall. You'd expect it to crumble upon a touch, but it does not."
	description_info = "Something's off. Is the rust crawling across the surface?"
	block_tele = TRUE
	integrity_enabled = 0

// Floors

/turf/simulated/flooring/eldritch
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/floors.dmi'
	integrity_enabled = 0


/turf/simulated/flooring/eldritch/cosmic
	name = "Cosmic Tear"
	desc = "It glows and hums with unknowable amounts of power."
	icon_state = "cosmic_carpet"

/turf/simulated/flooring/eldritch/reality_crack
	name = "???"
	desc = "You cannot comprehend what is occuring here."
	icon_state = "realitycrack"

/turf/simulated/flooring/eldritch/dark_ice
	name = "Ice"
	desc = "Cold, dark ice. Something is wrong about it."
	icon_state = "ice_dark"

/turf/simulated/flooring/eldritch/dark_ice_smooth
	name = "Smooth Ice"
	desc = "Smooth dark ice. It makes you feel so, so cold. No matter the gear you wear."
	icon_state = "ice_dark_smooth"

/turf/simulated/flooring/eldritch/dark_rock
	name = "Rock"
	desc = "Hardened rock, dark in color."
	icon_state = "rock_dark"

/turf/simulated/flooring/eldritch/dark_mud
	name = "Mud"
	desc = "Compacted mud. Pretty hardy."
	icon_state = "mud_dark"

/turf/simulated/flooring/eldritch/light_mud
	name = "Mud"
	desc = "Soft mud. Probably recently formed"
	icon_state = "mud_light"

/turf/simulated/flooring/eldritch/snow
	name = "Snow"
	desc = "Soft snow. It crunches under your feet. Why aren't you making any footprints in it?"
	icon_state = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/turf/simulated/flooring/eldritch/warped
	name = "?!"
	desc = "...What the fuck?"
	icon_state = "warped"

/turf/simulated/flooring/eldritch/anomalous1
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous1"

/turf/simulated/flooring/eldritch/anomalous2
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous2"

/turf/simulated/flooring/eldritch/anomalous3
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous3"

/turf/simulated/flooring/eldritch/anomalous4
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous4"

/turf/simulated/flooring/eldritch/anomalous5
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous5"

/turf/simulated/flooring/eldritch/anomalous6
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous6"

/turf/simulated/flooring/eldritch/anomalous7
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous7"

/turf/simulated/flooring/eldritch/anomalous8
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous8"

/turf/simulated/flooring/eldritch/anomalous9
	name = "..."
	desc = "Something's not right."
	icon_state = "anomalous9"

/turf/simulated/flooring/eldritch/darkness
	name = "Darkness"
	desc = "Darkness. Pure, unyielding darkness. It calls for you."
	icon_state = "dark"
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/darkness.dmi'


// standalone walls

/turf/simulated/flooring/eldritch/wall
	density = 1
	opacity = 1
	blocks_air = TRUE


// wood

/turf/simulated/flooring/eldritch/wall/wood
	name = "wooden wall"
	desc = "A wall carved from some sort of hardwood."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/walls/wood.dmi'
	icon_state = "wood1"


/turf/simulated/flooring/eldritch/wall/wood/variant2
	icon_state = "wood2"

/turf/simulated/flooring/eldritch/wall/wood/variant3
	icon_state = "wood3"

/turf/simulated/flooring/eldritch/wall/wood/variant4
	icon_state = "wood4"

/turf/simulated/flooring/eldritch/wall/wood/variant5
	icon_state = "wood5"

/turf/simulated/flooring/eldritch/wall/wood/variant6
	icon_state = "wood6"


// tent

/turf/simulated/flooring/eldritch/wall/tent
	name = "tent wall"
	desc = "A frame draped with some sort of hide that forms a wall."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/walls/tent.dmi'
	icon_state = "tent"

/turf/simulated/flooring/eldritch/wall/tent/door
	name = "closed tent door"
	desc = "A tent door that is draped closed. No matter how hard you try, it refuses to open."
	icon_state = "tent_door_closed"

/turf/simulated/flooring/eldritch/wall/tent/door2
	name = "open tent door"
	desc = "A tent door that is draped open."
	icon_state = "tent_door_open"
	density = 0
	opacity = 0
	blocks_air = FALSE


// window

/obj/structure/window/eldritch
	name = "window"
	desc = "An old style of window paned with glass and framed with wood."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/turf.dmi/walls/window.dmi'
	icon_state = "window"
	opacity = 0
	integrity_enabled = 0

/obj/structure/window/eldritch/fancy
	name = "fancy window"
	desc = "An elegant window that's evidently had some care put into it."
	icon_state = "window_fancy"

/obj/structure/window/eldritch/wood
	name = "wooden viewport"
	desc = "A crude wooden wall that's been carved to have a view to the other side."
	icon_state = "wood_window"

/obj/structure/window/eldritch/stone
	name = "stone viewport"
	desc = "A crude stone wall that's been carved to have a view to the other side."
	icon_state = "stone_window"

/obj/structure/window/eldritch/broken
	name = "broken window"
	desc = "An old style of window paned with glass and framed with wood. This one is broken beyond repair."
	icon_state = "window_broken"

/obj/structure/window/eldritch/broken_fancy
	name = "broken window"
	desc = "An elegant window that's evidently had some care put into it. This one is broken beyond repair."
	icon_state = "window_fancy_broken"
