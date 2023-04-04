#define RAISE_ANIMATE_TIME 20
#define FALL_ANIMATE_TIME 20

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

	/// operating timerid
	var/operation_timerid
	/// operation effects timerid
	var/operation_effects_timerid

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
	detect_connection()

/obj/machinery/nanite_chamber/Destroy()
	drop_contents()
	linked?.unlink_chamber()
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

/obj/machinery/nanite_chamber/interact(mob/user)
	. = ..()
	if(.)
		return
	toggle_open(user)
	return TRUE

/obj/machinery/nanite_chamber/proc/detect_connection()
	if(linked)
		return
	var/obj/machinery/computer/nanite_chamber/chamber = locate() in orange(1, src)
	if(chamber)
		chamber?.relink()

/obj/machinery/nanite_chamber/proc/set_locked(new_value)
	locked = new_value

/obj/machinery/nanite_chamber/proc/toggle_locked()
	set_locked(!locked)

/obj/machinery/nanite_chamber/proc/is_locked()
	return locked || operating

/obj/machinery/nanite_chamber/proc/operate_for(time = 15 SECONDS, effects_in = 7 SECONDS, datum/callback/effects_callback)
	if(operating)
		return FALSE
	operating = TRUE
	flick(src, "[base_icon_state]_raising")
	addtimer(effects_callback, min(effects_in, time))
	addtimer(CALLBACK(src, PROC_REF(finish_operating)), time)
	FLICK_IN(src, "[base_icon_state]_falling", max(time - (RAISE_ANIMATE_TIME + FALL_ANIMATE_TIME), 0))

/obj/machinery/nanite_chamber/proc/finish_operating()
	operating = FALSE

/obj/machinery/nanite_chamber/proc/cancel_operation(immediate)
	if(!operating)
		return
	if(operation_timerid)
		deltimer(operation_timerid)
	if(operation_effects_timerid)
		deltimer(operation_effects_timerid)
	flick(src, "[base_icon_state]_falling")
	if(!immediate)
		addtimer(CALLBACK(src, PROC_REF(do_cancel_operation)))
	else
		do_cancel_operation()

/obj/machinery/nanite_chamber/proc/do_cancel_operation()
	operating = FALSE

/obj/machinery/nanite_chamber/proc/try_refresh_protean()
	operate_for(15 SECONDS, 7 SECONDS, CALLBACK(src, PROC_REF(refresh_protean)))

/obj/machinery/nanite_chamber/proc/refresh_protean()
	#warn impl

/obj/machinery/nanite_chamber/proc/rebuild_protean()
	if(isnull(protean_core))
		return
	consume_protean_costs()
	// for now we just delete old organs, after organ refactor we wanna make this proper
	var/obj/item/organ/internal/nano/refactory/protean_refactory = locate() in held_items
	var/obj/item/organ/internal/nano/orchestrator/protean_orchestrator = locate() in held_items
	if(protean_refactory)
		QDEL_NULL(protean_refactory)
	if(protean_orchestrator)
		QDEL_NULL(protean_orchestrator)
	// do the human thing :D
	// todo: this doesn't transfer markings / naything because brains and minds are fucking stupid kill me please
	// todo: ORGAN AND CHARACTER SAVING REFACTOR AAAAAAAAAA
	var/mob/living/carbon/human/new_protean = new(src)
	new_protean.set_species(/datum/species/protean, force = TRUE)
	new_protean.real_name = protean_core.brainmob.real_name
	protean_core.brainmob.mind.transfer_to(new_protean)

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

/obj/machinery/nanite_chamber/proc/check_reconstruction_costs()
	var/list/avail = available_materials()
	var/list/wanted = protean_reconstruction_costs()
	for(var/mat in wanted)
		if(avail[mat] < wanted[mat])
			return FALSE
	return TRUE

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

/obj/machinery/nanite_chamber/proc/consume_reconstruction_costs()
	var/list/remaining = protean_reconstruction_costs()
	for(var/obj/item/stack/material/matstack in held_items)
		var/key = matstack.material.id
		if(!remaining[key])
			continue
		var/consumed = min(matstack.amount * SHEET_MATERIAL_AMOUNT, remaining[key])
		remaining[key] -= consume
		matstack.use(CEILING(consumed / SHEET_MATERIAL_AMOUNT, 1))

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
	cancel_operation()

#undef RAISE_ANIMATE_TIME
#undef FALL_ANIMATE_TIME
