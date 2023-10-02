/datum/design/circuit/algae_farm
	design_name = "Algae Oxygen Generator"
	id = "algae_farm"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm

/datum/design/circuit/thermoregulator
	design_name = "thermal regulator"
	id = "thermoregulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator

/datum/design/circuit/bomb_tester
	design_name = "Explosive Effect Simulator"
	id = "bomb_tester"
	req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester

/datum/design/circuit/quantum_pad
	design_name = "Quantum Pad"
	id = "QuantumPadCircuit"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4, TECH_BLUESPACE = 4, TECH_PRECURSOR = 1)
	build_path = /obj/item/circuitboard/quantumpad

//////Micro mech stuff
/datum/design/circuit/mecha/gopher_main
	design_name = "'Gopher' central control"
	id = "gopher_main"
	build_path = /obj/item/circuitboard/mecha/gopher/main

/datum/design/circuit/mecha/gopher_peri
	design_name = "'Gopher' peripherals control"
	id = "gopher_peri"
	build_path = /obj/item/circuitboard/mecha/gopher/peripherals

/datum/design/circuit/mecha/polecat_main
	design_name = "'Polecat' central control"
	id = "polecat_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/main

/datum/design/circuit/mecha/polecat_peri
	design_name = "'Polecat' peripherals control"
	id = "polecat_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/peripherals

/datum/design/circuit/mecha/polecat_targ
	design_name = "'Polecat' weapon control and targeting"
	id = "polecat_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/polecat/targeting

/datum/design/circuit/mecha/weasel_main
	design_name = "'Weasel' central control"
	id = "weasel_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/main

/datum/design/circuit/mecha/weasel_peri
	design_name = "'Weasel' peripherals control"
	id = "weasel_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/peripherals

/datum/design/circuit/mecha/weasel_targ
	design_name = "'Weasel' weapon control and targeting"
	id = "weasel_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/weasel/targeting

/datum/design/circuit/transhuman_clonepod
	design_name = "grower pod"
	id = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod

/datum/design/circuit/transhuman_synthprinter
	design_name = "SynthFab 3000"
	id = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter

/datum/design/circuit/transhuman_resleever
	design_name = "Resleeving pod"
	id = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever

// Resleeving

/datum/design/circuit/resleeving_control
	design_name = "Resleeving control console"
	id = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control

// Telesci stuff

/datum/design/circuit/telesci_console
	design_name = "Telepad Control Console"
	id = "telesci_console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/circuitboard/telesci_console

/datum/design/circuit/telesci_pad
	design_name = "Telepad"
	id = "telesci_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/telesci_pad

/datum/design/circuit/vitals_monitor
	design_name = "vitals monitor"
	id = "vitals"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/machine/vitals_monitor
