/datum/prototype/loot_pack/hydroponics
	abstract_type = /datum/prototype/loot_pack/hydroponics

/datum/prototype/loot_pack/hydroponics/drug_kit
	identifier = "DrugKit"
	always = list(
		/obj/machinery/portable_atmospherics/hydroponics = 3,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 2,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 2,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus = 5,
		/obj/item/flame/lighter/zippo = 1,
		/obj/item/seeds/ambrosiadeusseed = 3,
	)

/datum/prototype/loot_pack/hydroponics/random_seeds
	identifier = "SeedsRandom"
	amt = 10

/datum/prototype/loot_pack/hydroponics/random_seeds/draw(amount = amt)
	return list(/obj/item/seeds/random = amount)
