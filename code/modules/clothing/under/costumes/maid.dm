/**
 * This file is for maid outfits that are costumes. Maid outfits that are uniforms go in workwear.
 */
/obj/item/clothing/under/dress/maid
	name = "maid costume"
	desc = "Maid in China."
	icon = 'icons/clothing/uniform/costume/maid/maid.dmi'
	icon_state = "maid"

/obj/item/clothing/under/dress/maid/sexy
	name = "sexy maid costume"
	desc = "You must be a bit risque teasing all of them in a maid uniform!"
	icon = 'icons/clothing/uniform/costume/maid/maid_sexy.dmi'
	icon_state = "sexymaid"

/obj/item/clothing/under/dress/maid/neko
	name = "neko maid uniform"
	desc = "A tailored maid uniform that takes many cues from Old Earth Bavarian commonwear. It seems airy and breathable."
	icon = 'icons/clothing/uniform/costume/maid/maid_neko.dmi'
	icon_state = "neko"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

//KotetsuRedwood:Latex Maid Dresses, for everyone to 'enjoy'. :3c
/obj/item/clothing/under/fluff/latexmaid
	name = "latex maid dress"
	desc = "Squeak! A shiny outfit for cleaning, made by people with dirty minds."

	icon = 'icons/clothing/uniform/costume/maid/maid_latex.dmi'
	icon_state = "latex"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

	body_cover_flags = UPPER_TORSO|LOWER_TORSO
