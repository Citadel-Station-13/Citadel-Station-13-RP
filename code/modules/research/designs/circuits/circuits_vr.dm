/datum/design/circuit/algae_farm
	name = "Algae Oxygen Generator"
	identifier = "algae_farm"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/algae_farm

/datum/design/circuit/thermoregulator
	name = "thermal regulator"
	identifier = "thermoregulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/circuitboard/thermoregulator

/datum/design/circuit/bomb_tester
	name = "Explosive Effect Simulator"
	identifier = "bomb_tester"
	req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester

/datum/design/circuit/quantum_pad
	name = "Quantum Pad"
	identifier = "QuantumPadCircuit"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4, TECH_BLUESPACE = 4, TECH_PRECURSOR = 1)
	build_path = /obj/item/circuitboard/quantumpad

//////Micro mech stuff
/datum/design/circuit/mecha/gopher_main
	name = "'Gopher' central control"
	identifier = "gopher_main"
	build_path = /obj/item/circuitboard/mecha/gopher/main

/datum/design/circuit/mecha/gopher_peri
	name = "'Gopher' peripherals control"
	identifier = "gopher_peri"
	build_path = /obj/item/circuitboard/mecha/gopher/peripherals

/datum/design/circuit/mecha/polecat_main
	name = "'Polecat' central control"
	identifier = "polecat_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/main

/datum/design/circuit/mecha/polecat_peri
	name = "'Polecat' peripherals control"
	identifier = "polecat_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/polecat/peripherals

/datum/design/circuit/mecha/polecat_targ
	name = "'Polecat' weapon control and targeting"
	identifier = "polecat_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/polecat/targeting

/datum/design/circuit/mecha/weasel_main
	name = "'Weasel' central control"
	identifier = "weasel_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/main

/datum/design/circuit/mecha/weasel_peri
	name = "'Weasel' peripherals control"
	identifier = "weasel_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/weasel/peripherals

/datum/design/circuit/mecha/weasel_targ
	name = "'Weasel' weapon control and targeting"
	identifier = "weasel_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/weasel/targeting

/datum/design/circuit/transhuman_clonepod
	name = "grower pod"
	identifier = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod

/datum/design/circuit/transhuman_synthprinter
	name = "SynthFab 3000"
	identifier = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter

/datum/design/circuit/transhuman_resleever
	name = "Resleeving pod"
	identifier = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever

// Resleeving

/datum/design/circuit/resleeving_control
	name = "Resleeving control console"
	identifier = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control

/datum/design/circuit/partslathe
	name = "Parts lathe"
	identifier = "partslathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/partslathe

// Telesci stuff

/datum/design/circuit/telesci_console
	name = "Telepad Control Console"
	identifier = "telesci_console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/circuitboard/telesci_console

/datum/design/circuit/telesci_pad
	name = "Telepad"
	identifier = "telesci_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/telesci_pad

/datum/design/circuit/quantum_pad
	name = "Quantum Pad"
<<<<<<< HEAD
	identifier = "quantum_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
=======
	id = "quantum_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5, TECH_PRECURSOR = 1)
>>>>>>> citrp/master
	build_path = /obj/item/circuitboard/quantumpad

/datum/design/circuit/vitals_monitor
	name = "vitals monitor"
	identifier = "vitals"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/machine/vitals_monitor
