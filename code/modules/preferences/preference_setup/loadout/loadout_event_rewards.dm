/datum/gear/event_reward
	sort_category = LOADOUT_CATEGORY_EVENTS
	cost = 0 // If they got something custom, it's only right that they aren't penalized and need to re-adjust their loadout to compensate for their new item's cost.
	name = "If this item can be chosen or seen, ping a coder immediately!"
	path = /obj/item/bikehorn
	ckeywhitelist = list("This entry should never be choosable with this variable set.") // Reminder - ckeys are always all lowercase, regardless of what someone's username displays (and apparently without spaces)
/*
/datum/gear/event_reward/imperium       <------   Example Item
	name = "Imperium"
	path = /obj/item/clothing/suit/armor/combat/imperial/centurion
	slot = SLOT_ID_SUIT               <------   Important to change to whichever slot the item should be worn on. If it's not a piece of clothing/equipment, leaving it blank should put it into their backpack.
	ckeywhitelist = list("drofoljaelisglis")
*/
/datum/gear/event_reward/gameboy
	name = "Game Boy"
	path = /obj/item/instrument/gameboy
	ckeywhitelist = list("jaybird1")

/datum/gear/event_reward/foxmimko
	name = "Miko Garb"
	path = /obj/item/clothing/under/event_reward/foxmiko
	slot = SLOT_ID_UNIFORM
	ckeywhitelist = list("knouli")

/datum/gear/event_reward/glue
	name = "All Purpose Non-Toxic Glue"
	path = /datum/reagent/drink/glue
	ckeywhitelist = list("trubus", "g0atman", "linzolle", "racobio", "oaklee", "askaris", "bluewildrose", "serinexxa", "ticklem0nster", "pixelthekitty", "ktoma36", "keekenox", "nik707")

/datum/gear/event_reward/fishingcap
	name = "Fishing Cap"
	path = /obj/item/clothing/head/fishingcap
	ckeywhitelist = list("biteroankles", "cawingcrow", "tzula", "doopytoots", "slybrowngote", "0roxas0", "g0atman", "kiroking", "gonepostal298", "silicons", "linzolle", "vapeon", "keekenox", "monara", "crystal9156")

/datum/gear/event_reward/toadplush
	name = "Toad Plushie"
	path = /obj/item/toy/plushie/toad
	ckeywhitelist = list("coreflare", "jacksontmurphy", "uncleburbon", "biteroankles", "athena14", "rezbit", "nik707", "0roxas0")

/datum/gear/event_reward/cooking_pin
	name = "Culinary Excellence Pin"
	path = /obj/item/clothing/accessory/medal/cooking
	ckeywhitelist = list("spessinquisitor", "ktoma36", "ghxst_azy")

/datum/gear/event_reward/petrock
	name = "Pet Rock"
	path = /obj/item/toy/plushie/petrock
	ckeywhitelist = list("cawingcrow")

/datum/gear/event_reward/nka_miaphus
	name = "Miaphus'irra Campagian Medal"
	path = /obj/item/clothing/accessory/medal/nka_miaphus
	ckeywhitelist = list("trubus", "alphamach", "monara", "pixelthekitty", "biteroankles", "jacksontmurphy", "slybrowngote", "r0adic", "mazian")

/datum/gear/event_reward/tacskirt
	name = "Tactical Skirt"
	path = /obj/item/clothing/under/syndicate/skirt_pleated
	ckeywhitelist = list("grapepantasoda")
