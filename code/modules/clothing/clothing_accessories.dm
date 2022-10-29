/obj/item/clothing/_inv_return_attached()
	if(!accessories)
		return ..()
	. = ..()
	return islist(.)? (. + accessories) : (list(.) + accessories)

/obj/item/clothing/equipped(mob/user, slot, flags)
	. = ..()
	// propagate through accessories
	// DO NOT ALLOW NESTED ACCESSORIES
	if(!(flags & INV_OP_IS_ACCESSORY) && LAZYLEN(accessories))
		for(var/obj/item/I as anything in accessories)
			I.equipped(user, slot, flags | INV_OP_IS_ACCESSORY)

/obj/item/clothing/unequipped(mob/user, slot, flags)
	. = ..()
	// propagate through accessories
	// DO NOT ALLOW NESTED ACCESSORIES
	if(!(flags & INV_OP_IS_ACCESSORY) && LAZYLEN(accessories))
		for(var/obj/item/I as anything in accessories)
			I.unequipped(user, slot, flags | INV_OP_IS_ACCESSORY)

/obj/item/clothing/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	// propagate through accessories
	// DO NOT ALLOW NESTED ACCESSORIES
	if(!(flags & INV_OP_IS_ACCESSORY) && LAZYLEN(accessories))
		for(var/obj/item/I as anything in accessories)
			I.pickup(user, flags | INV_OP_IS_ACCESSORY, oldLoc)

/obj/item/clothing/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	// propagate through accessories
	// DO NOT ALLOW NESTED ACCESSORIES
	if(!(flags & INV_OP_IS_ACCESSORY) && LAZYLEN(accessories))
		for(var/obj/item/I as anything in accessories)
			I.dropped(user, flags | INV_OP_IS_ACCESSORY, newLoc)

/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	//Just no, okay
	if(!A.slot)
		return FALSE

	//Not valid at all, not in the valid list period.
	if((valid_accessory_slots & A.slot) != A.slot)
		return FALSE

	//Find all consumed slots
	var/consumed_slots = 0
	for(var/thing in accessories)
		var/obj/item/clothing/accessory/AC = thing
		consumed_slots |= AC.slot

	//Mask to just consumed restricted
	var/consumed_restricted = restricted_accessory_slots & consumed_slots

	//They share at least one bit with the restricted slots
	if(consumed_restricted & A.slot)
		return FALSE

	return TRUE

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/A = I
		if(attempt_attach_accessory(A, user))
			return

	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(I, user)
		return

	..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(LAZYLEN(accessories) && src.loc == user)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attack_hand(user)
		return
	if (ishuman(user) && src.loc == user)
		var/mob/living/carbon/human/H = user
		if(src == H.w_uniform) // Un-equip on single click, but not on uniform.
			return
	return ..()

/obj/item/clothing/examine(var/mob/user)
	. = ..()
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			. += "\A [A] is attached to it."

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attempt_attach_accessory(obj/item/clothing/accessory/A, mob/user)
	if(!valid_accessory_slots)
		if(user)
			to_chat(user, "<span class='warning'>You cannot attach accessories of any kind to \the [src].</span>")
		return FALSE

	var/obj/item/clothing/accessory/acc = A
	if(!istype(acc))
		return
	if(can_attach_accessory(acc))
		if(user)
			if(!user.attempt_insert_item_for_installation(acc, src))
				return
			else
				acc.forceMove(src)
		attach_accessory(user, acc)
		return TRUE
	else
		if(user)
			to_chat(user, "<span class='warning'>You cannot attach more accessories of this type to [src].</span>")
		return FALSE

/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	LAZYADD(accessories,A)
	A.on_attached(src, user)
	src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_accessory_slowdown()
	update_worn_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!LAZYLEN(accessories) || !(A in accessories))
		return

	A.on_removed(user)
	accessories -= A
	update_accessory_slowdown()
	update_worn_icon()

/obj/item/clothing/proc/update_accessory_slowdown()
	slowdown = initial(slowdown)
	for(var/obj/item/clothing/accessory/A in accessories)
		slowdown += A.slowdown

/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return
	var/obj/item/clothing/accessory/A
	if(!LAZYLEN(accessories))
		return
	var/list/choices = list()
	for(var/i in accessories)
		choices[i] = i
	A = show_radial_menu(usr, src, choices)
	if(!usr || usr.stat || !(src in usr))
		return
	if(A)
		remove_accessory(usr,A)
	if(!LAZYLEN(accessories))
		src.verbs -= /obj/item/clothing/proc/removetie_verb
		accessories = null

/obj/item/clothing/emp_act(severity)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()

/obj/item/clothing/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	. = ..()
	if((. == 0) && LAZYLEN(accessories))
		for(var/obj/item/I in accessories)
			var/check = I.handle_shield(user, damage, damage_source, attacker, def_zone, attack_text)

			if(check != 0)	// Projectiles sometimes use negatives IIRC, 0 is only returned if something is not blocked.
				. = check
				break

/obj/item/clothing/strip_menu_options(mob/user)
	. = ..()
	if(!length(accessories))
		return
	.["accessory"] = "Remove Accessory"

/obj/item/clothing/strip_menu_act(mob/user, action)
	. = ..()
	if(.)
		return
	switch(action)
		if("accessory")
			var/list/choices = unique_list_atoms_by_name(accessories)
			var/choice = input(user, "What to take off?", "Strip Accessory") as null|anything in choices
			if(!choice)
				return
			var/mob/M = worn_mob()
			if(!M)
				return
			var/obj/item/clothing/accessory/A = choices[choice]
			if(!(A in accessories))
				return
			add_attack_logs(user, M,  "Started to detach [choice] from [src]")
			M.visible_message(
				SPAN_WARNING("[user] starts to deatch \the [A] from [M]'s [src]!"),
				SPAN_WARNING("[user] starts to detach \the [A] from your [src]!")
			)
			if(!strip_menu_standard_do_after(user, HUMAN_STRIP_DELAY))
				return
			if(!(A in accessories))
				return
			add_attack_logs(user, worn_mob(),  "Detached [choice] from [src]")
			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				M.visible_message(
					SPAN_WARNING("[user] tears \the [A] off of [M]'s [src]!"),
					SPAN_WARNING("[user] tears \the [A] off of your [src]!")
				)
			else
				M.visible_message(
					SPAN_WARNING("[user] detaches \the [A] from [M]'s [src]!"),
					SPAN_WARNING("[user] detaches \the [A] from your [src]!")
				)
			A.on_removed(user)
			accessories -= A
			update_worn_icon()
