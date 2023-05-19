//Non-void Helments
/obj/item/clothing/head/helmet/tajaran/amohda
	name = "amohdan swordsman helmet"
	desc = "A helmet used by the traditional warriors of Amohda."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "amohdan_helmet"
	item_state = "amohdan_helmet"
	body_cover_flags = HEAD|FACE|EYES
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	species_restricted = list(SPECIES_TAJ)
	armor_type = /datum/armor/general/medieval
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/tajaran/kettle
	name = "Adhomian kettle helmet"
	desc = "A kettle helmet used by the forces of the new Kingdom of Adhomai."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "kettle_helment"
	item_state = "kettle_helment"
	armor_type = /datum/armor/general/medieval/light
