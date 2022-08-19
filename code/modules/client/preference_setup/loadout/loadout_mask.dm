// Mask
/datum/gear/mask
	name = "Bandana - Blue"
	path = /obj/item/clothing/mask/bandana/blue
	slot = SLOT_ID_MASK
	sort_category = "Masks and Facewear"

/datum/gear/mask/gold
	name = "Bandana - Gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/gear/mask/green
	name = "Bandana - Green"
	path = /obj/item/clothing/mask/bandana/green

/datum/gear/mask/red
	name = "Bandana - Red"
	path = /obj/item/clothing/mask/bandana/red

/datum/gear/mask/sterile
	name = "Sterile Mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/mask/half
	name = "Half Gas Mask"
	path = /obj/item/clothing/mask/gas/half
	cost = 2
/datum/gear/mask/skull
	name = "Bandana - Skull"
	path = /obj/item/clothing/mask/bandana/skull

/datum/gear/mask/balaclava
	name = "Balaclava"
	path = /obj/item/clothing/mask/balaclava

/datum/gear/mask/muzzle
	name = "Muzzle"
	path = /obj/item/clothing/mask/muzzle

/datum/gear/mask/fakemoustache
	name = "Fake Moustache"
	path = /obj/item/clothing/mask/fakemoustache

/datum/gear/mask/samurai
	name = "Samurai Mask"
	path = /obj/item/clothing/mask/samurai

/datum/gear/mask/samurai_colorable
	name = "Samurai Mask (Colorable)"
	path = /obj/item/clothing/mask/samurai/colorable

/datum/gear/mask/samurai_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/mask/fox
	name = "Fox mask" //capitalisation because everything else here is capitalised
	path = /obj/item/clothing/mask/gas/fox
