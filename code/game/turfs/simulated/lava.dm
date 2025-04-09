/turf/simulated/lava
	name = "lava"
	desc = "A pool of molten rock."
	description_info = "Molten rock is extremly dangerous, as it will cause massive harm to anything that touches it.<br>\
	A firesuit cannot fully protect from contact with molten rock."
	gender = PLURAL // So it says "That's some lava." on examine.
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "lava"
	edge_blending_priority = 0
	// flags = TURF_HAS_EDGES
	// todo: THE ABOVE FLAGS DOESNT WORK BECAUSE ITS ON FLOORING!
	slowdown = 2
	temperature_for_heat_exchangers = T0C + 2200
	turf_flags = TURF_FLAG_ERODING

	ambient_light = LIGHT_COLOR_LAVA
	ambient_light_multiplier = 1

	// smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_FLOOR_LAVA)
	canSmoothWith = (SMOOTH_GROUP_FLOOR_LAVA)

/turf/simulated/lava/noblend
	edge_blending_priority = 0

/turf/simulated/lava/indoors
	outdoors = FALSE

/turf/simulated/lava/indoors/noblend
	edge_blending_priority = 0

/turf/simulated/lava/Initialize(mapload)

	// For maximum pedantry.
	if(!outdoors)
		name = "magma"

	return ..()

/turf/simulated/lava/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/simulated/lava/make_outdoors()
	..()
	name = "lava"

/turf/simulated/lava/make_indoors()
	..()
	name = "magma"

/turf/simulated/lava/Entered(atom/movable/AM)
	. = ..()
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/lava/throw_landed(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
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

	for(var/atom/movable/thing as anything in thing_to_check)
		if(thing.is_avoiding_ground()) // Flying/riding over the lava. We're just gonna pretend convection doesn't exist.
			continue
		. = TRUE
		thing.lava_act()

// Lava that does nothing at all.
/turf/simulated/lava/harmless/burn_stuff(atom/movable/AM)
	return FALSE

// Tells AI mobs to not suicide by pathing into lava if it would hurt them.
/turf/simulated/lava/is_safe_to_enter(mob/living/L)
	if(!is_safe() && !L.is_avoiding_ground())
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
	else if(istype(W,/obj/item/stack/tile/floor/sandstone))
		var/obj/item/stack/tile/floor/sandstone/material = W
		if(material.get_amount() < 2)
			return 0
		else if(do_after(user, 4))
			material.use(2)
			new /obj/structure/catwalk/ashlander(src)
