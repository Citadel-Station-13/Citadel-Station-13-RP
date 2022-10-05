//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_suits.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_suits.dmi',
		)
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/tank/emergency/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	preserve_item = 1

	var/taurized = FALSE //Easier than trying to 'compare icons' to see if it's a taur suit
	valid_accessory_slots = (ACCESSORY_SLOT_OVER | ACCESSORY_SLOT_ARMBAND)
	restricted_accessory_slots = (ACCESSORY_SLOT_ARMBAND)

//taurized suit support
/obj/item/clothing/suit/equipped(mob/user, slot, flags)
	var/normalize = TRUE

	//Pyramid of doom-y. Improve somehow?
	if(!taurized && slot == SLOT_ID_SUIT && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isTaurTail(H.tail_style))
			var/datum/sprite_accessory/tail/taur/taurtail = H.tail_style
			if(taurtail.suit_sprites && (get_worn_icon_state(SLOT_ID_SUIT) in icon_states(taurtail.suit_sprites)))
				icon_override = taurtail.suit_sprites
				normalize = FALSE
				taurized = TRUE

	if(normalize && taurized)
		icon_override = initial(icon_override)
		taurized = FALSE

	return ..()

/obj/item/clothing/suit/make_worn_icon(var/body_type,var/slot_id,var/inhands,var/default_icon,var/default_layer = 0,var/icon/clip_mask) // Taur suits need to be shifted so its centered on their taur half.
	var/image/standing = ..()
	if(taurized) //Special snowflake var on suits
		standing.pixel_x = -16
		standing.layer = BODY_LAYER + 15 // 15 is above tail layer, so will not be covered by taurbody.
	return standing

// todo: accesosries shouldn't be directly done on this proc, use a helper proc to override
/obj/item/clothing/suit/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	if(!inhands && LAZYLEN(accessories) && taurized)
		for(var/obj/item/clothing/accessory/A in accessories)
			var/image/I = new(A.get_mob_overlay())
			I.pixel_x = 16 //Opposite of the pixel_x on the suit (-16) from taurization to cancel it out and puts the accessory in the correct place on the body.
			MA.overlays += I
		return MA
	else
		return ..()
