/datum/material/solid/stone/sandstone
	id = "sandstone"
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	ore_type_value = ORE_SURFACE

/datum/material/solid/stone/sandstone/marble
	id = "marble"
	name = "marble"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/datum/material/solid/stone/sandstone/silencium
	id = "silencium"
	name = "silencium"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/silencium
