// Citadel-specific RNG item picker.

// Saxon - Crusader.mp3
/obj/random/great_helm
	name = "random great helm"
	desc = "This is a random great helm."
	icon = 'modular_citadel/icons/obj/clothing/medieval_helmet.dmi'
	icon_state = "crusader"

/obj/random/great_helm/item_to_spawn()
	return pick(prob(10);/obj/item/clothing/head/helmet/medieval/crusader,
				prob(5);/obj/item/clothing/head/helmet/medieval/crusader/templar,
				prob(2);/obj/item/clothing/head/helmet/medieval/crusader/horned,
				prob(2);/obj/item/clothing/head/helmet/medieval/crusader/winged)

/obj/random/crusader_armor
	name = "random crusader armour"
	desc = "This is a random crusader armour."
	icon = 'modular_citadel/icons/obj/clothing/medieval_armor.dmi'
	icon_state = "crusader"

/obj/random/crusader_armor/item_to_spawn()
	return pick(prob(10);/obj/item/clothing/suit/armor/medieval/crusader/cross,
				prob(2);/obj/item/clothing/suit/armor/medieval/crusader/cross/teutonic,
				prob(2);/obj/item/clothing/suit/armor/medieval/crusader/cross/templar,
				prob(2);/obj/item/clothing/suit/armor/medieval/crusader/cross/hospitaller)

// Replica version
/obj/random/great_helm_replica
	name = "random great helm replica"
	desc = "This is a replica of random great helm."
	icon = 'modular_citadel/icons/obj/clothing/medieval_helmet.dmi'
	icon_state = "crusader"

/obj/random/great_helm_replica/item_to_spawn()
	return pick(prob(10);/obj/item/clothing/head/medievalfake/crusader,
				prob(5);/obj/item/clothing/head/medievalfake/crusader/templar,
				prob(2);/obj/item/clothing/head/medievalfake/crusader/horned,
				prob(2);/obj/item/clothing/head/medievalfake/crusader/winged)

/obj/random/crusader_armor_replica
	name = "random crusader armour replica"
	desc = "This is a replica of random crusader armour."
	icon = 'modular_citadel/icons/obj/clothing/medieval_armor.dmi'
	icon_state = "crusader"

/obj/random/crusader_armor_replica/item_to_spawn()
	return pick(prob(10);/obj/item/clothing/suit/medievalfake/crusader/cross,
				prob(2);/obj/item/clothing/suit/medievalfake/crusader/cross/teutonic,
				prob(2);/obj/item/clothing/suit/medievalfake/crusader/cross/templar,
				prob(2);/obj/item/clothing/suit/medievalfake/crusader/cross/hospitaller)

// Finally, related cloaks.
/obj/random/crusader_cloak
	name = "random crusader cloak"
	desc = "This is a random crusader cloak."
	icon = 'modular_citadel/icons/obj/clothing/ties_cit.dmi'
	icon_state = "cloak_crusader"

/obj/random/crusader_cloak/item_to_spawn()
	return pick(prob(10);/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade,
				prob(2);/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/teutonic,
				prob(2);/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/templar,
				prob(2);/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/hospitaller)
