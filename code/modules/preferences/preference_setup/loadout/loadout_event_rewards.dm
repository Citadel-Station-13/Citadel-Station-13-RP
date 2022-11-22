/datum/gear/event_reward
	sort_category = "Event Rewards"
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
	sort_category = "Event Rewards"
	cost = 0
	name = "Game Boy"
	path = /obj/item/instrument/gameboy
	ckeywhitelist = list("jaybird1")

/datum/gear/event_reward/foxmimko
	sort_category = "Event Rewards"
	cost = 0
	name = "Miko Garb"
	path = /obj/item/clothing/under/event_reward/foxmiko
	slot = SLOT_ID_UNIFORM
	ckeywhitelist = list("knouli")
