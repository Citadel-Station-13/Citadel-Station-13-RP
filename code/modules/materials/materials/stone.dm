/datum/material/stone
	id = MATERIAL_ID_SANDSTONE
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
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

/datum/material/stone/marble
	id = MATERIAL_ID_MARBLE
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30 //VOREStation Edit - Please.
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
