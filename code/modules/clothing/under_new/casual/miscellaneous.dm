/*
*	This file is for anything that does not fit elsewhere.
*	If you add 3 or more of something that groups together remove it from here and put it
*	in its own file.
*/

/obj/item/clothing/under/kilt
	icon = 'icons/clothing/uniform/casual/kilt.dmi'
	name = "kilt"
	icon_state = "kilt"
	desc = "Includes shoes and plaid"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX, BODYTYPE_TESHARI)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|FEET

