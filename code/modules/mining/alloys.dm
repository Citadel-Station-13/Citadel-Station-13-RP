//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/durasteel
	metaltag = MATERIAL_ID_DURASTEEL
	requires = list(
		"diamond" = 1,
		"platinum" = 1,
		"carbon" = 2,
		"hematite" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/durasteel

/datum/alloy/plasteel
	metaltag = MATERIAL_ID_PLASTEEL
	requires = list(
		"platinum" = 1,
		"carbon" = 2,
		"hematite" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel

/datum/alloy/steel
	metaltag = MATERIAL_ID_STEEL
	requires = list(
		"carbon" = 1,
		"hematite" = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	metaltag = MATERIAL_ID_PHORONGLASS
	requires = list(
		"platinum" = 1,
		"sand" = 2
		)
	product = /obj/item/stack/material/glass/phoronglass