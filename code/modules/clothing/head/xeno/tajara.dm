//Non-void Helments
/obj/item/clothing/head/helmet/amohda
	name = "amohdan swordsman helmet"
	desc = "A helmet used by the traditional warriors of Amohda."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "amohdan_helmet"
	item_state = "amohdan_helmet"
	body_cover_flags = HEAD|FACE|EYES
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	species_restricted = list(SPECIES_TAJ)
	armor_type = /datum/armor/station/stab
	siemens_coefficient = 0.35
