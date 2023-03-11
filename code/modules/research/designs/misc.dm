// Everything that didn't fit elsewhere

/datum/design/science/general/AssembleDesignName()
	..()
	name = "General purpose design ([build_name])"

/datum/design/science/general/communicator
	name = "Communicator"
	identifier = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/communicator

/datum/design/science/general/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	identifier = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/laser_pointer

/datum/design/science/general/translator
	name = "handheld translator"
	identifier = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/universal_translator

/datum/design/science/general/ear_translator
	name = "earpiece translator"
	identifier = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/universal_translator/ear

/datum/design/science/general/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	identifier = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer

/datum/design/science/illegal/AssembleDesignName()
	..()
	name = "Nonstandard design ([build_name])"

/datum/design/science/illegal/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	identifier = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/encryptionkey/binary

/datum/design/science/illegal/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	identifier = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500)
	build_path = /obj/item/storage/box/syndie_kit/chameleon

/datum/design/science/general/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	identifier = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace

/datum/design/science/general/sizegun
	name = "Size gun"
	identifier = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/gun/energy/sizegun
/*
/datum/design/science/general/bodysnatcher
	name = "Body Snatcher"
	identifier = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/bodysnatcher
*/
/datum/design/science/general/inducer_sci
	name = "Inducer (Scientific)"
	identifier = "inducersci"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 5, TECH_POWER = 6)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/inducer/sci

/datum/design/science/general/inducer_eng
	name = "Inducer (Industrial)"
	identifier = "inducerind"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_POWER = 7)
	materials = list(MAT_STEEL = 9000, MAT_GLASS = 3000, MAT_URANIUM = 5000, MAT_PHORON = 6000, MAT_DIAMOND = 1000) // Cit change until we have more of a need for titanium, MAT_TITANIUM = 2000)
	build_path = /obj/item/inducer/unloaded

/datum/design/science/general/translator_all
	name = "handheld omni-translator"
	identifier = "translator_all"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/universal_translator/adaptive

/datum/design/science/general/ear_translator_all
	name = "earpiece omni-translator"
	identifier = "ear_translator_all"
	req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6)	//dude what hte fuck lmao
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/universal_translator/ear/adaptive

/datum/design/science/advmop
	name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	identifier = "advmop"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(MAT_PLASTIC = 2500, MAT_STEEL = 500, MAT_COPPER = 200)
	build_path = /obj/item/mop/advanced

/datum/design/science/holosign
	name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	identifier = "holosign"
	req_tech = list(TECH_ENGINEERING = 5, TECH_BLUESPACE = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/holosign_creator

/datum/design/science/blutrash
	name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	identifier = "blutrash"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6)
	materials = list(MAT_PLASTIC = 5000, MAT_GOLD = 1500, MAT_URANIUM = 250, MAT_PHORON = 1500)
	build_path = /obj/item/storage/bag/trash/bluespace

/datum/design/item/reagent_synth_chemistry
	name = "Chemistry Synthesis Module"
	desc = "A reagent synthesis module required for dispenser functionality"
	id = "ReagentSynth"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6, TECH_BIO = 5)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 500, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/reagent_synth/chemistry
