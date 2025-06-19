/**
 * Military Uniforms
 */

/**
 * Military Surplus
 */
/obj/item/clothing/under/surplus
	name = "surplus fatigues"
	desc = "Old military fatigues like these are very common across the Frontier. Sturdy and somewhat comfortable, they hold up to the harsh working environments many colonists face, while also adding a little flair - regardless of prior military service."
	icon = 'icons/clothing/uniform/workwear/military/bdu_olive.dmi'
	icon_state = "bdu_olive"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/surplus/desert
	icon = 'icons/clothing/uniform/workwear/military/bdu_desert.dmi'
	icon_state = "bdu_desert"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/surplus/russoblue
	icon = 'icons/clothing/uniform/workwear/military/bdu_russoblue.dmi'
	icon_state = "bdu_russoblue"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Reuses spritesheet
/obj/item/clothing/under/worn_fatigues
	name = "special ops fatigues"
	desc = "These worn fatigues match the pattern known to be used by JSDF Marine Corps special forces."
	icon = 'icons/clothing/uniform/workwear/military/bdu_russoblue.dmi'
	icon_state = "bdu_russoblue"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
