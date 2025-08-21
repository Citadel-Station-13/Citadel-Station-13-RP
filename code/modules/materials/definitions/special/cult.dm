/datum/prototype/material/cult
	id = "cult"
	name = "cult"
	display_name = "disturbing stone"
	icon_base = 'icons/turf/walls/cult_wall.dmi'
	icon_colour = "#402821"
	icon_base = 'icons/turf/walls/cult_wall.dmi' // TODO: something because this is dumb
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target, /datum/prototype/material/cult)

/datum/prototype/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/debris/cleanable/blood(target)

/datum/prototype/material/cult/reinf
	id = "cult_reinforced"
	name = "cult2"
	display_name = "human remains"

/datum/prototype/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)
