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
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX, BODYTYPE_TESHARI)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|FEET

/obj/item/clothing/under/skirt/loincloth
	name = "loincloth"
	desc = "A piece of cloth wrapped around the waist."
	icon = 'icons/clothing/uniform/casual/loincloth.dmi'
	icon_state = "loincloth"

/obj/item/clothing/under/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon = 'icons/clothing/uniform/casual/psyche.dmi'
	icon_state = "psyche"

/obj/item/clothing/under/color/rainbow
	name = "rainbow jumpsuit"
	desc = "A multi-colored jumpsuit."
	icon = 'icons/clothing/uniform/casual/rainbow_jumpsuit.dmi'
	icon_state = "rainbow"

/obj/item/clothing/under/color/rainbow_skirt
	name = "rainbow pleated skirt"
	icon = 'icons/clothing/uniform/casual/rainbow_skirt.dmi'
	icon_state = "rainbow_skirt"
