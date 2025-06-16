/**
 * Vox ONLY clothing
 * I think this should not exist. We should consider putting these under the regular clothing files and not a /vox path if the new render icon system supports non-human exclusivity.
 */

/obj/item/clothing/under/vox
	has_sensors = UNIFORM_HAS_NO_SENSORS
	species_restricted = list(SPECIES_VOX)
	starting_accessories = list(/obj/item/clothing/accessory/storage/vox)	// Dont' start with a backback, so free webbing
	atom_flags = PHORONGUARD

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon = 'icons/clothing/uniform/casual/vox/vox-casual-1.dmi'
	icon_state = "vox-casual-1"
	body_cover_flags = LEGS
	worn_bodytypes = BODYTYPES(BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon = 'icons/clothing/uniform/casual/vox/vox-casual-2.dmi'
	icon_state = "vox-casual-2"
	worn_bodytypes = BODYTYPES(BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/vox/simonpants
	name = "simon pants"
	desc = "Based off the clothing of a hero so famous, even the Vox had to emulate his style."
	icon = 'icons/clothing/uniform/casual/vox/simonpants.dmi'
	icon_state = "simonpants"
	worn_bodytypes = BODYTYPES(BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
