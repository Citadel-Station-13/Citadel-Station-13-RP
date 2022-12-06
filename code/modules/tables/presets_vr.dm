/obj/structure/table/darkglass
	name = "darkglass table"
	desc = "Shiny!"
	icon_state = "darkglass"
	flipped = -1
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/darkglass/New()
	material = GET_MATERIAL_REF(/datum/material/solid/glass/darkglass)
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

	..()

/obj/structure/table/darkglass/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return
/obj/structure/table/alien/blue
	icon = 'icons/turf/shuttle_alien_blue.dmi'


/obj/structure/table/fancyblack
	name = "fancy table"
	desc = "Cloth!"
	icon = 'icons/obj/structures/tables/tablesfancy.dmi'
	icon_state = "fancyblack"
	flipped = -1
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/fancyblack/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/cloth/fancyblack)
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	. = ..()

/obj/structure/table/fancyblack/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

/obj/structure/table/gold
	icon_state = "plain_preview"
	color = "#FFFF00"

/obj/structure/table/gold/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/gold)
	. = ..()
