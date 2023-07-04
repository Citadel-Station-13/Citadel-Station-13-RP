/datum/design/science/stock_part/subspace
	abstract_type = /datum/design/science/stock_part/subspace

/datum/design/science/stock_part/subspace/generate_name(template)
	return "Subspace component design ([..()])"

/datum/design/science/stock_part/subspace/subspace_ansible
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 80, MAT_SILVER = 20)
	build_path = /obj/item/stock_parts/subspace/ansible

/datum/design/science/stock_part/subspace/hyperwave_filter
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 40, MAT_SILVER = 10)
	build_path = /obj/item/stock_parts/subspace/sub_filter

/datum/design/science/stock_part/subspace/subspace_amplifier
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_GOLD = 30, MAT_URANIUM = 15)
	build_path = /obj/item/stock_parts/subspace/amplifier

/datum/design/science/stock_part/subspace/subspace_treatment
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_SILVER = 20)
	build_path = /obj/item/stock_parts/subspace/treatment

/datum/design/science/stock_part/subspace/subspace_analyzer
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_GOLD = 15)
	build_path = /obj/item/stock_parts/subspace/analyzer

/datum/design/science/stock_part/subspace/subspace_crystal
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_GLASS = 1000, MAT_SILVER = 20, MAT_GOLD = 20)
	build_path = /obj/item/stock_parts/subspace/crystal

/datum/design/science/stock_part/subspace/subspace_transmitter
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list(MAT_GLASS = 100, MAT_SILVER = 10, MAT_URANIUM = 15)
	build_path = /obj/item/stock_parts/subspace/transmitter
