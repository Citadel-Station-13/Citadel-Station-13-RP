//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Simple generators that generate power by burning items from a /stack.
 *
 * TODO: consider splitting up 'single stack type' vs 'multiple stack types' to more than one subtype.
 */
/obj/item/vehicle_module/lazy/stack_generator
	name = "abstract concept of a generator"
	desc = "Generates power for a vehicle, presumably."
	#warn sprite
	icon_state = "tesla"

	/// stack type or types to accept
	var/list/accept_types
	/// in stack units, not material units
	/// * can be a single number; will be if [capacity_by_types] is a number.
	var/list/stored_types
	/// total capacity by type
	/// * can be a single number
	var/list/capacity_by_type
	/// burn time
	/// * is a typelist
	/// * can be a single number
	var/list/burn_time_by_type
	/// power (watts) generated per type
	/// * can be a single number
	var/list/power_gen_by_type
	/// can we early-extingiush things automatically?
	var/can_early_extinguish = TRUE
	/// heuristic: start burning fuel when mech power is under this ratio:
	var/start_burn_power_ratio = 0.9

	var/burning_type
	///	we stop processing when not on a vehicle so this is time we exited processing
	/// so you can't cheat 'cannot early extinguish' by taking the module off
	var/burning_background_at
	/// this is time left and not time expires because
	/// we don't want to cheat them out of power from subsystem tick drift
	var/burning_time_left
	/// are we temporarily extinguished?
	var/burning_is_extinguished

	/// are we active?
	var/active = FALSE

/obj/item/vehicle_module/lazy/stack_generator/Initialize(mapload)
	if(islist(accept_types))
		accept_types = typelist(NAMEOF(src, accept_types), accept_types)
	if(islist(stored_types))
		stored_types = typelist(NAMEOF(src, stored_types), stored_types)
	if(islist(capacity_by_type))
		capacity_by_type = typelist(NAMEOF(src, capacity_by_type), capacity_by_type)
	if(islist(burn_time_by_type))
		burn_time_by_type = typelist(NAMEOF(src, burn_time_by_type), burn_time_by_type)
	if(islist(power_gen_by_type))
		power_gen_by_type = typelist(NAMEOF(src, power_gen_by_type), power_gen_by_type)
	return ..()

/obj/item/vehicle_module/lazy/stack_generator/proc/is_single_stack()
	return !islist(accept_types)

/obj/item/vehicle_module/lazy/stack_generator/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	set_active(FALSE)
	burning_background_at = world.time

/obj/item/vehicle_module/lazy/stack_generator/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	update_burning_in_background()
	..()

/obj/item/vehicle_module/lazy/stack_generator/render_ui()
	..()
	l_ui_button("active", "Power", active ? "Enabled" : "Disabled", active, null, TRUE)
	var/original_time_left = (burning_type && islist(burn_time_by_type) ? burn_time_by_type[burning_type] : burn_time_by_type) || 1
	l_ui_html("Active Fuel", burning_type ? "[burning_time_left / original_time_left * 100]% remaining" : "None")
	if(islist(stored_types))
		for(var/obj/item/stack/casted as anything in stored_types)
			l_ui_html("Stored - [casted.name]", "[stored_types[casted]] sheets")
	else if(accept_types)
		var/obj/item/stack/casted = accept_types
		l_ui_html("Remaining ([casted.name])", "[stored_types] sheets")

/obj/item/vehicle_module/lazy/stack_generator/on_l_ui_button(datum/event_args/actor/actor, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("active")
			#warn impl, log

/obj/item/vehicle_module/lazy/stack_generator/proc/update_burning_in_background()
	if(can_early_extinguish)
		return
	var/elapsed = world.time - burning_background_at
	burning_time_left -= elapsed
	if(burning_time_left <= 0)
		burning_time_left = burning_background_at = burning_type = burning_is_extinguished = null

/obj/item/vehicle_module/lazy/stack_generator/process()

/obj/item/vehicle_module/lazy/stack_generator/proc/accepts_stack_type(obj/item/stack/stack_or_type)
	if(!ispath(stack_type.type, /obj/item/stack))
		return FALSE
	return ispath(stack_type.type, accept_type)

/**
 * @return FALSE to deny burn and extinguish
 */
/obj/item/vehicle_module/lazy/stack_generator/proc/on_burn_tick(stack_type)
	return TRUE

/obj/item/vehicle_module/lazy/stack_generator/on_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(!istype(clickchain.target, /obj/item/stack))
		return
	var/obj/item/stack/casted = clickchain.target
	if(!accepts_stack_type(casted))
		// TODO: standard feedback proc for vehicle actions
		clickchain.chat_feedback(
			SPAN_WARNING("[src] mounted on your vehicle doesn't accept [casted]."),
			target = casted,
		)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	var/sheets_loaded = attempt_load(casted)
	#warn feedback
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/vehicle_module/lazy/stack_generator/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!istype(using, /obj/item/stack))
		return
	var/obj/item/stack/casted = clickchain.target
	if(!accepts_stack_type(casted))
		clickchain.chat_feedback(
			SPAN_WARNING("[src] doesn't accept [casted]."),
			target = casted,
		)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	var/sheets_loaded = attempt_load(casted)
	#warn feedback
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/vehicle_module/lazy/stack_generator/proc/attempt_load(obj/item/stack/stack, limit = INFINITY)
	var/capacity = islist(capacity_by_type) ? capacity_by_type[stack.type] : capacity_by_type
	var/stored = islist(stored_types) ? stored_types[stack.type] : stored_types
	var/remaining = capacity - stored
	if(remaining <= 0)
		return 0
	. = stack.use(min(limit, remaining))
	if(islist(stored_types))
		stored_types[stack.type] = stored_types[stack.type] + .
	else
		stored_types += .

/**
 * * fast burning, high power
 * * inefficient
 */
/obj/item/vehicle_module/lazy/stack_generator/phoron
	name = "phoron generator"
	desc = "A self-contained generator that generates power from burning solid phoron. \
	Requires free-air oxidizer to work, and will ignite any flammable gases in the air. \
	Combustion byproducts will also be released."
	can_early_extinguish = FALSE
	accept_types = /obj/item/stack/material/phoron
	capacity_by_type = 75
	// burns fuel very fast
	burn_time_by_type = 0.5 MINUTES
	// but generates power also very fast
	power_gen_by_type = STATIC_CELL_UNITS_TO_W(1000, 1 MINUTES)

/obj/item/vehicle_module/lazy/stack_generator/phoron/on_burn_tick(stack_type)
	var/turf/maybe_turf = vehicle?.loc
	if(!isturf(maybe_turf))
		// no cheating
		return FALSE
	var/datum/gas_mixture/checking_mixture = maybe_turf.return_air_immutable()
	for(var/id in checking_mixture.gas)
		if(global.gas_data.flags[id] & GAS_FLAG_OXIDIZER)
			. = TRUE
			break
	if(!.)
		return
	// had oxidizer, try igniting
	maybe_turf.hotspot_expose(5000, 1)
	// TODO: phoron leak if damaged; maybe as liquid fuel?

/**
 * * slow burning, moderate power
 * * dangerous
 * * efficient
 */
/obj/item/vehicle_module/lazy/stack_generator/uranium
	name = "microfission reactor"
	desc = "A self-contained nuclear fission reactor. Unlike combustion generators, \
	this doesn't require free oxidizer to use, but may leak radiation if damaged."
	accept_types = /obj/item/stack/material/uranium
	capacity_by_type = 50
	// yes a single stack can last the whole round lol
	burn_time_by_type = 5 MINUTES
	// relatively low power but insanely efficient
	power_gen_by_type = STATIC_CELL_UNITS_TO_W(350, 1 MINUTES)

	var/uncontained_radiation_strength = RAD_INTENSITY_MECH_REACTOR_UNSHIELDED_TICK
	var/uncontained_radiation_falloff = RAD_FALLOFF_MECH_REACTOR

/obj/item/vehicle_module/lazy/stack_generator/uranium/on_burn_tick(stack_type)
	. = TRUE
	// give them a 10% grace period
	// if failure is over max skip the runtime error and go for 100% damage lmfao
	var/damage_ratio = ((integrity_failure > integrity_max) && 1) || \
		(1 - ((integrity - integrity_failure + 0.1 * integrity) / (integrity_max - integrity_failure)))
	if(damage_ratio > 0)
		radiation_pulse(src, uncontained_radiation_strength, uncontained_radiation_falloff, TRUE, TRUE)
