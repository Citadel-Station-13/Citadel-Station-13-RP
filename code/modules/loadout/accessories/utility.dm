/datum/loadout_entry/accessory/brown_drop_pouches
	name = "Drop Pouches - Brown"
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches
	cost = 2

/datum/loadout_entry/accessory/black_drop_pouches
	name = "Drop Pouches - Black"
	path = /obj/item/clothing/accessory/storage/black_drop_pouches
	cost = 2

/datum/loadout_entry/accessory/white_drop_pouches
	name = "Drop Pouches - White"
	path = /obj/item/clothing/accessory/storage/white_drop_pouches
	cost = 2

/datum/loadout_entry/accessory/holster_selection
	name = "Holster - Selection"
	path = /obj/item/clothing/accessory/holster

/datum/loadout_entry/accessory/holster_selection/New()
	..()
	var/holstertype = list()
	holstertype["Holster - Shoulder"] = /obj/item/clothing/accessory/holster
	holstertype["Holster - Armpit"] = /obj/item/clothing/accessory/holster/armpit
	holstertype["Holster - Waist"] = /obj/item/clothing/accessory/holster/waist
	holstertype["Holster - Hip"] = /obj/item/clothing/accessory/holster/hip
	holstertype["Holster - Leg"] = /obj/item/clothing/accessory/holster/leg
	holstertype["Holster - Machete"] = /obj/item/clothing/accessory/holster/machete
	tweaks += new/datum/loadout_tweak/path(holstertype)
