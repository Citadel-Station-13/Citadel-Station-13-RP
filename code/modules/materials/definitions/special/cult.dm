/datum/material/cult
	id = "cult"
	name = "cult"
	display_name = "disturbing stone"
	icon_base = 'icons/turf/walls/cult.dmi'
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target, /datum/material/cult)

/datum/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/debris/cleanable/blood(target)

/datum/material/cult/reinf
	id = "cult_reinforced"
	name = "cult2"
	display_name = "human remains"

/datum/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)
