/datum/design/science/disk
	abstract_type = /datum/design/science/disk

/datum/design/science/disk/generate_name(template)
	return "Data storage design ([..()])"

/datum/design/science/disk/design_disk
	design_name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/disk/design_disk

/datum/design/science/disk/tech_disk
	design_name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/disk/tech_disk
