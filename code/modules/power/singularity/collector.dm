//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
var/global/list/rad_collectors = list()

/obj/machinery/power/rad_collector
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and phoron to produce power."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(access_engine_equip)
//	use_power = 0
	var/obj/item/tank/phoron/P = null
	var/last_power = 0
	var/last_power_new = 0
	var/active = 0
	var/locked = 0
	var/drainratio = 1

/obj/machinery/power/rad_collector/Initialize(mapload)
	. = ..()
	rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	rad_collectors -= src
	return ..()

/obj/machinery/power/rad_collector/process(delta_time)
	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0


	if(P && active)
		var/rads = SSradiation.get_rads_at_turf(get_turf(src))
		if(rads)
			receive_pulse(rads * 5) //Maths is hard

	if(P)
		if(P.air_contents.gas[/datum/gas/phoron] == 0)
			investigate_log("<font color='red'>out of fuel</font>.","singulo")
			eject()
		else
			P.air_contents.adjust_gas(/datum/gas/phoron, -0.001*drainratio)

/obj/machinery/power/rad_collector/attack_hand(mob/user as mob)
	if(anchored)
		if(!src.locked)
			toggle_power()
			user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
			"You turn the [src.name] [active? "on":"off"].")
			investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [user.key]. [P?"Fuel: [round(P.air_contents.gas[/datum/gas/phoron]/0.29)]%":"<font color='red'>It is empty</font>"].","singulo")
		else
			to_chat(user, "<font color='red'>The controls are locked!</font>")

/obj/machinery/power/rad_collector/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tank/phoron))
		if(!src.anchored)
			to_chat(user, "<font color='red'>The [src] needs to be secured to the floor first.</font>")
			return 1
		if(src.P)
			to_chat(user, "<font color='red'>There's already a phoron tank loaded.</font>")
			return 1
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		src.P = W
		update_icons()
		return 1
	else if(W.is_crowbar())
		if(P && !src.locked)
			eject()
			return 1
	else if(W.is_wrench())
		if(P)
			to_chat(user, "<font color=#4F49AF>Remove the phoron tank first.</font>")
			return 1
		playsound(src, W.tool_sound, 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet.")
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
		return 1
	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if (src.allowed(user))
			if(active)
				src.locked = !src.locked
				to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
			else
				src.locked = 0 //just in case it somehow gets locked
				to_chat(user, "<font color='red'>The controls can only be locked when the [src] is active.</font>")
		else
			to_chat(user, "<font color='red'>Access denied!</font>")
		return 1
	return ..()

/obj/machinery/power/rad_collector/examine(mob/user)
	. = ..()
	. += "The meter indicates that \the [src] is collecting [last_power] W."

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

/obj/machinery/power/rad_collector/proc/receive_pulse(var/pulse_strength)
	if(P && active)
		var/power_produced = 0
		power_produced = (min(P.air_contents.gas[/datum/gas/phoron], 1000)) * pulse_strength * 20
		add_avail(power_produced * 0.001)
		last_power_new = power_produced

/obj/machinery/power/rad_collector/proc/update_icons()
	overlays.Cut()
	if(P)
		overlays += image('icons/obj/singularity.dmi', "ptank")
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(active)
		overlays += image('icons/obj/singularity.dmi', "on")

/obj/machinery/power/rad_collector/proc/toggle_power()
	active = !active
	if(active)
		icon_state = "ca_on"
		flick("ca_active", src)
	else
		icon_state = "ca"
		flick("ca_deactive", src)
	density = active
	update_icons()

/obj/machinery/power/rad_collector/MouseDroppedOnLegacy(mob/living/O, mob/living/user)
	. = ..()
	if(!istype(O))
		return 0 //not a mob
	if(user.incapacitated())
		return 0 //user shouldn't be doing things
	if(O.anchored)
		return 0 //mob is anchored???
	if(get_dist(user, src) > 1 || get_dist(user, O) > 1)
		return 0 //doesn't use adjacent() to allow for non-GLOB.cardinal (fuck my life)
	if(!ishuman(user) && !isrobot(user))
		return 0 //not a borg or human

	if(O.has_buckled_mobs())
		to_chat(user, "<span class='warning'>\The [O] has other entities attached to it. Remove them first.</span>")
		return

	if(O == user)
		usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	else
		visible_message("[user] puts [O] onto \the [src].")


	if(do_after(O, 3 SECOND, src))
		O.forceMove(src.loc)

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")
