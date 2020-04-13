
/datum/supply_pack/misc/beltminer
	name = "Belt-miner gear crate"
	contains = list(
			/obj/item/gun/energy/particle = 2,
			/obj/item/cell/device/weapon = 2,
			/obj/item/storage/firstaid/regular = 1,
			/obj/item/gps = 2,
			/obj/item/storage/box/traumainjectors = 1
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Belt-miner gear crate"
	access = access_mining

/datum/supply_pack/misc/eva_rig
	name = "eva hardsuit (empty)"
	contains = list(
			/obj/item/rig/eva = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "eva hardsuit crate"
	access = list(access_mining,
				  access_eva,
				  access_explorer,
				  access_pilot)
	one_access = TRUE

/datum/supply_pack/misc/mining_rig
	name = "industrial hardsuit (empty)"
	contains = list(
			/obj/item/rig/industrial = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "industrial hardsuit crate"
	access = list(access_mining,
				  access_eva)
	one_access = TRUE

/*
/datum/supply_pack/misc/looksir // CIT Change: Adds a crab crate, that isn't free
	name = "free crabs"
	contains = list()
	cost = 7
	containertype = /obj/structure/largecrate/animal/crab
	containername = "Crab Crate"
*/

/datum/supply_pack/misc/medical_rig
	name = "medical hardsuit (empty)"
	contains = list(
			/obj/item/rig/medical = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "medical hardsuit crate"
	access = access_medical

/datum/supply_pack/misc/rations
	name = "Emergency LiquidFood and Protein Rations"
	contains = list(
	/obj/item/reagent_containers/food/snacks/liquidfood = 10,
	/obj/item/reagent_containers/food/snacks/liquidprotein = 10
	)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "emergency rations"

/datum/supply_pack/misc/phoronoid
	name  = "Spare Phoronoid containment suits"
	contains = list(
	/obj/item/clothing/suit/space/plasman = 3,
	/obj/item/clothing/head/helmet/space/plasman = 3,
	/obj/item/clothing/mask/breath = 3,
	/obj/item/tank/vox = 3,
	)
	cost = 40
	containername = "spare phoronoid suits"

/datum/supply_pack/misc/security_rig
	name = "hazard hardsuit (empty)"
	contains = list(
			/obj/item/rig/hazard = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "hazard hardsuit crate"
	access = access_armory

/datum/supply_pack/misc/science_rig
	name = "ami hardsuit (empty)"
	contains = list(
			/obj/item/rig/hazmat = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "ami hardsuit crate"
	access = access_rd

/datum/supply_pack/misc/ce_rig
	name = "advanced voidsuit (empty)"
	contains = list(
			/obj/item/rig/ce = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "advanced voidsuit crate"
	access = access_ce
