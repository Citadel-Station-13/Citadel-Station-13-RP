/obj/machinery/portable_atmospherics/powered/scrubber
	name = "portable air scrubber"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE
	w_class = WEIGHT_CLASS_NORMAL

	atmos_portable_ui_flags = ATMOS_PORTABLE_UI_TOGGLE_POWER | ATMOS_PORTABLE_UI_SEE_POWER | ATMOS_PORTABLE_UI_SEE_FLOW
	power_maximum = 7500
	flow_maximum = 5000
	tgui_interface = "AtmosPortableScrubber"

	volume = 1000

	/// scrubbing ids
	var/list/scrubbing_ids = list()
	/// scrubbing groups
	var/scrubbing_groups = NONE
	/// molar rate current
	var/transfer_current = 0
	/// minimum moles to scrub per tick (if enough power) even if flow is not enough
	var/scrub_mole_boost = 50

/obj/machinery/portable_atmospherics/powered/scrubber/Initialize(mapload)
	. = ..()
	cell = new /obj/item/cell/apc(src)

//! LEGACY BELOW

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on
		update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/update_icon_state()
	. = ..()
	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/update_overlays()
	. = ..()
	if(holding)
		. += "scrubber-open"

	if(connected_port)
		. += "scrubber-connector"

//! LEGACY ABOVE

/obj/machinery/portable_atmospherics/powered/scrubber/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["atmosContext"] = global.gas_data.tgui_gas_context()
	.["scrubbingIds"] = scrubbing_ids
	.["scrubbingGroups"] = scrubbing_groups

/obj/machinery/portable_atmospherics/powered/scrubber/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["moleRate"] = transfer_current

/obj/machinery/portable_atmospherics/powered/scrubber/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("scrubID")
			var/target = params["target"]
			if(!istext(target))
				return FALSE
			if(!global.gas_data.gas_id_filterable(target))
				return FALSE
			if(target in scrubbing_ids)
				scrubbing_ids -= target
			else
				scrubbing_ids += target
			push_ui_data(data = list("scrubbingIds" = scrubbing_ids))
			return TRUE
		if("scrubGroup")
			var/target = params["target"]
			if(!isnum(target))
				return FALSE
			if(!global.gas_data.gas_groups_filterable(target))
				return FALSE
			scrubbing_groups ^= target
			push_ui_data(data = list("scrubbingGroups" = scrubbing_groups))
			return TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/process(delta_time)
	..()

	if(on && (cell?.charge || !use_cell))
		var/datum/gas_mixture/scrubbing = isnull(holding)? loc.return_air() : holding.air_contents
		var/old_mols = scrubbing.total_moles
		// todo: compensate for delta_time, right now this is not stable and will go faster/slower based on SSair tick rate.
		power_current = xgm_scrub_gas_volume(scrubbing, air_contents, scrubbing_ids, scrubbing_groups, flow_setting / scrubbing.group_multiplier, power_setting * efficiency_multiplier, scrub_mole_boost) / efficiency_multiplier
		transfer_current = (old_mols - scrubbing.total_moles) / delta_time
		update_connected_network()

	if(power_current)
		use_power(power_current, dt = delta_time)

//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "Huge Air Scrubber"
	icon = 'icons/obj/atmos_vr.dmi'
	icon_state = "scrubber:0"
	anchored = TRUE
	// just 1 million because no way to offload. yet.
	volume = 1000000
	flow_maximum = 50000
	use_cell = FALSE
	default_access_interface = FALSE
	default_multitool_hijack = TRUE

	use_power = USE_POWER_IDLE
	idle_power_usage = 50		//internal circuitry, friction losses and stuff
	active_power_usage = 1000	// Blowers running
	power_maximum = 100000	//100 kW ~ 135 HP

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Initialize(mapload)
	. = ..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	cut_overlays()
	. = ..()

	if(on && !(machine_stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/power_change()
	var/old_stat = machine_stat
	..()
	if (old_stat != machine_stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(I.is_wrench())
		if(on)
			to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
			return

		anchored = !anchored
		playsound(src.loc, I.tool_sound, 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

		return

	//doesn't use power cells
	if(istype(I, /obj/item/cell))
		return
	if(I.is_screwdriver())
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/tank))
		return

	..()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(I.is_wrench())
		to_chat(user, "<span class='warning'>The bolts are too tight for you to unscrew!</span>")
		return

	..()

// Tether tram air scrubbers for keeping arrivals clean - they work even with no area power
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/tram
	name = "\improper Tram Air Scrubber"
	icon_state = "scrubber:1"
	on = TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/tram/powered()
	return TRUE // Always be powered

// Triumph shuttle air scrubbers for keeping arrivals clean - they work even with no area power
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/shuttle
	name = "\improper Shuttle Air Scrubber"
	icon_state = "scrubber:1"
	on = TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/shuttle/powered()
	return TRUE // Always be powered
