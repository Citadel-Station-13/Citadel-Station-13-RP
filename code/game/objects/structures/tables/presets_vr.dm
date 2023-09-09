/obj/structure/table/darkglass
	name = "darkglass table"
	desc = "Shiny!"
	icon = 'icons/obj/tables_vr.dmi'
	icon_state = "darkglass_table_preview"
	flipped = -1
	can_reinforce = FALSE
	can_plate = FALSE
	material_parts = MATERIAL_DEFAULT_DISABLED

/obj/structure/table/darkglass/Initialize(mapload, base_material, reinforcing_material)
	. = ..()
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	remove_obj_verb(src, /obj/structure/table/proc/do_put)

/obj/structure/table/darkglass/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return
/obj/structure/table/alien/blue
	icon = 'icons/turf/shuttle_alien_blue.dmi'

/obj/structure/table/fancyblack
	name = "fancy table"
	desc = "Cloth!"
	icon = 'icons/obj/tablesfancy_vr.dmi'
	icon_state = "fancyblack"
	flipped = -1
	can_reinforce = FALSE
	can_plate = FALSE
	material_parts = MATERIAL_DEFAULT_DISABLED

/obj/structure/table/fancyblack/Initialize(mapload)
	. = ..()
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	remove_obj_verb(src, /obj/structure/table/proc/do_put)

/obj/structure/table/fancyblack/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return
/obj/structure/table/gold
	icon_state = "plain_preview"
	color = "#FFFF00"
	material_base = /datum/material/gold
