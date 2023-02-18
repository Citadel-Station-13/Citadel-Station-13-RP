/datum/prototype/loot_pack/gear
	abstract_type = /datum/prototype/loot_pack/gear

/datum/prototype/loot_pack/gear/space_miner
	some = list(
		/obj/item/pickaxe/silver,
		/obj/item/pickaxe/gold,
		/obj/item/pickaxe/jackhammer,
	)
	amt = 1

/datum/prototype/loot_pack/gear/space_miner/basic
	always = list(
		/obj/item/pickaxe/plasmacutter,
		/obj/item/tape_recorder,
		/obj/item/clothing/suit/space/void/mining,
		/obj/item/clothing/head/helmet/space/void/mining,
	)

/datum/prototype/loot_pack/gear/space_miner/advanced
	always = list(
		/obj/item/pickaxe/diamonddrill,
		/obj/item/tape_recorder,
		/obj/item/rig/industrial/equipped,
	)
