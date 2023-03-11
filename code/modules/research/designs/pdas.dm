// PDA

/datum/design/science/general/pda
	name = "PDA"
	desc = "Cheaper than whiny non-digital assistants."
	identifier = "pda"
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/pda

// Cartridges

/datum/design/science/pda_cartridge
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design/science/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([build_name])"

/datum/design/science/pda_cartridge/cart_basic
	identifier = "cart_basic"
	build_path = /obj/item/cartridge

/datum/design/science/pda_cartridge/engineering
	identifier = "cart_engineering"
	build_path = /obj/item/cartridge/engineering

/datum/design/science/pda_cartridge/atmos
	identifier = "cart_atmos"
	build_path = /obj/item/cartridge/atmos

/datum/design/science/pda_cartridge/medical
	identifier = "cart_medical"
	build_path = /obj/item/cartridge/medical

/datum/design/science/pda_cartridge/chemistry
	identifier = "cart_chemistry"
	build_path = /obj/item/cartridge/chemistry

/datum/design/science/pda_cartridge/security
	identifier = "cart_security"
	build_path = /obj/item/cartridge/security

/datum/design/science/pda_cartridge/janitor
	identifier = "cart_janitor"
	build_path = /obj/item/cartridge/janitor

/datum/design/science/pda_cartridge/science
	identifier = "cart_science"
	build_path = /obj/item/cartridge/signal/science

/datum/design/science/pda_cartridge/quartermaster
	identifier = "cart_quartermaster"
	build_path = /obj/item/cartridge/quartermaster

/datum/design/science/pda_cartridge/head
	identifier = "cart_head"
	build_path = /obj/item/cartridge/head

/datum/design/science/pda_cartridge/hop
	identifier = "cart_hop"
	build_path = /obj/item/cartridge/hop

/datum/design/science/pda_cartridge/hos
	identifier = "cart_hos"
	build_path = /obj/item/cartridge/hos

/datum/design/science/pda_cartridge/ce
	identifier = "cart_ce"
	build_path = /obj/item/cartridge/ce

/datum/design/science/pda_cartridge/cmo
	identifier = "cart_cmo"
	build_path = /obj/item/cartridge/cmo

/datum/design/science/pda_cartridge/rd
	identifier = "cart_rd"
	build_path = /obj/item/cartridge/rd

/datum/design/science/pda_cartridge/captain
	identifier = "cart_captain"
	build_path = /obj/item/cartridge/captain
