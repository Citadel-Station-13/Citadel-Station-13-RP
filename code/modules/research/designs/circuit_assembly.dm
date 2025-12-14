/datum/prototype/design/science/integrated_circuitry
	category = DESIGN_CATEGORY_INTEGRATED_CIRCUITRY
	abstract_type = /datum/prototype/design/science/integrated_circuitry

/datum/prototype/design/science/integrated_circuitry/custom_circuit_printer
	id = "integrated_circuit_printer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_DATA = 5)
	materials_base = list(MAT_STEEL = 2500)
	build_path = /obj/item/integrated_circuit_printer

/datum/prototype/design/science/integrated_circuitry/custom_circuit_printer_upgrade
	id = "integrated_circuit_adv_disk"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)
	materials_base = list(MAT_STEEL = 125)
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced

/datum/prototype/design/science/integrated_circuitry/wirer
	design_name = "Custom wirer tool"
	id = "integrated_circuit_wirer"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 125, MAT_GLASS = 55)
	build_path = /obj/item/integrated_electronics/wirer

/datum/prototype/design/science/integrated_circuitry/debugger
	design_name = "Custom circuit debugger tool"
	id = "integrated_circuit_debugger"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 125, MAT_GLASS = 55)
	build_path = /obj/item/integrated_electronics/debugger
