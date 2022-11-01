/**
 * Stack type objects!
 *
 * Contains:
 * * Stacks
 * * Recipe datum
 * * Recipe list datum
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
	/// See stack recipes initialisation, param "max_res_amount" must be equal to this max_amount.
	var/max_amount = 50
	/// bandaid until new inventorycode
	var/mid_delete = FALSE
	/// Determines whether different stack types can merge.
	var/stacktype
	/// Used when directly applied to a turf.
	var/build_type = null
	var/uses_charge = 0
	var/list/charge_costs = null
	var/list/datum/matter_synth/synths = null
	/// Determines whether the item should update it's sprites based on amount.
	var/no_variants = TRUE

	/// Will the item pass its own color var to the created item? Dyed cloth, wood, etc.
	var/pass_color = FALSE
	/// Will the stack merge with other stacks that are different colors? (Dyed cloth, wood, etc).
	var/strict_color_stacking = FALSE

/obj/item/stack/Initialize(mapload, new_amount, merge = TRUE)
	if(new_amount != null)
		amount = new_amount
	safety_check()
	if(!stacktype)
		stacktype = type
	. = ..()
	if(merge)
		for(var/obj/item/stack/S in loc)
			if(S.stacktype == stacktype)
				merge(S)
	update_icon()

/obj/item/stack/proc/safety_check()
	if(amount > max_amount)
		to_chat(usr, "The [name] spills on the [get_area_name(src)]!")
		amount -= max_amount
		var/obj/item/stack/newstack = new type(get_turf(usr))
		newstack.amount = max_amount
		return TRUE
	return FALSE

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
	if(safety_check())
		return
	list_recipes(user)

/obj/item/stack/proc/list_recipes(mob/user, recipes_sublist)
	if (!recipes)
		return
	if (!src || get_amount() <= 0)
		user << browse(null, "window=stack")
	user.set_machine(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if (recipes_sublist && recipe_list[recipes_sublist] && istype(recipe_list[recipes_sublist], /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list[recipes_sublist]
		recipe_list = srl.recipes
	var/t1 = text("<HTML><HEAD><title>Constructions from []</title></HEAD><body><TT>Amount Left: []<br>", src, src.get_amount())
	for(var/i=1;i<=recipe_list.len,i++)
		var/E = recipe_list[i]
		if (isnull(E))
			t1 += "<hr>"
			continue

		if (i>1 && !isnull(recipe_list[i-1]))
			t1+="<br>"

		if (istype(E, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = E
			t1 += "<a href='?src=\ref[src];sublist=[i]'>[srl.title]</a>"

		if (istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			var/max_multiplier = round(src.get_amount() / R.req_amount)
			var/title
			var/can_build = 1
			can_build = can_build && (max_multiplier>0)
			if (R.res_amount>1)
				title+= "[R.res_amount]x [R.title]\s"
			else
				title+= "[R.title]"
			title+= " ([R.req_amount] [src.singular_name]\s)"
			if (can_build)
				t1 += text("<A href='?src=\ref[src];sublist=[recipes_sublist];make=[i];multiplier=1'>[title]</A>  ")
			else
				t1 += text("[]", title)
				continue
			if (R.max_res_amount>1 && max_multiplier>1)
				max_multiplier = min(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5,10,25)
				for (var/n in multipliers)
					if (max_multiplier>=n)
						t1 += " <A href='?src=\ref[src];make=[i];multiplier=[n]'>[n*R.res_amount]x</A>"
				if (!(max_multiplier in multipliers))
					t1 += " <A href='?src=\ref[src];make=[i];multiplier=[max_multiplier]'>[max_multiplier*R.res_amount]x</A>"

	t1 += "</TT></body></HTML>"
	user << browse(t1, "window=stack")
	onclose(user, "stack")
	return

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [produced] [recipe.title]\s!"))
		else
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [recipe.title]!"))
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, SPAN_WARNING("There is another [recipe.title] here!"))
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, SPAN_WARNING("\The [recipe.title] must be constructed on the floor!"))
		return

	if (recipe.time)
		to_chat(user, SPAN_NOTICE("Building [recipe.title] ..."))
		if (!do_after(user, recipe.time))
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

/obj/item/stack/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_held_item() != src))
		return

	if (href_list["sublist"] && !href_list["make"])
		list_recipes(usr, text2num(href_list["sublist"]))

	if (href_list["make"])
		if (src.get_amount() < 1) qdel(src) //Never should happen

		var/list/recipes_list = recipes
		if (href_list["sublist"])
			var/datum/stack_recipe_list/srl = recipes_list[text2num(href_list["sublist"])]
			recipes_list = srl.recipes

		var/datum/stack_recipe/R = recipes_list[text2num(href_list["make"])]
		var/multiplier = text2num(href_list["multiplier"])
		if (!multiplier || (multiplier <= 0)) //href exploit protection
			return

		src.produce_recipe(R, multiplier, usr)

	if (src && usr.machine==src) //do not reopen closed window
		spawn( 0 )
			src.interact(usr)
			return
	return

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
	if(mid_delete || other.mid_delete) // bandaid until new inventory code
		return FALSE
	return other.stacktype == stacktype

/obj/item/stack/proc/use(used)
	if (!can_use(used))
		return FALSE
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			mid_delete = TRUE
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

/obj/item/stack/proc/add(extra)
	if(!uses_charge)
		if(amount + extra > get_max_amount())
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

/// Creates a new stack with the specified amount.
/obj/item/stack/proc/split(tamount)
	if (!amount)
		return null
	if (uses_charge)
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

/obj/item/stack/proc/add_to_stacks(mob/user)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s."))
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user)
	if(safety_check())
		return
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

/obj/item/stack/attackby(obj/item/W, mob/user)
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
		// var/stackmaterial = round(input(user,"How many sheets do you wish to take out of this stack? (Maximum  [max])") as null|num)
		var/stackmaterial = tgui_input_number(user, "How many sheets do you wish to take out of this stack?", "Stack", max, max, 1, round_value=TRUE)
		max = get_amount() // Not sure why this is done twice but whatever.
		stackmaterial = min(max, stackmaterial)
		if(stackmaterial == null || stackmaterial <= 0 || !in_range(user, src) || !user.canmove)
			return TRUE
		else
			change_stack(user, stackmaterial)
			to_chat(user, SPAN_NOTICE("You take [stackmaterial] sheets out of the stack"))
		return TRUE

/obj/item/stack/proc/change_stack(mob/user, amount)
	if(!use(amount, TRUE, FALSE))
		return FALSE
	var/obj/item/stack/F = new type(user? user : drop_location(), amount, FALSE)
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

/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	/// Amount of material needed for this recipe.
	var/req_amount = 1
	/// Amount of stuff that is produced in one batch (e.g. 4 for floor tiles).
	var/res_amount = 1
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material
	var/pass_color

/datum/stack_recipe/New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null, pass_stack_color)
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

/datum/stack_recipe_list/New(title, recipes)
	src.title = title
	src.recipes = recipes

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

	return TRUE
