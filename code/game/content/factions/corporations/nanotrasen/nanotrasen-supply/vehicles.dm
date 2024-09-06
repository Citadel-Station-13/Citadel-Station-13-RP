/datum/supply_pack/nanotrasen/vehicles
	category = "Vehicles"

/datum/supply_pack/nanotrasen/vehicles/dune_buggy
	name = "Exploration Dune Buggy"
	contains = list(
		/obj/vehicle_old/train/rover/engine/dunebuggy,
	)
	worth = 1250
	container_type = /obj/structure/largecrate
	container_name = "Exploration Dune Buggy Crate"


/datum/supply_pack/nanotrasen/vehicles/bike
	name = "Spacebike Crate"
	contains = list(
		/obj/structure/vehiclecage/spacebike,
	)
	worth = 1250
	container_type = /obj/structure/largecrate/vehicle
	container_name = "spacebike crate"

/datum/supply_pack/nanotrasen/vehicles/quadbike
	name = "ATV Crate"
	contains = list(
		/obj/vehicle/ridden/quadbike/random,
		/obj/item/key/quadbike,
	)
	worth = 1250
	container_type = /obj/structure/largecrate/vehicle
	container_name = "ATV crate"

/datum/supply_pack/nanotrasen/vehicles/skatepack1
	name = "Beginner Skateboard Pack"
	contains = list(
		/obj/vehicle_old/skateboard/beginner = 3,
		/obj/item/clothing/head/helmet/bike_helmet/random = 3,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Skateboard Crate - Beginner"

/datum/supply_pack/nanotrasen/vehicles/skatepack2
	name = "Professional Skateboard Pack"
	contains = list(
		/obj/vehicle_old/skateboard/pro = 2,
		/obj/item/clothing/head/helmet/bike_helmet/random = 2,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Skateboard Crate - Professional"

/datum/supply_pack/nanotrasen/vehicles/skatepack3
	name = "Hoverboard Pack"
	contains = list(
		/obj/vehicle_old/skateboard/hoverboard = 2,
		/obj/item/clothing/head/helmet/bike_helmet/random = 2,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Hoverboard Crate"

/datum/supply_pack/nanotrasen/vehicles/rover
	name = "NT Humvee"
	contains = list(
		/obj/vehicle_old/train/rover/engine,
	)
	worth = 1500
	container_type = /obj/structure/largecrate
	container_name = "NT Humvee Crate"


/datum/supply_pack/nanotrasen/vehicles/cargotrain
	name = "Cargo Train Tug"
	contains = list(
		/obj/vehicle_old/train/engine,
	)
	worth = 1500
	container_type = /obj/structure/largecrate
	container_name = "Cargo Train Tug Crate"

/datum/supply_pack/nanotrasen/vehicles/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(
		/obj/vehicle_old/train/trolley,
	)
	worth = 500
	container_type = /obj/structure/largecrate
	container_name = "Cargo Train Trolley Crate"
