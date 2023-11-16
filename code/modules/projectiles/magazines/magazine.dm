//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = ".357"
	icon = 'icons/obj/ammo.dmi'
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT | ITEM_ENCUMBERS_WHILE_HELD
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	materials_base = list(MAT_STEEL = 500)
	throw_force = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	preserve_item = 1

	//* dynamic config; can be changed at runtime freely
	/// is this a speedloader / supports being a speedloader?
	/// speedloader can only be used with internal ammo guns, and only if they allow speedloaders
	var/is_speedloader = FALSE
	/// is this a magazine despite being a speedloader? if set to TRUE, this still works with
	/// guns that accept magazines, even if it's a speedloader
	var/is_magazine_regardless = FALSE

	//* for magazines
	/// magazine type - must match gun's to be fitted into it, if gun's is
	/// setting this to a gun's typepath is allowed, this is an arbitrary field.
	var/magazine_type

	//* for speedloaders
	/// inherent speedloader delay, added to gun's speedloaders_delay
	var/speedloader_delay = 0
	/// speedloader type - must match gun's to fit ammo in, if gun's is set
	var/speedloader_type

	//* ammo storage
	/// max ammo in us
	var/ammo_max = 7
	/// currently stored ammo; defaults to ammo_max if unset
	/// this is used to detect base material costs too, so
	/// if this is not set properly or you're abusing ammo_internal, bad stuff happens
	//  todo: way to use a different count for base material cost detection
	var/ammo_current
	/// can bullets be removed?
	var/ammo_removable = TRUE
	/// ammo list
	/// only instantiated when we need to for memory reasons
	/// should not be directly manipulated unless you know what you're doing.
	///
	/// spec:
	/// ammo_preload is what 'current ammo' is, type-wise
	/// ammo_internal is considered the list of 1 to n casings infront of ammo_current.
	/// index 1 is the bottom, index ammo_internal.len is the top of the magazin.e
	/// peek/draw will peek/draw the last index first all the way to the first, and after that,
	/// ammo_current is considered the 'reserve' pool (as just a number).
	var/list/ammo_internal
	/// caliber - set to typepath to init
	var/ammo_caliber
	/// preloaded ammo type
	var/ammo_preload
	/// if set, only loads ammo of this type
	var/ammo_type
	/// if set, doesn't allow subtypes
	var/ammo_picky = FALSE

	//* Rendering
	/// use default rendering system
	/// in state moide, we will be "[base_icon_state]-[count]", from 0 to count (0 for empty)
	/// in segements mode, we will repeatedly add "[base_icon_state]-ammo" with given offsets.
	/// overlay mode is not supported
	var/rendering_system = GUN_RENDERING_DISABLED
	/// number of states
	var/rendering_count = 0
	/// used internally to avoid appearance churn
	VAR_PRIVATE/rendering_count_current
	/// for offset mode: initial x offset
	var/rendering_segment_x_start = 0
	/// for offset mode: initial y offset
	var/rendering_segment_y_start = 0
	/// for offset mode: x offset
	var/rendering_segment_x_offset = 0
	/// for offset mode: y offset
	var/rendering_segment_y_offset = 0
	/// display special "[base_icon_state]-empty" if count == 0
	var/rendering_segment_use_empty = FALSE
	/// add a specific overlay as "[base_icon_state]-[state]", useful for denoting different magazines
	/// that look similar with a stripe
	var/rendering_static_overlay

/obj/item/ammo_magazine/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	if(!isnull(rendering_static_overlay))
		add_overlay(rendering_static_overlay, TRUE)
	update_icon()

/obj/item/ammo_magazine/examine(mob/user, dist)
	. = ..()
	var/amount_left = amount_remaining()
	. += "There [(amount_left == 1)? "is" : "are"] [amount_left] round\s left!"

/**
 * peek top ammo casing
 */
/obj/item/ammo_magazine/proc/peek_top()
	if(!length(ammo_internal))
		// list empty, see if we have one to inject
		if(!ammo_current)
			// we're empty
			return
		var/obj/item/ammo_casing/created = instantiate_casing()
		if(isnull(ammo_internal))
			ammo_internal = list(created)
		else
			ammo_internal += created
		--ammo_current
		return created
	return ammo_internal[length(ammo_internal)]

/**
 * get and eject top casing
 */
/obj/item/ammo_magazine/proc/draw_top()
	if(length(ammo_internal))
		// list filled
		. = ammo_internal[length(ammo_internal)]
		--ammo_internal.len
		update_icon()
		return
	// list empty
	if(!ammo_current)
		return
	. = instantiate_casing()
	--ammo_current
	update_icon()

/**
 * put a casing into top
 */
/obj/item/ammo_magazine/proc/insert_top(obj/item/ammo_casing/casing)
	#warn impl
	update_icon()

/**
 * replace the first spent casing or insert top depending on if there's room
 */
/obj/item/ammo_magazine/proc/resupply_top(obj/item/ammo_casing/casing, replace_spent)
	#warn impl
	update_icon()

/**
 * transfer as many rounds to another magazine as possible
 *
 * @return rounds transferred
 */
/obj/item/ammo_magazine/proc/transfer_rounds_to(obj/item/ammo_magazine/receiver, force)
	#warn impl
	update_icon()
	receiver.update_icon()

/**
 * create casing when we draw into non-instantiated part of the mag
 */
/obj/item/ammo_magazine/proc/instantiate_casing()
	return new ammo_preload

/**
 * instantiate the entire internal ammo list
 *
 * DO NOT USE UNLESS YOU KNOW WHAT YOU ARE DOING.
 *
 * @return rounds created
 */
/obj/item/ammo_magazine/proc/instantiate_internal_list()
	var/existing = length(ammo_internal)
	if(existing > ammo_max)
		ammo_current = 0
		return
	LAZYINITLIST(ammo_internal)
	var/list/adding = list()
	for(var/i in 1 to min(ammo_current, ammo_max - existing))
		adding += instantiate_casing()
	. = length(adding)
	ammo_current = 0
	ammo_internal += adding

/**
 * can load a round
 */
/obj/item/ammo_magazine/proc/can_load_casing(obj/item/ammo_casing/casing)
	return casing.caliber == ammo_caliber

/obj/item/ammo_magazine/detect_material_base_costs()
	. = ..()
	if(isnull(ammo_preload))
		return
	var/shell_amount = isnull(ammo_current)? ammo_max : ammo_current
	if(!shell_amount)
		return
	var/obj/item/ammo_casing/casing = new ammo_preload
	if(!istype(casing))
		qdel(casing)
		return
	var/list/adding = casing.detect_material_base_costs()
	qdel(casing)
	for(var/key in adding)
		.[key] += adding[key] * shell_amount

#warn below

/obj/item/ammo_magazine/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = I
		if(!can_load_casing(casing))
			to_chat(user, SPAN_WARNING("[I] doesn't fit into [src]!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!amount_missing())
			to_chat(user, SPAN_WARNING("[src] is full."))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!user.temporarily_remove_from_inventory(casing, user = user))
			to_chat(user, SPAN_WARNING("[I] is stuck to your hand!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		insert_top(casing)
		// todo: variable load sounds
		playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	else if(istype(I, /obj/item/ammo_magazine))
		#warn impl
	else
		return ..()

/obj/item/ammo_magazine/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(!ammo_removable)
		return
	. = TRUE
	if(!amount_remaining())
		e_args.chat_feedback(SPAN_WARNING("[src] is empty."), src)
		return
	e_args.chat_feedback(SPAN_NOTICE("You remove a round from [src]."), src)
	var/obj/item/ammo_casing/casing = draw_top()
	e_args.performer.put_in_hands_or_drop(casing)

/obj/item/ammo_magazine/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
	if(!e_args.performer.is_holding_inactive(src))
		return
	if(!ammo_removable)
		return
	. = TRUE
	if(!amount_remaining())
		e_args.chat_feedback(SPAN_WARNING("[src] is empty."), src)
		return
	e_args.chat_feedback(SPAN_NOTICE("You remove a round from [src]."), src)
	var/obj/item/ammo_casing/casing = draw_top()
	e_args.performer.put_in_hands_or_drop(casing)

/**
 * puts a round into us, if possible
 * does not update icon by default!
 */
/obj/item/ammo_magazine/proc/load_casing(obj/item/ammo_casing/casing, replace_spent, update_icon)
	if(caliber)
		if(casing.caliber != caliber)
			return FALSE
	else
		if(casing.type != ammo_type)
			return FALSE
	if(length(stored_ammo) < ammo_max)
		// add
		casing.forceMove(src)
		if(QDELETED(casing))
			return FALSE
		stored_ammo += casing
		if(update_icon)
			update_icon()
		return TRUE
	else if(replace_spent)
		// replace
		var/obj/item/ammo_casing/enemy
		for(var/i in 1 to length(stored_ammo))
			enemy = stored_ammo[i]
			if(enemy.loaded())
				continue
			// this is the one
			casing.forceMove(src)
			if(QDELETED(casing))
				return FALSE
			stored_ammo[i] = casing
			// kick 'em out
			enemy.forceMove(drop_location())
			if(update_icon)
				update_icon()
			return TRUE
	return FALSE

/**
 * quickly gathers stuff from turf
 * does not sainty check
 *
 * @params
 * * where - the turf
 * * user - (optional) who's doing it
 *
 * @return number of rounds gathered
 */
/obj/item/ammo_magazine/proc/quick_gather(turf/where, mob/user)
	. = 0
	if(full())
		user?.action_feedback(SPAN_WARNING("[src] is full."), src)
		return
	for(var/obj/item/ammo_casing/casing in where)
		if(length(stored_ammo) >= ammo_max)
			break
		if(!casing.loaded())
			continue
		if(!load_casing(casing, FALSE))
			continue
		++.
	if(.)
		update_icon()
		user?.action_feedback(SPAN_NOTICE("You collect [.] rounds."), src)
	else
		user?.action_feedback(SPAN_WARNING("You fail to collect anything."), src)

#warn above

/obj/item/ammo_magazine/proc/is_full()
	return amount_remaining() >= ammo_max

/obj/item/ammo_magazine/proc/amount_remaining(live_only)
	if(!live_only)
		return ammo_current + length(ammo_internal)
	. = ammo_current
	for(var/obj/item/ammo_casing/casing as anything in ammo_internal)
		if(casing.loaded())
			.++

/obj/item/ammo_magazine/proc/amount_missing(live_only)
	return ammo_max - amount_remaining(live_only)

/obj/item/ammo_magazine/update_icon(updates)
	if(rendering_system == GUN_RENDERING_DISABLED)
		return ..()
	cut_overlays()
	var/count = CEILING(amount_remaining() / ammo_max * rendering_count, 1)
	if(count != rendering_count_current)
		return
	rendering_count_current = count
	switch(rendering_system)
		if(GUN_RENDERING_STATES)
			icon_state = "[base_icon_state]-[count]"
		if(GUN_RENDERING_SEGMENTS)
			if(count == 0)
				if(rendering_segment_use_empty)
					add_overlay("[base_icon_state]-empty")
			else
				var/px = rendering_segment_x_start
				var/py = rendering_segment_y_start
				for(var/i in 1 to count)
					var/image/seg = image(icon, icon_state = "[base_icon_state]-ammo")
					seg.pixel_x = px
					seg.pixel_y = py
					px += rendering_segment_x_offset
					py += rendering_segment_y_offset
	return ..()


