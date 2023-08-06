//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_REAL(gas_data, /datum/gas_data) = new

/**
 * master datum holding all atmospherics gas data
 * all lists should be accessed directly for speed
 * all lists are keyed by id
 */
/datum/gas_data
	//! gas data
	//? intrinsics
	/// ids; associative list to the instantiated datum
	var/list/gases = list()
	/// names
	var/list/names = list()
	/// flags
	var/list/flags = list()
	/// groups
	var/list/groups = list()
	//? physics
	/// specific heat
	var/list/specific_heats = list()
	/// molar masses
	var/list/molar_masses = list()
	//? reagents
	/// reagents: id = (reagentid, base amount, minimum moles, mole factor, max amount)
	/// this is a sparse lookup, not all gases are in here.
	var/list/reagents = list()
	//? visuals
	/// visuals: id = (state, threshold, factor)
	var/list/visuals = list()
	/// visuals cache
	var/list/visual_images = list()
	//? reactions
	var/list/rarities = list()

	//! gas cache lists
	/// list of lists of gas ids by flag
	var/list/gas_by_flag = list()
	/// list of lists of gas ids by group
	var/list/gas_by_group = list()

	//! global data
	/// next random gas id
	var/static/next_procedural_gas_id = 0

/datum/gas_data/New()
	build_hardcoded()

/datum/gas_data/proc/rebuild_caches()
	names = list()
	flags = list()
	groups = list()
	specific_heats = list()
	molar_masses = list()
	reagents = list()
	visuals = list()
	visual_images = list()
	rarities = list()
	gas_by_flag = list()
	gas_by_group = list()
	if(!islist(gases))
		gases = list()
	for(var/i in 1 to length(gases))
		var/id = gases[i]
		var/datum/gas/G = gases[id]
		if(!G)
			gases -= id
			continue
		if(id != G.id)
			gases[i] = G.id
			gases[G.id] = G
		_register_gas(G)

/datum/gas_data/proc/build_hardcoded()
	for(var/path in subtypesof(/datum/gas))
		var/datum/gas/G = new path
		register_gas(G)

/datum/gas_data/proc/register_gas(datum/gas/G)
	ASSERT(G.id)
	ASSERT(!gases[G.id])
	_register_gas(G)

/datum/gas_data/proc/_register_gas(datum/gas/G)
	//? intrinsics
	gases[G.id] = G
	names[G.id] = G.name
	if(groups[G.id])
		var/old_group = groups[G.id]
		LAZYREMOVE(gas_by_group[old_group], G.id)
	groups[G.id] = G.gas_groups
	if(G.gas_groups & GAS_GROUP_CORE)
		if(!((G.gas_flags & (GAS_FLAG_CORE | GAS_FLAG_FILTERABLE)) == (GAS_FLAG_CORE | GAS_FLAG_FILTERABLE)))
			stack_trace("[G.id] didn't have core/filterable flags even though it was marked as core group. Adding the flags...")
			G.gas_flags |= (GAS_FLAG_CORE | GAS_FLAG_FILTERABLE)
	else if(!(G.gas_groups & GAS_GROUPS_FILTERABLE))
		stack_trace("[G.id] didn't have a filterable gas group. This is probably a bad thing. Adding filterable flag...")
		G.gas_flags |= (GAS_FLAG_FILTERABLE)
	if(flags[G.id])
		var/old_flags = flags[G.id]
		for(var/bit in bitfield2list(old_flags))
			LAZYREMOVE(gas_by_flag["[bit]"], G.id)
	flags[G.id] = G.gas_flags
	//? physics
	specific_heats[G.id] = G.specific_heat
	molar_masses[G.id] = G.molar_mass
	//? reagents
	if(G.gas_reagent_id)
		reagents[G.id] = list(
			G.gas_reagent_id,
			G.gas_reagent_amount,
			G.gas_reagent_threshold,
			G.gas_reagent_factor,
			G.gas_reagent_max
		)
	else
		reagents -= G.id
	//? visuals
	if(!G.visual_overlay)
		visuals -= G.id
		visual_images -= G.id
	else
		visuals[G.id] = list(
			G.visual_overlay,
			G.visual_threshold,
			G.visual_factor
		)
		visual_images[G.id] = new /list(GAS_VISUAL_STEP_MAX)
		for(var/i in 1 to GAS_VISUAL_STEP_MAX)
			var/image/I = image('icons/modules/atmospherics/gas.dmi', icon_state = G.visual_overlay, layer = FLOAT_LAYER + i)
			I.plane = FLOAT_PLANE
			I.alpha = i * (255 / GAS_VISUAL_STEP_MAX)
			I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			I.color = G.visual_color
			I.appearance_flags = RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA | KEEP_APART
			visual_images[G.id][i] = I
	//? reactions
	rarities[G.id] = G.rarity
	//? rebuild cheap cache lists
	//* gas groups
	for(var/group in bitfield2list(G.gas_groups))
		LAZYINITLIST(gas_by_group[group])
		LAZYDISTINCTADD(gas_by_group[group], G.id)
	//* gas flags
	for(var/bit in bitfield2list(G.gas_flags))
		LAZYINITLIST(gas_by_flag["[bit]"])
		LAZYDISTINCTADD(gas_by_flag["[bit]"], G.id)

/**
 * tgui gas context
 *
 * generates data for tgui/interfaces/Atmos.tsx:
 * * GasContext
 * * FullGasContext
 *
 * @params
 * * ids - gas ids; defaults to all.
 * * full - for FullGasContext? Usually not needed.
 */
/datum/gas_data/proc/tgui_gas_context(list/ids, full = FALSE)
	. = list()
	var/list/gases = list()
	.["gases"] = gases
	var/list/core_ids = list()
	.["coreGases"] = core_ids
	var/list/filterable_ids = list()
	.["filterableGases"] = filterable_ids
	var/filterableGroups = GAS_GROUPS_FILTERABLE
	.["groupNames"] = global.gas_group_names
	for(var/id in (ids || gases))
		var/datum/gas/instance = gases[id]
		if(isnull(instance))
			continue
		var/list/assembled = list(
			"id" = instance.id,
			"name" = instance.name,
			"flags" = instance.gas_flags,
			"groups" = instance.gas_groups,
			"specificHeat" = instance.specific_heat,
			"molarMass" = instance.molar_mass,
		)
		if(instance.gas_flags & GAS_FLAG_CORE)
			core_ids |= instance.id
		if(instance.gas_flags & GAS_FLAG_FILTERABLE)
			filterable_ids += instance.id
		gases[instance.id] = assembled
	.["filterableGroups"] = filterableGroups

/**
 * gets tgui gas context for all non-unknown gasses
 */
/datum/gas_data/proc/tgui_known_gas_context(full = FALSE)
	. = list()
	for(var/id in flags)
		if(flags[id] & GAS_FLAG_UNKNOWN)
			continue
		. += id
	return tgui_gas_context(., full)

/**
 * checks if a gas group or set of gas groups is filterable
 *
 * returns all or none
 */
/datum/gas_data/proc/gas_groups_all_filterable(group_flag)
	return ((group_flag & GAS_GROUPS_FILTERABLE) == group_flag)? group_flag : NONE

/**
 * checks if a gas group or set of gas groups is filterable
 *
 * returns filterable groups
 */
/datum/gas_data/proc/gas_groups_filterable(group_flag)
	return (group_flag & GAS_GROUPS_FILTERABLE)

/**
 * checks if a gas id is specifically filterable
 */
/datum/gas_data/proc/gas_id_filterable(gas_id)
	return flags[gas_id] & (GAS_FLAG_FILTERABLE | GAS_FLAG_CORE)

/**
 * check if a procedural gas is not conflicting with any other gas
 */
/datum/gas_data/proc/procedural_gas_conflicts(datum/procedural_gas/instance)
	. = FALSE
	for(var/id in gases)
		var/datum/gas/gas = gases[id]
		if(abs(gas.molar_mass - instance.molar_mass) <= GAS_COLLISION_THRESHOLD_MOLAR_MASS)
			return TRUE
