/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1
	item_pixel_place = FALSE
	color = COLOR_STEEL

/obj/structure/table/rack/Initialize(mapload)
	. = ..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	if(material)	// For rack colors based on materials
		color = material.icon_color
	return

/obj/structure/table/rack/holorack/dismantle(obj/item/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

/obj/structure/table/rack/steel/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/rack/shelf
	name = "shelving"
	desc = "Some nice metal shelves."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shelf"

/obj/structure/table/rack/shelf/steel
	color = COLOR_STEEL

/obj/structure/table/rack/shelf/steel/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()
