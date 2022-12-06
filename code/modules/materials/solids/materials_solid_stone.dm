/datum/material/solid/stone
	name = null
	abstract_type = /datum/material/solid/stone

	wall_icon = 'icons/turf/walls/stone.dmi'
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	wall_blend_icons = list(
		'icons/turf/walls/solid.dmi' = TRUE,
		'icons/turf/walls/wood.dmi'  = TRUE,
		'icons/turf/walls/metal.dmi' = TRUE,
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_reinf_directionals = TRUE
	color = "#D9C179"

	stack_type = /obj/item/stack/material/sandstone
	shard_type = SHARD_STONE_PIECE
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_HARD - 5
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5


/datum/material/solid/stone/sandstone
	name = "sandstone"
	uid = "solid_stone_sandstone"
	lore_text = "A clastic sedimentary rock. The cost of boosting it to orbit is almost universally much higher than the actual value of the material."
	value_per_unit = 0.0025

/datum/material/solid/stone/marble
	name = "marble"
	uid = "solid_stone_marble"
	color = "#AAAAAA"
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	bench_icon = 'icons/obj/structures/benches/stone.dmi'
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/datum/material/solid/stone/silencium
	name = "silencium"
	uid = "solid_stone_silencium"
	color = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/silencium



/datum/material/solid/stone/cult
	name = "cult"
	uid = "solid_stone_cult"
	display_name = "disturbing stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	texture_layer_icon_state = "runed"
	wall_icon = 'icons/turf/walls/cult.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_cult.dmi'
	color = "#402821"
	shard_type = SHARD_STONE_PIECE

/datum/material/solid/stone/cult/place_dismantled_girder(turf/target)
	new /obj/structure/girder/cult(target, /datum/material/solid/stone/cult)

/datum/material/solid/stone/cult/place_dismantled_product(turf/target)
	new /obj/effect/debris/cleanable/blood(target)

/datum/material/solid/stone/cult/reinf
	name = "cult2"
	display_name = "human remains"

/datum/material/solid/stone/cult/reinf/place_dismantled_product(turf/target)
	new /obj/effect/decal/remains/human(target)
