/obj/item/clothing/_inv_return_attached()
	if(!accessories)
		return ..()
	. = ..()
	return islist(.)? (. + accessories) : (list(.) + accessories)

/obj/item/clothing/proc/is_accessory()
	return is_accessory

/obj/item/clothing/worn_mob()
	return isnull(accessory_host)? ..() : accessory_host.worn_mob()

/obj/item/clothing/update_worn_icon()
	if(accessory_host)
		return accessory_host.update_worn_icon()
	return ..()

/obj/item/clothing/get_carry_weight()
	. = ..()
	var/tally = 0
	for(var/obj/item/I as anything in accessories)
		tally += I.get_carry_weight()
	tally *= (1 - weight_compensation_mult)
	tally = max(0, tally - weight_compensation_flat)
	. += tally

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

/obj/item/clothing/render_additional(mob/M, icon/icon_used, state_used, layer_used, dim_x, dim_y, align_y, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	. = ..()
	var/list/accessory_overlays = render_worn_accessories(M, inhands, slot_meta, layer_used, bodytype)
	if(!isnull(accessory_overlays))
		. += accessory_overlays

/**
 * Renders accessories. Returns a list of mutable appearances or images, or null.
 *
 * @params
 * * M - wearer (optional)
 * * inhands - are we rendering for inhands?
 * * slot_meta - slot
 * * bodytype - bodytype
 */
/obj/item/clothing/proc/render_worn_accessories(mob/M, inhands, datum/inventory_slot_meta/slot_meta, layer_used, bodytype)
	RETURN_TYPE(/list)
	if(!length(accessories))
		return
	if(inhands)
		return // no support for now
	. = list()
	for(var/obj/item/clothing/C in accessories)
		if(!C.accessory_renders)
			continue
		var/overlays = C.render_accessory_worn(M, inhands, slot_meta, layer_used, bodytype)
		if(!overlays)
			continue
		. += overlays

/**
 * renders the overlay we apply to an item we're an accessory of.
 */
/obj/item/clothing/proc/render_accessory_inv()
	if(accessory_render_legacy)
		var/old
		if(istype(src, /obj/item/clothing/accessory))
			var/obj/item/clothing/accessory/A = src
			old = A.get_inv_overlay()
		return old
	var/mutable_appearance/MA = mutable_appearance(icon, accessory_inv_state || icon_state)
	MA.dir = SOUTH
	return MA

/**
 * Renders mob appearance for us as an accessory. Returns an image, or list of images.
 */
/obj/item/clothing/proc/render_accessory_worn(mob/M, inhands, datum/inventory_slot_meta/slot_meta, layer_used, bodytype)
	if(accessory_render_legacy)
		var/mutable_appearance/old
		if(istype(src, /obj/item/clothing/accessory))
			var/obj/item/clothing/accessory/A = src
			old = A.get_mob_overlay()
			if(!isnull(old) && old.plane == FLOAT_PLANE)
				old.layer = layer_used + BODY_LAYER + 0.1
		return old
	var/list/mutable_appearance/rendered = render_mob_appearance(M, accessory_render_specific? resolve_inventory_slot_meta(/datum/inventory_slot_meta/abstract/use_one_for_accessory) : slot_meta, bodytype)

	// sigh, fixup
	if(isnull(rendered))
		return
	else if(!islist(rendered))
		rendered = list(rendered)

	for(var/mutable_appearance/MA in rendered)
		// fixup layer, but only if it's attached to mob; this is shitcode but the auril players have snipers outside my house, i'll refactor this later.
		if(MA.plane == FLOAT_PLANE)
			MA.layer = layer_used + BODY_LAYER + 0.1  // ughhh, need way to override later.
		// sigh, legacy shit
		if(istype(accessory_host, /obj/item/clothing/suit))
			var/obj/item/clothing/suit/S = accessory_host
			if(S.taurized)
				MA.pixel_x += 16

	return rendered

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

/obj/item/clothing/attack_hand(mob/user, list/params)
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
	add_obj_verb(src, /obj/item/clothing/proc/removetie_verb)
	update_worn_icon()
	update_carry_weight()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!LAZYLEN(accessories) || !(A in accessories))
		return

	A.on_removed(user)
	accessories -= A
	update_worn_icon()
	update_carry_weight()

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
		remove_obj_verb(src, /obj/item/clothing/proc/removetie_verb)
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
