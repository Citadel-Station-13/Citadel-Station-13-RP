// TODO: Redo how we do this stuff. This is horrible. @Zandario

/// TABLE PRESETS
/obj/structure/table/standard
	icon_state = "solid"
	color = "#EEEEEE"

/obj/structure/table/standard/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/plastic)
	return ..()

/obj/structure/table/steel
	icon_state = "metal"
	color = "#666666"

/obj/structure/table/steel/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/marble
	icon_state = "stone"
	color = "#CCCCCC"

/obj/structure/table/marble/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/stone/marble)
	return ..()

/obj/structure/table/reinforced
	icon_state = "reinf"
	color = "#EEEEEE"

/obj/structure/table/reinforced/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/plastic)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/steel_reinforced
	icon_state = "reinf"
	color = "#666666"

/obj/structure/table/steel_reinforced/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/wooden_reinforced
	icon_state = "reinf"
	color = "#824B28"

	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/wooden_reinforced/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/woodentable
	icon_state = "solid"
	color = "#824B28"

	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/woodentable/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood)
	return ..()

/obj/structure/table/sifwoodentable
	icon_state = "solid"
	color = "#824B28"

	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/sifwoodentable/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood/sif)
	return ..()

/obj/structure/table/sifwooden_reinforced
	icon_state = "solid"
	color = "#824B28"

	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/sifwooden_reinforced/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood/sif)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/hardwoodtable
	icon_state = "metal"
	color = "#42291a"

	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/hardwoodtable/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood/hardwood)
	return ..()

/obj/structure/table/gamblingtable
	icon_state = "gamble"

/obj/structure/table/gamblingtable/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood)
	carpeted = 1
	return ..()

/obj/structure/table/glass
	icon_state = "glass"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

	smoothing_groups = list(SMOOTH_GROUP_GLASS_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_GLASS_TABLES)

/obj/structure/table/glass/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/glass)
	return ..()

/obj/structure/table/borosilicate
	icon_state = "glass"
	color = "#4D3EAC"
	alpha = 77

/obj/structure/table/borosilicate/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/glass/borosilicate)
	return ..()

/obj/structure/table/holotable
	icon_state = "holo"
	color = "#EEEEEE"

/obj/structure/table/holotable/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/plastic/holographic)
	return ..()

/obj/structure/table/woodentable/holotable
	icon_state = "holo"

/obj/structure/table/woodentable/holotable/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood/holographic)
	return ..()

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/alien/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/alienalloy/alium)
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	return ..()

/obj/structure/table/alien/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

/obj/structure/table/bananium
	icon_state = "plain_preview"
	color = "#d6c100"

/obj/structure/table/bananium/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/bananium)
	return ..()

/obj/structure/table/bananium_reinforced
	icon_state = "reinf"
	color = "#d6c100"

/obj/structure/table/bananium_reinforced/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/bananium)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()
