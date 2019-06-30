/datum/gear/uniform/voxcasual
	display_name = "casual wear (Vox)"
	path = /obj/item/clothing/under/vox/vox_casual
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/uniform/voxrobes
	display_name = "comfy robes (Vox)"
	path = /obj/item/clothing/under/vox/vox_robes
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/accessory/vox
	display_name = "storage vest (Vox)"
	path = /obj/item/clothing/accessory/storage/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/gloves/vox
	display_name = "insulated gauntlets (Vox)"
	path = /obj/item/clothing/gloves/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/shoes/vox
	display_name = "magclaws (Vox)"
	path = /obj/item/clothing/shoes/magboots/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/mask/vox
	display_name = "alien mask (Vox)"
	path = /obj/item/clothing/mask/gas/swat/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/uniform/loincloth
	display_name = "loincloth"
	path = /obj/item/clothing/suit/storage/fluff/loincloth
	sort_category = "Xenowear"

/datum/gear/uniform/plascapalt
	display_name = "alternate colony director helmet (phoronoid)"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/captain/alt
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Colony Director")

/datum/gear/uniform/plashosalt1
	display_name = "alternate head of security helmet 1 (phoronoid)"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt1
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Head of Security")

/datum/gear/uniform/plashosalt2
	display_name = "alternate head of security helmet 2 (phoronoid)"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt2
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Head of Security")

/datum/gear/uniform/plasaccessories
	display_name = "containment suit accessory selection (phoronoid)"
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN

/datum/gear/uniform/plasaccessories/New()
	..()
	var/list/plasaccessories = list()
	for(var/plasman in (typesof(/obj/item/clothing/accessory/plasman)))
		var/obj/item/clothing/accessory/plasman/plasaccessory_type = plasman
		plasaccessories[initial(plasaccessory_type.name)] = plasaccessory_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(plasaccessories))