// Modular computer components
/datum/design/science/modularcomponent/AssembleDesignName()
	..()
	name = "Computer part design ([item_name])"

// Hard drives

/datum/design/science/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/
	sort_string = "VAAAA"

/datum/design/science/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced
	sort_string = "VAAAB"

/datum/design/science/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super
	sort_string = "VAAAC"

/datum/design/science/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000, MAT_GLASS = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster
	sort_string = "VAAAD"

/datum/design/science/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small
	sort_string = "VAAAE"

/datum/design/science/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro
	sort_string = "VAAAF"

// Network cards

/datum/design/science/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 100)
	build_path = /obj/item/computer_hardware/network_card
	sort_string = "VBAAA"

/datum/design/science/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 200)
	build_path = /obj/item/computer_hardware/network_card/advanced
	sort_string = "VBAAB"

/datum/design/science/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 400)
	build_path = /obj/item/computer_hardware/network_card/wired
	sort_string = "VBAAC"

// Batteries

/datum/design/science/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module
	sort_string = "VCAAA"

/datum/design/science/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/advanced
	sort_string = "VCAAB"

/datum/design/science/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/battery_module/super
	sort_string = "VCAAC"

/datum/design/science/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 16000)
	build_path = /obj/item/computer_hardware/battery_module/ultra
	sort_string = "VCAAD"

/datum/design/science/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/computer_hardware/battery_module/nano
	sort_string = "VCAAE"

/datum/design/science/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/battery_module/micro
	sort_string = "VCAAF"

// Processor unit

/datum/design/science/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/computer_hardware/processor_unit
	sort_string = "VDAAA"

/datum/design/science/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/small
	sort_string = "VDAAB"

/datum/design/science/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 32000, glass = 8000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic
	sort_string = "VDAAC"

/datum/design/science/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 16000, glass = 4000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small
	sort_string = "VDAAD"

// Other parts

/datum/design/science/modularcomponent/cardslot
	name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/card_slot
	sort_string = "VEAAA"

/datum/design/science/modularcomponent/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/computer_hardware/nano_printer
	sort_string = "VEAAB"

/datum/design/science/modularcomponent/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/computer_hardware/tesla_link
	sort_string = "VEAAC"

// Data crystals (USB flash drives)

/datum/design/science/modularcomponent/portabledrive/AssembleDesignName()
	..()
	name = "Portable data drive design ([item_name])"

/datum/design/science/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/computer_hardware/hard_drive/portable
	sort_string = "VFAAA"

/datum/design/science/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 16000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced
	sort_string = "VFAAB"

/datum/design/science/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 32000)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
	sort_string = "VFAAC"
