/datum/prototype/design/circuit/machine/bioscan_antenna
	design_name = "Bioscan Antenna"
	build_path = /obj/item/circuitboard/machine/bioscan
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	id = "machine_bioscan"
	req_tech = list(TECH_DATA = 1)

/datum/prototype/design/circuit/machine/bioprinter
	design_name = "Bioprinter"
	build_path = /obj/item/circuitboard/bioprinter
	id = "machine_bioprinter"
	req_tech = list(TECH_BIO = 5, TECH_DATA = 2)
