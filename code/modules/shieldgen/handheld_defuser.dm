/obj/item/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	description_info = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern), in a similar way the floor mounted variant does. It is, however, portable and run by an internal battery. Can be recharged with a regular recharger."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "hdiffuser_off"
	origin_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_ILLEGAL = 2)
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/cell/device/cell = /obj/item/cell/device
	var/enabled = 0


/obj/item/shield_diffuser/Initialize(mapload)
	. = ..()
	init_cell_slot_easy_tool(cell_type, cell_accept)

/obj/item/shield_diffuser/Destroy()
	if(enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/shield_diffuser/process(delta_time)
	if(!enabled)
		return PROCESS_KILL

	var/obj/item/cell/cell = get_cell()
	for(var/direction in GLOB.cardinal)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/shield/S in shielded_tile)
			if(istype(S) && !S.diffused_for && !S.disabled_for && cell.checked_use(CELL_COST_SHIELD_DIFFUSION))
				S.diffuse(20)
		// Legacy shield support
		for(var/obj/effect/energy_field/S in shielded_tile)
			if(istype(S) && cell.checked_use(CELL_COST_SHIELD_DIFFUSION))
				qdel(S)

/obj/item/shield_diffuser/update_icon()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

/obj/item/shield_diffuser/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	enabled = !enabled
	update_icon()
	if(enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	to_chat(user, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/shield_diffuser/examine(mob/user, dist)
	. = ..()
	var/obj/item/cell/cell = get_cell()
	to_chat(user, "The charge meter reads [cell ? cell.percent() : 0]%")
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")
