// Yeah yeah, vague file name. Basically a misc folder for antag things that RnD can make.

/datum/design/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	sort_string = "VASBA"

/datum/design/item/dartgun
	name = "Illegal dartgun"
	desc = "A rapid firing dart gun, uses top loaded clips."
	id = "dartgun"
	req_tech = list(TECH_ILLEGAL = 8)
	materials = list(DEFAULT_WALL_MATERIAL = 7500, "glass" = 5000, "silver" = 4000, "gold" = 8500, "uranium" = 20000, "diamond" = 2000, "osmium" = 1000, "plastic" = 1000)
	build_path = /obj/item/weapon/gun/projectile/dartgun
	sort_string = "VASBC"

/datum/design/item/dartgun_cartridge
	name = "Illegal dartgun cartridge"
	desc = "A cartridge of toxic darts used in dartguns."
	id = "dartgun_cartridge"
	req_tech = list(TECH_ILLEGAL = 8)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000,  "uranium" = 2000)
	build_path = /obj/item/ammo_magazine/chemdart
	sort_string = "VASBED"
