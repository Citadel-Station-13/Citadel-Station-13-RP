//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* ----- Click Triggers ----- */

//* Attack Hand *//

/obj/item/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

	if(clickchain.performer.is_in_inventory(src))
		if(clickchain.performer.is_holding(src))
			if(obj_storage?.allow_open_via_offhand_click && obj_storage.auto_handle_interacted_open(clickchain))
				return . | CLICKCHAIN_DID_SOMETHING
		else
			if(obj_storage?.allow_open_via_equipped_click && obj_storage.auto_handle_interacted_open(clickchain))
				return . | CLICKCHAIN_DID_SOMETHING
	if(!clickchain.performer.is_holding(src))
		if(should_attempt_pickup(clickchain) && attempt_pickup(clickchain.performer))
			return . | CLICKCHAIN_DID_SOMETHING

/obj/item/proc/should_attempt_pickup(datum/event_args/actor/actor)
	return TRUE

/**
 * @params
 * * actor - (optional) person doing it
 * * silent - suppress feedback
 */
/obj/item/proc/should_allow_pickup(datum/event_args/actor/actor, silent)
	if(anchored)
		if(!silent)
			actor?.chat_feedback(
				SPAN_NOTICE("\The [src] won't budge, you can't pick it up!"),
				target = src,
			)
		return FALSE
	return TRUE

/obj/item/proc/attempt_pickup(mob/user)
	. = TRUE
	if (!user)
		return

	if(!should_allow_pickup(new /datum/event_args/actor(user)))
		return FALSE

	if(!CHECK_MOBILITY(user, MOBILITY_CAN_PICKUP))
		user.action_feedback(SPAN_WARNING("You can't do that right now."), src)
		return

	if (hasorgans(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.active_hand % 2)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
		if(!temp)
			to_chat(user, "<span class='notice'>You try to use your hand, but realize it is no longer attached!</span>")
			return

	var/old_loc = src.loc
	var/obj/item/actually_picked_up = src
	var/has_to_drop_to_ground_on_fail = FALSE

	if(isturf(old_loc))
		// if picking up from floor
		throwing?.terminate()
	else if(item_flags & ITEM_IN_STORAGE)
		// trying to take out of backpack
		var/datum/object_system/storage/resolved
		if(istype(loc, /atom/movable/storage_indirection))
			var/atom/movable/storage_indirection/holder = loc
			resolved = holder.parent
		else if(isobj(loc))
			var/obj/obj_loc = loc
			resolved = obj_loc.obj_storage
		if(isnull(resolved))
			item_flags &= ~ITEM_IN_STORAGE
			CRASH("in storage at [loc] ([REF(loc)]) ([loc?.type || "NULL"]) but cannot resolve storage system")
		actually_picked_up = resolved.try_remove(src, user, new /datum/event_args/actor(user))
		// they're in user, but not equipped now. this is so it doesn't touch the ground first.
		has_to_drop_to_ground_on_fail = TRUE

	if(isnull(actually_picked_up))
		to_chat(user, SPAN_WARNING("[src] somehow slips through your grasp. What just happened?"))
		return
	if(!user.put_in_hands(actually_picked_up, INV_OP_NO_MERGE_STACKS, user.active_hand))
		if(has_to_drop_to_ground_on_fail)
			actually_picked_up.forceMove(user.drop_location())
		return
	// success
	if(isturf(old_loc))
		new /obj/effect/temporary_effect/item_pickup_ghost(old_loc, actually_picked_up, user)

//* Drag / Drop *//

/obj/item/OnMouseDrop(atom/over, mob/user, proximity, params)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	if(anchored) // Don't.
		return
	if(user.restrained())
		return	// don't.
		// todo: restraint levels, e.g. handcuffs vs straightjacket
	// todo: this needs to check for user / actor indirection bullshit (e.g. someone does the clickdragging while controlling another mob)
	if(!user.is_in_inventory(src))
		// not being held
		if(!isturf(loc))	// yea nah
			return ..()
		if(user.Adjacent(src))
			// check for equip
			if(istype(over, /atom/movable/screen/actor_hud/inventory/plate/hand))
				var/atom/movable/screen/actor_hud/inventory/plate/hand/H = over
				user.put_in_hand(src, H.hand_index)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			else if(istype(over, /atom/movable/screen/actor_hud/inventory/plate/slot))
				var/atom/movable/screen/actor_hud/inventory/plate/slot/S = over
				user.equip_to_slot_if_possible(src, S.inventory_slot_id)
				return CLICKCHAIN_DO_NOT_PROPAGATE
		// check for slide
		if(Adjacent(over) && user.CanSlideItem(src, over) && (istype(over, /obj/structure/table/rack) || istype(over, /obj/structure/table) || istype(over, /turf)))
			var/turf/old = get_turf(src)
			if(over == old)	// same tile don't bother
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!Move(get_turf(over)))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			//! todo: i want to strangle the mofo who did planes instead of invisibility, which makes it computationally infeasible to check ghost invisibility in get hearers in view
			//! :) FUCK YOU.
			//! this if check is all for you. FUCK YOU.
			if(!isobserver(user))
				user.visible_message(SPAN_NOTICE("[user] slides [src] over."), SPAN_NOTICE("You slide [src] over."), range = MESSAGE_RANGE_COMBAT_SUBTLE)
			log_inventory("[user] slid [src] from [COORD(old)] to [COORD(over)]")
			return CLICKCHAIN_DO_NOT_PROPAGATE
	else
		// being held, check for attempt unequip
		if(istype(over, /atom/movable/screen/actor_hud/inventory/plate/hand))
			var/atom/movable/screen/actor_hud/inventory/plate/hand/H = over
			user.put_in_hand(src, H.hand_index)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(over, /atom/movable/screen/actor_hud/inventory/plate/slot))
			var/atom/movable/screen/actor_hud/inventory/plate/slot/S = over
			user.equip_to_slot_if_possible(src, S.inventory_slot_id)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(over, /turf))
			user.drop_item_to_ground(src)
			return CLICKCHAIN_DO_NOT_PROPAGATE

// funny!
// todo: move to mob files
/mob/proc/CanSlideItem(obj/item/I, turf/over)
	return FALSE

// todo: move to mob files
/mob/living/CanSlideItem(obj/item/I, turf/over)
	return Adjacent(I) && !incapacitated() && !stat && !restrained()

// todo: move to mob files
/mob/observer/dead/CanSlideItem(obj/item/I, turf/over)
	return is_spooky

//* ------ Inhand Triggers ------ *//

//* Attack Self *//

/**
 * Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
 *
 * You should do . = ..() and check ., if it's TRUE, it means a parent proc requested the call chain to stop.
 *
 * todo: please stop overriding this, use on_attack_self.
 * todo: nuke mob/user.
 * todo: rename this to like /activate_inhand, /on_activate_inhand
 * todo: actor is not currently always given.
 *
 * @params
 * * user - The person using us in hand; stop using this, this is deprecated
 * * actor - the event_args that spawned this call
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/attack_self(mob/user, datum/event_args/actor/actor)
	// todo: this should realistically be SHOULD_NOT_OVERRIDE but there's a massive number of overrides (some unnecessary), so this is for a later date
	// SHOULD_NOT_OVERRIDE(TRUE) // may be re-evaluated later
	if(isnull(actor))
		actor = new /datum/event_args/actor(user)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ACTIVATE_INHAND, actor)
	if(signal_return & RAISE_ITEM_ACTIVATE_INHAND_HANDLED)
		return TRUE
	if(on_attack_self(actor))
		return TRUE
	if(interaction_flags_item & INTERACT_ITEM_ATTACK_SELF)
		interact(user)

/**
 * Called after we attack self
 * Used to allow for attack_self to be interrupted by signals in nearly all cases.
 * You should usually override this instead of attack_self.
 *
 * You should do . = ..() and check ., if it's TRUE, it means a parent proc requested the call chain to stop.
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_attack_self(datum/event_args/actor/e_args)
	if(!isnull(obj_cell_slot?.cell) && obj_cell_slot.remove_yank_inhand && obj_cell_slot.interaction_active(src))
		e_args.visible_feedback(
			target = src,
			range = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_NOTICE("[e_args.performer] removes the cell from [src]."),
			audible = SPAN_NOTICE("You hear fasteners falling out and something being removed."),
			otherwise_self = SPAN_NOTICE("You remove the cell from [src]."),
		)
		log_construction(e_args, src, "removed cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
		e_args.performer.put_in_hands_or_drop(obj_cell_slot.remove_cell(e_args.performer))
		return TRUE
	if(!isnull(obj_storage) && obj_storage.allow_quick_empty && obj_storage.allow_quick_empty_via_attack_self)
		var/turf/turf = get_turf(e_args.performer)
		obj_storage.auto_handle_interacted_mass_dumping(e_args, turf)
		return TRUE
	return FALSE

//* Unique Action *//

/**
 * Called when a mob uses our unique aciton.
 *
 * @params
 * * actor - the event_args that spawned this call
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/unique_action(datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE) // may be re-evaluated later
	if(ismob(actor))
		actor = new /datum/event_args/actor(actor)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_UNIQUE_ACTION, actor)
	if(signal_return & RAISE_ITEM_UNIQUE_ACTION_HANDLED)
		return TRUE
	if(on_unique_action(actor))
		return TRUE

/**
 * Called when an unique action is triggered.
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_unique_action(datum/event_args/actor/e_args)
	return FALSE

//* Defensive Toggle *//

/**
 * Called when a mob uses our defensive toggle action.
 *
 * @params
 * * actor - the event_args that spawned this call
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/defensive_toggle(datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE) // may be re-evaluated later
	if(ismob(actor))
		actor = new /datum/event_args/actor(actor)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_DEFENSIVE_TOGGLE, actor)
	if(signal_return & RAISE_ITEM_DEFENSIVE_TOGGLE_HANDLED)
		return TRUE
	if(on_defensive_toggle(actor))
		return TRUE

/**
 * Called on defensive toggle
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_defensive_toggle(datum/event_args/actor/e_args)
	return FALSE

//* Defensive Trigger *//

/**
 * Called when a mob uses our defensive trigger action.
 *
 * @params
 * * actor - the event_args that spawned this call
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/defensive_trigger(datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE) // may be re-evaluated later
	if(ismob(actor))
		actor = new /datum/event_args/actor(actor)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_DEFENSIVE_TRIGGER, actor)
	if(signal_return & RAISE_ITEM_DEFENSIVE_TRIGGER_HANDLED)
		return TRUE
	if(on_defensive_trigger(actor))
		return TRUE

/**
 * Called on defensive trigger.
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_defensive_trigger(datum/event_args/actor/e_args)
	return FALSE
