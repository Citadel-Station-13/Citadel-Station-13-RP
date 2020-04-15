// Since facemask have adjusted sprite, why not use it?


/obj/item/clothing/mask/gas/half
	var/hanging = 0

/obj/item/clothing/mask/gas/half/proc/adjust_mask(mob/user)
	if(usr.canmove && !usr.stat)
		src.hanging = !src.hanging
		if (src.hanging)
			gas_transfer_coefficient = 1
			gas_filter_strength = 0
			body_parts_covered = body_parts_covered & ~FACE
			item_flags = item_flags & ~BLOCK_GAS_SMOKE_EFFECT & ~AIRTIGHT
			armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
			icon_state = "halfgas_up"
			to_chat(usr, "Your mask is now hanging on your neck.")
		else
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			gas_filter_strength = initial(gas_filter_strength)
			body_parts_covered = initial(body_parts_covered)
			item_flags = initial(item_flags)
			armor = initial(armor)
			icon_state = initial(icon_state)
			to_chat(usr, "You pull the mask up to cover your face.")
		update_clothing_icon()

/obj/item/clothing/mask/gas/half/verb/toggle()
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	adjust_mask(usr)

/obj/item/clothing/mask/gas/half/AltClick()
	adjust_mask(usr)
