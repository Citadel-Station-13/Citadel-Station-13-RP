// Everything that didn't fit elsewhere

/datum/design/item/general/AssembleDesignName()
	..()
	name = "General purpose design ([item_name])"

/datum/design/item/general/communicator
	name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/communicator
	sort_string = "TAAAA"

/datum/design/item/general/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/laser_pointer
	sort_string = "TAABA"

/datum/design/item/general/translator
	name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/universal_translator
	sort_string = "TAACA"

/datum/design/item/general/ear_translator
	name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/universal_translator/ear
	sort_string = "TAACB"

/datum/design/item/general/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer
	sort_string = "TAADA"

/datum/design/item/illegal/AssembleDesignName()
	..()
	name = "Nonstandard design ([item_name])"

/datum/design/item/illegal/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/encryptionkey/binary
	sort_string = "TBAAA"

/datum/design/item/illegal/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500)
	build_path = /obj/item/storage/box/syndie_kit/chameleon
	sort_string = "TBAAB"

/datum/design/item/general/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace
	sort_string = "TAVAA"

/datum/design/item/general/sizegun
	name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/gun/energy/sizegun
	sort_string = "TAVAB"
/*
/datum/design/item/general/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/bodysnatcher
	sort_string = "TBVAA"
*/
/datum/design/item/general/inducer_sci
	name = "Inducer (Scientific)"
	id = "inducersci"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 5, TECH_POWER = 6)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/inducer/sci
	sort_string = "TAVAB"

/datum/design/item/general/inducer_eng
	name = "Inducer (Industrial)"
	id = "inducerind"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_POWER = 7)
	materials = list(MAT_STEEL = 9000, MAT_GLASS = 3000, MAT_URANIUM = 5000, MAT_PHORON = 6000, MAT_DIAMOND = 1000) // Cit change until we have more of a need for titanium, MAT_TITANIUM = 2000)
	build_path = /obj/item/inducer/unloaded
	sort_string = "TAVAC"

/datum/design/item/general/translator_all
	name = "handheld omni-translator"
	id = "translator_all"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/universal_translator/all
	sort_string = "TAACC"

/datum/design/item/general/ear_translator_all
	name = "earpiece omni-translator"
	id = "ear_translator_all"
	req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6)	//dude what hte fuck lmao
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/universal_translator/ear/all
	sort_string = "TAACD"

/datum/design/item/advmop
	name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	id = "advmop"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(MAT_PLASTIC = 2500, MAT_STEEL = 500, MAT_COPPER = 200)
	build_path = /obj/item/mop/advanced

/datum/design/item/holosign
	name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	id = "holosign"
	req_tech = list(TECH_ENGINEERING = 5, TECH_BLUESPACE = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/holosign_creator

/datum/design/item/blutrash
	name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	id = "blutrash"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6)
	materials = list(MAT_PLASTIC = 5000, MAT_GOLD = 1500, MAT_URANIUM = 250, MAT_PHORON = 1500)
	build_path = /obj/item/storage/bag/trash/bluespace
