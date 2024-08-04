GLOBAL_LIST_INIT(generic_fishing_rare_list, list(
		/obj/item/fish/solarfin = 1,
		/obj/item/fish/bass/glitter = 5,
		/obj/item/fish/koi = 3,
		/obj/item/reagent_containers/food/snacks/lobster = 2,
		/obj/item/fish/crab/evil = 1
		))

GLOBAL_LIST_INIT(generic_fishing_uncommon_list, list(
		/obj/item/fish/salmon = 6,
		/obj/item/fish/pike = 10,
		/obj/item/fish/javelin = 3
		))

GLOBAL_LIST_INIT(generic_fishing_common_list, list(
		/obj/item/fish/bass = 10,
		/obj/item/fish/trout = 8,
		/obj/item/fish/perch = 6,
		/obj/item/reagent_containers/food/snacks/shrimp = 5,
		/obj/item/fish/murkin = 8,
		/obj/item/fish/rockfish = 5,
		/obj/item/fish/crab = 1
		))

GLOBAL_LIST_INIT(generic_fishing_junk_list, list(
		/obj/item/clothing/shoes/boots/cowboy = 1,
		/obj/random/fishing_junk = 10
		))

GLOBAL_LIST_INIT(generic_fishing_pool_list, list(
		/obj/item/bikehorn/rubberducky = 5,
		/obj/item/toy/plushie/carp = 20,
		/obj/random/junk = 80,
		/obj/random/trash = 80,
		/obj/item/spacecash/c1 = 10,
		/obj/item/spacecash/c10 = 5,
		/obj/item/spacecash/c100 = 1))

/obj/random/fishing_junk
	name = "junk"
	desc = "This is a random fishing junk item."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/fishing_junk/item_to_spawn()
	return pickweight(list(
	/obj/random/toy = 60,
	/obj/random/maintenance/engineering = 50,
	/obj/random/maintenance/clean = 40,
	/obj/random/maintenance/security = 40,
	/obj/random/maintenance/research = 40,
	/obj/structure/closet/crate/secure/loot = 30,
	/obj/random/bomb_supply = 30,
	/obj/random/powercell = 30,
	/obj/random/tech_supply/component = 30,
	/obj/random/unidentified_medicine/old_medicine = 30,
	/obj/random/plushie = 30,
	/obj/random/contraband = 20,
	/obj/random/coin = 20,
	/obj/random/medical = 15,
	/obj/random/unidentified_medicine/fresh_medicine = 15,
	/obj/random/action_figure = 15,
	/obj/random/plushielarge = 15,
	/obj/random/firstaid = 10,
	/obj/random/tool/powermaint = 5,
	/obj/random/unidentified_medicine/combat_medicine = 1,
	/obj/random/tool/alien = 1,
	/obj/random/handgun = 1,
	/mob/living/simple_mob/animal/sif/hooligan_crab = 1
	))
