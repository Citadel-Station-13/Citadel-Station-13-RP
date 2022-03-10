/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	gender = PLURAL
	origin_tech = list(TECH_MATERIAL = 1)
	icon = 'icons/obj/stacks.dmi'
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount = 50 //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	/// bandaid until new inventorycode
	var/mid_delete = FALSE
	var/stacktype //determines whether different stack types can merge
	var/build_type = null //used when directly applied to a turf
	var/uses_charge = 0
	var/list/charge_costs = null
	var/list/datum/matter_synth/synths = null
	var/no_variants = TRUE // Determines whether the item should update it's sprites based on amount.

	var/pass_color = FALSE // Will the item pass its own color var to the created item? Dyed cloth, wood, etc.
	var/strict_color_stacking = FALSE // Will the stack merge with other stacks that are different colors? (Dyed cloth, wood, etc)

/obj/item/stack/Initialize(mapload, new_amount, merge = TRUE)
	if(new_amount != null)
		amount = new_amount
	var/safety = 51			//badmin safety check :^)
	if((amount > max_amount) && max_amount)
		while(--safety && (amount > max_amount))
			amount -= max_amount
			new type(loc, max_amount, FALSE)
	if(!stacktype)
		stacktype = type
	. = ..()
	if(merge)
		for(var/obj/item/stack/S in loc)
			if(S.stacktype == stacktype)
				merge(S)
	update_icon()

/obj/item/stack/Destroy()
	if (src && usr && usr.machine == src)
		usr << browse(null, "window=stack")
	mid_delete = TRUE
	return ..()

/obj/item/stack/update_icon()
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

/obj/item/stack/examine(mob/user)
	. = ..()
	if(!uses_charge)
		. += "There are [amount] [singular_name]\s in the stack."
	else
		. += "There is enough charge for [get_amount()]."

/obj/item/stack/attack_self(mob/user)
	ui_interact(user)

/obj/item/stack/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stack", name)
		ui.open()

/obj/item/stack/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["amount"] = get_amount()

	return data

/obj/item/stack/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["recipes"] = recursively_build_recipes(recipes)

	return data

/obj/item/stack/proc/recursively_build_recipes(list/recipe_to_iterate)
	var/list/L = list()
	for(var/recipe in recipe_to_iterate)
		if(istype(recipe, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/R = recipe
			L["[R.title]"] = recursively_build_recipes(R.recipes)
		if(istype(recipe, /datum/stack_recipe))
			var/datum/stack_recipe/R = recipe
			L["[R.title]"] = build_recipe(R)

	return L

/obj/item/stack/proc/build_recipe(datum/stack_recipe/R)
	return list(
		"res_amount" = R.res_amount,
		"max_res_amount" = R.max_res_amount,
		"req_amount" = R.req_amount,
		"ref" = "\ref[R]",
	)

/obj/item/stack/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/stack/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("make")
			if(get_amount() < 1)
				qdel(src)
				return

			var/datum/stack_recipe/R = locate(params["ref"])
			if(!is_valid_recipe(R, recipes)) //href exploit protection
				return FALSE
			var/multiplier = text2num(params["multiplier"])
			if(!multiplier || (multiplier <= 0)) //href exploit protection
				return
			produce_recipe(R, multiplier, usr)
			return TRUE

/obj/item/stack/proc/is_valid_recipe(datum/stack_recipe/R, list/recipe_list)
	for(var/S in recipe_list)
		if(S == R)
			return TRUE
		if(istype(S, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/L = S
			if(is_valid_recipe(R, L.recipes))
				return TRUE

	return FALSE

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, var/quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, "<span class='warning'>You haven't got enough [src] to build \the [produced] [recipe.title]\s!</span>")
		else
			to_chat(user, "<span class='warning'>You haven't got enough [src] to build \the [recipe.title]!</span>")
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, "<span class='warning'>There is another [recipe.title] here!</span>")
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, "<span class='warning'>\The [recipe.title] must be constructed on the floor!</span>")
		return

	if (recipe.time)
		to_chat(user, "<span class='notice'>Building [recipe.title] ...</span>")
		if (!do_after(user, recipe.time, exclusive = TRUE))
			return

	if (use(required))
		var/atom/O
		if(ispath(recipe.result_type, /obj/item/stack))
			O = new recipe.result_type(user.drop_location(), produced)
		else if(recipe.use_material)
			O = new recipe.result_type(user.drop_location(), recipe.use_material)
		else
			O = new recipe.result_type(user.drop_location())
		O.setDir(user.dir)
		O.add_fingerprint(user)

		if (istype(O, /obj/item/storage)) //BubbleWrap - so newly formed boxes are empty
			for (var/obj/item/I in O)
				qdel(I)

		if ((pass_color || recipe.pass_color))
			if(!color)
				if(recipe.use_material)
					var/datum/material/MAT = get_material_by_name(recipe.use_material)
					if(MAT.icon_colour)
						O.color = MAT.icon_colour
				else
					return
			else
				O.color = color

//Return 1 if an immediate subsequent call to use() would succeed.
//Ensures that code dealing with stacks uses the same logic
/obj/item/stack/proc/can_use(var/used)
	if (get_amount() < used)
		return 0
	return 1

/**
  * Can we merge with this stack?
  */
/obj/item/stack/proc/can_merge(obj/item/stack/other)
	if(!istype(other))
		return FALSE
	if(mid_delete || other.mid_delete)	// bandaid until new inventory code
		return FALSE
	return other.stacktype == stacktype

/obj/item/stack/proc/use(var/used)
	if (!can_use(used))
		return 0
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			if(usr)
				usr.remove_from_mob(src, null)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		update_icon()
		return 1
	else
		if(get_amount() < used)
			return 0
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.use_charge(charge_costs[i] * used) // Doesn't need to be deleted
		return 1

/obj/item/stack/proc/add(var/extra)
	if(!uses_charge)
		if(amount + extra > get_max_amount())
			return 0
		else
			amount += extra
		update_icon()
		return 1
	else if(!synths || synths.len < uses_charge)
		return 0
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an equal amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	if (!get_amount())
		return 0
	if (!can_merge(S) && !type_verified)
		return 0
	if ((strict_color_stacking || S.strict_color_stacking) && S.color != color)
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

//creates a new stack with the specified amount
/obj/item/stack/proc/split(var/tamount)
	if (!amount)
		return null
	if(uses_charge)
		return null

	var/transfer = max(min(tamount, src.amount, initial(max_amount)), 0)

	var/orig_amount = src.amount
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack = new src.type(loc, transfer, FALSE)
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

/obj/item/stack/proc/add_to_stacks(mob/user as mob)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, "<span class='notice'>You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s.</span>")
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		change_stack(user, 1)
	else
		return ..()

/obj/item/stack/Crossed(obj/o)
	if(can_merge(o) && !o.throwing)
		merge(o)
	. = ..()

/obj/item/stack/proc/merge(obj/item/stack/S) //Merge src into S, as much as possible
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

/obj/item/stack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		src.transfer_to(S)

		spawn(0) //give the stacks a chance to delete themselves if necessary
			if (S && usr.machine==S)
				S.interact(usr)
			if (src && usr.machine==src)
				src.interact(usr)
	else
		return ..()

/obj/item/stack/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !in_range(user, src) || !user.canmove)
		return
	attempt_split_stack(user)

/obj/item/stack/proc/attempt_split_stack(mob/living/user)
	if(uses_charge)
		return
	else
		if(zero_amount())
			return
		//get amount from user
		var/max = get_amount()
		var/stackmaterial = round(input(user,"How many sheets do you wish to take out of this stack? (Maximum  [max])") as null|num)
		max = get_amount()
		stackmaterial = min(max, stackmaterial)
		if(stackmaterial == null || stackmaterial <= 0 || !in_range(user, src) || !user.canmove)
			return TRUE
		else
			change_stack(user, stackmaterial)
			to_chat(user, "<span class='notice'>You take [stackmaterial] sheets out of the stack</span>")
		return TRUE

/obj/item/stack/proc/change_stack(mob/user, amount)
	if(!use(amount, TRUE, FALSE))
		return FALSE
	var/obj/item/stack/F = new type(user? user : drop_location(), amount, FALSE)
	. = F
	F.copy_evidences(src)
	if(user)
		if(!user.put_in_hands(F, merge_stacks = FALSE))
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

/obj/item/stack/proc/combine_in_loc()
	return //STUBBED for now, as it seems to randomly delete stacks

/obj/item/stack/dropped(atom/old_loc)
	. = ..()
	if(isturf(loc))
		combine_in_loc()

/obj/item/stack/Moved(atom/old_loc, direction, forced)
	. = ..()
	if(pulledby && isturf(loc))
		combine_in_loc()


/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1 //amount of material needed for this recipe
	var/res_amount = 1 //amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material
	var/pass_color

	New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null, pass_stack_color)
		src.title = title
		src.result_type = result_type
		src.req_amount = req_amount
		src.res_amount = res_amount
		src.max_res_amount = max_res_amount
		src.time = time
		src.one_per_turf = one_per_turf
		src.on_floor = on_floor
		src.use_material = supplied_material
		src.pass_color = pass_stack_color

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null
	New(title, recipes)
		src.title = title
		src.recipes = recipes
