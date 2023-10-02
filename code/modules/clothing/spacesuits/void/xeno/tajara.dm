//Special
/obj/item/clothing/suit/space/void/nka
	name = "new kingdom mercantile voidsuit"
	desc = "An amalgamation of old civilian voidsuits and diving suits. This bulky space suit is used by the crew of the New Kingdom's mercantile navy."
	icon = 'icons/obj/clothing/species/tajaran/suits.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/suits.dmi'
	icon_state = "nkavoid"
	item_state = "nkavoid"
	armor_type = /datum/armor/station/hossuit
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(SPECIES_TAJ)

/obj/item/clothing/head/helmet/space/void/nka
	name = "new kingdom mercantile voidsuit helmet"
	desc = "An amalgamation of old civilian voidsuits and diving suits. This bulky space suit is used by the crew of the New Kingdom's mercantile navy."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "nkavoidhelm"
	item_state = "nkavoidhelm"
	armor_type = /datum/armor/station/hossuit
	species_restricted = list(SPECIES_TAJ)

/obj/item/clothing/suit/space/void/dpra
	name = "DPRA voidsuit"
	desc = "A refitted, sturdy voidsuit. These armored models were issued to the DPRA's volunteer spacer militia."
	icon = 'icons/obj/clothing/species/tajaran/suits.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/suits.dmi'
	icon_state = "DPRA_voidsuit"
	item_state = "DPRA_voidsuit"
	armor_type = /datum/armor/station/hossuit
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(SPECIES_TAJ)

/obj/item/clothing/head/helmet/space/void/dpra
	name = "DPRA voidsuit helmet"
	desc = "A refitted, sturdy voidsuit. These armored models were issued to the DPRA's volunteer spacer militia."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "DPRA_voidsuit_helmet"
	item_state = "DPRA_voidsuit_helmet"
	armor_type = /datum/armor/station/hossuit
	species_restricted = list(SPECIES_TAJ)
