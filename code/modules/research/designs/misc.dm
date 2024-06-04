/datum/design/science/general
	abstract_type = /datum/design/science/general

/datum/design/science/general/generate_name(template)
	return "General purpose design ([..()])"

/datum/design/science/general/communicator
	design_name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/communicator

/datum/design/science/general/laserpointer
	design_name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/laser_pointer

/datum/design/science/general/translator
	design_name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/universal_translator

/datum/design/science/general/ear_translator
	design_name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/universal_translator/ear

/datum/design/science/general/light_replacer
	design_name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer

/datum/design/science/illegal
	abstract_type = /datum/design/science/illegal

/datum/design/science/illegal/generate_name(template)
	return "Non-standard design ([..()])"

/datum/design/science/illegal/binaryencrypt
	design_name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials_base = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/encryptionkey/binary

/datum/design/science/illegal/chameleon
	design_name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials_base = list(MAT_STEEL = 500)
	build_path = /obj/item/storage/box/syndie_kit/chameleon

/datum/design/science/general/bluespace_jumpsuit
	design_name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace

/datum/design/science/general/sizegun
	design_name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000)
	build_path = /obj/item/gun/energy/sizegun

/datum/design/science/general/inducer_sci
	design_name = "Inducer (Scientific)"
	id = "inducersci"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 5, TECH_POWER = 6)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/inducer/sci

/datum/design/science/general/inducer_eng
	design_name = "Inducer (Industrial)"
	id = "inducerind"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_POWER = 7)
	materials_base = list(MAT_STEEL = 9000, MAT_GLASS = 3000, MAT_URANIUM = 5000, MAT_PHORON = 6000, MAT_DIAMOND = 1000) // Cit change until we have more of a need for titanium, MAT_TITANIUM = 2000)
	build_path = /obj/item/inducer/unloaded

/datum/design/science/general/translator_all
	design_name = "handheld omni-translator"
	id = "translator_all"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 3000, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/universal_translator/adaptive

/datum/design/science/general/ear_translator_all
	design_name = "earpiece omni-translator"
	id = "ear_translator_all"
	req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6)	//dude what hte fuck lmao
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/universal_translator/ear/adaptive

/datum/design/science/advmop
	design_name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	id = "advmop"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials_base = list(MAT_PLASTIC = 2500, MAT_STEEL = 500, MAT_COPPER = 200)
	build_path = /obj/item/mop/advanced

/datum/design/science/holosign
	design_name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	id = "holosign"
	req_tech = list(TECH_ENGINEERING = 5, TECH_BLUESPACE = 4, TECH_POWER = 4)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/holosign_creator

/datum/design/science/blutrash
	design_name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	id = "blutrash"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6)
	materials_base = list(MAT_PLASTIC = 5000, MAT_GOLD = 1500, MAT_URANIUM = 250, MAT_PHORON = 1500)
	build_path = /obj/item/storage/bag/trash/bluespace

/datum/design/science/reagent_synth_chemistry
	design_name = "Chemistry Synthesis Module"
	desc = "A reagent synthesis module required for dispenser functionality"
	id = "ReagentSynth"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 500, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/reagent_synth/chemistry
