/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = FALSE
	can_reinforce = FALSE
	flipped = -1
	item_pixel_place = FALSE

/obj/structure/table/rack/Initialize(mapload)
	. = ..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	if(material) //VOREStation Add for rack colors based on materials
		color = material.icon_colour
	return

/obj/structure/table/rack/holorack/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, SPAN_WARNING("You cannot dismantle \the [src]."))
	return
/obj/structure/table/rack/steel
	color = "#666666"

/obj/structure/table/rack/steel/Initialize(mapload)
	material = get_material_by_name(MAT_STEEL)
	return ..()

/obj/structure/table/rack/shelf
	name = "shelving"
	desc = "Some nice metal shelves."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shelf"

/obj/structure/table/rack/shelf/steel
	color = "#666666"

/obj/structure/table/rack/shelf/steel/Initialize(mapload)
	material = get_material_by_name(MAT_STEEL)
	return ..()
