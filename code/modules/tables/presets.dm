// TODO: Redo how we do this stuff. This is horrible. @Zandario

/// TABLE PRESETS
/obj/structure/table/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"
	material_parts = list(
		"base" = /datum/material/plastic,
		"reinf"= null,
	)

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = "#666666"
	material_parts = list(
		"base" = /datum/material/steel,
		"reinf"= null,
	)

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"
	material_parts = list(
		"base" = /datum/material/sandstone/marble,
		"reinf"= null,
	)

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"
	material_parts = list(
		"base" = /datum/material/plastic,
		"reinf"= /datum/material/steel,
	)

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"
	material_parts = list(
		"base" = /datum/material/steel,
		"reinf"= /datum/material/steel,
	)

/obj/structure/table/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/wood,
		"reinf"= /datum/material/steel,
	)

/obj/structure/table/woodentable
	icon_state = "plain_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/wood,
		"reinf"= null,
	)

/obj/structure/table/sifwoodentable
	icon_state = "plain_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/wood/sif,
		"reinf"= null,
	)

/obj/structure/table/sifwooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/wood/sif,
		"reinf"= /datum/material/steel,
	)

/obj/structure/table/hardwoodtable
	icon_state = "stone_preview"
	color = "#42291a"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/wood/hardwood,
		"reinf"= null,
	)

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"

	material_parts = list(
		"base" = /datum/material/wood,
		"reinf"= null,
	)
	carpeted = TRUE

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

	smoothing_groups = (SMOOTH_GROUP_GLASS_TABLES)
	canSmoothWith = (SMOOTH_GROUP_GLASS_TABLES)

	material_parts = list(
		"base" = /datum/material/glass,
		"reinf"= null,
	)

/obj/structure/table/glass/Initialize(mapload)
	material = SSmaterials.resolve_material(/datum/material/glass)
	return ..()

/obj/structure/table/borosilicate
	icon_state = "plain_preview"
	color = "#4D3EAC"
	alpha = 77

	material_parts = list(
		"base" = /datum/material/glass/phoron,
		"reinf"= null,
	)

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

	material_parts = list(
		"base" = /datum/material/plastic/holographic,
		"reinf"= null,
	)

/obj/structure/table/woodentable/holotable
	icon_state = "holo_preview"

	material_parts = list(
		"base" = /datum/material/wood/holographic,
		"reinf"= null,
	)

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien_preview"
	can_reinforce = FALSE
	can_plate = FALSE

	material_parts = list(
		"base" = /datum/material/alienalloy/alium,
		"reinf"= null,
	)

/obj/structure/table/alien/Initialize(mapload)
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	remove_obj_verb(src, /obj/structure/table/proc/do_put)
	return ..()

/obj/structure/table/alien/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

/obj/structure/table/bananium
	icon_state = "plain_preview"
	color = "#d6c100"

	material_parts = list(
		"base" = /datum/material/bananium,
		"reinf"= null,
	)

/obj/structure/table/bananium_reinforced
	icon_state = "reinf_preview"
	color = "#d6c100"

	material_parts = list(
		"base" = /datum/material/bananium,
		"reinf"= /datum/material/steel,
	)

/obj/structure/table/sandstone
	icon_state = "stone_preview"
	color = "#D9C179"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/sandstone,
		"reinf"= null,
	)

/obj/structure/table/bone
	icon_state = "stone_preview"
	color = "#e6dfc8"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

	material_parts = list(
		"base" = /datum/material/bone,
		"reinf"= null,
	)

//BENCH PRESETS
/obj/structure/table/bench/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

	material_parts = list(
		"base" = /datum/material/plastic,
		"reinf"= null,
	)

/obj/structure/table/bench/steel
	icon_state = "plain_preview"
	color = "#666666"

	material_parts = list(
		"base" = /datum/material/steel,
		"reinf"= null,
	)

/obj/structure/table/bench/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

	material_parts = list(
		"base" = /datum/material/sandstone/marble,
		"reinf"= null,
	)

/obj/structure/table/bench/wooden
	icon_state = "plain_preview"
	color = "#824B28"

	material_parts = list(
		"base" = /datum/material/wood,
		"reinf"= null,
	)

/obj/structure/table/bench/sifwooden
	icon_state = "plain_preview"
	color = "#824B28"

	material_parts = list(
		"base" = /datum/material/wood/sif,
		"reinf"= null,
	)

/obj/structure/table/bench/sifwooden/padded
	icon_state = "padded_preview"
	carpeted = 1

/obj/structure/table/bench/padded
	icon_state = "padded_preview"

	material_parts = list(
		"base" = /datum/material/steel,
		"reinf"= null,
	)
	carpeted = TRUE

/obj/structure/table/bench/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

	material_parts = list(
		"base" = /datum/material/glass,
		"reinf"= null,
	)

/obj/structure/table/bench/sandstone
	icon_state = "stone_preview"
	color = "#D9C179"

	material_parts = list(
		"base" = /datum/material/sandstone,
		"reinf"= null,
	)

/obj/structure/table/bench/bone
	icon_state = "stone_preview"
	color = "#e6dfc8"

	material_parts = list(
		"base" = /datum/material/bone,
		"reinf"= null,
	)
