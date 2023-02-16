// TODO: Redo how we do this stuff. This is horrible. @Zandario

/// TABLE PRESETS
/obj/structure/table/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/standard/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/plastic)
	return ..()

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/steel/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/steel)
	return ..()

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/marble/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/sandstone/marble)
	return ..()

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/reinforced/Initialize(mapload)
	material   = SSmaterials.get_material(/datum/material/plastic)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	return ..()

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/steel_reinforced/Initialize(mapload)
	material   = SSmaterials.get_material(/datum/material/steel)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	return ..()

/obj/structure/table/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/wooden_reinforced/Initialize(mapload)
	material   = SSmaterials.get_material(/datum/material/wood)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	return ..()

/obj/structure/table/woodentable
	icon_state = "plain_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/woodentable/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood)
	return ..()

/obj/structure/table/sifwoodentable
	icon_state = "plain_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/sifwoodentable/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood/sif)
	return ..()

/obj/structure/table/sifwooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/sifwooden_reinforced/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood/sif)
	reinforced = SSmaterials.get_material(MAT_STEEL)
	return ..()

/obj/structure/table/hardwoodtable
	icon_state = "stone_preview"
	color = "#42291a"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/hardwoodtable/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood/hardwood)
	return ..()

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"

/obj/structure/table/gamblingtable/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood/)
	carpeted = 1
	return ..()

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

	smoothing_groups = (SMOOTH_GROUP_GLASS_TABLES)
	canSmoothWith = (SMOOTH_GROUP_GLASS_TABLES)

/obj/structure/table/glass/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/glass)
	return ..()

/obj/structure/table/borosilicate
	icon_state = "plain_preview"
	color = "#4D3EAC"
	alpha = 77

/obj/structure/table/borosilicate/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/glass/phoron)
	return ..()

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/holotable/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/plastic/holographic)
	return ..()

/obj/structure/table/woodentable/holotable
	icon_state = "holo_preview"

/obj/structure/table/woodentable/holotable/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood/holographic)
	return ..()

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien_preview"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/alien/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/alienalloy/alium)
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	remove_obj_verb(src, /obj/structure/table/proc/do_put)
	return ..()

/obj/structure/table/alien/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

/obj/structure/table/bananium
	icon_state = "plain_preview"
	color = "#d6c100"

/obj/structure/table/bananium/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/bananium)
	return ..()

/obj/structure/table/bananium_reinforced
	icon_state = "reinf_preview"
	color = "#d6c100"

/obj/structure/table/bananium_reinforced/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/bananium)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	return ..()

/obj/structure/table/sandstone
	icon_state = "stone_preview"
	color = "#D9C179"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/sandstone/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/sandstone)
	return ..()

/obj/structure/table/bone
	icon_state = "stone_preview"
	color = "#e6dfc8"

	smoothing_groups = (SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = (SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/bone/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/bone)
	return ..()

//BENCH PRESETS
/obj/structure/table/bench/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/standard/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/plastic)
	return ..()

/obj/structure/table/bench/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/bench/steel/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/steel)
	return ..()

/obj/structure/table/bench/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/bench/marble/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/sandstone/marble)
	return ..()

/*
/obj/structure/table/bench/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/reinforced/New()
	material = SSmaterials.get_material(/datum/material/plastic)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	..()

/obj/structure/table/bench/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/bench/steel_reinforced/New()
	material = SSmaterials.get_material(/datum/material/steel)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	..()

/obj/structure/table/bench/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden_reinforced/New()
	material = SSmaterials.get_material(/datum/material/wood)
	reinforced = SSmaterials.get_material(/datum/material/steel)
	..()
*/
/obj/structure/table/bench/wooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood)
	return ..()

/obj/structure/table/bench/sifwooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/sifwooden/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/wood/sif)
	return ..()

/obj/structure/table/bench/sifwooden/padded
	icon_state = "padded_preview"
	carpeted = 1

/obj/structure/table/bench/padded
	icon_state = "padded_preview"

/obj/structure/table/bench/padded/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/steel)
	carpeted = 1
	return ..()

/obj/structure/table/bench/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/bench/glass/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/glass)
	return ..()

/obj/structure/table/bench/sandstone
	icon_state = "stone_preview"
	color = "#D9C179"

/obj/structure/table/bench/sandstone/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/sandstone)
	return ..()

/obj/structure/table/bench/bone
	icon_state = "stone_preview"
	color = "#e6dfc8"

/obj/structure/table/bench/bone/Initialize(mapload)
	material = SSmaterials.get_material(/datum/material/bone)
	return ..()

/*
/obj/structure/table/bench/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/holotable/New()
	material = SSmaterials.get_material(/datum/material/plastic/holographic)
	..()

/obj/structure/table/bench/wooden/holotable
	icon_state = "holo_preview"

/obj/structure/table/bench/wooden/holotable/New()
	material = SSmaterials.get_material(/datum/material/wood/holographic)
	..()
*/
