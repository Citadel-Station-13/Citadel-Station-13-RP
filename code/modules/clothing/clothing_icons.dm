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

//HELMET: May have a lighting overlay
/obj/item/clothing/head/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	. = ..()
	if(on && (slot_meta.id == SLOT_ID_HEAD))
		var/bodytype_str = bodytype_to_string(bodytype)
		var/cache_key = "[light_overlay][LAZYACCESS(sprite_sheets, bodytype_str) ? "_[bodytype_str]" : ""]"
		var/image/I = GLOB.light_overlay_cache[cache_key]
		MA.add_overlay(I)

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
