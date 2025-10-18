/obj/machinery/recycling_pad
	name = "recycling pad"
	desc = "A recycling pad, for when you need that junk to go."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recycling_pad"
	density = 0
	anchored = 1
	layer = TURF_LAYER + 0.1
	circuit = /obj/item/circuitboard/recycling_pad

	var/min_salvage = 5
	var/max_salvage =  10

/obj/machinery/recycling_pad/RefreshParts()
	..()

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/manipulator))
			min_salvage += P.rating * 2
		if(istype(P, /obj/item/stock_parts/micro_laser))
			min_salvage += P.rating * 1
			max_salvage += P.rating * 3
		if(istype(P, /obj/item/stock_parts/scanning_module))
			max_salvage += P.rating * 5

/obj/machinery/recycling_pad/Crossed(var/atom/movable/M)

	. = ..()
	var/list/mech_types = list(/obj/effect/decal/mecha_wreckage,/obj/structure/loot_pile/mecha)
	var/list/broken_types = list(/obj/item/broken_device)
	var/list/trash_types = list(/obj/item/trash)
	var/list/salvage = list(/obj/item/stack/material/plasteel,/obj/item/stack/material/steel,/obj/item/stack/material/diamond,/obj/item/stack/material/uranium/,/obj/item/stack/material/glass/,/obj/item/stack/material/plastic)
	var/list/broken_salvage = list(/obj/item/stack/material/steel,/obj/item/stack/material/glass/)
	var/list/trash_salvage = list(/obj/item/stack/material/plastic)
	var/wrenched = 1

	if(wrenched == anchored)
		for(var/mtype in mech_types)
			if(istype(M, mtype))
				qdel(M)
				visible_message("The machine begins to take apart the wreckage.","The machine begins to take apart the wreckage.")
				playsound(loc,"sound/items/rped.ogg", 50, 1, -1)
				var/salvage_type = pick(salvage)
				new salvage_type(loc, rand(min_salvage, max_salvage))

		for(var/mtype in broken_types)
			if(istype(M, mtype))
				qdel(M)
				playsound(loc,"sound/items/rped.ogg", 10, 1, -1)
				var/salvage_type = pick(broken_salvage)
				new salvage_type(loc, rand((min_salvage/3), (max_salvage/3)))

		for(var/mtype in trash_types)
			if(istype(M, mtype))
				qdel(M)
				playsound(loc,"sound/items/rped.ogg", 10, 1, -1)
				var/salvage_type = pick(trash_salvage)
				new salvage_type(loc, rand((min_salvage/6), (max_salvage/6)))


/obj/machinery/recycling_pad/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(I.is_wrench())
		anchored = !anchored
		visible_message("<span class='notice'>\The [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by [user].</span>")
		playsound(src, I.tool_sound, 75, 1)
		return
