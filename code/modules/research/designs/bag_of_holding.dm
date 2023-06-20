// Bags of holding

/datum/design/science/boh/generate_name(template)
	return "Bluespace storage prototype ([..()])"

/datum/design/science/boh/bag_holding
	design_name = "Bag of Holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding

/datum/design/science/boh/dufflebag_holding
	design_name = "DuffleBag of Holding"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "duffle-holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding/duffle
