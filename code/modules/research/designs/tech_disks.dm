/datum/prototype/design/science/disk
	category = DESIGN_CATEGORY_DATA
	abstract_type = /datum/prototype/design/science/disk

/datum/prototype/design/science/disk/generate_name(template)
	return "Data storage design ([..()])"

/datum/prototype/design/science/disk/design_disk
	design_name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/disk/design_disk

/datum/prototype/design/science/disk/tech_disk
	design_name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/disk/tech_disk
