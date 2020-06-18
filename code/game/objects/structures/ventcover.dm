/obj/structure/ventcover
	name = "ventilation cover"
	desc = "A ventilation cover, not to be confused with the ones connected to pipes."
	icon = 'icons/obj/structures.dmi'
	icon_state = "vent"
	item_state = "closed"
	density = 0
	anchored = 1.0
	var/open = FALSE
	w_class = ITEMSIZE_NORMAL
	plane = PLATING_PLANE
	//	flags = CONDUCT

/obj/structure/ventcover/Initialize()
	. = ..()

	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/mineral)))
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/ventcover/VENT in src.loc)
		if(VENT != src)
			crash_with("Found multiple ventilation structures at '[log_info_line(loc)]'")
			return INITIALIZE_HINT_QDEL

/obj/structure/ventcover/Destroy()
	if(istype(loc, /turf/simulated/open))
		var/turf/simulated/open/O = loc
		spawn(1)
			if(istype(O))
				O.update()
	. = ..()

/obj/structure/ventcover/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/ventcover/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.welding == 1)
			if(WT.remove_fuel(0, user))
				to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
			new /obj/item/stack/rods(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
	if(istype(C, /obj/item/tool/crowbar))
		to_chat(user, "<span class='notice'>You start prying [open? "closed":"open"] the vent cover...</span>")
		playsound(src, C.usesound, 100, 1)
		if(do_after(user, 5 SECONDS * C.toolspeed))
			open = !open
			to_chat(user, "<span class='notice'>You pry [open? "open":"close"] the cover.</span>")
			update_icon()
	if(istype(C, /obj/item/tool/screwdriver))
		to_chat(user, "<span class='notice'>You start to [open? "closed":"open"] the vent cover...</span>")
		playsound(src, C.usesound, 20, 1)
		if(do_after(user, 10 SECONDS * C.toolspeed))
			open = !open
			to_chat(user, "<span class='notice'>You [open? "open":"close"] the cover.</span>")
			update_icon()

/obj/structure/ventcover/update_icon()
	. = ..()
	icon_state = open? "vent-open" : "vent"
