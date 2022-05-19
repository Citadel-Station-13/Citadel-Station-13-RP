/obj/item/clothing/apply_accessories(var/image/standing)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			standing.add_overlay(A.get_mob_overlay())

/obj/item/clothing/apply_blood(var/image/standing)
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)

//UNIFORM: Always appends "_s" to iconstate, stupidly.
/obj/item/clothing/under/get_worn_icon_state(var/slot_id)
	var/state2use = ..()
	state2use += "_s"
	return state2use

//HELMET: May have a lighting overlay
/obj/item/clothing/head/make_worn_icon(var/body_type,var/slot_id,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null)
	var/image/standing = ..()
	if(on && slot_id == /datum/inventory_slot_meta/inventory/head)
		var/cache_key = "[light_overlay][LAZYACCESS(sprite_sheets,body_type) ? "_[body_type]" : ""]"
		if(standing && GLOB.light_overlay_cache[cache_key])
			standing.add_overlay(GLOB.light_overlay_cache[cache_key])
	return standing

//SUIT: Blood state is slightly different
/obj/item/clothing/suit/apply_blood(var/image/standing)
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = "[blood_overlay_type]blood")
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)
