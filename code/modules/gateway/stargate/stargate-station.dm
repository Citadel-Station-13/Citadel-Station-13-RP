/**
 * Preset for station-side stargate
 */
//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = 1
	icon_state = "offcenter"
	use_power = USE_POWER_IDLE

	//warping vars
	var/list/linked = list()
	var/ready = 0				//have we got all the parts for a gateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/Initialize(mapload)
	update_icon()
	wait = world.time + config_legacy.gateway_delay	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)
	. = ..()
	density = TRUE

/obj/machinery/gateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centerstation/process(delta_time)
	if(machine_stat & (NOPOWER))
		if(active) toggleoff()
		return

	if(active)
		use_power(5000)


/obj/machinery/gateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOB.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centerstation/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!powered())		return
	if(!awaygate)
		to_chat(user, "<span class='notice'>Error: No destination found. Please program gateway.</span>")
		return
	if(world.time < wait)
		to_chat(user, "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes.</span>")
		return
	if(!awaygate.calibrated && !LAZYLEN(awaydestinations))
		to_chat(user, SPAN_NOTICE("Error: Destination gate uncalibrated. Gateway unsafe to use without far-end calibration update."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centerstation/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/M as mob|obj)
	if(!ready)		return
	if(!active)		return
	if(!awaygate)	return

	use_power(5000)
	SEND_SOUND(M, sound('sound/effects/phasein.ogg'))
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)
	if(awaygate.calibrated)
		M.forceMove(get_step(awaygate.loc, SOUTH))
		M.setDir(SOUTH)
		return
	else
		var/obj/landmark/dest = pick(awaydestinations)
		if(dest)
			M.forceMove(dest.loc)
			M.setDir(SOUTH)
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool))
		if(!awaygate)
			awaygate = locate(/obj/machinery/gateway/centeraway)
			if(!awaygate) // We still can't find the damn thing because there is no destination.
				to_chat(user, "<span class='notice'>Error: Programming failed. No destination found.</span>")
				return
			to_chat(user, "<span class='notice'><b>Startup programming successful!</b></span>: A destination in another point of space and time has been detected.")
		else
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return

/obj/machinery/gateway/centerstation/proc/admin_setup(/mob/usr)
	detect()

	awaygate = locate(/obj/machinery/gateway/centeraway)
	if(!awaygate) // We still can't find the damn thing because there is no destination.
		to_chat(usr, "Unable to locate awaygate (type: /obj/machinery/gateway/centeraway)")
		return

	awaygate.stationgate = src
	awaygate.detect()

	wait = 0

	toggleon(usr)
	awaygate.toggleon(usr)

/obj/machinery/gateway/centerstation/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_SETUP_GATEWAY, "Setup Gateway")

/obj/machinery/gateway/centerstation/vv_do_topic(list/href_list)
	if(href_list[VV_HK_SETUP_GATEWAY] && check_rights(R_FUN))
		admin_setup(usr)
	. = ..()

/obj/machinery/gateway/centerstation/attack_ghost(mob/user)
	. = ..()
	if(awaygate)
		user.forceMove(awaygate.loc)
	else
		to_chat(user, "[src] has no destination.")
