/**
 * # Magazines
 *
 * A holder for ammo casings.
 *
 * * Holds logic required to lazy-init casings, be inserted into guns, etc.
 */
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT | ITEM_ENCUMBERS_WHILE_HELD
	slot_flags = SLOT_BELT

	icon = 'icons/system/error_32x32.dmi'
	inhand_state = "syringe_kit"
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	worn_render_flags = WORN_RENDER_INHAND_ALLOW_DEFAULT

	materials_base = list(MAT_STEEL = 500)
	throw_force = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 4
	throw_range = 10
	preserve_item = 1

	//* dynamic config; can be changed at runtime freely
	/// what types of magazines are we?
	///
	/// * this is a bitfield
	var/magazine_type = MAGAZINE_TYPE_NORMAL
	/// the class we ask the gun to render us as
	///
	/// * uses MAGAZINE_CLASS_* flags
	/// * while quirky, guns do reserve the right to filter magazines by class.
	/// * if our requested class isn't on a gun, the gun reserves the right to render us as the default class ('-mag')
	var/magazine_class = MAGAZINE_CLASS_GENERIC

	//* for magazines
	/// magazine type - must match gun's to be fitted into it, if gun's is
	/// setting this to a gun's typepath is allowed, this is an arbitrary field.
	//  todo: impl
	var/magazine_restrict
	// todo: magazine_insert_delay
	// todo: magazine_remove_delay

	//* for speedloaders
	/// inherent speedloader delay, added to gun's speedloaders_delay
	//  todo: impl
	var/speedloader_delay = 0
	/// speedloader type - must match gun's to fit ammo in, if gun's is set
	//  todo: impl
	var/speedloader_restrict

	//* for stripper clips / usage as single loader
	// todo: clip_load_delay
	// todo: clip_restrict

	//* loading *//
	/// sound for loading a piece of ammo
	var/load_sound = 'sound/weapons/flipblade.ogg'

	//* Ammo *//
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
	/// index 1 is the bottom, index ammo_internal.len is the top of the magazine.
	/// peek/draw will peek/draw the last index first all the way to the first, and after that,
	/// ammo_current is considered the 'reserve' pool (as just a number).
	var/list/obj/item/ammo_casing/ammo_internal
	/// caliber - set to typepath to init
	var/ammo_caliber
	/// preloaded ammo type
	var/ammo_preload
	/// if set, only loads ammo matching this restrict value
	///
	/// * ammo by default has their typepath as the restrict value
	/// * ammo can set strings / enums to this too; make sure to #define them.
	var/ammo_restrict
	/// if set and ammo_restrict uses typepaths, doesn't allow subtypes
	var/ammo_restrict_no_subtypes = FALSE
	/// init all contents on initialize instead of lazy-drawing
	///
	/// todo: kill this with fire
	///
	/// * used for things like microbatteries / legacy content
	var/ammo_legacy_init_everything = FALSE

	//* Rendering *//
	/// use default rendering system
	/// in state mode, we will be "[base_icon_state]-[count]", from 0 to count (0 for empty)
	/// in segments mode, we will repeatedly add "[base_icon_state]-ammo" with given offsets.
	///
	/// * overlays moade is not supported;
	///   todo: in overlays mode, we should be "[base_icon_state]-[count]" from 0 to count, overlaid, while we have ammo
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
	/// add a specific overlay, useful for denoting different magazines
	/// that look similar with a stripe
	var/rendering_static_overlay
	/// color the static overlay this way
	var/rendering_static_overlay_color

/obj/item/ammo_magazine/Initialize(mapload)
	. = ..()

	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

	if(!isnull(rendering_static_overlay))
		var/image/static_overlay = image(icon, rendering_static_overlay)
		if(rendering_static_overlay_color)
			static_overlay.color = rendering_static_overlay_color
		add_overlay(static_overlay, TRUE)

	if(ammo_legacy_init_everything)
		instantiate_internal_list()
	if(isnull(ammo_current))
		ammo_current = ammo_max

	update_icon()

/obj/item/ammo_magazine/get_containing_worth(flags)
	. = ..()
	var/obj/item/ammo_casing/ammo_casted = ammo_preload
	. += (isnull(ammo_current)? ammo_max : ammo_current) * initial(ammo_casted.worth_intrinsic)
	for(var/obj/item/ammo_casing/casing in ammo_internal)
		. += casing.get_worth(flags)

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

/obj/item/ammo_magazine/examine(mob/user, dist)
	. = ..()
	var/amount_left = amount_remaining()
	. += "There [(amount_left == 1)? "is" : "are"] [amount_left] round\s left!"

/**
 * transfer as many rounds to another magazine as possible
 *
 * * This proc must do safety checks like caliber. The receiving side does not!
 *
 * @params
 * * receiver - receiving mag
 * * update_icon - update icons for both us and receiver
 *
 * @return rounds transferred
 */
/obj/item/ammo_magazine/proc/transfer_rounds_to(obj/item/ammo_magazine/receiver, update_icon)
	. = 0
	var/amount_missing = receiver.amount_missing()
	// todo: mixed caliber support
	if(!receiver.loads_caliber(ammo_caliber))
		return
	for(var/i in 1 to min(amount_missing, amount_remaining()))
		receiver.push(pop(receiver, TRUE), TRUE)
		++.
	update_icon()
	receiver.update_icon()

/**
 * create casing when we draw into non-instantiated part of the mag
 */
/obj/item/ammo_magazine/proc/instantiate_casing(atom/newloc)
	return new ammo_preload(newloc)

/**
 * instantiate the entire internal ammo list
 *
 * * DO NOT USE UNLESS YOU KNOW WHAT YOU ARE DOING.
 *	caliber = "nsfw"

 * @return rounds created
 */
/obj/item/ammo_magazine/proc/instantiate_internal_list()
	LAZYINITLIST(ammo_internal)
	var/existing = length(ammo_internal)
	if(existing > ammo_max || !ammo_preload)
		ammo_current = 0
		return 0
	var/list/adding = list()
	for(var/i in 1 to min(ammo_current, ammo_max - existing))
		adding += instantiate_casing()
	. = length(adding)
	ammo_current = 0
	ammo_internal += adding

/**
 * can load a round
 *
 * @return null for success, a string describing why not otherwise.
 */
/obj/item/ammo_magazine/proc/why_cant_load_casing(obj/item/ammo_casing/casing)
	if(!loads_caliber(casing.caliber))
		return "mismatched caliber"
	if(ammo_restrict && (ammo_restrict_no_subtypes ? casing.type != ammo_restrict : !istype(casing, ammo_restrict)))
		return "mismatched ammo"

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
	var/obj/item/ammo_casing/casing = pop(src)
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
	var/obj/item/ammo_casing/casing = pop(src)
	e_args.performer.put_in_hands_or_drop(casing)

/obj/item/ammo_magazine/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = I
		if(!isnull(why_cant_load_casing(casing)))
			to_chat(user, SPAN_WARNING("[I] doesn't fit into [src]!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!amount_missing())
			to_chat(user, SPAN_WARNING("[src] is full."))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!user.temporarily_remove_from_inventory(casing, user = user))
			to_chat(user, SPAN_WARNING("[I] is stuck to your hand!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!push(casing))
			to_chat(user, SPAN_WARNING("You fail to insert [I] into [src]!"))
			return
		// todo: variable load sounds
		playsound(src, load_sound, 50, 1)
		to_chat(user, SPAN_NOTICE("You put [I] into [src]"))
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	else if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/enemy = I
		var/amount_transferred = enemy.transfer_rounds_to(src, update_icon = TRUE)
		if(!amount_transferred)
			to_chat(user, SPAN_WARNING("You fail to transfer any rounds from [I] to [src]."))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else
			to_chat(user, SPAN_NOTICE("You transfer [amount_transferred] rounds from [I] to [src]."))
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	else
		return ..()

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
	var/needed
	if((needed = amount_remaining()) >= ammo_max)
		user?.action_feedback(SPAN_WARNING("[src] is full."), src)
		return
	// todo: de-instantiate unmodified rounds
	for(var/obj/item/ammo_casing/casing in where)
		if(. > needed)
			break
		if(!casing.is_loaded())
			continue
		if(!isnull(why_cant_load_casing(casing)))
			continue
		if(!push(casing, TRUE))
			continue
		++.
	if(.)
		update_icon()
		user?.action_feedback(SPAN_NOTICE("You collect [.] rounds."), src)
	else
		user?.action_feedback(SPAN_WARNING("You fail to collect anything."), src)

/obj/item/ammo_magazine/update_icon(updates)
	if(rendering_system == GUN_RENDERING_DISABLED)
		return ..()
	cut_overlays()
	var/count = CEILING(amount_remaining() / ammo_max * rendering_count, 1)
	if(count == rendering_count_current)
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

//*                 Accessors - Top of Mag                   *//
//* This is the preferred way to interact with a magazine.   *//

/**
 * peek top ammo casing
 */
/obj/item/ammo_magazine/proc/peek()
	RETURN_TYPE(/obj/item/ammo_casing)
	if(!length(ammo_internal))
		// list empty, see if we have one to inject
		if(!ammo_current || !ammo_preload)
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
/obj/item/ammo_magazine/proc/pop(atom/newloc, no_update)
	RETURN_TYPE(/obj/item/ammo_casing)
	if(length(ammo_internal))
		// list filled
		. = ammo_internal[length(ammo_internal)]
		--ammo_internal.len
		update_icon()
		return
	// list empty
	if(!ammo_current || !ammo_preload)
		return
	. = instantiate_casing(newloc)
	--ammo_current
	if(!no_update)
		update_icon()

/**
 * put a casing into top
 *
 * @return TRUE/FALSE on success/failure
 */
/obj/item/ammo_magazine/proc/push(obj/item/ammo_casing/casing, no_update)
	if(amount_remaining() >= ammo_max)
		return FALSE
	LAZYADD(ammo_internal, casing)
	if(casing.loc != src)
		casing.forceMove(src)
	if(!no_update)
		update_icon()
	return TRUE

/**
 * replace the first spent casing from the top or insert top depending on if there's room
 *
 * @return TRUE/FALSE on success/failure
 */
/obj/item/ammo_magazine/proc/push_resupply(obj/item/ammo_casing/casing, no_update, atom/transfer_old_to)
	// try to resupply
	for(var/i in length(ammo_internal) to 1 step -1)
		var/obj/item/ammo_casing/loaded = ammo_internal[i]
		if(loaded.is_loaded())
			continue
		loaded.forceMove(transfer_old_to || drop_location())
		ammo_internal[i] = casing
		if(casing.loc != src)
			casing.forceMove(src)
		return TRUE
	if(!no_update)
		update_icon()
	// try to insert
	return push(casing, no_update)

//* Ammo - Getters *//

/obj/item/ammo_magazine/proc/is_full()
	return amount_remaining() >= ammo_max

/obj/item/ammo_magazine/proc/amount_remaining(live_only)
	if(!live_only)
		return ammo_current + length(ammo_internal)
	. = ammo_current
	for(var/obj/item/ammo_casing/casing as anything in ammo_internal)
		if(casing.is_loaded())
			.++

/obj/item/ammo_magazine/proc/amount_missing(live_only)
	return ammo_max - amount_remaining(live_only)

/**
 * Gets the predicted typepath of a casing a given index from the top, where 1 is the top.
 *
 * * Real casings are read.
 * * Fake casings are predicted from the type that would have been lazy-generated.
 * * Null if something isn't there / left
 */
/obj/item/ammo_magazine/proc/peek_path_of_position(index)
	if(index > length(ammo_internal))
		return (index - length(ammo_internal)) >= ammo_current ? ammo_preload : null
	return ammo_internal[length(ammo_internal) - index]?.type

//* Caliber *//

/obj/item/ammo_magazine/proc/loads_caliber(datum/ammo_caliber/caliberlike)
	var/datum/ammo_caliber/ours = resolve_caliber(ammo_caliber)
	var/datum/ammo_caliber/theirs = resolve_caliber(caliberlike)
	return ours.equivalent(theirs)
