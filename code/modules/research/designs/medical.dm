/datum/prototype/design/science/medical
	abstract_type = /datum/prototype/design/science/medical
	category = DESIGN_CATEGORY_MEDICAL
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)

// Surgical devices

/datum/prototype/design/science/medical/scalpel_laser1
	id = "laserscalpel"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 5000)
	build_path = /obj/item/surgical/scalpel/laser1

/datum/prototype/design/science/medical/scalpel_laser2
	id = "ilaserscalpel"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 5000, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/scalpel/laser2

/datum/prototype/design/science/medical/scalpel_laser3
	id = "advlaserscalpel"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 5000, MAT_SILVER = 2000, MAT_GOLD = 1500)
	build_path = /obj/item/surgical/scalpel/laser3

/datum/prototype/design/science/medical/scalpel_manager
	id = "ims"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 5000, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 750)
	build_path = /obj/item/surgical/scalpel/manager

/datum/prototype/design/science/medical/saw_manager
	id = "superbonesaw"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_DATA = 5)
	materials_base = list (MAT_STEEL = 12500, MAT_PLASTIC = 800, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_OSMIUM = 1000)
	build_path = /obj/item/surgical/circular_saw/manager

/datum/prototype/design/science/medical/organ_ripper
	id = "organshredder"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	materials_base = list (MAT_STEEL = 12500, MAT_PLASTIC = 8000, MAT_OSMIUM = 2500)
	build_path = /obj/item/surgical/scalpel/ripper

/datum/prototype/design/science/medical/bone_clamp
	id = "boneclamp"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials_base = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/bone_clamp

/datum/prototype/design/science/medical/switchtool
	id = "surgeonswitchtool"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials_base = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/switchtool/surgery

/datum/prototype/design/science/medical/medical_analyzer
	id = "healthscanner"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/healthanalyzer

/datum/prototype/design/science/medical/improved_analyzer
	id = "ihealthscanner"
	req_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 1500)
	build_path = /obj/item/healthanalyzer/improved

/datum/prototype/design/science/medical/advanced_analyzer
	id = "advhealthscanner"
	req_tech = list(TECH_MAGNET = 6, TECH_BIO = 7, TECH_PHORON = 4)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1250, MAT_GOLD = 1750, MAT_URANIUM = 1000, MAT_PLASTIC = 500)
	build_path = /obj/item/healthanalyzer/advanced

/datum/prototype/design/science/medical/phasic_analyzer
	id = "phahealthscanner"
	req_tech = list(TECH_MAGNET = 7, TECH_BIO = 8, TECH_BLUESPACE = 6, TECH_PHORON = 5)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1250, MAT_DIAMOND = 750, MAT_PHORON = 500, MAT_PLASTIC = 1000, MAT_OSMIUM = 500)
	build_path = /obj/item/healthanalyzer/phasic

/datum/prototype/design/science/medical/advanced_roller
	id = "superrollerbed"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/roller/adv

//General stuff

/datum/prototype/design/science/medical/protohypospray
	id = "protohypo"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 1500, MAT_SILVER = 2000, MAT_GOLD = 1500, MAT_URANIUM = 1000)
	build_path = /obj/item/hypospray/advanced

/datum/prototype/design/science/medical/cell_based
	abstract_type = /datum/prototype/design/science/medical/cell_based

/datum/prototype/design/science/medical/cell_based/cell_medigun_mag_advanced
	design_name = "advanced medical cell magazine"
	id = "advmedcellmag"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 4, TECH_BIO = 7)
	materials_base = list(MAT_STEEL = 5000, MAT_PLASTIC = 10000, MAT_GLASS = 5000, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 5000)
	build_path = /obj/item/ammo_magazine/microbattery/vm_aml/sidearm/advanced

/datum/prototype/design/science/medigun_cell
	category = DESIGN_CATEGORY_MEDIGUN //stop clogging up other categoriesp lease
	abstract_type = /datum/prototype/design/science/medigun_cell

/datum/prototype/design/science/medigun_cell/generate_name(template)
	return "Nanite cell prototype ([..()])"

//Tier 1

/datum/prototype/design/science/medigun_cell/toxin
	design_name = "TOXIN"
	id = "meditoxcell"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/toxin

/datum/prototype/design/science/medigun_cell/omni
	design_name = "OMNI"
	id = "mediomnicell"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/omni

/datum/prototype/design/science/medigun_cell/antirad
	design_name = "ANTIRAD"
	id = "mediaradcell"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/antirad

//Tier 2

/datum/prototype/design/science/medigun_cell/brute2
	design_name = "BRUTE-II"
	id = "medibrute2cell"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/brute2

/datum/prototype/design/science/medigun_cell/burn2
	design_name = "BURN-II"
	id = "mediburn2cell"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/burn2

/datum/prototype/design/science/medigun_cell/stabilize2
	design_name = "STABILIZE-II"
	id = "RNDDesignMedigunCellStab2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_SILVER = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/stabilize2

/datum/prototype/design/science/medigun_cell/omni2
	design_name = "OMNI-II"
	id = "mediomni2cell"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/omni2

//Tier 3

/datum/prototype/design/science/medigun_cell/toxin2
	design_name = "TOXIN-II"
	id = "meditox2cell"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 900, MAT_SILVER = 900, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/toxin2

/datum/prototype/design/science/medigun_cell/haste
	design_name = "HASTE"
	id = "medihastecell"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900, MAT_SILVER = 900, MAT_DIAMOND = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/haste

/datum/prototype/design/science/medigun_cell/resist
	design_name = "RESIST"
	id = "mediresistcell"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900, MAT_URANIUM = 900, MAT_DIAMOND = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/resist

/datum/prototype/design/science/medigun_cell/corpse_mend
	design_name = "CORPSE MEND"
	id = "medicorpsemendcell"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_PHORON = 3000, MAT_DIAMOND = 3000)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/corpse_mend

//Tier 4

/datum/prototype/design/science/medigun_cell/brute3
	design_name = "BRUTE-III"
	id = "medibrut3cell"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/brute3

/datum/prototype/design/science/medigun_cell/burn3
	design_name = "BURN-III"
	id = "mediburn3cell"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/burn3

/datum/prototype/design/science/medigun_cell/toxin3
	design_name = "meditox3cell"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/toxin3

/datum/prototype/design/science/medigun_cell/omni3
	design_name = "OMNI-III"
	id = "mediomni3cell"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/omni3

//Tierless

/datum/prototype/design/science/medigun_cell/shrink
	design_name = "SHRINK"
	id = "medishrinkcell"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 1800)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/shrink

/datum/prototype/design/science/medigun_cell/grow
	design_name = "GROW"
	id = "medigrowcell"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 1800)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/grow

/datum/prototype/design/science/medigun_cell/normalsize
	design_name = "NORMALSIZE"
	id = "medinormalcell"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 1800)
	build_path = /obj/item/ammo_casing/microbattery/vm_aml/normalsize
