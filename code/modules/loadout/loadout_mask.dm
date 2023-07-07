// Mask
/datum/loadout_entry/mask
	name = "Bandana - Blue"
	path = /obj/item/clothing/mask/bandana/blue
	slot = SLOT_ID_MASK
	sort_category = LOADOUT_CATEGORY_MASKS

/datum/loadout_entry/mask/gold
	name = "Bandana - Gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/loadout_entry/mask/green
	name = "Bandana - Green"
	path = /obj/item/clothing/mask/bandana/green

/datum/loadout_entry/mask/red
	name = "Bandana - Red"
	path = /obj/item/clothing/mask/bandana/red

/datum/loadout_entry/mask/sterile
	name = "Sterile Mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/loadout_entry/mask/half
	name = "Half Gas Mask"
	path = /obj/item/clothing/mask/gas/half
	cost = 2
/datum/loadout_entry/mask/skull
	name = "Bandana - Skull"
	path = /obj/item/clothing/mask/bandana/skull

/datum/loadout_entry/mask/balaclava
	name = "Balaclava"
	path = /obj/item/clothing/mask/balaclava

/datum/loadout_entry/mask/muzzle
	name = "Muzzle"
	path = /obj/item/clothing/mask/muzzle

/datum/loadout_entry/mask/fakemoustache
	name = "Fake Moustache"
	path = /obj/item/clothing/mask/fakemoustache

/datum/loadout_entry/mask/samurai
	name = "Samurai Mask"
	path = /obj/item/clothing/mask/samurai

/datum/loadout_entry/mask/samurai_colorable
	name = "Samurai Mask (Colorable)"
	path = /obj/item/clothing/mask/samurai/colorable

/datum/loadout_entry/mask/samurai_colorable/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/mask/fox
	name = "Fox mask" //capitalisation because everything else here is capitalised
	path = /obj/item/clothing/mask/gas/fox

/datum/loadout_entry/mask/opaque
	name = "Opaque Mask"
	path = /obj/item/clothing/mask/gas/opaque
