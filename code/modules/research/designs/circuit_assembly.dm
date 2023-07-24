/datum/design/science/integrated_circuitry
	abstract_type = /datum/design/science/integrated_circuitry

/datum/design/science/integrated_circuitry/generate_name(template)
	return "Circuitry device design ([..()])"

/datum/design/science/integrated_circuitry/custom_circuit_printer
	design_name = "Portable integrated circuit printer"
	desc = "A portable(ish) printer for modular machines."
	id = "ic_printer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_DATA = 5)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/integrated_circuit_printer

/datum/design/science/integrated_circuitry/custom_circuit_printer_upgrade
	design_name = "Integrated circuit printer upgrade - advanced designs"
	desc = "Allows the integrated circuit printer to create advanced circuits"
	id = "ic_printer_upgrade_adv"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced

/datum/design/science/integrated_circuitry/wirer
	design_name = "Custom wirer tool"
	id = "wirer"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	build_path = /obj/item/integrated_electronics/wirer

/datum/design/science/integrated_circuitry/debugger
	design_name = "Custom circuit debugger tool"
	id = "debugger"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	build_path = /obj/item/integrated_electronics/debugger

// Assemblies

/datum/design/science/integrated_circuitry/assembly
	abstract_type = /datum/design/science/integrated_circuitry/assembly

/datum/design/science/integrated_circuitry/assembly/generate_name(template)
	return "Circuitry assembly design ([..()])"

/datum/design/science/integrated_circuitry/assembly/custom_circuit_assembly_small
	design_name = "Small custom assembly"
	desc = "A customizable assembly for simple, small devices."
	id = "assembly-small"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/electronic_assembly

/datum/design/science/integrated_circuitry/assembly/custom_circuit_assembly_medium
	design_name = "Medium custom assembly"
	desc = "A customizable assembly suited for more ambitious mechanisms."
	id = "assembly-medium"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 20000)
	build_path = /obj/item/electronic_assembly/medium

/datum/design/science/integrated_circuitry/assembly/custom_circuit_assembly_large
	design_name = "Large custom assembly"
	desc = "A customizable assembly for large machines."
	id = "assembly-large"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 40000)
	build_path = /obj/item/electronic_assembly/large

/datum/design/science/integrated_circuitry/assembly/custom_circuit_assembly_drone
	design_name = "Drone custom assembly"
	desc = "A customizable assembly optimized for autonomous devices."
	id = "assembly-drone"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 30000)
	build_path = /obj/item/electronic_assembly/drone

/datum/design/science/integrated_circuitry/assembly/custom_circuit_assembly_device
	design_name = "Device custom assembly"
	desc = "An customizable assembly designed to interface with other devices."
	id = "assembly-device"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/assembly/electronic_assembly

/datum/design/science/integrated_circuitry/assembly/custom_circuit_assembly_implant
	design_name = "Implant custom assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	id = "assembly-implant"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/implant/integrated_circuit
