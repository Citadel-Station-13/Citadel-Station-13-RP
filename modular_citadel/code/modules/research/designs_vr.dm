/datum/design/item/nif
	name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 8000, "uranium" = 6000, "diamond" = 6000)
	build_path = /obj/item/device/nif
	sort_string = "HABBC"

/datum/design/item/nifbio
	name = "adaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 6, TECH_MATERIAL = 6, TECH_ENGINEERING = 6, TECH_DATA = 6, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 15000, "uranium" = 10000, "diamond" = 10000)
	build_path = /obj/item/device/nif/bioadap
	sort_string = "HABBCA" //Changed String from HABBE to HABBD

/datum/design/item/nifspecial
	name = "specialty NIF"
	id = "specialnif"
	req_tech = list(TECH_MAGNET = 7, TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_ENGINEERING = 7, TECH_DATA = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "glass" = 20000, "uranium" = 10000, "diamond" = 14000, "phoron" = 10000)
	build_path = /obj/item/device/nif/specialty
	sort_string = "HABBCB"

/datum/design/item/nifquality
	name = "quality NIF"
	id = "qualitynif"
	req_tech = list(TECH_MAGNET = 6, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 15000, "uranium" = 10000, "diamond" = 14000)
	build_path = /obj/item/device/nif/quality
	sort_string = "HABBCD"

/datum/design/item/nifdurable
	name = "durable NIF"
	id = "durablenif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_ENGINEERING = 7, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "glass" = 20000, "uranium" = 8000, "diamond" = 8000)
	build_path = /obj/item/device/nif/durable
	sort_string = "HABBCE"

/*/datum/design/item/nifsandbox //Removed until functionality implemented.
	name = "sandboxed NIF"
	id = "sandboxnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "uranium" = 6000, "diamond" = 2000)
	build_path = /obj/item/device/nif/sandbox
	sort_string = "HABBCF"*/

/datum/design/item/nifsurvival
	name = "survivalist NIF"
	id = "backupnif"
	req_tech = list(TECH_MAGNET = 7, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 6, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 4000, "phoron" = 8000)
	build_path = /obj/item/device/nif/backup
	sort_string = "HABBCG"

/datum/design/item/nifcheap
	name = "cheap NIF"
	id = "cheapnif"
	req_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 4000)
	build_path = /obj/item/device/nif/cheap
	sort_string = "HABBCH"

/datum/design/item/nifsize
	name = "sizechanger NIF"
	id = "sizenif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 8000, "uranium" = 6000, "diamond" = 6000)
	build_path = /obj/item/device/nif/preprogrammed/sizechange
	sort_string = "HABBCI"

/datum/category_item/autolathe/medical/consumernif
	name = "consumer NIF"
	path = /obj/item/device/nif/consumer