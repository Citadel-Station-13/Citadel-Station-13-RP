//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * individual power bus
 * * units are joules / watts
 */
/datum/rig_power_bus
	/// owning rig
	var/obj/item/rig/rig
	/// cell
	var/obj/item/cell/cell
	/// is the cell removable?
	var/cell_removable = TRUE
	/// last burst draw
	/// * this is reset on tick, at which point it already Happened. the draw happens instantly.
	/// * measured in joules
	var/list/burst_draws
	/// current static draws by source
	/// * source is arbitrary
	/// * measured in joules
	var/list/static_draws
	/// online? we become offline if we run out of power during usage
	var/online = TRUE

/datum/rig_power_bus/New(obj/item/rig/rig, starting_cell_type)
	src.rig = rig

/datum/rig_power_bus/Destroy()
	rig = null
	burst_draws = null
	static_draws = null
	return ..()

/datum/rig_power_bus/proc/accepts_cell(obj/item/cell/cell, datum/event_args/actor/actor, silent)

/**
 * @params
 * * source - source to store in list (for one tick) as.
 * * amount - amount to draw in joules
 * @return drawn amount
 */
/datum/rig_power_bus/proc/perform_burst_draw(source, amount)
	// just here incase featurecoders are silly
	if(QDESTROYING(src))
		CRASH("attempted to draw power from a deleted power bus. this is a memory leak.")
	if(!burst_draws)
		burst_draws = list()
	burst_draws[source] += amount
	#warn drain cell, return amount

/**
 * @params
 * * source - source to register in list as.
 * * amount - amount to draw per tick in joules
 */
/datum/rig_power_bus/proc/register_static_draw(source, amount)
	// just here incase featurecoders are silly
	if(QDESTROYING(src))
		CRASH("attempted to draw power from a deleted power bus. this is a memory leak.")
	if(!static_draws)
		static_draws = list()
	static_draws[source] = amount

/datum/rig_power_bus/proc/unregister_static_draw(source)
	static_draws -= source

/datum/rig_power_bus/proc/tick(dt)

#warn impl

/datum/rig_power_bus/main_power

/datum/rig_power_bus/aux_power



