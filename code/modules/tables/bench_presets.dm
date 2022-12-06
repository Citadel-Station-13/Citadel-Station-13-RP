/// TODO: Repath to /obj/structure/bench instead of this BS @Zandario
/obj/structure/table/bench/standard
	icon_state = "solid"
	color = "#EEEEEE"

/obj/structure/table/bench/standard/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/plastic)
	return ..()

/obj/structure/table/bench/steel
	icon_state = "solid"
	color = "#666666"

/obj/structure/table/bench/steel/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/bench/marble
	icon_state = "stone"
	color = "#CCCCCC"

/obj/structure/table/bench/marble/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/stone/marble)
	return ..()

/*
/obj/structure/table/bench/reinforced
	icon_state = "reinf"
	color = "#EEEEEE"

/obj/structure/table/bench/reinforced/New()
	material = GET_MATERIAL_REF(/datum/material/solid/plastic)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	..()

/obj/structure/table/bench/steel_reinforced
	icon_state = "reinf"
	color = "#666666"

/obj/structure/table/bench/steel_reinforced/New()
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	..()

/obj/structure/table/bench/wooden_reinforced
	icon_state = "reinf"
	color = "#824B28"

/obj/structure/table/bench/wooden_reinforced/New()
	material = GET_MATERIAL_REF(datum/material/solid/wood)
	reinforced = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	..()
*/
/obj/structure/table/bench/wooden
	icon_state = "solid"
	color = "#824B28"

/obj/structure/table/bench/wooden/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood)
	return ..()

/obj/structure/table/bench/sifwooden
	icon_state = "solid"
	color = "#824B28"

/obj/structure/table/bench/sifwooden/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/wood/sif)
	return ..()

/obj/structure/table/bench/sifwooden/padded
	icon_state = "padded"
	carpeted = TRUE

/obj/structure/table/bench/padded
	icon_state = "padded"

/obj/structure/table/bench/padded/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	carpeted = TRUE
	return ..()

/obj/structure/table/bench/glass
	icon_state = "solid"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/bench/glass/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/glass)
	return ..()

/*
/obj/structure/table/bench/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/holotable/New()
	material = GET_MATERIAL_REF(/datum/material/solid/plastic/holographic)
	..()

/obj/structure/table/bench/wooden/holotable
	icon_state = "holo_preview"

/obj/structure/table/bench/wooden/holotable/New()
	material = GET_MATERIAL_REF(/datum/material/solid/wood/holographic)
	..()
*/
