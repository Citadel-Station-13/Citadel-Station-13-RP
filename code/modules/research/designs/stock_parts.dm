/*
	Various Stock Parts
*/

/datum/prototype/design/science/stock_part
	abstract_type = /datum/prototype/design/science/stock_part
	lathe_type = LATHE_TYPE_PROTOLATHE
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_PARTS
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds. //Sets an independent time for stock parts, currently one third normal print time.
	var/tier = 0

/datum/prototype/design/science/stock_part/generate_name(template)
	if(tier > 0)
		return "Component design (T[tier]: [..()])"
	return "Component design ([..()])"

// Matter Bins

/datum/prototype/design/science/stock_part/basic_matter_bin
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials_base = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin
	tier = 1

/datum/prototype/design/science/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials_base = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin/adv
	tier = 2

/datum/prototype/design/science/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials_base = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin/super
	tier = 3

/datum/prototype/design/science/stock_part/hyper_matter_bin
	id = "hyper_matter_bin"
	req_tech = list(TECH_MATERIAL = 6, TECH_ARCANE = 2)
	materials_base = list(MAT_STEEL = 200, MAT_VERDANTIUM = 60, MAT_DURASTEEL = 75)
	build_path = /obj/item/stock_parts/matter_bin/hyper
	tier = 4

/datum/prototype/design/science/stock_part/omni_matter_bin
	id = "omni_matter_bin"
	req_tech = list(TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_PLASTEEL = 100, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/matter_bin/omni
	tier = 5

// Micro-manipulators

/datum/prototype/design/science/stock_part/micro_mani
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials_base = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator
	tier = 1

/datum/prototype/design/science/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials_base = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator/nano
	tier = 2

/datum/prototype/design/science/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials_base = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator/pico
	tier = 3

/datum/prototype/design/science/stock_part/hyper_mani
	id = "hyper_mani"
	req_tech = list(TECH_MATERIAL = 6, TECH_DATA = 3, TECH_ARCANE = 2)
	materials_base = list(MAT_STEEL = 200, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 50)
	build_path = /obj/item/stock_parts/manipulator/hyper
	tier = 4

/datum/prototype/design/science/stock_part/omni_mani
	id = "omni_mani"
	req_tech = list(TECH_MATERIAL = 7, TECH_DATA = 4, TECH_PRECURSOR = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_PLASTEEL = 500, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/manipulator/omni
	tier = 5

// Capacitors

/datum/prototype/design/science/stock_part/basic_capacitor
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor
	tier = 1

/datum/prototype/design/science/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor/adv
	tier = 2

/datum/prototype/design/science/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50, MAT_GOLD = 20)
	build_path = /obj/item/stock_parts/capacitor/super
	tier = 3

/datum/prototype/design/science/stock_part/hyper_capacitor
	id = "hyper_capacitor"
	req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 1, TECH_ARCANE = 1)
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 100, MAT_VERDANTIUM = 30, MAT_DURASTEEL = 25)
	build_path = /obj/item/stock_parts/capacitor/hyper
	tier = 4

/datum/prototype/design/science/stock_part/omni_capacitor
	id = "omni_capacitor"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials_base = list(MAT_STEEL = 2000, MAT_DIAMOND = 1000, MAT_GLASS = 1000, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/capacitor/omni
	tier = 5

// Sensors

/datum/prototype/design/science/stock_part/basic_sensor
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module
	tier = 1

/datum/prototype/design/science/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module/adv
	tier = 2

/datum/prototype/design/science/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 20, MAT_SILVER = 10)
	build_path = /obj/item/stock_parts/scanning_module/phasic
	tier = 3

/datum/prototype/design/science/stock_part/hyper_sensor
	id = "hyper_sensor"
	req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 4, TECH_ARCANE = 1)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 20, MAT_SILVER = 50, MAT_VERDANTIUM = 40, MAT_DURASTEEL = 50)
	build_path = /obj/item/stock_parts/scanning_module/hyper
	tier = 4

/datum/prototype/design/science/stock_part/omni_sensor
	id = "omni_sensor"
	req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials_base = list(MAT_STEEL = 1000, MAT_PLASTEEL = 500, MAT_GLASS = 750, MAT_SILVER = 500, MAT_MORPHIUM = 60, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/scanning_module/omni
	tier = 5

// Micro-lasers

/datum/prototype/design/science/stock_part/basic_micro_laser
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials_base = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser
	tier = 1

/datum/prototype/design/science/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser/high
	tier = 2

/datum/prototype/design/science/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials_base = list(MAT_STEEL = 10, MAT_GLASS = 20, MAT_URANIUM = 10)
	build_path = /obj/item/stock_parts/micro_laser/ultra
	tier = 3

/datum/prototype/design/science/stock_part/hyper_micro_laser
	id = "hyper_micro_laser"
	req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 6, TECH_ARCANE = 2)
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 20, MAT_URANIUM = 30, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/micro_laser/hyper
	tier = 4

/datum/prototype/design/science/stock_part/omni_micro_laser
	id = "omni_micro_laser"
	req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 2000, MAT_MORPHIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/micro_laser/omni
	tier = 5

// RPEDs

/datum/prototype/design/science/stock_part/RPED
	design_name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/storage/part_replacer

/datum/prototype/design/science/stock_part/ARPED
	design_name = "Advanced Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity."
	id = "arped"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/storage/part_replacer/adv

/datum/prototype/design/science/stock_part/ERPED
	design_name = "Experimental Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity, \
	is made more compact, and can upgrade while maintenance panels are closed."
	id = "erped" //honestly an unfortunate acronym but I'm keeping it lmao
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 6)
	build_path = /obj/item/storage/part_replacer/experimental
