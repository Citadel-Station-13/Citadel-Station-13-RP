// Modular computer components
/datum/design/science/modularcomponent/AssembleDesignName()
	..()
	name = "Computer part design ([build_name])"

// Hard drives

/datum/design/science/modularcomponent/disk/normal
	name = "basic hard drive"
	identifier = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/

/datum/design/science/modularcomponent/disk/advanced
	name = "advanced hard drive"
	identifier = "hdd_advanced"
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced

/datum/design/science/modularcomponent/disk/super
	name = "super hard drive"
	identifier = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super

/datum/design/science/modularcomponent/disk/cluster
	name = "cluster hard drive"
	identifier = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000, MAT_GLASS = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster

/datum/design/science/modularcomponent/disk/small
	name = "small hard drive"
	identifier = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small

/datum/design/science/modularcomponent/disk/micro
	name = "micro hard drive"
	identifier = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro

// Network cards

/datum/design/science/modularcomponent/netcard/basic
	name = "basic network card"
	identifier = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/network_card

/datum/design/science/modularcomponent/netcard/advanced
	name = "advanced network card"
	identifier = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/network_card/advanced

/datum/design/science/modularcomponent/netcard/wired
	name = "wired network card"
	identifier = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 400)
	build_path = /obj/item/computer_hardware/network_card/wired

// Batteries

/datum/design/science/modularcomponent/battery/normal
	name = "standard battery module"
	identifier = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module

/datum/design/science/modularcomponent/battery/advanced
	name = "advanced battery module"
	identifier = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/advanced

/datum/design/science/modularcomponent/battery/super
	name = "super battery module"
	identifier = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/battery_module/super

/datum/design/science/modularcomponent/battery/ultra
	name = "ultra battery module"
	identifier = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000)
	build_path = /obj/item/computer_hardware/battery_module/ultra

/datum/design/science/modularcomponent/battery/nano
	name = "nano battery module"
	identifier = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module/nano

/datum/design/science/modularcomponent/battery/micro
	name = "micro battery module"
	identifier = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/micro

// Processor unit

/datum/design/science/modularcomponent/cpu/
	name = "computer processor unit"
	identifier = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/processor_unit

/datum/design/science/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	identifier = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/small

/datum/design/science/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	identifier = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 32000, glass = 8000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic

/datum/design/science/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	identifier = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 16000, glass = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small

// Other parts

/datum/design/science/modularcomponent/cardslot
	name = "RFID card slot"
	identifier = "cardslot"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/card_slot

/datum/design/science/modularcomponent/nanoprinter
	name = "nano printer"
	identifier = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/nano_printer

/datum/design/science/modularcomponent/teslalink
	name = "tesla link"
	identifier = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/computer_hardware/tesla_link

// Data crystals (USB flash drives)

/datum/design/science/modularcomponent/portabledrive/AssembleDesignName()
	..()
	name = "Portable data drive design ([build_name])"

/datum/design/science/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	identifier = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/computer_hardware/hard_drive/portable

/datum/design/science/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	identifier = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 16000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced

/datum/design/science/modularcomponent/portabledrive/super
	name = "super data crystal"
	identifier = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 32000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
