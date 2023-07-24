/datum/loadout_entry/accessory/armband
	name = "Armband Selection"
	path = /obj/item/clothing/accessory/armband

/datum/loadout_entry/accessory/armband/New()
	..()
	var/list/armbands = list()
	for(var/armband in (typesof(/obj/item/clothing/accessory/armband) - typesof(/obj/item/clothing/accessory/armband/med/color)))
		var/obj/item/clothing/accessory/armband_type = armband
		armbands[initial(armband_type.name)] = armband_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(armbands, /proc/cmp_text_asc))

/datum/loadout_entry/accessory/armband/colored
	name = "Armband - Colorable"
	path = /obj/item/clothing/accessory/armband/med/color
