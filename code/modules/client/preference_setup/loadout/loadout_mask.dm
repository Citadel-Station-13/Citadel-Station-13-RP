/*
	Masks & Facewear
*/

/datum/gear/mask
	sort_category = "Masks and Facewear" // This controls the name of the category in the loadout.
	type_category = /datum/gear/mask // All subtypes of the geartype declared will be associated with this - practically speaking this controls where the items themselves go.
	slot = slot_wear_mask // Assigns the slot of each item of the gear subtype to the slot specified.
	cost = 1 // Controls how much an item's "cost" is in the loadout point menu. If re-specified on a different item, that value will override this one. This sets the default value.

/datum/gear/mask/blue
	display_name = "bandana, blue"
	path = /obj/item/clothing/mask/bandana/blue

/datum/gear/mask/gold
	display_name = "bandana, gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/gear/mask/green
	display_name = "bandana, green 2"
	path = /obj/item/clothing/mask/bandana/green

/datum/gear/mask/red
	display_name = "bandana, red"
	path = /obj/item/clothing/mask/bandana/red

/datum/gear/mask/sterile
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/mask/skull
	display_name = "bandana, skull"
	path = /obj/item/clothing/mask/bandana/skull