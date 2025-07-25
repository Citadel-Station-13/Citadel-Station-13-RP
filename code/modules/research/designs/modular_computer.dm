/datum/prototype/design/science/modularcomponent
	category = DESIGN_CATEGORY_COMPUTER
	abstract_type = /datum/prototype/design/science/modularcomponent

/datum/prototype/design/science/modularcomponent/disk
	category = DESIGN_CATEGORY_COMPUTER
	subcategory = "Storage"
	abstract_type = /datum/prototype/design/science/modularcomponent/disk

/datum/prototype/design/science/modularcomponent/disk/normal
	design_name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/

/datum/prototype/design/science/modularcomponent/disk/advanced
	design_name = "advanced hard drive"
	id = "hdd_advanced"
	materials_base = list(MAT_STEEL = 400, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced

/datum/prototype/design/science/modularcomponent/disk/super
	design_name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 250)
	build_path = /obj/item/computer_hardware/hard_drive/super

/datum/prototype/design/science/modularcomponent/disk/cluster
	design_name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 800, MAT_GLASS = 350)
	build_path = /obj/item/computer_hardware/hard_drive/cluster

/datum/prototype/design/science/modularcomponent/disk/small
	design_name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 400, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small

/datum/prototype/design/science/modularcomponent/disk/micro
	design_name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro

/datum/prototype/design/science/modularcomponent/netcard
	abstract_type = /datum/prototype/design/science/modularcomponent/netcard

/datum/prototype/design/science/modularcomponent/netcard/basic
	design_name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 250, MAT_GLASS = 50)
	build_path = /obj/item/computer_hardware/network_card

/datum/prototype/design/science/modularcomponent/netcard/advanced
	design_name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 275, MAT_GLASS = 75)
	build_path = /obj/item/computer_hardware/network_card/advanced

/datum/prototype/design/science/modularcomponent/netcard/wired
	design_name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 150, MAT_GLASS = 25)
	build_path = /obj/item/computer_hardware/network_card/wired

/datum/prototype/design/science/modularcomponent/battery
	abstract_type = /datum/prototype/design/science/modularcomponent/battery

/datum/prototype/design/science/modularcomponent/battery/normal
	design_name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 200)
	build_path = /obj/item/computer_hardware/battery_module

/datum/prototype/design/science/modularcomponent/battery/advanced
	design_name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 250)
	build_path = /obj/item/computer_hardware/battery_module/advanced

/datum/prototype/design/science/modularcomponent/battery/super
	design_name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 350)
	build_path = /obj/item/computer_hardware/battery_module/super

/datum/prototype/design/science/modularcomponent/battery/ultra
	design_name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 450)
	build_path = /obj/item/computer_hardware/battery_module/ultra

/datum/prototype/design/science/modularcomponent/battery/nano
	design_name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 200)
	build_path = /obj/item/computer_hardware/battery_module/nano

/datum/prototype/design/science/modularcomponent/battery/micro
	design_name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 250)
	build_path = /obj/item/computer_hardware/battery_module/micro

/datum/prototype/design/science/modularcomponent/cpu
	abstract_type = /datum/prototype/design/science/modularcomponent/cpu

/datum/prototype/design/science/modularcomponent/cpu/normal
	design_name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 250)
	build_path = /obj/item/computer_hardware/processor_unit

/datum/prototype/design/science/modularcomponent/cpu/small
	design_name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 250)
	build_path = /obj/item/computer_hardware/processor_unit/small

/datum/prototype/design/science/modularcomponent/cpu/photonic
	design_name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 350, glass = 500)
	build_path = /obj/item/computer_hardware/processor_unit/photonic

/datum/prototype/design/science/modularcomponent/cpu/photonic/small
	design_name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 350, glass = 500)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small

/datum/prototype/design/science/modularcomponent/cardslot
	design_name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	materials_base = list(MAT_STEEL = 250)
	build_path = /obj/item/computer_hardware/card_slot

/datum/prototype/design/science/modularcomponent/nanoprinter
	design_name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 250)
	build_path = /obj/item/computer_hardware/nano_printer

/datum/prototype/design/science/modularcomponent/teslalink
	design_name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 375)
	build_path = /obj/item/computer_hardware/tesla_link

/datum/prototype/design/science/modularcomponent/portabledrive
	abstract_type = /datum/prototype/design/science/modularcomponent/portabledrive

/datum/prototype/design/science/modularcomponent/portabledrive/generate_name(template)
	return "Portable data drive design ([..()])"

/datum/prototype/design/science/modularcomponent/portabledrive/basic
	design_name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	materials_base = list(MAT_GLASS = 250)
	build_path = /obj/item/computer_hardware/hard_drive/portable

/datum/prototype/design/science/modularcomponent/portabledrive/advanced
	design_name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	materials_base = list(MAT_GLASS = 350)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced

/datum/prototype/design/science/modularcomponent/portabledrive/super
	design_name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	materials_base = list(MAT_GLASS = 450)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
