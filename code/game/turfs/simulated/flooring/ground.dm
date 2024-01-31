
/singleton/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null

/singleton/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow_new.dmi'
	icon_base = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/singleton/flooring/snow/gravsnow
	name = "snowy gravel"
	desc = "A layer of coarse ice pebbles and assorted gravel."
	icon = 'icons/turf/snow_new.dmi'
	icon_base = "gravsnow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/singleton/flooring/snow/snow2
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow.dmi'
	icon_base = "snow"
	flooring_flags = TURF_HAS_EDGES

/singleton/flooring/snow/gravsnow2
	name = "gravsnow"
	icon = 'icons/turf/snow.dmi'
	icon_base = "gravsnow"

/singleton/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	icon_base = "snowyplating"
	flooring_flags = null

/singleton/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	icon_base = "ice"

/singleton/flooring/snow/plating/drift
	icon_base = "snowyplayingdrift"
