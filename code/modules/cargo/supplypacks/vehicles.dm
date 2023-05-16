/datum/supply_pack/vehicles
	group = "Vehicles"


/datum/supply_pack/vehicles/dune_buggy
	name = "Exploration Dune Buggy"
	contains = list(
			/obj/vehicle_old/train/rover/engine/dunebuggy
			)
	cost = 100
	container_type = /obj/structure/largecrate
	container_name = "Exploration Dune Buggy Crate"


/datum/supply_pack/vehicles/bike
	name = "Spacebike Crate"
	contains = list()
	cost = 200
	container_type = /obj/structure/largecrate/vehicle/bike
	container_name = "Spacebike Crate"

/datum/supply_pack/vehicles/quadbike
	name = "ATV Crate"
	contains = list()
	cost = 30
	container_type = /obj/structure/largecrate/vehicle/quadbike
	container_name = "ATV Crate"

/*
/datum/supply_pack/vehicles/quadtrailer
	name = "ATV Trailer Crate"
	contains = list()
	cost = 50
	container_type = /obj/structure/largecrate/vehicle/quadtrailer
	container_name = "ATV Trailer Crate"
*/

/datum/supply_pack/vehicles/skatepack1
	name = "Beginner Skateboard Pack"
	contains = list(
			/obj/vehicle_old/skateboard/beginner = 3,
			/obj/item/clothing/head/helmet/bike_helmet/random = 3
			)
	cost = 100
	container_type = /obj/structure/closet/crate
	container_name = "Skateboard Crate - Beginner"

/datum/supply_pack/vehicles/skatepack2
	name = "Professional Skateboard Pack"
	contains = list(
			/obj/vehicle_old/skateboard/pro = 2,
			/obj/item/clothing/head/helmet/bike_helmet/random = 2
			)
	cost = 200
	container_type = /obj/structure/closet/crate
	container_name = "Skateboard Crate - Professional"

/datum/supply_pack/vehicles/skatepack3
	name = "Hoverboard Pack"
	contains = list(
			/obj/vehicle_old/skateboard/hoverboard = 2,
			/obj/item/clothing/head/helmet/bike_helmet/random = 2
			)
	cost = 300
	container_type = /obj/structure/closet/crate
	container_name = "Hoverboard Crate"

/datum/supply_pack/vehicles/rover
	name = "NT Humvee"
	contains = list(
			/obj/vehicle_old/train/rover/engine
			)
	container_type = /obj/structure/largecrate
	container_name = "NT Humvee Crate"
	cost = 500


/datum/supply_pack/vehicles/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle_old/train/engine)
	cost = 35
	container_type = /obj/structure/largecrate
	container_name = "Cargo Train Tug Crate"

/datum/supply_pack/vehicles/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle_old/train/trolley)
	cost = 15
	container_type = /obj/structure/largecrate
	container_name = "Cargo Train Trolley Crate"
