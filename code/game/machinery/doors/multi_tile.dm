//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	airlock_type = "Wide"
	width = 2
	appearance_flags = 0
	var/obj/structure/filler_object/filler1
	var/obj/structure/filler_object/filler2
	open_sound_powered = 'sound/machines/door/WideOpen.ogg'
	close_sound_powered = 'sound/machines/door/WideClose.ogg'
	icon = 'icons/obj/doors/double/door.dmi'
	fill_file = 'icons/obj/doors/double/fill_steel.dmi'
	color_file = 'icons/obj/doors/double/color.dmi'
	color_fill_file = 'icons/obj/doors/double/fill_color.dmi'
	glass_file = 'icons/obj/doors/double/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/double/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/double/lights_deny.dmi'
	lights_file = 'icons/obj/doors/double/lights_green.dmi'
	emag_file = 'icons/obj/doors/double/emag.dmi'
	stripe_file = 'icons/obj/doors/double/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/double/fill_stripe.dmi'

/obj/machinery/door/airlock/multi_tile/Initialize(mapload)
	. = ..()
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/airlock/multi_tile/LateInitialize()
	SetBounds()
	create_fillers()

/obj/machinery/door/airlock/multi_tile/Destroy()
	QDEL_NULL(filler1)
	QDEL_NULL(filler2)
	return ..()

/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/open()
	. = ..()

	if(filler1)
		filler1.set_opacity(opacity)
		if(filler2)
			filler2.set_opacity(opacity)

	return .

/obj/machinery/door/airlock/multi_tile/close()
	. = ..()

	if(filler1)
		filler1.set_opacity(opacity)
		if(filler2)
			filler2.set_opacity(opacity)

	return .

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = world.icon_size
			bound_height = width * world.icon_size
		else
			bound_width = width * world.icon_size
			bound_height = world.icon_size

/obj/machinery/door/airlock/multi_tile/proc/create_fillers()
	var/filler2_loc
	if(dir == SOUTH)
		filler2_loc = get_step(src,EAST)
	else if(dir == WEST)
		filler2_loc = get_step(src,NORTH)
	filler1 = new(get_turf(src.loc))
	filler2 = new(get_turf(filler2_loc))
	filler1.density = 0
	filler2.density = 0
	filler1.set_opacity(opacity)
	filler2.set_opacity(opacity)
	QUEUE_SMOOTH(filler2)
	QUEUE_SMOOTH_NEIGHBORS(filler2) //do blending for filler 2, which represents the far side of the door. blending already happens for the airlock itself.
	SetBounds()

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile
	window_color = GLASS_COLOR


/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/structure/filler_object
	name = ""
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = ""
	density = 1
	anchored = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS+SMOOTH_GROUP_AIRLOCK+SMOOTH_GROUP_WINDOW_FULLTILE+SMOOTH_GROUP_WALLS)

/obj/structure/filler_object/Initialize(mapload)
	. = ..()
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/machinery/door/airlock/multi_tile/metal/mait
	//req_one_access = list(ACCESS_ENGINEERING_MAINT) //VOREStaiton Edit - Maintenance is open access
