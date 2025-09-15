/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "waterballoon-e"
	damage_force = 0

/obj/item/toy/balloon/Initialize(mapload)
	. = ..()
	create_reagents(10)

/obj/item/toy/balloon/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return
	if (istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(src,target) <= 1)
		target.reagents.trans_to_obj(src, 10)
		to_chat(user, "<span class='notice'>You fill the balloon with the contents of [target].</span>")
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.splash(user, reagents.total_volume)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, "<span class='notice'>You fill the balloon with the contents of [O].</span>")
					O.reagents.trans_to_obj(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/throw_impact(atom/A, datum/thrownthing/TT)
	. = ..()
	if(!(TT.throw_flags & THROW_AT_IS_GENTLE))
		if(src.reagents.total_volume >= 1)
			src.visible_message("<span class='warning'>\The [src] bursts!</span>","You hear a pop and a splash.")
			reagents.perform_entity_splash(A, 1)
			src.icon_state = "burst"
			QDEL_IN(src, 5)

/obj/item/toy/balloon/throw_land(atom/A, datum/thrownthing/TT)
	. = ..()
	if(!(TT.throw_flags & THROW_AT_IS_GENTLE))
		if(src.reagents.total_volume >= 1)
			src.visible_message("<span class='warning'>\The [src] bursts!</span>","You hear a pop and a splash.")
			reagents.perform_entity_splash(A, 1)
			src.icon_state = "burst"
			QDEL_IN(src, 5)

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
	else
		icon_state = "waterballoon-e"
