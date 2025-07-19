//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Roguetown Medieval.
 *
 * Sprite credits to where they're due. I don't know who made these, only where I
 * found them. If it's actually from Lifeweb or something, please understand I don't
 * have this history data.
 */
/turf/simulated/wall/rt_medieval
	abstract_type = /turf/simulated/wall/rt_medieval
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	material_system = FALSE
	base_icon_state = "wall"
	icon_state = "wall-0"
	// needed due to base wall being steel :/
	color = null

// TODO: destructible sprites, consturction, shift these slowly into
//       materials system. wall themes/styles?
// TODO: proper icon smoothing

/turf/simulated/wall/rt_medieval/boss
	name = "archaic terrain wall"
	desc = "You don't how this was made, but it doesn't look very welcoming."
	icon = 'icons/turf/walls/rt_medieval/boss.dmi'

/turf/simulated/wall/rt_medieval/stone
	name = "archaic stone wall"
	desc = "An archaic wall made from stone. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/stone.dmi'

/turf/simulated/wall/rt_medieval/stone/brick
	name = "archaic stone brick wall"
	desc = "An archaic wall made from stone brick. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/stone/brick.dmi'

/turf/simulated/wall/rt_medieval/stone/craft
	name = "archaic craft stone wall"
	desc = "An archaic wall made from textured stone. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/stone/craft.dmi'

/turf/simulated/wall/rt_medieval/stone/moss_red
	name = "archaic mossy stone wall"
	desc = "An archaic wall made from stone. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/stone/moss_red.dmi'

/turf/simulated/wall/rt_medieval/stone/moss_green
	name = "archaic mossy stone wall"
	desc = "An archaic wall made from stone. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/stone/moss_green.dmi'

/turf/simulated/wall/rt_medieval/stone/moss_blue
	name = "archaic mossy stone wall"
	desc = "An archaic wall made from stone. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/stone/moss_blue.dmi'

/turf/simulated/wall/rt_medieval/wood
	name = "archaic wooden wall"
	desc = "An archaic wall made from wood. It looks sturdy."
	icon = 'icons/turf/walls/rt_medieval/wood.dmi'
