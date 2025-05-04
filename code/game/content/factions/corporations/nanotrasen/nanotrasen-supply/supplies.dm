/*
*	Here is where any supply packs
*	related to civilian tasks live
*/

/datum/supply_pack/nanotrasen/supply
	abstract_type = /datum/supply_pack/nanotrasen/supply
	category = "Supplies"

/datum/supply_pack/nanotrasen/supply/food
	name = "Kitchen supply crate"
	contains = list(
		/obj/item/reagent_containers/food/condiment/flour = 6,
		/obj/item/reagent_containers/food/drinks/milk = 3,
		/obj/item/reagent_containers/food/drinks/soymilk = 2,
		/obj/item/storage/fancy/egg_box = 2,
		/obj/item/reagent_containers/food/snacks/tofu = 4,
		/obj/item/reagent_containers/food/snacks/meat = 4,
	)
	worth = 100 // i like our service players and will not grief them with high prices
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Food crate"

/datum/supply_pack/nanotrasen/supply/toner
	name = "Toner cartridges"
	contains = list(
		/obj/item/toner = 6,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Toner cartridges"

/datum/supply_pack/nanotrasen/supply/janitor
	name = "Janitorial supplies"
	contains = list(
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/mop,
		/obj/item/clothing/under/rank/janitor,
		/obj/item/cartridge/janitor,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft/purple,
		/obj/item/storage/belt/janitor,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/caution = 4,
		/obj/item/storage/bag/trash,
		/obj/item/lightreplacer,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/reagent_containers/spray/pestbgone,
		/obj/item/grenade/simple/chemical/premade/cleaner = 3,
		/obj/structure/mopbucket,
	)
	worth = 350 // i like our service players and will not grief them with high prices
	container_type = /obj/structure/closet/crate
	container_name = "Janitorial supplies"

/datum/supply_pack/nanotrasen/supply/shipping
	name = "Shipping supplies"
	contains = list(
		/obj/fiftyspawner/cardboard,
		/obj/item/packageWrap = 4,
		/obj/item/wrapping_paper = 2,
		/obj/item/destTagger,
		/obj/item/hand_labeler,
		/obj/item/tool/wirecutters,
		/obj/item/duct_tape_roll = 2,
	)
	worth = 150
	container_type = /obj/structure/closet/crate
	container_name = "Shipping supplies crate"

/datum/supply_pack/nanotrasen/supply/bureaucracy
	contains = list(
		/obj/item/clipboard = 2,
		/obj/item/pen/red,
		/obj/item/pen/blue,
		/obj/item/pen/blue,
		/obj/item/camera_film,
		/obj/item/folder/blue,
		/obj/item/folder/red,
		/obj/item/folder/yellow,
		/obj/item/hand_labeler,
		/obj/item/duct_tape_roll,
		/obj/structure/filingcabinet/chestdrawer/unanchored,
		/obj/item/paper_bin,
	)
	name = "Office supplies"
	worth = 150
	container_type = /obj/structure/closet/crate
	container_name = "Office supplies crate"

/datum/supply_pack/nanotrasen/supply/spare_pda
	name = "Spare PDAs"
	contains = list(
		/obj/item/pda = 3,
	)
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/thinktronic

/datum/supply_pack/nanotrasen/supply/minergear
	name = "Shaft miner equipment"
	contains = list(
		/obj/item/storage/backpack/industrial,
		/obj/item/storage/backpack/satchel/eng,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/black,
		/obj/item/atmos_analyzer,
		/obj/item/storage/bag/ore,
		/obj/item/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/mining_scanner,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/glasses/meson,
	)
	worth = 350
	container_type = /obj/structure/closet/crate/secure/corporate/grayson

/datum/supply_pack/nanotrasen/supply/mule
	name = "Mulebot Crate"
	contains = list()
	worth = 500
	container_type = /obj/structure/largecrate/animal/mulebot
	container_name = "Mulebot Crate"

//Culture Update
/datum/supply_pack/nanotrasen/misc/mining_tyrmalin
	name = "Tyrmalin Mining Crate"
	contains = list(
		/obj/item/melee/thermalcutter = 1,
		/obj/item/pickaxe/tyrmalin = 2,
		/obj/item/grenade/simple/explosive/ied/tyrmalin = 2,
	)
	worth = 250
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Tyrmalin Mining crate"
	container_access = list(
		/datum/access/station/supply/mining,
	)

/datum/supply_pack/nanotrasen/misc/mining_charges_smallbulk_tyrmalin
	name = "Tyrmalin Mining Charge Crate"
	contains = list(
		/obj/item/grenade/simple/explosive/ied/tyrmalin = 5,
	)
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Tyrmalin Mining Charge crate"
	container_access = list(
		/datum/access/station/supply/mining,
	)

/datum/supply_pack/nanotrasen/misc/mining_charges_largebulk_tyrmalin
	name = "Bulkpurchase Tyrmalin Mining Charge Crate"
	contains = list(
		/obj/item/grenade/simple/explosive/ied/tyrmalin = 10,
	)
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Tyrmalin Mining Charge crate Bulkbuy!!!"
	container_access = list(
		/datum/access/station/supply/mining,
	)

/datum/supply_pack/nanotrasen/misc/breathing_nitrogen
	name = "Emergency Nitrogen Supplies"
	contains = list(
		/obj/item/tank/emergency/nitrogen = 2,
		/obj/item/tank/emergency/nitrogen/double = 1,
		/obj/item/clothing/mask/gas/opaque = 3,
	)
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/unathi
	container_name = "Emergency Nitrogen Supplies"
