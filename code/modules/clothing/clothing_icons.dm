/obj/item/clothing/apply_accessories(mutable_appearance/standing)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			standing.add_overlay(A.get_mob_overlay())

/obj/item/clothing/apply_blood(mutable_appearance/standing)
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)

//UNIFORM: Always appends "_s" to iconstate, stupidly.
/obj/item/clothing/under/get_worn_icon_state(slot_name)
	var/state2use = ..()
	state2use += "_s"
	return state2use

//HELMET: May have a lighting overlay
/obj/item/clothing/head/build_worn_icon(body_type, slot_name, inhands, default_icon, default_layer)
	var/mutable_appearance/standing = ..()
	if(on && slot_name == slot_head_str)
		var/cache_key = "[light_overlay][LAZYACCESS(sprite_sheets,body_type) ? "_[body_type]" : ""]"
		if(standing && light_overlay_cache[cache_key])
			standing.add_overlay(light_overlay_cache[cache_key])
	return standing

//SUIT: Blood state is slightly different
/obj/item/clothing/suit/apply_blood(mutable_appearance/standing)
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = "[blood_overlay_type]blood")
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)
