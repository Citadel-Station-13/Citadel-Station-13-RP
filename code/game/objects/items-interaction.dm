//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Inhand Triggers *//

/**
 * Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
 *
 * You should do . = ..() and check ., if it's TRUE, it means a parent proc requested the call chain to stop.
 *
 * todo: please stop overriding this, use on_attack_self.
 * todo: nuke mob/user.
 * todo: rename this to like /activate_inhand, /on_activate_inhand
 *
 * @params
 * * actor - the event_args that spawned this call
 * * user - The person using us in hand; stop using this, this is deprecated
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/attack_self(mob/user, datum/event_args/actor/actor = new /datum/event_args/actor(user))
	// todo: this should realistically be SHOULD_NOT_OVERRIDE but there's a massive number of overrides (some unnecessary), so this is for a later date
	// SHOULD_NOT_OVERRIDE(TRUE) // may be re-evaluated later
	SEND_SIGNAL(src, COMSIG_ITEM_ACTIVATE_INHAND, actor)
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
	SEND_SIGNAL(src, COMSIG_ITEM_UNIQUE_ACTION, actor)
	if(on_unique_action(actor))
		return TRUE

/**
 * Called when an unique action is triggered.
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_unique_action(datum/event_args/actor/e_args)
	return FALSE

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
	SEND_SIGNAL(src, COMSIG_ITEM_DEFENSIVE_TOGGLE, actor)
	if(on_defensive_toggle(actor))
		return TRUE

/**
 * Called on defensive toggle
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_defensive_toggle(datum/event_args/actor/e_args)
	return FALSE

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
	SEND_SIGNAL(src, COMSIG_ITEM_DEFENSIVE_TRIGGER, actor)
	if(on_defensive_trigger(actor))
		return TRUE

/**
 * Called on defensive trigger.
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/on_defensive_trigger(datum/event_args/actor/e_args)
	return FALSE
