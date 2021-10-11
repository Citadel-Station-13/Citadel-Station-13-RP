// Mask
/datum/gear/mask
	display_name = "Bandana - Blue"
	path = /obj/item/clothing/mask/bandana/blue
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/gold
	display_name = "Bandana - Gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/gear/mask/green
	display_name = "Bandana - Green"
	path = /obj/item/clothing/mask/bandana/green

/datum/gear/mask/red
	display_name = "Bandana - Red"
	path = /obj/item/clothing/mask/bandana/red

/datum/gear/mask/sterile
	display_name = "Sterile Mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/mask/half
	display_name = "Half Gas Mask"
	path = /obj/item/clothing/mask/gas/half
	cost = 2
/datum/gear/mask/skull
	display_name = "Bandana - Skull"
	path = /obj/item/clothing/mask/bandana/skull

/datum/gear/mask/balaclava
	display_name = "Balaclava"
	path = /obj/item/clothing/mask/balaclava

/datum/gear/mask/muzzle
	display_name = "Muzzle"
	path = /obj/item/clothing/mask/muzzle

/datum/gear/mask/fakemoustache
	display_name = "Fake Moustache"
	path = /obj/item/clothing/mask/fakemoustache

/datum/gear/mask/samurai
	display_name = "Samurai Mask"
	path = /obj/item/clothing/mask/samurai

/datum/gear/mask/samurai_colorable
	display_name = "Samurai Mask (Colorable)"
	path = /obj/item/clothing/mask/samurai/colorable

/datum/gear/mask/samurai_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
