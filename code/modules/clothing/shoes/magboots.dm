/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	clothing_flags = PHORONGUARD
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "magboots", SLOT_ID_LEFT_HAND = "magboots")
	species_restricted = null
	force = 3
	overshoes = 1
	shoes_under_pants = -1	//These things are huge
	preserve_item = 1
	var/magpulse = 0
	var/slowdown_on = 3
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"
	step_volume_mod = 1.3
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	slowdown = worn_over? max(SHOES_SLOWDOWN, worn_over.slowdown): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown += slowdown_on

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		clothing_flags &= ~NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		if(icon_base) icon_state = "[icon_base]0"
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		clothing_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		if(icon_base) icon_state = "[icon_base]1"
		to_chat(user, "You enable the mag-pulse traction system.")
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()

/obj/item/clothing/shoes/magboots/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	if(slot != SLOT_ID_SHOES)
		return FALSE

	if(!istype(I, /obj/item/clothing/shoes))
		return FALSE

	var/obj/item/clothing/shoes/S = I

	return !S.overshoes

/obj/item/clothing/shoes/magboots/equipped(mob/user, slot, flags)
	. = ..()
	set_slowdown()

/obj/item/clothing/shoes/magboots/unequipped(mob/user, slot, flags)
	. = ..()
	set_slowdown()

/obj/item/clothing/shoes/magboots/examine(mob/user)
	. = ..()
	var/state = "disabled"
	if(clothing_flags & NOSLIP)
		state = "enabled"
	. += "Its mag-pulse traction system appears to be [state]."
/obj/item/clothing/shoes/magboots/vox

	desc = "A pair of heavy, jagged armoured foot pieces, seemingly suitable for a velociraptor."
	name = "vox magclaws"
	item_state = "boots-vox"
	icon_state = "boots-vox"
	atom_flags = PHORONGUARD
	species_restricted = list(SPECIES_VOX)

	action_button_name = "Toggle the magclaws"

/obj/item/clothing/shoes/magboots/vox/attack_self(mob/user)
	if(src.magpulse)
		clothing_flags &= ~NOSLIP
		magpulse = 0
		REMOVE_TRAIT(src, TRAIT_ITEM_NODROP, MAGBOOT_TRAIT)
		to_chat(user, "You relax your deathgrip on the flooring.")
	else
		//make sure these can only be used when equipped.
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/H = user
		if (H.shoes != src)
			to_chat(user, "You will have to put on the [src] before you can do that.")
			return

		clothing_flags |= NOSLIP
		magpulse = 1
		ADD_TRAIT(src, TRAIT_ITEM_NODROP, MAGBOOT_TRAIT)
		to_chat(user, "You dig your claws deeply into the flooring, bracing yourself.")
	user.update_action_buttons()

//In case they somehow come off while enabled.
/obj/item/clothing/shoes/magboots/vox/dropped(mob/user, flags, atom/newLoc)
	..()
	if(src.magpulse)
		user.visible_message("The [src] go limp as they are removed from [usr]'s feet.", "The [src] go limp as they are removed from your feet.")
		clothing_flags &= ~NOSLIP
		magpulse = 0
		REMOVE_TRAIT(src, TRAIT_ITEM_NODROP, MAGBOOT_TRAIT)

/obj/item/clothing/shoes/magboots/vox/examine(mob/user)
	. = ..()
	if(magpulse)
		. += "It would be hard to take these off without relaxing your grip first."
		//theoretically this message should only be seen by the wearer when the claws are equipped.

/obj/item/clothing/shoes/magboots/advanced
	name = "advanced magboots"
	icon_state = "advmag0"
	slowdown_on = 0
	icon_base = "advmag"

/obj/item/clothing/shoes/magboots/syndicate
	name = "blood red magboots"
	desc = "Prior to its dissolution, many Syndicate agents were tasked with stealing NanoTrasen's prototype advanced magboots. Reverse engineering these rare tactical boots was achieved shortly before the end of the conflict."
	icon_state = "syndiemag0"
	icon_base = "syndiemag"
	slowdown_on = 0
