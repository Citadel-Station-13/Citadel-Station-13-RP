/datum/prototype/loot_pack/chemistry
	abstract_type = /datum/prototype/loot_pack/chemistry

/datum/prototype/loot_pack/chemistry/advanced
	always = list(
		/obj/item/reagent_containers/glass/beaker/bluespace,
		/obj/item/reagent_containers/hypospray/science,
		/obj/item/storage/firstaid/combat,
	)
	some = list(
		/obj/item/reagent_containers/glass/beaker/bluespace = 1,
		/obj/item/reagent_containers/glass/beaker/large = 1,
		/obj/item/reagent_containers/glass/beaker/noreact = 1,
	)
	amt = 5
