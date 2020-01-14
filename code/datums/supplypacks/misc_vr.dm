
/datum/supply_pack/misc/beltminer
	name = "Belt-miner gear crate"
	contains = list(
			/obj/item/weapon/gun/energy/particle = 2,
			/obj/item/weapon/cell/device/weapon = 2,
			/obj/item/weapon/storage/firstaid/regular = 1,
			/obj/item/device/gps = 2,
			/obj/item/weapon/storage/box/traumainjectors = 1
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Belt-miner gear crate"
	access = access_mining

/datum/supply_pack/misc/eva_rig
	name = "eva hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/eva = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "eva hardsuit crate"
	access = access_mining

/datum/supply_pack/misc/mining_rig
	name = "industrial hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/industrial = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "industrial hardsuit crate"
	access = access_mining

/datum/supply_pack/misc/looksir // CIT Change: Adds a crab crate, that isn't free
	name = "free crabs"
	contains = list()
	cost = 7
	containertype = /obj/structure/largecrate/animal/crab
	containername = "Crab Crate"

/datum/supply_pack/misc/rations
	name = "Emergency LiquidFood Rations"
	contains = list(
	/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 10
	)
	cost = 5
	containertype = /obj/structure/closet/crate/freezer
	containername = "emergency rations"

/datum/supply_pack/misc/phoronoid
	name  = "Spare Phoronoid containment suits"
	contains = list(
	/obj/item/clothing/suit/space/plasman = 3,
	/obj/item/clothing/head/helmet/space/plasman = 3,
	/obj/item/clothing/mask/breath = 3,
	/obj/item/weapon/tank/vox = 3,
	)
	cost = 40
	containername = "spare phoronoid suits"