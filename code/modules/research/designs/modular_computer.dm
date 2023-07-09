/datum/design/science/modularcomponent
	abstract_type = /datum/design/science/modularcomponent

/datum/design/science/modularcomponent/generate_name(template)
	return "Computer part design ([..()])"

/datum/design/science/modularcomponent/disk
	abstract_type = /datum/design/science/modularcomponent/disk

/datum/design/science/modularcomponent/disk/normal
	design_name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/stock_parts/computer/hard_drive/

/datum/design/science/modularcomponent/disk/advanced
	design_name = "advanced hard drive"
	id = "hdd_advanced"
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/hard_drive/advanced

/datum/design/science/modularcomponent/disk/super
	design_name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 400)
	build_path = /obj/item/stock_parts/computer/hard_drive/super

/datum/design/science/modularcomponent/disk/cluster
	design_name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000, MAT_GLASS = 800)
	build_path = /obj/item/stock_parts/computer/hard_drive/cluster

/datum/design/science/modularcomponent/disk/small
	design_name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/hard_drive/small

/datum/design/science/modularcomponent/disk/micro
	design_name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/stock_parts/computer/hard_drive/micro

/datum/design/science/modularcomponent/netcard
	abstract_type = /datum/design/science/modularcomponent/netcard

/datum/design/science/modularcomponent/netcard/basic
	design_name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 100)
	build_path = /obj/item/stock_parts/computer/network_card

/datum/design/science/modularcomponent/netcard/advanced
	design_name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/network_card/advanced

/datum/design/science/modularcomponent/netcard/wired
	design_name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 400)
	build_path = /obj/item/stock_parts/computer/network_card/wired

/datum/design/science/modularcomponent/battery
	abstract_type = /datum/design/science/modularcomponent/battery

/datum/design/science/modularcomponent/battery/normal
	design_name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/stock_parts/computer/battery_module

/datum/design/science/modularcomponent/battery/advanced
	design_name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/stock_parts/computer/battery_module/advanced

/datum/design/science/modularcomponent/battery/super
	design_name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/stock_parts/computer/battery_module/super

/datum/design/science/modularcomponent/battery/ultra
	design_name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000)
	build_path = /obj/item/stock_parts/computer/battery_module/ultra

/datum/design/science/modularcomponent/battery/nano
	design_name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/stock_parts/computer/battery_module/nano

/datum/design/science/modularcomponent/battery/micro
	design_name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/stock_parts/computer/battery_module/micro

/datum/design/science/modularcomponent/cpu
	abstract_type = /datum/design/science/modularcomponent/cpu

/datum/design/science/modularcomponent/cpu/normal
	design_name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/stock_parts/computer/processor_unit

/datum/design/science/modularcomponent/cpu/small
	design_name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/stock_parts/computer/processor_unit/small

/datum/design/science/modularcomponent/cpu/photonic
	design_name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 32000, glass = 8000)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic

/datum/design/science/modularcomponent/cpu/photonic/small
	design_name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 16000, glass = 4000)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic/small

/datum/design/science/modularcomponent/cardslot
	design_name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/stock_parts/computer/card_slot

/datum/design/science/modularcomponent/nanoprinter
	design_name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/stock_parts/computer/nano_printer

/datum/design/science/modularcomponent/teslalink
	design_name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/stock_parts/computer/tesla_link

/datum/design/science/modularcomponent/portabledrive
	abstract_type = /datum/design/science/modularcomponent/portabledrive

/datum/design/science/modularcomponent/portabledrive/generate_name(template)
	return "Portable data drive design ([..()])"

/datum/design/science/modularcomponent/portabledrive/basic
	design_name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable

/datum/design/science/modularcomponent/portabledrive/advanced
	design_name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 16000)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/advanced

/datum/design/science/modularcomponent/portabledrive/super
	design_name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 32000)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/super
