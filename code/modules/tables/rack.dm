/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1
	item_pixel_place = FALSE

/obj/structure/table/rack/Initialize(mapload)
	. = ..()
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	remove_obj_verb(src, TYPE_PROC_REF(/obj/structure/table, do_put))

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	if(material)
		color = material.icon_colour
	return

/obj/structure/table/rack/holorack/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return
