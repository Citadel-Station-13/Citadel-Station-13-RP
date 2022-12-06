/datum/material/solid/metal/aliumium
	name = "alien alloy"
	uid = "solid_alien"
	wall_icon = 'icons/turf/walls/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	// wall_flags = PAINT_PAINTABLE
	door_icon_base = "metal"
	hitsound = 'sound/weapons/smash.ogg'
	// construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	// hidden_from_codex = TRUE
	// value = 2.5
	default_solid_form = /obj/item/stack/material/cubes
	// exoplanet_rarity = MAT_RARITY_EXOTIC

/datum/material/solid/metal/aliumium/Initialize()
	wall_icon = 'icons/turf/walls/metal.dmi'
	// wall_flags = PAINT_PAINTABLE
	color = rgb(rand(10,150),rand(10,150),rand(10,150))
	// explosion_resistance = rand(25,40)
	// brute_armor = rand(10,20)
	// burn_armor = rand(10,20)
	hardness = rand(15,100)
	reflectiveness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,11000)
	. = ..()

/datum/material/solid/metal/aliumium/place_dismantled_girder(turf/target, datum/material/reinf_material)
	return
