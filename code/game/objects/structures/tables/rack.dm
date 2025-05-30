// todo: de-table

/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	can_deconstruct = TRUE
	is_not_a_table = TRUE
	material_base = /datum/prototype/material/steel
	flipped = -1
	item_pixel_place = FALSE
	base_name = "rack"

/obj/structure/table/rack/Initialize(mapload)
	. = ..()
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	remove_obj_verb(src, /obj/structure/table/proc/do_put)

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	if(!isnull(material_base))
		color = material_base.icon_colour

// todo: AAAAGGGGHGHHHH GET RID OF THIS
/obj/structure/table/rack/holorack_legacy
	can_deconstruct = FALSE
