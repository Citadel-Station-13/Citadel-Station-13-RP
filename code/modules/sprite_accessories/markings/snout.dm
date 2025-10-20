/datum/sprite_accessory/marking/snout
	abstract_type = /datum/sprite_accessory/marking/snout
	icon = "icons/mob/sprite_accessories/markings/snouts.dmi"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/snout/cryptid
	name = "Cryptid Snout"
	id = "marking_cryptid_snout"
	icon_state = "cryptid_primary"
	extra_overlay = "cryptid_secondary"
	extra_overlay2 = "cryptid_tertiary"
	legacy_use_additive_color_matrix = FALSE
	icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND
