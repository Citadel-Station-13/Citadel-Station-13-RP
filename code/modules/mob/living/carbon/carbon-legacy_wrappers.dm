//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/proc/legacy_has_taur_tail()
	return istype(resolve_sprite_accessory(SPRITE_ACCESSORY_SLOT_TAIL), /datum/sprite_accessory/tail/legacy_taur)
