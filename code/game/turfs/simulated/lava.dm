/turf/simulated/lava
	name = "lava"
	desc = "A pool of molten rock."
	description_info = "Molten rock is extremly dangerous, as it will cause massive harm to anything that touches it.<br>\
	A firesuit cannot fully protect from contact with molten rock."
	gender = PLURAL // So it says "That's some lava." on examine.
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "lava"
	edge_blending_priority = 4
	movement_cost = 2
	special_temperature = T0C + 2200

	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA

	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA


/turf/open/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/lava/GetHeatCapacity()
	. = 700000

/turf/open/lava/GetTemperature()
	. = 5000

// For maximum pedantry.
/turf/simulated/lava/Initialize(mapload)
	if(!outdoors)
		name = "magma"
	return ..()

/turf/simulated/lava/make_outdoors()
	..()
	name = "lava"

/turf/simulated/lava/make_indoors()
	..()
	name = "magma"

/turf/simulated/lava/Entered(atom/movable/AM)
	..()
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/lava/hitby(atom/movable/AM)
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/lava/process(delta_time)
	if(!burn_stuff())
		STOP_PROCESSING(SSobj, src)

/turf/simulated/lava/proc/is_safe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/catwalk))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	return LAZYLEN(found_safeties)

/turf/simulated/lava/proc/burn_stuff(atom/movable/AM)
	. = FALSE

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)

	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if(O.throwing)
				continue
			. = TRUE
			O.lava_act()

		else if(isliving(thing))
			var/mob/living/L = thing
			if(L.hovering || L.throwing) // Flying over the lava. We're just gonna pretend convection doesn't exist.
				continue
			. = TRUE
			L.lava_act()

// Lava that does nothing at all.
/turf/simulated/lava/harmless/burn_stuff(atom/movable/AM)
	return FALSE

// Tells AI mobs to not suicide by pathing into lava if it would hurt them.
/turf/simulated/lava/is_safe_to_enter(mob/living/L)
	if(!is_safe() && !L.hovering)
		return FALSE
	return ..()

/turf/simulated/lava/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W))
		return
	else if(istype(W,/obj/item/stack/rods))
		var/obj/item/stack/rods/material = W
		if(material.get_amount() < 2)
			return 0
		else if(do_after(user, 4))
			material.use(2)
			new /obj/structure/catwalk(src)
