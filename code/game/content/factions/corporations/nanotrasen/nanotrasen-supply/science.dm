/*
*	Here is where any supply packs
*	related to science tasks live
*/
/datum/supply_pack/nanotrasen/science
	category = "Science"

/datum/supply_pack/nanotrasen/science/virus
	name = "Virus sample crate"
	contains = list(
		/obj/item/virusdish/random = 4,
	)
	container_type = "/obj/structure/closet/crate/secure"
	container_name = "Virus sample crate"
	container_access = list(
		/datum/access/station/medical/virology,
	)

/datum/supply_pack/nanotrasen/science/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	worth = 350 // reagent worth unimplemented
	container_type = /obj/structure/largecrate
	container_name = "coolant tank crate"

/datum/supply_pack/nanotrasen/science/phoron
	name = "Phoron research crate"
	contains = list(
		/obj/item/tank/phoron = 3,
		/obj/item/tank/oxygen = 3,
		/obj/item/assembly/igniter = 3,
		/obj/item/assembly/prox_sensor = 3,
		/obj/item/assembly/timer = 3,
		/obj/item/assembly/signaler = 3,
		/obj/item/transfer_valve = 3,
	)
	container_type = /obj/structure/closet/crate/secure/phoron
	container_name = "Phoron assembly crate"
	container_access = list(
		/datum/access/station/science/toxins,
	)

/datum/supply_pack/nanotrasen/science/exoticseeds
	name = "Exotic seeds crate"
	contains = list(
		/obj/item/seeds/replicapod = 2,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/libertymycelium,
		/obj/item/seeds/reishimycelium,
		/obj/item/seeds/random = 6,
		/obj/item/seeds/kudzuseed,
	)
	worth = 650
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Exotic Seeds crate"

/datum/supply_pack/nanotrasen/science/integrated_circuit_printer
	name = "Integrated circuit printer"
	contains = list(
		/obj/item/integrated_circuit_printer = 2,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Integrated circuit crate"

/datum/supply_pack/nanotrasen/science/integrated_circuit_printer_upgrade
	name = "Integrated circuit printer upgrade - advanced designs"
	contains = list(
		/obj/item/disk/integrated_circuit/upgrade/advanced,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Integrated circuit crate"

/datum/supply_pack/nanotrasen/science/xenoarch
	name = "Xenoarchaeology Tech crate"
	contains = list(
		/obj/item/pickaxe/excavationdrill,
		/obj/item/xenoarch_multi_tool,
		/obj/item/clothing/suit/space/anomaly,
		/obj/item/clothing/head/helmet/space/anomaly,
		/obj/item/storage/belt/archaeology,
		/obj/item/flashlight/lantern,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/clothing/glasses/meson,
		/obj/item/pickaxe,
		/obj/item/storage/bag/fossils,
		/obj/item/hand_labeler,
	)
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Xenoarchaeology Tech crate"

/datum/supply_pack/nanotrasen/science/jukebox_circuitboard
	name = "Jukebox Circuit Board crate"
	contains = list(
		/obj/item/circuitboard/jukebox = 2,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Jukebox Circuit Board crate"


/datum/supply_pack/nanotrasen/science/pred
	name = "Dangerous Predator crate"
	container_type = /obj/structure/largecrate/animal/pred
	container_name = "Dangerous Predator crate"
	worth = 350

/datum/supply_pack/nanotrasen/science/pred_doom
	name = "EXTREMELY Dangerous Predator crate"
	container_type = /obj/structure/largecrate/animal/dangerous
	container_name = "EXTREMELY Dangerous Predator crate"
	legacy_contraband = 1
	worth = 550
