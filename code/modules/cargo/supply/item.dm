/datum/supply_item
	/// name
	var/name
	/// desc
	var/desc
	/// category
	var/category = "Misc"
	/// path of what we contain
	var/item_type
	/// max amount per order
	var/max_amount = 1
	/// flags
	var/supply_item_flags = NONE
	/// cost per unit
	var/cost
	/// cost multiplier - applied during autodetection
	var/factor
	/// singular access enum to lock to
	var/access_lock

/datum/supply_item/New()
	if(auto)
		auto_construct(item_type)

#warn support /datum/material, don't overwrite cost if it's set

/datum/supply_item/proc/auto_construct(datum/from_path)
	if(!ispath(from_path, /atom))
		// no support for automatic gas/reagent/material yet
		return
	var/atom/from_atom = from_path
	name = initial(from_atom.name)
	desc = initial(from_atom.desc)
	cost = get_worth_static(from_atom)
	if(ispath(from_atom, /obj/item/stack))
		var/obj/item/stack/from_stack = from_atom
		max_amount = initial(from_stack.max_amount) * 10
	else
		max_amount = 10

/datum/supply_item/proc/ui_data_list()
	return list(
		"name" = name,
		"desc" = desc,
		"category" = category,
		"max" = max_amount,
		"ref" = ref(src),
		"flags" = supply_item_flags,
		"cost" = cost,
		"access" = access_lock,
	)

/**
 * spawning
 *
 * when spawning things, spawn objects in nullspace, then put in:
 * * normal: for non locked objects
 * * locked: list of access enums as text, for locked items
 * * restricted: list of access enumas s text, for locked items, not overridable by private orders
 *
 * all handling/packing will be done by the handler.
 */
/datum/supply_item/proc/instantiate(amount, list/normal, list/locked, list/restricted)
	if(!isatom(item_type))
		CRASH("non-atom types are not implemented")
	if(ispath(item_type, /obj/item/stack))
		#warn impl
	else
		#warn impl
