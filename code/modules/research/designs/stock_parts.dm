/*
	Various Stock Parts
*/

/datum/design/science/stock_part
	lathe_type = LATHE_TYPE_PROTOLATHE
	work = (3 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds. //Sets an independent time for stock parts, currently one third normal print time.

/datum/design/science/stock_part/generate_name(template)
	return "Component design ([..()])"

// Matter Bins

/datum/design/science/stock_part/basic_matter_bin
	identifier = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin

/datum/design/science/stock_part/adv_matter_bin
	identifier = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin/adv

/datum/design/science/stock_part/super_matter_bin
	identifier = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin/super

/datum/design/science/stock_part/hyper_matter_bin
	identifier = "hyper_matter_bin"
	req_tech = list(TECH_MATERIAL = 6, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 200, MAT_VERDANTIUM = 60, MAT_DURASTEEL = 75)
	build_path = /obj/item/stock_parts/matter_bin/hyper

/datum/design/science/stock_part/omni_matter_bin
	identifier = "omni_matter_bin"
	req_tech = list(TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 2000, MAT_PLASTEEL = 100, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/matter_bin/omni

// Micro-manipulators

/datum/design/science/stock_part/micro_mani
	identifier = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator

/datum/design/science/stock_part/nano_mani
	identifier = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator/nano

/datum/design/science/stock_part/pico_mani
	identifier = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator/pico

/datum/design/science/stock_part/hyper_mani
	identifier = "hyper_mani"
	req_tech = list(TECH_MATERIAL = 6, TECH_DATA = 3, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 200, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 50)
	build_path = /obj/item/stock_parts/manipulator/hyper

/datum/design/science/stock_part/omni_mani
	identifier = "omni_mani"
	req_tech = list(TECH_MATERIAL = 7, TECH_DATA = 4, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 2000, MAT_PLASTEEL = 500, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/manipulator/omni

// Capacitors

/datum/design/science/stock_part/basic_capacitor
	identifier = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor

/datum/design/science/stock_part/adv_capacitor
	identifier = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor/adv

/datum/design/science/stock_part/super_capacitor
	identifier = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50, MAT_GOLD = 20)
	build_path = /obj/item/stock_parts/capacitor/super

/datum/design/science/stock_part/hyper_capacitor
	identifier = "hyper_capacitor"
	req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 1, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 100, MAT_VERDANTIUM = 30, MAT_DURASTEEL = 25)
	build_path = /obj/item/stock_parts/capacitor/hyper

/datum/design/science/stock_part/omni_capacitor
	identifier = "omni_capacitor"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 2000, MAT_DIAMOND = 1000, MAT_GLASS = 1000, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/capacitor/omni

// Sensors

/datum/design/science/stock_part/basic_sensor
	identifier = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module

/datum/design/science/stock_part/adv_sensor
	identifier = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module/adv

/datum/design/science/stock_part/phasic_sensor
	identifier = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20, MAT_SILVER = 10)
	build_path = /obj/item/stock_parts/scanning_module/phasic

/datum/design/science/stock_part/hyper_sensor
	identifier = "hyper_sensor"
	req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 4, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20, MAT_SILVER = 50, MAT_VERDANTIUM = 40, MAT_DURASTEEL = 50)
	build_path = /obj/item/stock_parts/scanning_module/hyper

/datum/design/science/stock_part/omni_sensor
	identifier = "omni_sensor"
	req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 1000, MAT_PLASTEEL = 500, MAT_GLASS = 750, MAT_SILVER = 500, MAT_MORPHIUM = 60, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/scanning_module/omni

// Micro-lasers

/datum/design/science/stock_part/basic_micro_laser
	identifier = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser

/datum/design/science/stock_part/high_micro_laser
	identifier = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser/high

/datum/design/science/stock_part/ultra_micro_laser
	identifier = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20, MAT_URANIUM = 10)
	build_path = /obj/item/stock_parts/micro_laser/ultra

/datum/design/science/stock_part/hyper_micro_laser
	identifier = "hyper_micro_laser"
	req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 6, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 20, MAT_URANIUM = 30, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/micro_laser/hyper

/datum/design/science/stock_part/omni_micro_laser
	identifier = "omni_micro_laser"
	req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 2000, MAT_MORPHIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/micro_laser/omni


// RPEDs

/datum/design/science/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	identifier = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/storage/part_replacer

/datum/design/science/stock_part/ARPED
	name = "Advanced Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity."
	identifier = "arped"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/storage/part_replacer/adv
