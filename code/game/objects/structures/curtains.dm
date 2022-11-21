/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/curtain.dmi'
	icon_state = "bathroom-closed"
	base_icon_state = "bathroom"
	color = "#ACD1E9" // Default color, didn't bother hardcoding other colors, mappers can and should easily change it.
	alpha = 200 // Mappers can also just set this to 255 if they want curtains that can't be seen through.
	plane = GAME_PLANE
	layer = SIGN_LAYER
	anchored = TRUE
	opacity = FALSE
	density = FALSE

	var/open = FALSE
	/// If it can be seen through when closed.
	var/opaque_closed = FALSE

/obj/structure/curtain/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	playsound(loc, 'sound/effects/curtain.ogg', 50, TRUE)
	toggle()

/obj/structure/curtain/proc/toggle()
	open = !open
	if(open)
		plane = GAME_PLANE
		layer = SIGN_LAYER
		set_density(FALSE)
		set_opacity(FALSE)
	else
		plane = GAME_PLANE_UPPER
		layer = WALL_OBJ_LAYER
		set_density(TRUE)
		if(opaque_closed)
			set_opacity(TRUE)

	update_appearance()

/obj/structure/curtain/update_icon_state()
	icon_state = "[base_icon_state]-[open ? "open" : "closed"]"
	return ..()

/obj/structure/curtain/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/pen/crayon))
		color = input(user,"","Choose Color",color) as color
	else
		return ..()

/obj/structure/curtain/wirecutter_act(obj/item/I, mob/user)
	..()
	if(anchored)
		return TRUE
	playsound(src, I.tool_sound, 50, TRUE)
	to_chat(user, SPAN_NOTICE("You start to cut the shower curtains."))

	if(do_after(user, 10))
		user.visible_message(
			SPAN_WARNING("[user] cuts apart [src]."),
			SPAN_NOTICE("You start to cut apart [src]."),
			SPAN_HEAR("You hear cutting."),
		)
		to_chat(user, SPAN_NOTICE("You cut apart [src]."))
		deconstruct()

	return TRUE

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message(SPAN_WARNING("[P] tears [src] down!"))
		qdel(src)
	else
		..(P, def_zone)

/obj/structure/curtain/drop_products(method)
	new /obj/item/stack/material/cloth (loc, 2)
	new /obj/item/stack/material/plastic (loc, 2)
	new /obj/item/stack/rods (loc, 1)

/obj/structure/curtain/open
	icon_state = "bathroom-open"
	plane = GAME_PLANE_UPPER
	layer = WALL_OBJ_LAYER
	opacity = FALSE

/obj/structure/curtain/bounty
	icon_state = "bounty-open"
	base_icon_state = "bounty"
	color = null
	alpha = 255
	opaque_closed = TRUE

/obj/structure/curtain/cloth
	color = null
	alpha = 255
	opaque_closed = TRUE

/obj/structure/curtain/cloth/drop_products(method)
	new /obj/item/stack/material/cloth (loc, 4)
	new /obj/item/stack/rods (loc, 1)

/obj/structure/curtain/cloth/fancy
	icon_state = "cur_fancy-open"
	base_icon_state = "cur_fancy"

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"
	opaque_closed = TRUE

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"

/obj/structure/curtain/open/bed
	name = "bed curtain"
	color = "#854636"
	opaque_closed = TRUE

/obj/structure/curtain/open/privacy
	name = "privacy curtain"
	color = "#B8F5E3"

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#ACD1E9"
	opaque_closed = FALSE

/obj/structure/curtain/open/shower/engineering
	color = "#FFA500"

/obj/structure/curtain/open/shower/medical
	color = "#B8F5E3"

/obj/structure/curtain/open/shower/security
	color = "#AA0000"
