//TABLE PRESETS
/obj/structure/table/standard
	icon_state = "solid"
	color = "#EEEEEE"

/obj/structure/table/standard/Initialize(mapload)
	material = get_material_by_name(MAT_PLASTIC)
	return ..()

/obj/structure/table/steel
	icon_state = "metal"
	color = "#666666"

/obj/structure/table/steel/Initialize(mapload)
	material = get_material_by_name(MAT_STEEL)
	return ..()

/obj/structure/table/marble
	icon_state = "stone"
	color = "#CCCCCC"

/obj/structure/table/marble/Initialize(mapload)
	material = get_material_by_name(MAT_MARBLE)
	return ..()

/obj/structure/table/reinforced
	icon_state = "reinf"
	color = "#EEEEEE"

/obj/structure/table/reinforced/Initialize(mapload)
	material = get_material_by_name(MAT_PLASTIC)
	reinforced = get_material_by_name(MAT_STEEL)
	return ..()

/obj/structure/table/steel_reinforced
	icon_state = "reinf"
	color = "#666666"

/obj/structure/table/steel_reinforced/Initialize(mapload)
	material = get_material_by_name(MAT_STEEL)
	reinforced = get_material_by_name(MAT_STEEL)
	return ..()

/obj/structure/table/wooden_reinforced
	icon_state = "reinf"
	color = "#824B28"

/obj/structure/table/wooden_reinforced/Initialize(mapload)
	material = get_material_by_name(MAT_WOOD)
	reinforced = get_material_by_name(MAT_STEEL)
	return ..()

/obj/structure/table/woodentable
	icon_state = "solid"
	color = "#824B28"

/obj/structure/table/woodentable/Initialize(mapload)
	material = get_material_by_name(MAT_WOOD)
	return ..()

/obj/structure/table/sifwoodentable
	icon_state = "solid"
	color = "#824B28"

/obj/structure/table/sifwoodentable/Initialize(mapload)
	material = get_material_by_name(MAT_SIFWOOD)
	return ..()

/obj/structure/table/sifwooden_reinforced
	icon_state = "solid"
	color = "#824B28"

/obj/structure/table/sifwooden_reinforced/Initialize(mapload)
	material = get_material_by_name(MAT_SIFWOOD)
	reinforced = get_material_by_name(MAT_STEEL)
	return ..()

/obj/structure/table/hardwoodtable
	icon_state = "metal"
	color = "#42291a"

/obj/structure/table/hardwoodtable/Initialize(mapload)
	material = get_material_by_name(MAT_HARDWOOD)
	return ..()

/obj/structure/table/gamblingtable
	icon_state = "gamble"

/obj/structure/table/gamblingtable/Initialize(mapload)
	material = get_material_by_name(MAT_WOOD)
	carpeted = 1
	return ..()

/obj/structure/table/glass
	icon_state = "glass"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/glass/Initialize(mapload)
	material = get_material_by_name(MAT_GLASS)
	return ..()

/obj/structure/table/borosilicate
	icon_state = "glass"
	color = "#4D3EAC"
	alpha = 77

/obj/structure/table/borosilicate/Initialize(mapload)
	material = get_material_by_name(MAT_GLASS_BS)
	return ..()

/obj/structure/table/holotable
	icon_state = "holo"
	color = "#EEEEEE"

/obj/structure/table/holotable/Initialize(mapload)
	material = get_material_by_name("holo[MAT_PLASTIC]")
	return ..()

/obj/structure/table/woodentable/holotable
	icon_state = "holo"

/obj/structure/table/woodentable/holotable/Initialize(mapload)
	material = get_material_by_name("holowood")
	return ..()

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/alien/Initialize(mapload)
	material = get_material_by_name("alium")
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
	material = get_material_by_name("bananium")
	return ..()

/obj/structure/table/bananium_reinforced
	icon_state = "reinf"
	color = "#d6c100"

/obj/structure/table/bananium_reinforced/Initialize(mapload)
	material = get_material_by_name("bananium")
	reinforced = get_material_by_name(MAT_STEEL)
	return ..()
