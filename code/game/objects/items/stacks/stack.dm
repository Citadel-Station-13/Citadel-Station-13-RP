/**
 * automatically splitting stack spawns
 *
 * supports /datum/prototype/material as well
 *
 * @return **amount of objects created** (not total stack/sheet amount made!)
 */
/proc/spawn_stacks_at(atom/location, stack_path, amount)
	. = 0
	var/safety = 50
	if(ispath(stack_path, /datum/prototype/material))
		var/datum/prototype/material/resolved = RSmaterials.fetch(stack_path)
		// todo: ugh
		resolved.place_sheet(location, amount)
		return 1
	else if(istype(stack_path, /obj/item/stack))
		stack_path = stack_path:type
	var/obj/item/stack/casted_path = stack_path
	var/max_amount = initial(casted_path.max_amount)
	while(amount > 0)
		var/creating = min(amount, max_amount)
		new stack_path(location, creating)
		.++
		amount -= creating
		--safety
		if(!safety)
			CRASH("ran out of safety")

/proc/__construct_legacy_stack_provider_material_map()
	return list(
		/obj/item/stack/rods = list(
			/datum/prototype/material/steel::id = SHEET_MATERIAL_AMOUNT / 2,
		),
		/obj/item/stack/tile/floor = list(
			/datum/prototype/material/steel::id = SHEET_MATERIAL_AMOUNT / 4,
		),
		/obj/item/stack/material/glass/reinforced = list(
			/datum/prototype/material/glass::id = SHEET_MATERIAL_AMOUNT / 1,
			/datum/prototype/material/steel::id = SHEET_MATERIAL_AMOUNT / 2,
		),
	)

/**
 * Items that can stack, tracking the number of which is in it
 *
 * * [worth_intrinsic] is the only thing used on this path for detecting economic value. Normal get_worth() is not considered.
 */
/obj/item/stack
	gender = PLURAL
	origin_tech = list(TECH_MATERIAL = 1)
	icon = 'icons/obj/stacks.dmi'
	item_flags = ITEM_CAREFUL_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD

	/// Total number of states used in updating icons.
	/// todo: all stacks should use this, remove `use_new_icon_update
	///
	/// * Only active when [use_new_icon_update] is set on
	/// * This counts up from 1.
	/// * If null, we don't do icon updates based on amount.
	var/icon_state_count

	/// Our effective stack type. Defaults to our type.
	/// * Used to determine our identity when calling into providers.
	/// * Used to determine what can merge into what (so colored subtypes of cable can all be considered cable).
	var/stack_type
	/// What type we split into. Useful if you have an infinite stack you don't want to be split into another infinite stack.
	/// * Use `|| stack_type || type` to default to stack type if this is not set.
	var/split_type

	/// Current amount
	var/amount = 1
	/// Maximum amount
	var/max_amount = 50

	/// this is admittedly shitcode but this allows for automatic
	/// stack provider support for non /material stacks that are directly derived from
	/// materials, like reinf glass and metal tiles
	///
	/// todo: please find a better way.
	var/static/list/legacy_stack_provider_material_map = __construct_legacy_stack_provider_material_map()

	/// explicit recipes, lazy-list. this is typelist'd
	var/list/datum/stack_recipe/explicit_recipes

	//! legacy - re-evaluate these at some point!
	var/singular_name
	/// Determines whether the item should update it's sprites based on amount.
	var/no_variants = TRUE

	/// skip default / old update_icon() handling
	var/skip_legacy_icon_update = FALSE
	/// use new update icon system
	/// * this is mandatory for all new stacks
	var/use_new_icon_update = FALSE

	/// Will the item pass its own color var to the created item? Dyed cloth, wood, etc.
	var/pass_color = FALSE
	/// Will the stack merge with other stacks that are different colors? (Dyed cloth, wood, etc).
	var/strict_color_stacking = FALSE
	//! end

/obj/item/stack/Initialize(mapload, new_amount, merge = TRUE)
	if(has_typelist(explicit_recipes))
		explicit_recipes = get_typelist(explicit_recipes)
	else
		explicit_recipes = typelist(NAMEOF(src, explicit_recipes), generate_explicit_recipes())
	if(!isnull(new_amount))
		amount = new_amount
	// todo: lint this to make sure everyone sets this, don't set in initialize as a safety net
	if(!stack_type)
		stack_type = type
	. = ..()
	// only merge 1. outside of mapload and 2. if we had amount
	if(merge && !mapload && amount)
		for(var/obj/item/stack/S in loc)
			if(can_merge_into(S))
				merge_into_other(S, TRUE)
		// and if we did and no longer have amount, delete ourselves
		if(amount == 0)
			return INITIALIZE_HINT_QDEL
	update_icon()

/obj/item/stack/update_icon_state()
	if(!use_new_icon_update)
		return ..()
	if(!icon_state_count)
		return ..()
	icon_state = "[base_icon_state || initial(icon_state)]-[get_amount_icon_notch(get_amount())]"
	return ..()

/obj/item/stack/update_icon()
	. = ..()
	if(skip_legacy_icon_update)
		return
	if(no_variants)
		icon_state = initial(icon_state)
	else
		if(amount <= (max_amount * (1/3)))
			icon_state = initial(icon_state)
		else if (amount <= (max_amount * (2/3)))
			icon_state = "[initial(icon_state)]_2"
		else
			icon_state = "[initial(icon_state)]_3"
		item_state = initial(icon_state)

/obj/item/stack/examine(mob/user, dist)
	. = ..()
	if(!has_stack_provider())
		. += "There are [get_amount()] [singular_name]\s in the stack."
	else
		. += "There are [get_amount()] [singular_name]\s in \the [get_provider_name()]."

/**
 * Get the explicit recipes of this stack type
 */
/obj/item/stack/proc/generate_explicit_recipes()
	return list()

/obj/item/stack/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!stackcrafting_makes_sense())
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "StackCrafting")
		ui.open()

/obj/item/stack/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["recipes"] = tgui_recipes()
	.["maxAmount"] = max_amount
	.["name"] = name

/obj/item/stack/proc/stackcrafting_makes_sense()
	return length(explicit_recipes)

/obj/item/stack/proc/tgui_recipes()
	var/list/assembled = list()
	for(var/datum/stack_recipe/recipe as anything in explicit_recipes)
		assembled[++assembled.len] = recipe.tgui_recipe_data()
	return assembled

/obj/item/stack/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["amount"] = get_amount()

/obj/item/stack/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("craft")
			var/recipe_ref = params["recipe"]
			if(!istext(recipe_ref))
				return TRUE
			var/datum/stack_recipe/recipe = locate(recipe_ref)
			if(!can_craft_recipe(recipe))
				return TRUE
			var/make_amount = params["amount"]
			craft_recipe(recipe, usr, make_amount)
			return TRUE

/obj/item/stack/proc/can_craft_recipe(datum/stack_recipe/recipe)
	if(recipe in explicit_recipes)
		return TRUE
	return FALSE

/obj/item/stack/proc/craft_recipe(datum/stack_recipe/recipe, mob/user, make_amount)
	if(make_amount > (isnull(recipe.max_amount)? (recipe.result_is_stack? INFINITY : 1) : recipe.max_amount))
		return FALSE
	var/needed = recipe.cost * (make_amount / recipe.result_amount)
	if(FLOOR(needed, 1) != needed) // no decimals, thank you!
		return FALSE
	if(needed > get_amount())
		return FALSE
	var/turf/where = get_turf(user)
	if(!do_after(user, recipe.time, src, progress_anchor = user))
		return FALSE
	if(needed > get_amount())
		return FALSE
	if(!recipe.craft(where, make_amount, src, user, FALSE, user.dir))
		return FALSE
	log_stackcrafting(user, src, recipe.name, make_amount, needed, where)
	use(needed)

/**
 * Can we merge with this stack?
 */
/obj/item/stack/proc/can_merge_into(obj/item/stack/other)
	if(!istype(other))
		return FALSE
	if((strict_color_stacking || other.strict_color_stacking) && (color != other.color))
		return FALSE
	return can_merge_into_type(other.type)

// todo: deprecated
/obj/item/stack/proc/can_use(used)
	return has_amount(used)

// todo: deprecated
/obj/item/stack/proc/use(used, no_delete)
	return use_amount(used, no_delete)

// todo: deprecated
/obj/item/stack/proc/add(extra, force)
	return give_amount(extra, force)

/**
 * The transfer and split procs work differently than use() and add().
 * Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
 * They also remove an equal amount from the source stack.
 */

/// Attempts to transfer amount to S, and returns the amount actually transferred.
/obj/item/stack/proc/transfer_to(obj/item/stack/S, tamount=null, type_verified)
	if (!get_amount())
		return 0
	if (!can_merge_into(S) && !type_verified)
		return 0

	if (isnull(tamount))
		tamount = src.get_amount()

	var/transfer = max(min(tamount, src.get_amount(), (S.get_max_amount() - S.get_amount())), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(S)
			if(blood_DNA)
				S.blood_DNA |= blood_DNA
		return transfer
	return 0

/// Creates a new stack with the specified amount.
// todo: refactor and combine /change_stack into here
/obj/item/stack/proc/split(tamount, atom/where, force)
	if (!amount)
		return null

	var/transfer = max(min(tamount, src.amount, force? INFINITY : initial(max_amount)), 0)

	var/orig_amount = src.amount
	if (transfer && src.use(transfer))
		var/make_type = isnull(split_type)? type : split_type
		var/obj/item/stack/newstack = new make_type(where, transfer, FALSE)
		newstack.color = color
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(newstack)
			if(blood_DNA)
				newstack.blood_DNA |= blood_DNA
		return newstack
	return null

/obj/item/stack/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		change_stack(user, 1)
	else
		return ..()

/obj/item/stack/Crossed(atom/movable/AM)
	. = ..()
	// if we're in a mob, do not automerge
	if(!ismob(loc) && !AM.throwing && can_merge_into(AM))
		merge_into_other(AM)

/**
 * Merge self into other
 *
 * * Can delete ourselves.
 *
 * @return amount merged
 */
/obj/item/stack/proc/merge_into_other(obj/item/stack/other, no_delete)
	if(QDELETED(other) || QDELETED(src) || (other == src)) //amusingly this can cause a stack to consume itself, let's not allow that.
		return
	var/transfer = get_amount()
	transfer = min(transfer, other.max_amount - other.amount)
	if(pulledby)
		pulledby.start_pulling(other)
	other.copy_evidences(src)
	use(transfer, no_delete)
	other.add(transfer)
	return transfer

/obj/item/stack/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if (istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		src.transfer_to(S)
		return
	return ..()

/obj/item/stack/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	.["split"] = create_context_menu_tuple("split", src, 1, MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP, TRUE)

/obj/item/stack/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("split")
			// TODO: e-args support
			attempt_split_stack(e_args.initiator)

/obj/item/stack/alt_clicked_on(mob/user, location, control, list/params)
	. = ..()
	if(.)
		return
	if(user.Reachability(src) && CHECK_MOBILITY(user, MOBILITY_CAN_PICKUP))
		attempt_split_stack(user)
		return TRUE

// TODO: THERE HAS TO BE A BETTER FUCKING WAY
/obj/item/stack/should_list_turf_on_alt_click(mob/user)
	return FALSE

/obj/item/stack/proc/attempt_split_stack(mob/living/user)
	//get amount from user
	var/max = get_amount()
	var/stackmaterial = tgui_input_number(user, "How many sheets do you wish to take out of this stack?", "Stack", max, max, 1, round_value=TRUE)
	if(QDELETED(src))
		return
	max = get_amount() // Not sure why this is done twice but whatever.
	stackmaterial = min(max, stackmaterial)
	if(stackmaterial == null || stackmaterial <= 0 || !in_range(user, src) || !CHECK_MOBILITY(user, MOBILITY_CAN_PICKUP))
		return TRUE
	else
		change_stack(user, stackmaterial)
		to_chat(user, SPAN_NOTICE("You take [stackmaterial] sheets out of the stack"))
	return TRUE

// todo: refactor and combine with /split
/obj/item/stack/proc/change_stack(mob/user, amount)
	var/atom/our_current_location = drop_location()
	if(!use(amount, TRUE, FALSE))
		return FALSE
	var/make_type = isnull(split_type)? type : split_type
	var/obj/item/stack/F = new make_type(user? user : our_current_location, amount, FALSE)
	. = F
	F.copy_evidences(src)
	if(user)
		if(!user.put_in_hands(F, INV_OP_NO_MERGE_STACKS))
			F.forceMove(user.drop_location())
		add_fingerprint(user)
		F.add_fingerprint(user)

/obj/item/stack/proc/copy_evidences(obj/item/stack/from)
	if(from.blood_DNA)
		blood_DNA = from.blood_DNA.Copy()
	if(from.fingerprints)
		fingerprints = from.fingerprints.Copy()
	if(from.fingerprintshidden)
		fingerprintshidden = from.fingerprintshidden.Copy()
	if(from.fingerprintslast)
		fingerprintslast = from.fingerprintslast

/obj/item/stack/proc/legacy_add_to_stacks_please_refactor_me(mob/user)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s."))
		if(!amount)
			break

//* Access *//

/**
 * Gets how many sheets we have.
 */
/obj/item/stack/proc/get_amount()
	if(item_mount)
		return check_provider_remaining()
	return amount

/**
 * Gets how many sheets we can carry.
 */
/obj/item/stack/proc/get_max_amount()
	if(item_mount)
		return check_provider_capacity()
	return max_amount

/**
 * Gets how many sheets we can accept.
 */
/obj/item/stack/proc/get_missing_amount()
	return get_max_amount() - get_amount()

/**
 * Checks if we have an amount.
 *
 * @return TRUE / FALSE
 */
/obj/item/stack/proc/has_amount(amount)
	return check_provider_remaining() >= amount

/**
 * Use an amount if we have the whole amount.
 *
 * @return amount used
 */
/obj/item/stack/proc/use_checked_amount(amount)
	if(!has_amount(amount))
		return 0
	return use_amount(amount)

/**
 * Use an amount. Will use less if we don't have that much.
 *
 * @return amount used
 */
/obj/item/stack/proc/use_amount(amount, no_delete)
	if(item_mount)
		return pull_from_provider(amount)
	if(amount <= 0)
		return 0
	amount = min(amount, src.amount)
	. = amount
	src.amount -= amount
	update_amount(no_delete)

/**
 * Gives a number of sheets back to us.
 *
 * @return amount added
 */
/obj/item/stack/proc/give_amount(amount, force)
	if(item_mount)
		return push_to_provider(amount, force)
	if(!force)
		amount = min(amount, max_amount - src.amount)
	if(amount <= 0)
		return 0
	. = amount
	src.amount += amount
	update_amount()

/**
 * Sets our amount to a specific amount.
 *
 * * If we use a stack provider, we'll push/pull automatically. This can be weird, because providers don't act the same as stacks.
 * * Setting us to 0 will delete us immediately.
 *
 * @return amount changed
 */
/obj/item/stack/proc/set_amount(new_amount, force)
	if(new_amount < 0 || (new_amount != floor(amount)))
		stack_trace("Tried to set a bad stack amount: [new_amount]")
		return 0

	if(item_mount)
		var/current_amount = check_provider_remaining()
		var/amount_to_push_or_pull = new_amount - current_amount

		if(!amount_to_push_or_pull)
			return 0
		return amount_to_push_or_pull > 0 ? push_to_provider(amount_to_push_or_pull, force) : pull_from_provider(amount_to_push_or_pull)

	if(!force)
		new_amount = min(amount, max_amount)

	. = new_amount - amount
	amount = new_amount

	update_amount()

/**
 * This can destroy the stack.
 */
/obj/item/stack/proc/update_amount(no_delete)
	if(QDELING(src))
		return
	if(item_mount)
	else
		if(amount <= 0)
			if(!no_delete)
				qdel(src)
			return
		update_icon()

//* Getters *//

/**
 * Get the number for `iconstate-[n]` icon state rendering.
 *
 * @return number, or null if `icon_state_count` isn't set.
 */
/obj/item/stack/proc/get_amount_icon_notch(the_amount)
	if(!icon_state_count)
		return null
	return CEILING(the_amount / max_amount * icon_state_count, 1)

//* Stack Providers *//

/obj/item/stack/proc/has_stack_provider()
	return !!item_mount

/**
 * Get the name of our stack provider.
 * * You must check if stack provider exists.
 */
/obj/item/stack/proc/get_provider_name()
	return item_mount.stack_get_provider_name(src, null, stack_type)

/**
 * * You must check if stack provider exists.
 * @return amount left
 */
/obj/item/stack/proc/check_provider_remaining()
	var/list/legacy_remap = legacy_stack_provider_material_map[type]
	if(legacy_remap)
		. = INFINITY
		for(var/mat_id in legacy_remap)
			. = min(., (item_mount.material_get_amount(src, null, mat_id) / legacy_remap[mat_id]) / SHEET_MATERIAL_AMOUNT)
	else
		. = item_mount.stack_get_amount(src, null, stack_type) / SHEET_MATERIAL_AMOUNT

/**
 * * You must check if stack provider exists.
 * @return max volume
 */
/obj/item/stack/proc/check_provider_capacity()
	var/list/legacy_remap = legacy_stack_provider_material_map[type]
	if(legacy_remap)
		. = INFINITY
		for(var/mat_id in legacy_remap)
			. = min(., (item_mount.material_get_capacity(src, null, mat_id) / legacy_remap[mat_id]) / SHEET_MATERIAL_AMOUNT)
	else
		. = item_mount.stack_get_capacity(src, null, stack_type) / SHEET_MATERIAL_AMOUNT

/**
 * * You must check if stack provider exists.
 * @return amount pushed
 */
/obj/item/stack/proc/push_to_provider(amount, force)
	var/list/legacy_remap = legacy_stack_provider_material_map[type]
	if(legacy_remap)
		// we have to be atomic, so do an expensive check first
		if(!force)
			var/has_remaining_capacity = check_provider_capacity() - check_provider_remaining()
			if(has_remaining_capacity <= 0)
				return 0
			amount = min(amount, has_remaining_capacity)
		. = amount
		for(var/mat_id in legacy_remap)
			item_mount.material_give_amount(src, null, mat_id, amount * legacy_remap[mat_id] * SHEET_MATERIAL_AMOUNT)
	else
		. = item_mount.stack_give_amount(src, null, stack_type, amount * SHEET_MATERIAL_AMOUNT, force)

/**
 * * You must check if stack provider exists.
 * @return amount pulled
 */
/obj/item/stack/proc/pull_from_provider(amount)
	var/list/legacy_remap = legacy_stack_provider_material_map[type]
	if(legacy_remap)
		// we have to be atomic, so do an expensive check first
		var/has_remaining = check_provider_remaining()
		for(var/mat_id in legacy_remap)
			item_mount.material_use_amount(src, null, mat_id, has_remaining * legacy_remap[mat_id] * SHEET_MATERIAL_AMOUNT)
	else
		. = item_mount.stack_use_amount(src, null, stack_type, amount * SHEET_MATERIAL_AMOUNT)

//* Types *//

/**
 * Get our 'use as type'.
 */
/obj/item/stack/proc/get_use_as_type()
	return stack_type || type

/**
 * We can be used as a specific stack type.
 */
/obj/item/stack/proc/can_use_as_type(path)
	return stack_type == path || type == path

/**
 * Can merge into a type
 */
/obj/item/stack/proc/can_merge_into_type(path)
	return path == (stack_type || type)
