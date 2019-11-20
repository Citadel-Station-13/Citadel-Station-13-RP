//TABLE PRESETS
/obj/structure/table/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"
	material_primary = DEFAULT_TABLE_MATERIAL_ID

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = "#666666"
	material_primary = MATERIAL_ID_STEEL

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"
	material_primary = MATERIAL_ID_MARBLE

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"
	material_primary = DEFAULT_TABLE_MATERIAL_ID
	material_reinforcing = MATERIAL_ID_STEEL

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"
	material_primary = MATERIAL_ID_STEEL
	material_reinforced = MATERIAL_ID_REINFORCED

/obj/structure/table/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"
	material_primary = MATERIAL_ID_WOOD
	material_reinforcing = MATERIAL_ID_STEEL

/obj/structure/table/woodentable
	icon_state = "plain_preview"
	color = "#824B28"
	material_primary = MATERIAL_ID_WOOD

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	material_primary = MATERIAL_ID_WOOD
	carpeted = TRUE

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255
	material_primary = MATERIAL_ID_GLASS

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"
	material_primary = MATERIAL_ID_STEEL_HOLO

/obj/structure/table/woodentable/holotable
	icon_state = "holo_preview"
	material_primary = MATERIAL_ID_WOOD_HOLO

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien_preview"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/alien/New()
	material = get_material_by_name("alium")
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	..()

/obj/structure/table/alien/dismantle(obj/item/weapon/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle [src].</span>")
	return

//BENCH PRESETS
/obj/structure/table/bench/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"
	material_primary = DEFAULT_TABLE_MATERIAL_ID

/obj/structure/table/bench/steel
	icon_state = "plain_preview"
	color = "#666666"
	material_primary = MATERIAL_ID_STEEL

/obj/structure/table/bench/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"
	material_primary = MATERIAL_ID_MARBLE

/*
/obj/structure/table/bench/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/reinforced/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(MATERIAL_ID_STEEL)
	..()

/obj/structure/table/bench/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/bench/steel_reinforced/New()
	material = get_material_by_name(MATERIAL_ID_STEEL)
	reinforced = get_material_by_name(MATERIAL_ID_STEEL)
	..()

/obj/structure/table/bench/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden_reinforced/New()
	material = get_material_by_name(MATERIAL_ID_WOOD)
	reinforced = get_material_by_name(MATERIAL_ID_STEEL)
	..()
*/
/obj/structure/table/bench/wooden
	icon_state = "plain_preview"
	color = "#824B28"
	material_primary = MATERIAL_ID_WOOD

/obj/structure/table/bench/padded
	icon_state = "padded_preview"
	material_primary = MATERIAL_ID_STEEL
	carpeted = TRUE

/obj/structure/table/bench/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255
	material_primary = MATERIAL_ID_GLASS

/*
/obj/structure/table/bench/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/holotable/New()
	material = get_material_by_name("holo[DEFAULT_TABLE_MATERIAL]")
	..()

/obj/structure/table/bench/wooden/holotable
	icon_state = "holo_preview"

/obj/structure/table/bench/wooden/holotable/New()
	material = get_material_by_name("holowood")
	..()
*/