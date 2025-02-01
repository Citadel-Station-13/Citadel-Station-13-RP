//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/human/should_hide_sprite_accessory(slot, datum/sprite_accessory/resolved)
	switch(slot)
		if(SPRITE_ACCESSORY_SLOT_EARS)
			if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
				return FALSE
		if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
			if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHAIR))
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_HAIR)
			if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_HORNS)
			if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
				return TRUE
			if(hiding_horns && resolved.can_be_hidden)
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_TAIL)
			if(hiding_tail && resolved.can_be_hidden)
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_WINGS)
			if(hiding_wings && resolved.can_be_hidden)
				return TRUE
	#warn impl
	return ..()

/mob/living/carbon/human/postprocess_sprite_accessory(slot, datum/sprite_accessory/resolved, rendered)
	..()
	switch(slot)
		if(
			SPRITE_ACCESSORY_SLOT_EARS,
			SPRITE_ACCESSORY_SLOT_FACEHAIR,
			SPRITE_ACCESSORY_SLOT_HAIR,
			SPRITE_ACCESSORY_SLOT_HORNS
		)
			if(islist(rendered))
				for(var/image/I as anything in rendered)
					I.pixel_y += head_spriteacc_offset
					I.alpha = head_organ.hair_opacity
			else
				var/image/I = rendered
				I.pixel_y += head_spriteacc_offset
				I.alpha = head_organ.hair_opacity
