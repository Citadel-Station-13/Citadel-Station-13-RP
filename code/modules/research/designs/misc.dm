/datum/prototype/design/science/general
	abstract_type = /datum/prototype/design/science/general



/datum/prototype/design/science/general/communicator
	design_name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 250, MAT_GLASS = 125)
	category = DESIGN_CATEGORY_TELECOMMUNICATIONS
	build_path = /obj/item/communicator

/datum/prototype/design/science/general/laserpointer
	design_name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 75, MAT_GLASS = 50)
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/laser_pointer

/datum/prototype/design/science/general/translator
	design_name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 350, MAT_GLASS = 250)
	build_path = /obj/item/universal_translator

/datum/prototype/design/science/general/ear_translator
	design_name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 200, MAT_GOLD = 100)
	build_path = /obj/item/universal_translator/ear

/datum/prototype/design/science/general/light_replacer
	design_name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 500, MAT_SILVER = 150, MAT_GLASS = 250)
	build_path = /obj/item/lightreplacer

/datum/prototype/design/science/illegal
	abstract_type = /datum/prototype/design/science/illegal

/datum/prototype/design/science/illegal/generate_name(template)
	return "Non-standard design ([..()])"

/datum/prototype/design/science/illegal/binaryencrypt
	design_name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials_base = list(MAT_STEEL = 75, MAT_GLASS = 25)
	build_path = /obj/item/encryptionkey/binary

/datum/prototype/design/science/illegal/chameleon
	design_name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials_base = list(MAT_STEEL = 500)
	build_path = /obj/item/storage/box/syndie_kit/chameleon

/datum/prototype/design/science/general/bluespace_jumpsuit
	design_name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 125)
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/clothing/under/bluespace

/datum/prototype/design/science/general/sizegun
	design_name = "Size gun"
	id = "sizegun"
	category = DESIGN_CATEGORY_RECREATION
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 750, MAT_URANIUM = 250)
	build_path = /obj/item/gun/projectile/energy/sizegun

/datum/prototype/design/science/general/inducer_sci
	design_name = "Inducer (Scientific)"
	id = "inducersci"
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_CHARGING
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 5, TECH_POWER = 6)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1500, MAT_URANIUM = 750, MAT_PHORON = 250)
	build_path = /obj/item/inducer/sci

/datum/prototype/design/science/general/inducer_eng
	design_name = "Inducer (Industrial)"
	id = "inducerind"
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_CHARGING
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_POWER = 7)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1500, MAT_URANIUM = 1000, MAT_GOLD = 375, MAT_SILVER = 400, MAT_DIAMOND = 250)
	build_path = /obj/item/inducer/unloaded

/datum/prototype/design/science/general/translator_all
	design_name = "handheld omni-translator"
	id = "translator_all"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 250, MAT_GOLD = 250, MAT_SILVER = 250)
	build_path = /obj/item/universal_translator/adaptive

/datum/prototype/design/science/general/ear_translator_all
	design_name = "earpiece omni-translator"
	id = "ear_translator_all"
	req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6)	//dude what hte fuck lmao
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 250, MAT_GOLD = 250, MAT_SILVER = 250)
	build_path = /obj/item/universal_translator/ear/adaptive

/datum/prototype/design/science/advmop
	design_name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	id = "advmop"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials_base = list(MAT_PLASTIC = 1250, MAT_STEEL = 500, MAT_COPPER = 200)
	build_path = /obj/item/mop/advanced

/datum/prototype/design/science/holosign
	design_name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	id = "holosign"
	req_tech = list(TECH_ENGINEERING = 5, TECH_BLUESPACE = 4, TECH_POWER = 4)
	materials_base = list(MAT_STEEL = 350, MAT_GLASS = 125)
	build_path = /obj/item/holosign_creator

/datum/prototype/design/science/blutrash
	design_name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	id = "blutrash"
	category = DESIGN_CATEGORY_STORAGE
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6)
	materials_base = list(MAT_PLASTIC = 750, MAT_GOLD = 250, MAT_URANIUM = 375, MAT_PHORON = 500)
	build_path = /obj/item/storage/bag/trash/bluespace

/datum/prototype/design/science/reagent_synth_chemistry
	design_name = "Chemistry Synthesis Module"
	desc = "A reagent synthesis module required for dispenser functionality"
	id = "ReagentSynth"
	subcategory = DESIGN_SUBCATEGORY_STATION
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 6, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 400, MAT_GLASS = 200, MAT_URANIUM = 500, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/reagent_synth/chemistry

/datum/prototype/design/science/size_standardization
	design_name = "Size Standardization Bracelet"
	desc = "A bracelet that changes the size of the wearer to the galactic standard."
	id = "sizestandardbracelet"
	category = DESIGN_CATEGORY_RECREATION
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 3, TECH_BIO = 4)
	materials_base = list(MAT_STEEL = 200)
	build_path = /obj/item/clothing/gloves/size

/datum/prototype/design/science/coffeepot_bluespace
	design_name = "Bluespace Coffeepot"
	id = "bluespace_coffeepot"
	// using phoron in your coffee pot is a good idea
	materials_base = list(MAT_STEEL = 1000, MAT_PLASTIC = 500, MAT_PHORON = 500)
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3)
	build_path = /obj/item/reagent_containers/food/drinks/coffeepot/bluespace
	category = DESIGN_CATEGORY_RECREATION
