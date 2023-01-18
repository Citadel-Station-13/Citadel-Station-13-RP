/*
*	Here is where any supply packs
*	related to hydroponics tasks live.
*/


/datum/supply_pack/hydro
	group = "Hydroponics"

/datum/supply_pack/hydro/monkey
	name = "Monkey crate"
	contains = list (/obj/item/storage/box/monkeycubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Monkey crate"

/datum/supply_pack/hydro/farwa
	name = "Farwa crate"
	contains = list (/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Farwa crate"

/datum/supply_pack/hydro/neara
	name = "Neaera crate"
	contains = list (/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Neaera crate"

/datum/supply_pack/hydro/stok
	name = "Stok crate"
	contains = list (/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Stok crate"

/datum/supply_pack/hydro/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	container_type = /obj/structure/largecrate/animal/corgi
	container_name = "Corgi Crate"

/datum/supply_pack/hydro/cat
	name = "Cat Crate"
	contains = list()
	cost = 45
	container_type = /obj/structure/largecrate/animal/cat
	container_name = "Cat Crate"

/datum/supply_pack/hydro/hydroponics
	name = "Hydroponics Supply Crate"
	contains = list(
			/obj/item/reagent_containers/spray/plantbgone = 4,
			/obj/item/reagent_containers/glass/bottle/ammonia = 2,
			/obj/item/material/knife/machete/hatchet,
			/obj/item/material/minihoe,
			/obj/item/analyzer/plant_analyzer,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/suit/storage/apron,
			/obj/item/material/minihoe,
			/obj/item/storage/box/botanydisk
			)
	cost = 20
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Hydroponics crate"
	access = access_hydroponics

/datum/supply_pack/hydro/cow
	name = "Cow crate"
	cost = 25
	container_type = /obj/structure/largecrate/animal/cow
	container_name = "Cow crate"
	access = access_hydroponics

/datum/supply_pack/hydro/goat
	name = "Goat crate"
	cost = 25
	container_type = /obj/structure/largecrate/animal/goat
	container_name = "Goat crate"
	access = access_hydroponics

/datum/supply_pack/hydro/chicken
	name = "Chicken crate"
	cost = 25
	container_type = /obj/structure/largecrate/animal/chick
	container_name = "Chicken crate"
	access = access_hydroponics

/datum/supply_pack/hydro/seeds
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
			/obj/item/seeds/sugarcaneseed
			)
	cost = 10
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Seeds crate"
	access = access_hydroponics

/datum/supply_pack/hydro/weedcontrol
	name = "Weed control crate"
	contains = list(
			/obj/item/material/knife/machete/hatchet = 2,
			/obj/item/reagent_containers/spray/plantbgone = 4,
			/obj/item/clothing/mask/gas = 2,
			/obj/item/grenade/chem_grenade/antiweed = 2,
			/obj/item/material/twohanded/fireaxe/scythe
			)
	cost = 45
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Weed control crate"
	access = access_hydroponics

/datum/supply_pack/hydro/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 10
	container_type = /obj/structure/largecrate
	container_name = "water tank crate"

/datum/supply_pack/hydro/bee_keeper
	name = "Beekeeping crate"
	contains = list(
			/obj/item/clothing/head/beekeeper,
			/obj/item/clothing/suit/beekeeper,
			/obj/item/beehive_assembly,
			/obj/item/bee_smoker,
			/obj/item/honey_frame = 5,
			/obj/item/bee_pack
			)
	cost = 40
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Beekeeping crate"
	access = access_hydroponics

/datum/supply_pack/hydro/tray
	name = "Empty hydroponics trays"
	cost = 50
	container_type = /obj/structure/closet/crate/hydroponics
	container_name = "Hydroponics tray crate"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0} = 3)
	access = access_hydroponics


/datum/supply_pack/hydro/diycarpotox
	name = "Gather-It-Yourself Carpotoxin"
	cost = 30
	container_type = /obj/structure/largecrate/animal/carp
	container_name = "DIY carpotoxin crate"

/datum/supply_pack/hydro/diyspidertox
	name = "Gather-It-Yourself Spider Toxin"
	cost = 30
	container_type = /obj/structure/largecrate/animal/spiders
	container_name = "DIY spider toxin crate"

/datum/supply_pack/hydro/birds
	name = "Birds Crate"
	cost = 200 //You're getting 22 birds. Of course it's going to be a lot!
	container_type = /obj/structure/largecrate/birds
	container_name = "Bird crate"
	access = access_hydroponics

/datum/supply_pack/hydro/sobaka
	name = "Sobaka crate"
	contains = list (/obj/item/storage/box/monkeycubes/sobakacubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Sobaka crate"

/datum/supply_pack/hydro/saru
	name = "Saru crate"
	contains = list (/obj/item/storage/box/monkeycubes/sarucubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Saru crate"

/datum/supply_pack/hydro/sparra
	name = "Sparra crate"
	contains = list (/obj/item/storage/box/monkeycubes/sparracubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Sparra crate"

/datum/supply_pack/hydro/wolpin
	name = "Wolpin crate"
	contains = list (/obj/item/storage/box/monkeycubes/wolpincubes)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Wolpin crate"

/datum/supply_pack/hydro/fennec
	name = "Fennec crate"
	cost = 60 //considering a corgi crate is 50, and you get two fennecs
	container_type = /obj/structure/largecrate/animal/fennec
	container_name = "Fennec crate"

/datum/supply_pack/hydro/fish
	name = "Fish supply crate"
	contains = list(
			/obj/item/reagent_containers/food/snacks/lobster = 6,
			/obj/item/reagent_containers/food/snacks/shrimp = 6,
			/obj/item/reagent_containers/food/snacks/cuttlefish = 8,
			/obj/item/reagent_containers/food/snacks/sliceable/monkfish = 1
			)
	cost = 20
	container_type = /obj/structure/closet/crate/freezer
	container_name = "Fish crate"

/datum/supply_pack/hydro/woolie
	name = "Woolie crate"
	cost = 50
	container_type = /obj/structure/largecrate/animal/woolie
	container_name = "Woolie crate"
	access = access_hydroponics

/datum/supply_pack/hydro/icegoat
	name = "Glacicorn crate"
	cost = 50
	container_type = /obj/structure/largecrate/animal/icegoat
	container_name = "Glacicorn crate"
	access = access_hydroponics

/datum/supply_pack/hydro/cow
	name = "Furnace Grub crate"
	cost = 40
	container_type = /obj/structure/largecrate/animal/furnacegrub
	container_name = "Furnace Grub crate"
	access = access_hydroponics



