/datum/design/circuit/machine/chemical_dispenser
	name = "Chemical Dispenser"
	build_path = /obj/item/circuitboard/machine/chemical_dispenser
	identifier = "MachineChemicalDispenser"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3, TECH_MATERIAL = 4)

/datum/design/circuit/machine/soda_dispenser
	name = "Drink Dispenser (Soda)"
	build_path = /obj/item/circuitboard/machine/chemical_dispenser/soda
	identifier = "MachineDrinkDispenserSoda"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3, TECH_MATERIAL = 4)

/datum/design/circuit/machine/booze_dispenser
	name = "Drink Dispenser (Bar)"
	build_path = /obj/item/circuitboard/machine/chemical_dispenser/booze
	identifier = "MachineDrinkDispenserBooze"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3, TECH_MATERIAL = 4)

/datum/design/circuit/machine/cafe_dispenser
	name = "Drink Dispenser (Cafe)"
	build_path = /obj/item/circuitboard/machine/chemical_dispenser/cafe
	identifier = "MachineDrinkDispenserCafe"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3, TECH_MATERIAL = 4)
