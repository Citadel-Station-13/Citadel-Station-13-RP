//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
var/global/list/rad_collectors = list()

/obj/machinery/power/rad_collector
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and phoron to produce power."
	icon = 'icons/obj/machines/rad_collector.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(access_engine_equip)
//	use_power = FALSE
	var/obj/item/tank/phoron/P = null
	var/last_power = 0
	var/last_power_new = 0
	var/active = FALSE
	var/locked = FALSE
	var/drainratio = 1

	var/health = 100
	var/max_safe_temp = 1000 + T0C
	var/melted

	var/last_rads
	var/max_rads = 250 // rad collector will reach max power output at this value, and break at twice this value
	var/max_power = 5e5
	var/pulse_coeff = 20
	var/end_time = 0
	var/alert_delay = 10 SECONDS

/obj/machinery/power/rad_collector/Initialize(mapload)
	. = ..()
	rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	rad_collectors -= src
	return ..()

/obj/machinery/power/rad_collector/process(delta_time)
	if((stat & BROKEN) || melted)
		return
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/our_turfs_air = T.return_air()
		if(our_turfs_air.temperature > max_safe_temp)
			health -= ((our_turfs_air.temperature - max_safe_temp) / 10)
			if(health <= 0)
				collector_break()

	// So that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0
	var/rads = SSradiation.get_rads_at_turf(get_turf(src))

	if(P && active)
		if(rads > max_rads*2)
			collector_break()
		if(rads)
			if(rads > max_rads)
				if(world.time > end_time)
					end_time = world.time + alert_delay
					visible_message("\icon[src] \the [src] beeps loudly as the radiation reaches dangerous levels, indicating imminent damage.")
					playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
			receive_pulse(12.5*(rads/max_rads)/(0.3+(rads/max_rads)))

	if(P)
		if(P.air_contents.gas[/datum/gas/phoron] == 0)
			investigate_log("<font color='red'>out of fuel</font>.","singulo")
			eject()
		else
			P.air_contents.adjust_gas(GAS_PHORON, -0.01*drainratio*min(rads,max_rads)/max_rads) // Fuel cost increases linearly with incoming radiation
	return


/obj/machinery/power/rad_collector/attack_hand(mob/user as mob)
	if(anchored)
		if((stat & BROKEN) || melted)
			to_chat(user, "<span class='warning'>The [src] is completely destroyed!</span>")
		if(!src.locked)
			toggle_power()
			user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
			"You turn the [src.name] [active? "on":"off"].")
			investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [user.key]. [P?"Fuel: [round(P.air_contents.gas[/datum/gas/phoron]/0.29)]%":"<font color='red'>It is empty</font>"].","singulo")
			return
		else
			to_chat(user, "<font color='red'>The controls are locked!</font>")
			return


/obj/machinery/power/rad_collector/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tank/phoron))
		if(!src.anchored)
			to_chat(user, "<font color='red'>The [src] needs to be secured to the floor first.</font>")
			return TRUE
		if(src.P)
			to_chat(user, "<font color='red'>There's already a phoron tank loaded.</font>")
			return TRUE
		user.drop_item()
		src.P = W
		W.loc = src
		update_icons()
		return TRUE
	else if(W.is_crowbar())
		if(P && !src.locked)
			eject()
			return TRUE
	else if(W.is_wrench())
		if(P)
			to_chat(user, "<font color=#4F49AF>Remove the phoron tank first.</font>")
			return TRUE
		playsound(src, W.usesound, 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet.")
		if(anchored && !(stat & BROKEN))
			connect_to_network()
		else
			disconnect_from_network()
		return TRUE
	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if (src.allowed(user))
			if(active)
				src.locked = !src.locked
				to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
			else
				src.locked = FALSE //just in case it somehow gets locked
				to_chat(user, "<font color='red'>The controls can only be locked when the [src] is active.</font>")
		else
			to_chat(user, "<font color='red'>Access denied!</font>")
		return TRUE
	return ..()

/obj/machinery/power/rad_collector/examine(mob/user)
	if(..(user, 3) && !(stat & BROKEN))
		to_chat(user, "The meter indicates that \the [src] is collecting [last_power] W.")
		return TRUE

/obj/machinery/power/rad_collector/ex_act(severity)
	switch(severity)
		if(2, 3)
			eject()
	return ..()

/obj/machinery/power/rad_collector/proc/eject()
	locked = 0
	var/obj/item/tank/phoron/Z = src.P
	if (!Z)
		return
	Z.loc = get_turf(src)
	Z.layer = initial(Z.layer)
	src.P = null
	if(active)
		toggle_power()
	else
		update_icons()

/obj/machinery/power/rad_collector/proc/collector_break()
	if(P && P.air_contents)
		var/turf/T = get_turf(src)
		if(T)
			T.assume_air(P.air_contents)
			audible_message(SPAN_DANGER("\The [P] detonates, sending shrapnel flying!"))
			fragmentate(T, 2, 4, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 3, /obj/item/projectile/bullet/pellet/fragment/tank = 1))
			explosion(T, -1, -1, 0)
			QDEL_NULL(P)
	disconnect_from_network()
	stat |= BROKEN
	melted = TRUE
	anchored = FALSE
	active = FALSE
	desc += " This one is destroyed beyond repair."
	update_icon()

/obj/machinery/power/rad_collector/proc/receive_pulse(var/pulse_strength)
	if(P && active)
		var/power_produced = 0
		power_produced = min(100*P.air_contents.gas[GAS_PHORON]*pulse_strength*pulse_coeff,max_power)
		add_avail(power_produced)
		last_power_new = power_produced
		return
	return

/obj/machinery/power/rad_collector/proc/update_icons()
	overlays.Cut()
	underlays.Cut()

	if(P)
		overlays += image(icon, "ptank")
		underlays += image(icon, "ca_filling")
	underlays += image(icon, "ca_inside")
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		var/rad_power = round(min(100 * last_rads / max_rads, 100), 20)
		overlays += image(icon, "rads_[rad_power]")
		overlays += image(icon, "on")

/obj/machinery/power/rad_collector/proc/toggle_power()
	active = !active
	if(melted)
		icon_state = "ca_melt"
	else if(active)
		icon_state = "ca_on"
		flick("ca_active", src)
	else
		icon_state = "ca"
		flick("ca_deactive", src)
	update_icons()
	return
