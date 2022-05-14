/*
*	Here is where any supply packs
*	related to materials live.
*/


/datum/supply_pack/materials
	group = "Materials"

/datum/supply_pack/materials/metal50
	name = "50 metal sheets"
	contains = list(/obj/fiftyspawner/steel)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Metal sheets crate"

/datum/supply_pack/materials/glass50
	name = "50 glass sheets"
	contains = list(/obj/fiftyspawner/glass)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Glass sheets crate"

/datum/supply_pack/materials/wood50
	name = "50 wooden planks"
	contains = list(/obj/fiftyspawner/wood)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Wooden planks crate"

/datum/supply_pack/materials/wood50
	name = "50 hardwood planks"
	contains = list(/obj/fiftyspawner/hardwood)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "Hardwood planks crate"

/datum/supply_pack/materials/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/fiftyspawner/plastic)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Plastic sheets crate"

/datum/supply_pack/materials/leather50
	name = "50 leather sheets"
	contains = list(/obj/fiftyspawner/leather)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Leather sheets crate"

/datum/supply_pack/materials/cloth50
	name = "50 cloth sheets"
	contains = list(/obj/fiftyspawner/cloth)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Cloth sheets crate"

/datum/supply_pack/materials/cardboard_sheets
	contains = list(/obj/fiftyspawner/cardboard)
	name = "50 cardboard sheets"
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Cardboard sheets crate"

/datum/supply_pack/materials/carpet
	name = "Imported carpet"
	container_type = /obj/structure/closet/crate
	container_name = "Imported carpet crate"
	cost = 15
	contains = list(
					/obj/fiftyspawner/carpet,
					/obj/fiftyspawner/tealcarpet
					)


/datum/supply_pack/misc/linoleum
	name = "Linoleum"
	container_type = /obj/structure/closet/crate
	container_name = "Linoleum crate"
	cost = 15
	contains = list(/obj/fiftyspawner/linoleum)
