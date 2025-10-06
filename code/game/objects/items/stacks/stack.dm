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

	/// Always create this type when splitting, instead of our own type.
	var/split_type
	/// The type we actually are. This is what is used when things try to consume an amount of us.
	/// * null = this current type
	var/stack_type

	var/singular_name
	var/amount = 1
	/// See stack recipes initialisation, param "max_res_amount" must be equal to this max_amount.
	var/max_amount = 50
	/// Determines whether different stack types can merge.
	var/stacktype_legacy
	var/uses_charge = 0
	var/list/charge_costs = null
	var/list/datum/matter_synth/synths = null
	/// Determines whether the item should update it's sprites based on amount.
	var/no_variants = TRUE

	/// skip default / old update_icon() handling
	var/skip_legacy_icon_update = FALSE
	/// use new update icon system
	/// * this is mandatory for all new stacks
	var/use_new_icon_update = FALSE

	/// Total number of states used in updating icons.
	/// todo: all stacks should use this, remove `use_new_icon_update
	///
	/// * Only active when [use_new_icon_update] is set on
	/// * This counts up from 1.
	/// * If null, we don't do icon updates based on amount.
	var/icon_state_count

	/// Will the item pass its own color var to the created item? Dyed cloth, wood, etc.
	var/pass_color = FALSE
	/// Will the stack merge with other stacks that are different colors? (Dyed cloth, wood, etc).
	var/strict_color_stacking = FALSE

	/// explicit recipes, lazy-list. this is typelist'd
	var/list/datum/stack_recipe/explicit_recipes

/obj/item/stack/Initialize(mapload, new_amount, merge = TRUE)
	if(has_typelist(explicit_recipes))
		explicit_recipes = get_typelist(explicit_recipes)
	else
		explicit_recipes = typelist(NAMEOF(src, explicit_recipes), generate_explicit_recipes())
	if(new_amount != null)
		amount = new_amount
	if(!stacktype_legacy)
		stacktype_legacy = type
	. = ..()
	if(merge)
		for(var/obj/item/stack/S in loc)
			if(can_merge(S))
				merge(S)
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
	if(!uses_charge)
		. += "There are [amount] [singular_name]\s in the stack."
	else
		. += "There is enough charge for [get_amount()]."

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
 * Return 1 if an immediate subsequent call to use() would succeed.
 * Ensures that code dealing with stacks uses the same logic
 */
/obj/item/stack/proc/can_use(used)
	if (get_amount() < used)
		return FALSE
	return TRUE

/**
 * Can we merge with this stack?
 */
/obj/item/stack/proc/can_merge(obj/item/stack/other)
	if(!istype(other))
		return FALSE
	if((strict_color_stacking || other.strict_color_stacking) && (color != other.color))
		return FALSE
	return other.stacktype_legacy == stacktype_legacy

/obj/item/stack/proc/use(used)
	if (!can_use(used))
		return FALSE
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		update_icon()
		return TRUE
	else
		if(get_amount() < used)
			return FALSE
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.use_charge(charge_costs[i] * used) // Doesn't need to be deleted
		return TRUE

/obj/item/stack/proc/add(extra, force)
	if(!uses_charge)
		if((amount + extra > get_max_amount()) && !force)
			return FALSE
		else
			amount += extra
		update_icon()
		return TRUE
	else if(!synths || synths.len < uses_charge)
		return FALSE
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)

/**
 * The transfer and split procs work differently than use() and add().
 * Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
 * They also remove an equal amount from the source stack.
 */

/// Attempts to transfer amount to S, and returns the amount actually transferred.
/obj/item/stack/proc/transfer_to(obj/item/stack/S, tamount=null, type_verified)
	if (!get_amount())
		return 0
	if (!can_merge(S) && !type_verified)
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
	if (uses_charge)
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

/obj/item/stack/proc/get_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.get_charge() / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.get_charge() / charge_costs[i]))
		return
	return amount

/obj/item/stack/proc/get_max_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.max_energy / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.max_energy / charge_costs[i]))
		return
	return max_amount

/obj/item/stack/proc/add_to_stacks(mob/user)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s."))
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		change_stack(user, 1)
	else
		return ..()

/obj/item/stack/Crossed(atom/movable/AM)
	. = ..()
	// if we're in a mob, do not automerge
	if(!ismob(loc) && !AM.throwing && can_merge(AM))
		merge(AM)

/// Merge src into S, as much as possible.
/obj/item/stack/proc/merge(obj/item/stack/S)
	if(uses_charge)
		return	// how about no!
	if(QDELETED(S) || QDELETED(src) || (S == src)) //amusingly this can cause a stack to consume itself, let's not allow that.
		return
	var/transfer = get_amount()
	if(S.uses_charge)
		transfer = min(transfer, S.get_max_amount() - S.get_amount())
	else
		transfer = min(transfer, S.max_amount - S.amount)
	if(pulledby)
		pulledby.start_pulling(S)
	S.copy_evidences(src)
	use(transfer, TRUE)
	S.add(transfer)
	return transfer

/obj/item/stack/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if (istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		src.transfer_to(S)
		return
	return ..()

/obj/item/stack/alt_clicked_on(mob/user, location, control, list/params)
	. = ..()
	if(.)
		return
	if(user.Reachability(src) && CHECK_MOBILITY(user, MOBILITY_CAN_PICKUP))
		attempt_split_stack(user)
		return TRUE

/obj/item/stack/proc/attempt_split_stack(mob/living/user)
	if(uses_charge)
		return
	else
		if(zero_amount())
			return
		//get amount from user
		var/max = get_amount()
		// var/stackmaterial = round(input(user,"How many sheets do you wish to take out of this stack? (Maximum  [max])") as null|num)
		var/stackmaterial = tgui_input_number(user, "How many sheets do you wish to take out of this stack?", "Stack", max, max, 1, round_value=TRUE)
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
	if(!use(amount, TRUE, FALSE))
		return FALSE
	var/make_type = isnull(split_type)? type : split_type
	var/obj/item/stack/F = new make_type(user? user : drop_location(), amount, FALSE)
	. = F
	F.copy_evidences(src)
	if(user)
		if(!user.put_in_hands(F, INV_OP_NO_MERGE_STACKS))
			F.forceMove(user.drop_location())
		add_fingerprint(user)
		F.add_fingerprint(user)
	zero_amount()

/obj/item/stack/proc/zero_amount()
	if(uses_charge)
		return get_amount() <= 0
	if(amount < 1)
		qdel(src)
		return TRUE
	return FALSE

/obj/item/stack/proc/copy_evidences(obj/item/stack/from)
	if(from.blood_DNA)
		blood_DNA = from.blood_DNA.Copy()
	if(from.fingerprints)
		fingerprints = from.fingerprints.Copy()
	if(from.fingerprintshidden)
		fingerprintshidden = from.fingerprintshidden.Copy()
	if(from.fingerprintslast)
		fingerprintslast = from.fingerprintslast

/obj/item/stack/proc/set_amount(new_amount, no_limits = FALSE)
	if(new_amount < 0 || new_amount % 1)
		stack_trace("Tried to set a bad stack amount: [new_amount]")
		return 0

	// Clean up the new amount
	new_amount = max(round(new_amount), 0)

	// Can exceed max if you really want
	if(new_amount > max_amount && !no_limits)
		new_amount = max_amount

	amount = new_amount

	// Can set it to 0 without qdel if you really want
	if(amount == 0 && !no_limits)
		qdel(src)
		return FALSE
	update_icon()
	return TRUE

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
 *
 * todo: use this instead of raw stacktype_legacy checks
 */
/obj/item/stack/proc/can_merge_into_type(path)
	CRASH("Not implemented.")
