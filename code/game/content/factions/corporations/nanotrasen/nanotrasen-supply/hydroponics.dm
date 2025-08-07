/*
*	Here is where any supply packs
*	related to hydroponics tasks live.
*/


/datum/supply_pack/nanotrasen/hydroponics
	category = "Hydroponics"
	container_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/nanotrasen/hydroponics/hydroponics
	name = "Hydroponics Supply Crate"
	contains = list(
		/obj/item/reagent_containers/spray/plantbgone = 4,
		/obj/item/reagent_containers/glass/bottle/ammonia = 2,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/material/minihoe,
		/obj/item/plant_analyzer,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/suit/storage/apron,
		/obj/item/material/minihoe,
		/obj/item/storage/box/botanydisk,
	)
	worth = 350
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Hydroponics crate"

/datum/supply_pack/nanotrasen/hydroponics/seeds
	name = "Seeds crate"
	contains = list(
		/obj/item/seeds/chiliseed,
		/obj/item/seeds/berryseed,
		/obj/item/seeds/cornseed,
		/obj/item/seeds/eggplantseed,
		/obj/item/seeds/tomatoseed,
		/obj/item/seeds/appleseed,
		/obj/item/seeds/soyaseed,
		/obj/item/seeds/wheatseed,
		/obj/item/seeds/carrotseed,
		/obj/item/seeds/harebell,
		/obj/item/seeds/lemonseed,
		/obj/item/seeds/orangeseed,
		/obj/item/seeds/grassseed,
		/obj/item/seeds/sunflowerseed,
		/obj/item/seeds/chantermycelium,
		/obj/item/seeds/potatoseed,
		/obj/item/seeds/sugarcaneseed,
	)
	worth = 125

/datum/supply_pack/nanotrasen/hydroponics/weedcontrol
	name = "Weed control crate"
	contains = list(
		/obj/item/material/knife/machete/hatchet = 2,
		/obj/item/reagent_containers/spray/plantbgone = 4,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/grenade/simple/chemical/premade/antiweed = 2,
		/obj/item/material/twohanded/fireaxe/scythe,
	)
	worth = 125

/datum/supply_pack/nanotrasen/hydroponics/watertank
	name = "Water tank crate"
	contains = list(
		/obj/structure/reagent_dispensers/watertank,
	)
	worth = 75
	container_type = /obj/structure/largecrate

/datum/supply_pack/nanotrasen/hydroponics/bee_keeper
	name = "Beekeeping crate"
	contains = list(
		/obj/item/clothing/head/beekeeper,
		/obj/item/clothing/suit/beekeeper,
		/obj/item/beehive_assembly,
		/obj/item/bee_smoker,
		/obj/item/honey_frame = 5,
		/obj/item/bee_pack,
	)
	worth = 300
	container_name = "Beekeeping crate"

/datum/supply_pack/nanotrasen/hydroponics/tray
	name = "Empty hydroponics trays"
	worth = 75
	container_name = "Hydroponics tray crate"
	contains = list(
		/obj/machinery/portable_atmospherics/hydroponics/unanchored = 3,
	)

/datum/supply_pack/nanotrasen/hydroponics/ironwood
	name = "Ironwood Saplings"
	contains = list(
		/obj/item/seeds/ironwood = 6,
	)
	worth = 100
	container_name = "Ironwood Sapling Samples"

/datum/supply_pack/nanotrasen/hydroponics/creeper
	name = "Creeper Sanghum"
	contains = list(
		/obj/item/seeds/creepermoss = 6,
	)
	worth = 100
	container_name = "Creeper Sanghum Seeds"

/datum/supply_pack/nanotrasen/hydroponics/fungiwheat
	name = "Fungiwheat"
	contains = list(
		/obj/item/seeds/fungiwheat = 6,
	)
	worth = 100
	container_name = "Fungiwheat Spores"
