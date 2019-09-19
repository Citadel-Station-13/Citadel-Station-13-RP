/datum/material/cult
	id = MATERIAL_ID_CULT
	display_name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/cult/place_dismantled_girder(turf/target)
	new /obj/structure/girder/cult(target, "cult")

/datum/material/cult/place_dismantled_product(turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/datum/material/cult/reinf
	id = MATERIAL_ID_CULT_REINFORCED
	display_name = "human remains"

/datum/material/cult/reinf/place_dismantled_product(turf/target)
	new /obj/effect/decal/remains/human(target)

