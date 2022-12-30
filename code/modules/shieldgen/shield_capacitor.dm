
//---------- shield capacitor
//pulls energy out of a power net and charges an adjacent generator

/obj/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "A machine that charges a shield generator."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "capacitor"
	var/active = 0
	density = 1
	req_one_access = list(access_engine,access_captain,access_security)
	var/stored_charge = 0	//not to be confused with power cell charge, this is in Joules
	var/last_stored_charge = 0
	var/time_since_fail = 100
	var/max_charge = 8e6	//8 MJ
	var/max_charge_rate = 400000	//400 kW
	var/locked = 0
	use_power = USE_POWER_OFF //doesn't use APC power
	var/charge_rate = 100000	//100 kW
	var/obj/machinery/shield_gen/owned_gen

/obj/machinery/shield_capacitor/advanced
	name = "advanced shield capacitor"
	desc = "A machine that charges a shield generator.  This version can store, input, and output more electricity."
	max_charge = 12e6
	max_charge_rate = 600000

/obj/machinery/shield_capacitor/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		src.locked = !src.locked
		to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
		. = 1
		updateDialog()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()

/obj/machinery/shield_capacitor/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(emagged)
			to_chat(user, "<span class='warning'>The lock seems to be broken.</span>")
			return
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
	else if(W.is_wrench())
		src.anchored = !src.anchored
		playsound(src, W.tool_sound, 75, 1)
		src.visible_message("<font color=#4F49AF>[icon2html(thing = src, target = world)] [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by [user].</font>")

		if(anchored)
			spawn(0)
				for(var/obj/machinery/shield_gen/gen in range(1, src))
					if(get_dir(src, gen) == src.dir)
						owned_gen = gen
						owned_gen.capacitors |= src
						owned_gen.updateDialog()
		else
			if(owned_gen && (src in owned_gen.capacitors))
				owned_gen.capacitors -= src
			owned_gen = null
	else
		..()

/obj/machinery/shield_capacitor/attack_hand(mob/user)
	if(machine_stat & (BROKEN))
		return
	interact(user)

/obj/machinery/shield_capacitor/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (machine_stat & (BROKEN)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=shield_capacitor")
			return
	var/t = "<B>Shield Capacitor Control Console</B><br><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "This capacitor is: [active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" ] <a href='?src=\ref[src];toggle=1'>[active ? "\[Deactivate\]" : "\[Activate\]"]</a><br>"
		t += "Capacitor Status: [time_since_fail > 2 ? "<font color=green>OK.</font>" : "<font color=red>Discharging!</font>"]<br>"
		t += "Stored Energy: [format_SI(stored_charge, "J")] ([100 * round(stored_charge/max_charge, 0.01)]%)<br>"
		t += "Charge Rate: \
		<a href='?src=\ref[src];charge_rate=-100000'>\[----\]</a> \
		<a href='?src=\ref[src];charge_rate=-10000'>\[---\]</a> \
		<a href='?src=\ref[src];charge_rate=-1000'>\[--\]</a> \
		<a href='?src=\ref[src];charge_rate=-100'>\[-\]</a>[format_SI(charge_rate, "W")]\
		<a href='?src=\ref[src];charge_rate=100'>\[+\]</a> \
		<a href='?src=\ref[src];charge_rate=1000'>\[++\]</a> \
		<a href='?src=\ref[src];charge_rate=10000'>\[+++\]</a> \
		<a href='?src=\ref[src];charge_rate=100000'>\[++++\]</a><br>"
	t += "<hr>"
	t += "<A href='?src=\ref[src]'>Refresh</A> "
	t += "<A href='?src=\ref[src];close=1'>Close</A><BR>"

	user << browse(t, "window=shield_capacitor;size=500x400")
	user.set_machine(src)

/obj/machinery/shield_capacitor/process(delta_time)
	if (!anchored)
		active = 0

	//see if we can connect to a power net.
	var/datum/powernet/PN
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if (C)
		PN = C.powernet

	if (PN)
		var/power_draw = clamp(max_charge - stored_charge, 0, charge_rate) //what we are trying to draw
		power_draw = PN.draw_power(power_draw * 0.001) * 1000 //what we actually get
		stored_charge += power_draw

	time_since_fail++
	if(stored_charge < last_stored_charge)
		time_since_fail = 0 //losing charge faster than we can draw from PN
	last_stored_charge = stored_charge

/obj/machinery/shield_capacitor/Topic(href, href_list[])
	..()
	if( href_list["close"] )
		usr << browse(null, "window=shield_capacitor")
		usr.unset_machine()
		return
	if( href_list["toggle"] )
		if(!active && !anchored)
			to_chat(usr, "<font color='red'>The [src] needs to be firmly secured to the floor first.</font>")
			return
		active = !active
	if( href_list["charge_rate"] )
		charge_rate = between(10000, charge_rate + text2num(href_list["charge_rate"]), max_charge_rate)

	updateDialog()

/obj/machinery/shield_capacitor/power_change()
	if(machine_stat & BROKEN)
		icon_state = "broke"
	else
		..()

/obj/machinery/shield_capacitor/verb/rotate_clockwise()
	set name = "Rotate Capacitor Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		to_chat(usr, "It is fastened to the floor!")
		return

	src.setDir(turn(src.dir, 270))
	return
