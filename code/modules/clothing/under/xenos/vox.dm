/obj/item/clothing/under/vox
	has_sensor = 0
	species_restricted = list(SPECIES_VOX)
	starting_accessories = list(/obj/item/clothing/accessory/storage/vox)	// Dont' start with a backback, so free webbing
	flags = PHORONGUARD

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon_state = "vox-casual-1"
	item_state = "vox-casual-1"
	body_parts_covered = LEGS

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon_state = "vox-casual-2"
	item_state = "vox-casual-2"

//Vox Pressure Suits
/obj/item/clothing/under/pressuresuit
	species_restricted = list(SPECIES_VOX)
	name = "vox pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Now in classic grey!"
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_override = 'icons/mob/species/vox/uniform.dmi'
	flags_inv = HIDEGLOVES|HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags = PHORONGUARD

/obj/item/clothing/under/pressuresuit/voxcivassistant
	name = "assistant pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Now in classic grey!"
	icon_state = "vox-civ-assistant"
	item_state = "vox-civ-assistant"
