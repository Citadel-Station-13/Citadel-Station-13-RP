/obj/item/suit_cooling_unit
	name = "portable suit cooling unit"
	desc = "A portable heat sink and liquid cooled radiator that can be hooked up to a space suit's existing temperature controls to provide industrial levels of cooling."
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/obj/device.dmi'
	icon_state = "suitcooler0"
	slot_flags = SLOT_BACK

	//copied from tank.dm
	damage_force = 5.0
	throw_force = 10.0
	throw_speed = 1
	throw_range = 4
	item_action_name = "Toggle Heatsink"
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR

	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 3500)
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2)

	var/cell_type = /obj/item/cell/basic/tier_1/medium
	var/cell_accept = CELL_TYPE_MEDIUM | CELL_TYPE_SMALL | CELL_TYPE_WEAPON
	var/cell_locked = FALSE

	var/on = 0				//is it turned on?
	var/cover_open = 0		//is the cover open?
	var/max_cooling = 15				// in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 3			// charge per second at max_cooling
	var/thermostat = T20C

	//TODO: make it heat up the surroundings when not in space

/obj/item/suit_cooling_unit/Initialize(mapload)
	var/datum/object_system/cell_slot/slot = init_cell_slot(cell_type, cell_accept)
	slot.remove_yank_offhand = TRUE
	slot.remove_yank_context = TRUE
	return ..()

/obj/item/suit_cooling_unit/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return cover_open && !cell_locked

/obj/item/suit_cooling_unit/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	toggle(usr)

/obj/item/suit_cooling_unit/process()
	if (!on || !obj_cell_slot?.cell)
		return PROCESS_KILL

	if (!ismob(loc))
		return

	if (!attached_to_suit(loc))		//make sure they have a suit and we are attached to it
		return

	var/mob/living/carbon/human/H = loc

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	var/efficiency = 1 - H.get_pressure_weakness(environment.return_pressure())	// You need to have a good seal for effective cooling
	var/temp_adj = 0										// How much the unit cools you. Adjusted later on.
	var/env_temp = get_environment_temperature()			// This won't save you from a fire
	var/thermal_protection = H.get_heat_protection(env_temp)	// ... unless you've got a good suit.

	if(thermal_protection < 0.99)		//For some reason, < 1 returns false if the value is 1.
		temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)
	else
		temp_adj = min(H.bodytemperature - thermostat, max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*charge_consumption

	H.bodytemperature -= temp_adj*efficiency

	obj_cell_slot.cell.use(charge_usage)

	if(obj_cell_slot.cell.charge <= 0)
		turn_off(1)

/obj/item/suit_cooling_unit/proc/get_environment_temperature()
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(istype(H.loc, /obj/vehicle/sealed/mecha))
			var/obj/vehicle/sealed/mecha/M = H.loc
			return M.return_temperature()
		else if(istype(H.loc, /obj/machinery/atmospherics/component/unary/cryo_cell))
			var/obj/machinery/atmospherics/component/unary/cryo_cell/C = H.loc
			return C.air_contents.temperature

	var/turf/T = get_turf(src)
	if(istype(T, /turf/space))
		return 0	//space has no temperature, this just makes sure the cooling unit works in space

	var/datum/gas_mixture/environment = T.return_air()
	if (!environment)
		return 0

	return environment.temperature

/obj/item/suit_cooling_unit/proc/attached_to_suit(mob/M)
	if (!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M

	if (!H.wear_suit || (H.s_store != src && H.back != src))
		return 0

	return 1

/obj/item/suit_cooling_unit/proc/turn_on()
	if(!obj_cell_slot?.cell)
		return
	if(obj_cell_slot.cell.charge <= 0)
		return

	on = 1
	START_PROCESSING(SSobj, src)
	updateicon()

/obj/item/suit_cooling_unit/proc/turn_off(var/failed)
	if(failed) visible_message("\The [src] clicks and whines as it powers down.")
	on = 0
	STOP_PROCESSING(SSobj, src)
	updateicon()

/obj/item/suit_cooling_unit/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	toggle(user)

/obj/item/suit_cooling_unit/proc/toggle(var/mob/user)
	if(on)
		turn_off()
	else
		turn_on()
	to_chat(user, "<span class='notice'>You switch \the [src] [on ? "on" : "off"].</span>")

/obj/item/suit_cooling_unit/attackby(obj/item/W as obj, mob/user as mob)
	if (W.is_screwdriver())
		if(cover_open)
			cover_open = 0
			to_chat(user, "You screw the panel into place.")
		else
			cover_open = 1
			to_chat(user, "You unscrew the panel.")
		playsound(src, W.tool_sound, 50, 1)
		updateicon()
		return
	return ..()

/obj/item/suit_cooling_unit/proc/updateicon()
	if (cover_open)
		if (obj_cell_slot?.cell)
			icon_state = "suitcooler1"
		else
			icon_state = "suitcooler2"
	else
		icon_state = "suitcooler0"

/obj/item/suit_cooling_unit/examine(mob/user, dist)
	. = ..()

	if(Adjacent(user))

		if (on)
			if (attached_to_suit(src.loc))
				. += "It's switched on and running."
			else
				. += "It's switched on, but not attached to anything."
		else
			. += "It is switched off."

		if (cover_open)
			if(obj_cell_slot?.cell)
				. += "The panel is open, exposing the [obj_cell_slot.cell]."
			else
				. += "The panel is open."

		if (obj_cell_slot?.cell)
			. += "The charge meter reads [round(obj_cell_slot.cell.percent())]%."
		else
			. += "It doesn't have a power cell installed."

/obj/item/suit_cooling_unit/empty
	cell_type = null

/obj/item/suit_cooling_unit/emergency
	icon_state = "esuitcooler"
	w_class = WEIGHT_CLASS_NORMAL
	cell_locked = TRUE

/obj/item/suit_cooling_unit/emergency/updateicon()
	return
