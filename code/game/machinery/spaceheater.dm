/obj/machinery/space_heater
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set the station on fire."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	anchored = FALSE
	density = TRUE

	var/cell_type = /obj/item/cell/basic/tier_1/medium
	var/cell_accept = CELL_TYPE_MEDIUM | CELL_TYPE_LARGE

	var/on = FALSE
	var/set_temperature = T0C + 20 //K
	var/heating_power = 40000

/obj/machinery/space_heater/Initialize(mapload, newdir)
	init_cell_slot_easy_machine(cell_type, cell_accept)
	. = ..()
	update_icon()

/obj/machinery/space_heater/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot, silent, datum/event_args/actor/actor)
	return panel_open && ..()

/obj/machinery/space_heater/update_icon()
	cut_overlays()
	. = ..()
	icon_state = "sheater[on]"
	if(panel_open)
		add_overlay("sheater-open")
	if(on)
		set_light(3, 3, "#FFCC00")
	else
		set_light(0)

/obj/machinery/space_heater/examine(mob/user, dist)
	. = ..()
	. += "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"]."
	if(panel_open)
		. += "The power cell is [obj_cell_slot?.cell ? "installed" : "missing"]."
	else
		. += "The charge meter reads [obj_cell_slot?.cell ? round(obj_cell_slot.cell.percent(),1) : 0]%"

/obj/machinery/space_heater/powered()
	return obj_cell_slot?.cell?.charge

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		panel_open = !panel_open
		playsound(src, I.tool_sound, 50, 1)
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon()
		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()

/obj/machinery/space_heater/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	interact(user)

/obj/machinery/space_heater/interact(mob/user as mob)
	if(panel_open)

		var/dat
		dat = "Power cell: "
		if(obj_cell_slot?.cell)
			dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=cellinstall'>Removed</A><BR>"

		dat += "Power Level: [obj_cell_slot?.cell ? round(obj_cell_slot.cell.percent(),1) : 0]%<BR><BR>"

		dat += "Set Temperature: "

		dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

		dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
		dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

		user.set_machine(src)
		user << browse("<HEAD><TITLE>Space Heater Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=spaceheater")
		onclose(user, "spaceheater")
	else
		on = !on
		user.visible_message("<span class='notice'>[user] switches [on ? "on" : "off"] the [src].</span>","<span class='notice'>You switch [on ? "on" : "off"] the [src].</span>")
		update_icon()


/obj/machinery/space_heater/Topic(href, href_list)
	if(usr.stat)
		return
	if((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		switch(href_list["op"])

			if("temp")
				var/value = text2num(href_list["val"])

				// limit to 0-90 degC
				set_temperature = clamp(set_temperature + value, T0C, T0C + 90)

			if("cellremove")
				if(panel_open && obj_cell_slot?.cell)
					usr.visible_message(
						"<span class='notice'>\The [usr] removes \the [obj_cell_slot.cell] from \the [src].</span>",
						"<span class='notice'>You remove \the [obj_cell_slot.cell] from \the [src].</span>",
					)
					var/obj/item/cell/removed = obj_cell_slot.remove_cell()
					usr.put_in_hands_or_drop(removed)
					removed.add_fingerprint(usr)
					power_change()


			if("cellinstall")
				if(panel_open && obj_cell_slot && !obj_cell_slot?.cell)
					var/obj/item/cell/C = usr.get_active_held_item()
					if(istype(C))
						if(!usr.attempt_insert_item_for_installation(C, src))
							return
						obj_cell_slot.insert_cell(C)
						C.add_fingerprint(usr)
						power_change()
						usr.visible_message("<span class='notice'>[usr] inserts \the [C] into \the [src].</span>", "<span class='notice'>You insert \the [C] into \the [src].</span>")

		updateDialog()
	else
		usr << browse(null, "window=spaceheater")
		usr.unset_machine()

/obj/machinery/space_heater/process(delta_time)
	if(on)
		if(obj_cell_slot?.cell?.charge)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) > 0.1)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					if(heat_transfer > 0)	//heating air
						heat_transfer = min(heat_transfer, heating_power) //limit by the power rating of the heater

						removed.adjust_thermal_energy(heat_transfer)
						obj_cell_slot.cell.use(DYNAMIC_W_TO_CELL_UNITS(heat_transfer * SPACE_HEATER_CHEAT_FACTOR, 1))
					else	//cooling air
						heat_transfer = abs(heat_transfer)

						//Assume the heat is being pumped into the hull which is fixed at 20 C
						var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
						heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

						heat_transfer = removed.adjust_thermal_energy(-heat_transfer)	//get the actual heat transfer

						var/power_used = abs(heat_transfer)/cop
						obj_cell_slot.cell.use(DYNAMIC_W_TO_CELL_UNITS(power_used * SPACE_HEATER_CHEAT_FACTOR, 1))

				env.merge(removed)
		else
			on = 0
			power_change()
			update_icon()
