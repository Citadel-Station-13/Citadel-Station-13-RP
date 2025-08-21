/datum/prototype/design/science/boh
	abstract_type = /datum/prototype/design/science/boh
	category = DESIGN_CATEGORY_BLUESPACE

/datum/prototype/design/science/boh/bag_holding
	design_name = "Bag of Holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_of_holding"
	category = DESIGN_CATEGORY_STORAGE
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	// nah this stays at high values, bluespace bags bad lol
	materials_base = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding

/datum/prototype/design/science/boh/dufflebag_holding
	design_name = "Dufflebag of Holding"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dbag_of_holding"
	category = DESIGN_CATEGORY_STORAGE
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	// nah this stays at high values, bluespace bags bad lol
	materials_base = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding/duffle
