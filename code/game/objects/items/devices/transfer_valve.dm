/obj/item/transfer_valve
	name = "tank transfer valve"
	desc = "Regulates the transfer of air between two tanks."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "valve_1"
	base_icon_state = "valve"
	//inhand_icon_state = "ttv"
	//lefthand_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
	//righthand_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY

	var/obj/item/tank/tank_one
	var/obj/item/tank/tank_two
	var/obj/item/assembly/attached_device
	var/mob/attacher = null
	var/valve_open = FALSE
	var/toggle = TRUE

/obj/item/transfer_valve/Destroy()
	attached_device = null
	return ..()

/obj/item/transfer_valve/attackby(obj/item/item, mob/user, params)
	var/turf/location = get_turf(src) // For admin logs
	if(istype(item, /obj/item/tank))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(tank_one && tank_two)
			to_chat(user, SPAN_WARNING("There are already two tanks attached, remove one first!"))
			return

		if(!tank_one)
			if(!user.attempt_insert_item_for_installation(item, src))
				return
			tank_one = item
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer valve."))

		else if(!tank_two)
			if(!user.attempt_insert_item_for_installation(item, src))
				return
			tank_two = item
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer valve."))

			message_admins("[key_name_admin(user)] attached both tanks to a transfer valve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
			log_game("[key_name_admin(user)] attached both tanks to a transfer valve.")

		update_appearance()
		SStgui.update_uis(src) // update all UIs attached to src
//TODO: Have this take an assemblyholder
	else if(isassembly(item))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/assembly/A = item
		if(A.secured)
			to_chat(user, SPAN_NOTICE("The device is secured."))
			return
		if(attached_device)
			to_chat(user, SPAN_WARNING("There is already a device attached to the valve, remove it first!"))
			return
		if(!user.attempt_insert_item_for_installation(item, src))
			return
		attached_device = A
		to_chat(user, SPAN_NOTICE("You attach the [item] to the valve controls and secure it."))
		//A.on_attach()
		A.holder = src
		A.toggle_secure() //This calls update_appearance(), which calls update_appearance() on the holder (i.e. the bomb).

		bombers += "[key_name(user)] attached a [item] to a transfer valve."
		message_admins("[key_name_admin(user)] attached a [item] to a transfer valve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
		log_game("[key_name_admin(user)] attached a [item] to a transfer valve.")
		attacher = user
		SStgui.update_uis(src) //Update all UIs attached to src
	return ..()

/obj/item/transfer_valve/attack_self(mob/user)
	ui_interact(user)

/obj/item/transfer_valve/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/transfer_valve/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TransferValve", name) // 460, 320
		ui.open()

/obj/item/transfer_valve/ui_data(mob/user)
	var/list/data = list()
	data["tank_one"] = tank_one ? tank_one.name : null
	data["tank_two"] = tank_two ? tank_two.name : null
	data["attached_device"] = attached_device ? attached_device.name : null
	data["valve"] = valve_open
	return data

/obj/item/transfer_valve/ui_act(action, params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("tankone")
			remove_tank(tank_one)
		if("tanktwo")
			remove_tank(tank_two)
		if("toggle")
			toggle_valve()
		if("device")
			if(attached_device)
				attached_device.attack_self(usr)
		if("remove_device")
			if(attached_device)
				attached_device.forceMove(get_turf(src))
				attached_device.holder = null
				attached_device = null
				update_appearance()
		else
			. = FALSE
	if(.)
		update_appearance()
		add_fingerprint(usr)

/obj/item/transfer_valve/proc/process_activation(var/obj/item/D)
	if(toggle)
		toggle = FALSE
		toggle_valve()
		VARSET_IN(src, toggle, TRUE, 5 SECONDS)

///obj/item/transfer_valve/proc/toggle_off()
//	toggle = TRUE

/obj/item/transfer_valve/update_icon_state()
	icon_state = "[base_icon_state][(!tank_one && !tank_two && !attached_device) ? "_1" : null]"
	return ..()

/obj/item/transfer_valve/update_overlays()
	. = ..()
	if(tank_one)
		. += "[tank_one.icon_state]"

	if(!tank_two)
		underlays = null
	else
		var/mutable_appearance/J = mutable_appearance(icon, icon_state = "[tank_two.icon_state]")
		var/matrix/T = matrix()
		T.Translate(-13, 0)
		J.transform = T
		underlays = list(J)

	if(!attached_device)
		return

	. += "device"
	if(!istype(attached_device, /obj/item/assembly/infra))
		return
	var/obj/item/assembly/infra/sensor = attached_device
	if(sensor.on && sensor.visible)
		. += "proxy_beam"

/obj/item/transfer_valve/proc/remove_tank(obj/item/tank/T)
	if(tank_one == T)
		split_gases()
		tank_one = null
	else if(tank_two == T)
		split_gases()
		tank_two = null
	else
		return

	T.loc = get_turf(src)
	update_appearance()

/obj/item/transfer_valve/proc/merge_gases()
	if(valve_open)
		return
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_one.air_contents.remove_ratio(1)
	tank_two.air_contents.merge(temp)
	valve_open = 1

/obj/item/transfer_valve/proc/split_gases()
	if(!valve_open)
		return

	valve_open = 0

	if(QDELETED(tank_one) || QDELETED(tank_two))
		return

	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_two.air_contents.remove_ratio(ratio1)
	tank_one.air_contents.merge(temp)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume


	/*
	Exadv1: I know this isn't how it's going to work, but this was just to check
	it explodes properly when it gets a signal (and it does).
	*/

/obj/item/transfer_valve/proc/toggle_valve()
	if(!valve_open && (tank_one && tank_two))
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)

		var/attacher_name = ""
		if(!attacher)
			attacher_name = "Unknown"
		else
			attacher_name = "[attacher.name]([attacher.ckey])"

		var/log_str = "Bomb valve opened in <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name]</a> "
		log_str += "with [attached_device ? attached_device : "no device"] attacher: [attacher_name]"

		if(attacher)
			log_str += "(<A HREF='?_src_=holder;adminmoreinfo=\ref[attacher]'>?</A>)"

		var/mob/mob = get_mob_by_key(src.fingerprintslast)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[mob]'>?</A>)"

		log_str += " Last touched by: [src.fingerprintslast][last_touch_info]"
		bombers += log_str
		message_admins(log_str, 0, 1)
		log_game(log_str)
		merge_gases()

	else if(valve_open==1 && (tank_one && tank_two))
		split_gases()

	update_appearance()

// this doesn't do anything but the timer etc. expects it to be here
// eventually maybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/transfer_valve/proc/c_state()
	return
