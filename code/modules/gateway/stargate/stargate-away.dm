/**
 * Preset for away destinations for the stargate system
 */

/obj/machinery/gateway/centeraway
	density = 1
	icon_state = "offcenter"
	use_power = USE_POWER_OFF
	var/calibrated = 1
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = 0
	var/obj/machinery/gateway/centeraway/stationgate = null


/obj/machinery/gateway/centeraway/Initialize(mapload)
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)
	. = ..()
	density = 1


/obj/machinery/gateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centeraway/proc/detect()
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


/obj/machinery/gateway/centeraway/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!stationgate || !calibrated)
		to_chat(user, SPAN_NOTICE("Error: No destination found. Please calibrate gateway."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centeraway/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


/obj/machinery/gateway/centeraway/Bumped(atom/movable/M as mob|obj)
	if(!ready)	return
	if(!active)	return
	if(istype(M, /mob/living/carbon))
		for(var/obj/item/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, "<font color='black'>The station gate has detected your exile implant and is blocking your entry.</font>")
				return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.setDir(SOUTH)
	SEND_SOUND(M, sound('sound/effects/phasein.ogg'))
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)


/obj/machinery/gateway/centeraway/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool))
		if(calibrated && stationgate)
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return
		else
			stationgate = locate(/obj/machinery/gateway/centerstation)
			if(!stationgate)
				to_chat(user, "<span class='notice'>Error: Recalibration failed. No destination found... That can't be good.</span>")
				return
			else
				to_chat(user, "<font color=#4F49AF><b>Recalibration successful!</b>:</font><font color='black'> This gate's systems have been fine tuned. Travel to this gate will now be on target.</font>")
				calibrated = 1
				return

/obj/machinery/gateway/centeraway/attack_ghost(mob/user)
	. = ..()
	if(stationgate)
		user.forceMove(stationgate.loc)
	else
		to_chat(user, "[src] has no destination.")
