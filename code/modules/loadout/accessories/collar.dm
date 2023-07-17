/datum/loadout_entry/choker	// A colorable choker
	name = "Choker"
	path = /obj/item/clothing/accessory/choker
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory
	sort_category = LOADOUT_CATEGORY_ACCESSORIES

/datum/loadout_entry/collar
	name = "Collar - Silver"
	path = /obj/item/clothing/accessory/collar/silver
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory
	sort_category = LOADOUT_CATEGORY_ACCESSORIES

/datum/loadout_entry/collar/New()
	..()
	tweaks = list(gear_tweak_collar_tag)

/datum/loadout_entry/collar/golden
	name = "Collar - Golden"
	path = /obj/item/clothing/accessory/collar/gold

/datum/loadout_entry/collar/bell
	name = "Collar - Bell"
	path = /obj/item/clothing/accessory/collar/bell

/datum/loadout_entry/collar/shock
	name = "Collar - Shock"
	path = /obj/item/clothing/accessory/collar/shock

/datum/loadout_entry/collar/spike
	name = "Collar - Spike"
	path = /obj/item/clothing/accessory/collar/spike

/datum/loadout_entry/collar/pink
	name = "Collar - Pink"
	path = /obj/item/clothing/accessory/collar/pink

/datum/loadout_entry/collar/holo
	name = "Collar - Holo"
	path = /obj/item/clothing/accessory/collar/holo

/datum/loadout_entry/collar/cow
	name = "Collar - Cowbell"
	path = /obj/item/clothing/accessory/collar/cowbell

/datum/loadout_entry/collar/holo/indigestible
	name = "Collar - Holo - Indigestible"
	path = /obj/item/clothing/accessory/collar/holo/indigestible
