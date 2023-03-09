// todo: rework
/obj/machinery/power/rad_collector
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and phoron to produce power."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINEERING_ENGINE)
//	use_power = 0
	var/obj/item/tank/phoron/P = null
	/// stored power in kilojoules
	var/stored_power = 0
	/// mols of phoron to consume per kj of power
	/**
	 * (1013)(70)/((8.314)(293.15)) --> ~30 mol phoron in a full takn
	 * assuming someone's tryharding, 5000 rad/second --> 5 * RAD_MISC_COLLECTOR_MULTIPLIER MW per collector
	 * we want it to drain in x hours.
	 * let rads be R, let hours be H, let mols be M
	 * assuming ssradiation doesn't lag the fuck out,
	 * factor = 30 / ((60 * 60 * H) * 5000 * RAD_MISC_COLLECTOR_MULTIPLIER)
	 *
	 * let's set it to 1 hours for such a tryhard setup for now; cooling phoron is now needed for longetivity :)
	 */
	var/gas_usage_factor = 30 / ((60 * 60 * 1) * 5000 * RAD_MISC_COLLECTOR_MULTIPLIER)
	/// last KW
	var/last_output
	/// rad insulation when on
	var/rad_insulation_active = RAD_INSULATION_HIGH
	/// rad insulation when off
	var/rad_insulation_inactive = RAD_INSULATION_NONE
	/// amount of rads to toss
	var/flat_loss = RAD_MISC_COLLECTOR_FLAT_LOSS
	/// kj per rad
	var/efficiency = RAD_MISC_COLLECTOR_MULTIPLIER
	/// minimum kj to try to push
	var/minimum_push = 10
	/// % of stored power to push per process
	var/push_ratio = 0.05
	var/active = 0
	var/locked = 0

/obj/machinery/power/rad_collector/Initialize(mapload)
	. = ..()
	rad_insulation = active? rad_insulation_active : rad_insulation_inactive

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
	if(active)
		. += "<span class='notice'>[src]'s display states that it has stored <b>[render_power(stored_power, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_JOULE)]</b>, and is currently outputting [render_power(last_output, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_WATT)].</span>"
	else
		. += "<span class='notice'><b>[src]'s display displays the words:</b> \"Power production mode. Please insert <b>Phoron</b>.\"</span>"

/obj/machinery/power/rad_collector/legacy_ex_act(severity)
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

// todo: rework
/obj/machinery/power/rad_collector/rad_act(strength, datum/radiation_wave/wave)
	. = ..()
	var/power_produced = max(0, (strength - flat_loss) * efficiency)
	var/gas_needed = power_produced * gas_usage_factor
	if(!power_produced || !P?.air_contents.gas[/datum/gas/phoron])
		return
	P.air_contents.adjust_gas(/datum/gas/phoron, -gas_needed)
	if(!P.air_contents.gas[/datum/gas/phoron])
		investigate_log("ran out of gas", INVESTIGATE_SINGULO)
		eject()
	stored_power += power_produced

/obj/machinery/power/rad_collector/process(delta_time)
	if(!stored_power)
		last_output = 0
		return
	var/attempt = clamp(max(minimum_push, stored_power * push_ratio), 0, stored_power)
	// if you don't have a powernet you still lose the poewr
	stored_power -= attempt
	//? kj to kw
	add_avail((last_output = (attempt / delta_time)))

/obj/machinery/power/rad_collector/proc/update_icons()
	cut_overlays()
	var/list/overlays_to_add = list()
	if(P)
		overlays_to_add += image('icons/obj/singularity.dmi', "ptank")

	if(!(machine_stat & (NOPOWER|BROKEN)) && active)
		overlays_to_add += image('icons/obj/singularity.dmi', "on")

	add_overlay(overlays_to_add)

	return


/obj/machinery/power/rad_collector/proc/toggle_power()
	active = !active
	rad_insulation = active? rad_insulation_active : rad_insulation_inactive
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
