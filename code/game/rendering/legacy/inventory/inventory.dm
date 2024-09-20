/atom/movable/screen/inventory
	name = "inv box"

/atom/movable/screen/inventory/proc/check_inventory_usage(mob/user)
	if(!user.canClick())
		return FALSE
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_STORAGE) || user.stat)
		return FALSE
	return TRUE

/atom/movable/screen/inventory/plate/slot
	/// the ID of this slot
	var/slot_id

/atom/movable/screen/inventory/plate/slot/Click()
	if(!check_inventory_usage(usr))
		return

	// usr.attack_ui(slot_id)

// Hand slots are special to handle the handcuffs overlay
/atom/movable/screen/inventory/plate/hand
	/// hand index
	var/index
	/// are we the left hand
	var/is_left_hand = FALSE
	/// current handcuffed overlay
	var/image/handcuff_overlay

/atom/movable/screen/inventory/plate/hand/Click()
	usr.activate_hand_of_index(index)

#warn parse above
