//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Inhand Triggers *//

/**
 * Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
 *
 * You should do . = ..() and check ., if it's TRUE, it means a parent proc requested the call chain to stop.
 *
 * @params
 * * user - The person using us in hand
 *
 * @return TRUE to signal to overrides to stop the chain and do nothing.
 */
/obj/item/proc/attack_self(mob/user)
	// SHOULD_CALL_PARENT(TRUE)
	// attack_self isn't really part of the item attack chain.
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user)
	if(on_attack_self(new /datum/event_args/actor(user)))
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
