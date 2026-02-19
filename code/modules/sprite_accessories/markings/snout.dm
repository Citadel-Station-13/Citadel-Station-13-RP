/datum/sprite_accessory/marking/snout
	abstract_type = /datum/sprite_accessory/marking/snout
	icon = "icons/mob/sprite_accessories/markings/snouts.dmi"
	body_parts = list(BP_HEAD)

// split into three accessories because the code for markings is incredibly ancient
/datum/sprite_accessory/marking/snout/cryptid
	name = "Cryptid Snout"
	id = "marking_cryptid_snout"
	icon_state = "cryptid"
	legacy_use_additive_color_matrix = FALSE
	icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND

/datum/sprite_accessory/marking/snout/cryptid/eyes
	name = "Cryptid Snout (Secondary)"
	id = "marking_cryptid_snout_secondary"
	icon_state = "cryptid_secondary"

/datum/sprite_accessory/marking/snout/cryptid/eyes
	name = "Cryptid Snout (Eyes)"
	id = "marking_cryptid_snout_eyes"
	icon_state = "cryptid_eyes"
