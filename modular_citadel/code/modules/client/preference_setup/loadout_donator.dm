/datum/gear/donator
	display_name = "If this item can be chosen or seen, ping a coder immediately!"
	sort_category = "Donator"
	path = /obj/item/weapon/bikehorn
	ckeywhitelist = list("This entry should never be choosable with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard

/*
/datum/gear/donator/testhorn
	display_name = "Airhorn - Example Item"
	path = /obj/item/weapon/bikehorn
	ckeywhitelist = list("realdonaldtrump")
*/

/datum/gear/donator/chayse
	display_name = "NTSC Naval Uniform"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/donator/chayse
	ckeywhitelist = list("realdonaldtrump", "aaronskywalker")

/datum/gear/donator/labredblack
	display_name = "Black and Red Coat"
	slot = slot_wear_suit
	path = /obj/item/clothing/suit/storage/toggle/labcoat/donator/labredblack
	ckeywhitelist = list("blakeryan", "durandalphor")

/datum/gear/donator/carrotsatchel
	display_name = "Carrot Satchel"
	slot = slot_back
	path = /obj/item/weapon/storage/backpack/satchel/donator/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donator/stripedcollar
	display_name = "Striped collar"
	slot = slot_tie
	path = /obj/item/clothing/accessory/collar/donator/striped
	ckeywhitelist = list("jademanique")
