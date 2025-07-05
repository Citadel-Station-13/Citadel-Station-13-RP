/**
 * This file is for anything tha does not fit elsewhere.
 * If you add 3 or more of something that groups together remove it from here and put it
 * in its own file please.
 */

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid"
	icon = 'icons/clothing/uniform/casual/kilt.dmi'
	icon_state = "kilt"
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|FEET

/obj/item/clothing/under/skirt/loincloth
	name = "loincloth"
	desc = "A piece of cloth wrapped around the waist."
	icon = 'icons/clothing/uniform/casual/loincloth.dmi'
	icon_state = "loincloth"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon = 'icons/clothing/uniform/casual/psyche.dmi'
	icon_state = "psyche"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/color/rainbow
	name = "rainbow jumpsuit"
	desc = "A multi-colored jumpsuit."
	icon = 'icons/clothing/uniform/casual/rainbow_jumpsuit.dmi'
	icon_state = "rainbow"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/color/rainbow_skirt
	name = "rainbow pleated skirt"
	icon = 'icons/clothing/uniform/casual/rainbow_skirt.dmi'
	icon_state = "rainbow_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/ascetic
	name = "plain ascetic garb"
	desc = "Popular with freshly grown vatborn and new age cultists alike."
	icon = 'icons/clothing/uniform/casual/ascetic.dmi'
	icon_state = "ascetic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/ascetic_fem
	name = "plain ascetic garb"
	desc = "Popular with freshly grown vatborn and new age cultists alike."
	icon = 'icons/clothing/uniform/casual/ascetic_fem.dmi'
	icon_state = "ascetic_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bathrobe
	name = "bathrobe"
	desc = "A fluffy robe to keep you from showing off to the world."
	icon = 'icons/clothing/uniform/casual/bathrobe.dmi'
	icon_state = "bathrobe"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tourist
	name = "tourist liesurewear"
	desc = "This loud shirt is made of mid-grade cashmere. This premier liesurewear pairs well with a nice pair of khaki shorts that stop uncomfortably above the knee."
	icon = 'icons/clothing/uniform/casual/tourist.dmi'
	icon_state = "tourist"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/moderncoat
	name = "modern wrapped coat"
	desc = "The cutting edge of fashion."
	icon = 'icons/clothing/uniform/casual/moderncoat.dmi'
	icon_state = "moderncoat"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/fluff/v_nanovest
	name = "Varmacorp nanovest"
	desc = "A nifty little vest optimized for nanite contact."
	icon = 'icons/clothing/uniform/casual/nanovest.dmi'
	icon_state = "nanovest"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
