//TABLE PRESETS
/obj/structure/table/standard
	icon = 'icons/obj/smooth_structures/table_greyscale.dmi'
	icon_state = "table_greyscale-0"
	base_icon_state = "table_greyscale"

/obj/structure/table/standard/Initialize(mapload)
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	return ..()

/obj/structure/table/steel
	icon = 'icons/obj/smooth_structures/table.dmi'
	icon_state = "table-0"
	base_icon_state = "table"
	//material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS

/obj/structure/table/steel/Initialize(mapload)
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

/obj/structure/table/marble
	color = "#CCCCCC"

/obj/structure/table/marble/Initialize(mapload)
	material = get_material_by_name("marble")
	return ..()

/obj/structure/table/reinforced
	name = "reinforced table"
	desc = "A reinforced version of the four legged table."
	icon = 'icons/obj/smooth_structures/reinforced_table.dmi'
	icon_state = "reinforced_table-0"
	base_icon_state = "reinforced_table"

/obj/structure/table/reinforced/Initialize(mapload)
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

/obj/structure/table/reinforced/steel
	color = "#666666"

/obj/structure/table/reinforced/steel/Initialize(mapload)
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

/obj/structure/table/wooden_reinforced
	color = "#824B28"

/obj/structure/table/wooden_reinforced/Initialize(mapload)
	material = get_material_by_name("wood")
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

/obj/structure/table/wood
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon = 'icons/obj/smooth_structures/wood_table.dmi'
	icon_state = "wood_table-0"
	base_icon_state = "wood_table"
	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/wood/Initialize(mapload)
	material = get_material_by_name("wood")
	return ..()

/obj/structure/table/sifwoodentable
	color = "#824B28"

/obj/structure/table/sifwoodentable/Initialize(mapload)
	material = get_material_by_name("alien wood")
	return ..()

/obj/structure/table/sifwooden_reinforced
	color = "#824B28"

/obj/structure/table/sifwooden_reinforced/Initialize(mapload)
	material = get_material_by_name("alien wood")
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

/obj/structure/table/wood/hard
	color = "#42291a"

/obj/structure/table/wood/hard/Initialize(mapload)
	material = get_material_by_name("hardwood")
	return ..()

/obj/structure/table/wood/poker
	name = "gambling table"
	desc = "A seedy table for seedy dealings in seedy places."
	icon = 'icons/obj/smooth_structures/poker_table.dmi'
	icon_state = "poker_table-0"
	base_icon_state = "poker_table"

/obj/structure/table/wood/poker/Initialize(mapload)
	material = get_material_by_name("wood")
	carpeted = 1
	return ..()

/obj/structure/table/glass
	icon = 'icons/obj/smooth_structures/glass_table.dmi'
	icon_state = "glass_table-0"
	base_icon_state = "glass_table"
	material = list(/datum/material/glass = 2000)
	smoothing_groups = list(SMOOTH_GROUP_GLASS_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_GLASS_TABLES)
	//color = "#00E1FF"
	//alpha = 77 // 0.3 * 255

/obj/structure/table/glass/Initialize(mapload)
	material = get_material_by_name("glass")
	return ..()

/obj/structure/table/borosilicate
	icon_state = "plain_preview"
	color = "#4D3EAC"
	alpha = 77

/obj/structure/table/borosilicate/Initialize(mapload)
	material = get_material_by_name("borosilicate glass")
	return ..()

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/holotable/Initialize(mapload)
	material = get_material_by_name("holo[DEFAULT_TABLE_MATERIAL]")
	return ..()

/obj/structure/table/wood/holotable
	icon_state = "holo_preview"

/obj/structure/table/wood/holotable/Initialize(mapload)
	material = get_material_by_name("holowood")
	return ..()

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien_preview"
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
	icon_state = "reinf_preview"
	color = "#d6c100"

/obj/structure/table/bananium_reinforced/Initialize(mapload)
	material = get_material_by_name("bananium")
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

//BENCH PRESETS
/obj/structure/table/bench/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/standard/Initialize(mapload)
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	return ..()

/obj/structure/table/bench/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/bench/steel/Initialize(mapload)
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	return ..()

/obj/structure/table/bench/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/bench/marble/Initialize(mapload)
	material = get_material_by_name("marble")
	return ..()

/*
/obj/structure/table/bench/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/reinforced/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/bench/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/bench/steel_reinforced/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/bench/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden_reinforced/New()
	material = get_material_by_name("wood")
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()
*/
/obj/structure/table/bench/wooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden/Initialize(mapload)
	material = get_material_by_name("wood")
	return ..()

/obj/structure/table/bench/sifwooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/sifwooden/Initialize(mapload)
	material = get_material_by_name("alien wood")
	return ..()

/obj/structure/table/bench/sifwooden/padded
	icon_state = "padded_preview"
	carpeted = 1

/obj/structure/table/bench/padded
	icon_state = "padded_preview"

/obj/structure/table/bench/padded/Initialize(mapload)
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	carpeted = 1
	return ..()

/obj/structure/table/bench/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/bench/glass/Initialize(mapload)
	material = get_material_by_name("glass")
	return ..()

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
