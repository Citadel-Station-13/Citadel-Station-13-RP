/obj/item/circuitboard/machine/nanite_chamber
	name = T_BOARD("nanite chamber")
	build_path = /obj/machinery/nanite_chamber
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/scanning_module = 1,
	)

/obj/machinery/nanite_chamber
	name = "nanite chamber"
	desc = "A nanoswarm servicing chamber."
	icon = 'icons/modules/nanites/machinery/chamber.dmi'
	icon_state = "chamber"
	base_icon_state = "chamber"
	circuit = /obj/item/circuitboard/machine/nanite_chamber

	idle_power_usage = POWER_USAGE_NANITE_CHAMBER_IDLE
	active_power_usage = POWER_USAGE_NANITE_CHAMBER_ACTIVE
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON

	/// linked computer
	var/obj/machinery/computer/nanite_chamber/linked

	/// opened?
	var/open = FALSE
	/// locked?
	var/locked = FALSE
	/// operating?
	var/operating = FALSE
	/// occupant person
	var/mob/living/occupant
	/// occupant nanoswarm brain
	var/obj/item/mmi/digital/posibrain/nano/protean_core
	/// stored materials as items
	var/list/obj/item/held_items

	/// cost to rebuild a protean's swarm
	var/static/list/protean_cost_nanoswarm = list(
		MAT_STEEL = 20000,
	)
	/// cost to rebuild protean's orchestrator
	var/static/list/protean_cost_orchestrator = list(
		MAT_VERDANTIUM = 4000,
		MAT_GOLD = 8000,
		MAT_SILVER = 8000,
		MAT_METALHYDROGEN = 12000,
	)
	/// cost to rebuild protean's refactory
	var/static/list/protean_cost_refactory = list(
		MAT_DIAMOND = 6000,
		MAT_MORPHIUM = 12000,
		MAT_STEEL = 5000,
		MAT_VALHOLLIDE = 6000,
	)

/obj/machinery/nanite_chamber/Initialize(mapload)
	. = ..()

/obj/machinery/nanite_chamber/Destroy()
	drop_contents()
	return ..()

/obj/machinery/nanite_chamber/update_overlays()
	. = ..()
	if(locked)
		. += "[base_icon_state]_bolted"

/obj/machinery/nanite_chamber/update_icon_state()
	if(operating)
		icon_state = "[base_icon_state]_active"
	else if(occupant)
		icon_state = "[base_icon_state]_occupied"
	else if(open)
		icon_state = "[base_icon_state]_open"
	else
		icon_state = "[base_icon_state]"
	return ..()

/obj/machinery/nanite_chamber/Moved(atom/old_loc, direction, forced)
	. = ..()

/obj/machinery/nanite_chamber/interact(mob/user)
	. = ..()
	if(.)
		return
	toggle_open(user)
	return TRUE

#warn impl

/obj/machinery/nanite_chamber/proc/reassert_connection()

/obj/machinery/nanite_chamber/proc/detect_connection()

/obj/machinery/nanite_chamber/proc/set_locked(new_value)
	locked = new_value

/obj/machinery/nanite_chamber/proc/toggle_locked()
	set_locked(!locked)

/obj/machinery/nanite_chamber/proc/is_locked()
	return locked || operating

/obj/machinery/nanite_chamber/proc/rebuild_protean()
	#warn impl

/obj/machinery/nanite_chamber/proc/open(mob/user)
	if(open)
		return TRUE
	return toggle_open(user)

/obj/machinery/nanite_chamber/proc/close(mob/user)
	if(!open)
		return TRUE
	return toggle_open(user)

/obj/machinery/nanite_chamber/proc/toggle_open(mob/user)
	if(is_locked())
		return FALSE
	if(open)
		take_contents()
	else
		drop_contents()
	open = !open
	density = !open
	update_icon()
	return TRUE

/obj/machinery/nanite_chamber/proc/drop_contents()
	var/atom/where = drop_location()
	for(var/atom/movable/AM as anything in held_items)
		AM.forceMove(where)
	held_items = null
	occupant?.forceMove(where)
	protean_core?.forceMove(where)
	linked?.update_static_data()

/obj/machinery/nanite_chamber/proc/take_contents()
	if(!occupant)
		var/mob/living/new_mob = locate() in loc
		if(new_mob)
			occupant = new_mob
			new_mob.forceMove(src)
	if(!occupant && !protean_core)
		var/obj/item/mmi/digital/posibrain/nano/new_core = locate() in loc
		if(new_core)
			protean_core = new_core
			new_core.forceMove(src)
		for(var/obj/item/organ/internal/nano/O in loc)
			LAZYADD(held_items, O)
			O.forceMove(src)
		for(var/obj/item/stack/material/M in loc)
			M.forceMove(src)
			if(QDELETED(M))
				continue
			LAZYADD(held_items, M)
	linked?.update_static_data()

/**
 * estimate cost of reconstruction for proteans, null if no protean found.
 */
/obj/machinery/nanite_chamber/proc/protean_reconstruction_costs()
	if(isnull(protean_core))
		return
	. = list()
	for(var/mat in protean_cost_nanoswarm)
		.[mat] += protean_cost_nanoswarm[mat]
	if(!locate(/obj/item/organ/internal/nano/orchestrator) in held_items)
		for(var/mat in protean_cost_orchestrator)
			.[mat] += protean_cost_orchestrator[mat]
	if(!locate(/obj/item/organ/internal/nano/refactory) in held_items)
		for(var/mat in protean_cost_refactory)
			.[mat] += protean_cost_refactory[mat]

/obj/machinery/nanite_chamber/proc/available_materials()
	. = list()
	for(var/obj/item/stack/material/matstack in held_items)
		.[matstack.material.id] += matstack.amount * SHEET_MATERIAL_AMOUNT

/obj/machinery/nanite_chamber/contents_resist(mob/escapee)
	if(open(escapee))
		return FALSE
	escapee.action_feedback(SPAN_WARNING("You start kicking at [src], trying to free yourself!"), src)
	visible_message(
		SPAN_WARNING("A loud thumping sound is heard from [src]!"),
		blind_message = SPAN_WARNING("You hear a loud thumping noise, as if someone was trying to break glass."),
		range = MESSAGE_RANGE_COMBAT_LOUD,
	)
	contents_resist_sequence(escapee, 1 MINUTES)
	return TRUE

/obj/machinery/nanite_chamber/contents_resist_finish(mob/escapee)
	set_locked(FALSE)
	open(escapee)
	escapee.action_feedback(SPAN_WARNING("You kick open [src], freeing yourself!"))
	visible_message(
		SPAN_WARNING("A final kick from [escapee] finally manages to disengage [src]'s locks."),
		blind_message = SPAN_WARNING("You hear a loud kick on glass, and the sound of mechanical locks disengaging."),
		range = MESSAGE_RANGE_COMBAT_LOUD,
	)
