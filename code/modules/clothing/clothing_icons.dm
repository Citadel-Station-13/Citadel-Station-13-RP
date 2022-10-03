/obj/item/clothing/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	. = ..()
	if(inhands)
		return
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			MA.overlays += A.get_mob_overlay()

/obj/item/clothing/render_apply_blood(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	. = ..()
	if(inhands)
		return
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		MA.overlays += bloodsies

//UNIFORM: Always appends "_s" to iconstate, stupidly.
/obj/item/clothing/under/get_worn_icon_state(var/slot_id)
	var/state2use = ..()
	state2use += "_s"
	return state2use

//HELMET: May have a lighting overlay
/obj/item/clothing/head/make_worn_icon(var/body_type,var/slot_id,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null)
	var/image/standing = ..()
	if(on && slot_id == SLOT_ID_HEAD)
		var/cache_key = "[light_overlay][LAZYACCESS(sprite_sheets,body_type) ? "_[body_type]" : ""]"
		if(standing && GLOB.light_overlay_cache[cache_key])
			standing.add_overlay(GLOB.light_overlay_cache[cache_key])
	return standing

//SUIT: Blood state is slightly different
/obj/item/clothing/suit/render_apply_blood(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	. = ..()
	if(inhands)
		return
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = "[blood_overlay_type]blood")
		bloodsies.color		= blood_color
		MA.overlays += bloodsies
