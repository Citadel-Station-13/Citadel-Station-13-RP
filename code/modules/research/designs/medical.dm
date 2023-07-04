/datum/design/science/medical
	abstract_type = /datum/design/science/medical
	materials = list(MAT_STEEL = 30, MAT_GLASS = 20)

/datum/design/science/medical/generate_name(template)
	return "Medical equipment prototype ([..()])"

// Surgical devices

/datum/design/science/medical/scalpel_laser1
	design_name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 5000)
	build_path = /obj/item/surgical/scalpel/laser1

/datum/design/science/medical/scalpel_laser2
	design_name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 5000, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/scalpel/laser2

/datum/design/science/medical/scalpel_laser3
	design_name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 5000, MAT_SILVER = 2000, MAT_GOLD = 1500)
	build_path = /obj/item/surgical/scalpel/laser3

/datum/design/science/medical/scalpel_manager
	design_name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 5000, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 750)
	build_path = /obj/item/surgical/scalpel/manager

/datum/design/science/medical/saw_manager
	design_name = "Energetic Bone Diverter"
	desc = "A strange development following the I.M.S., this heavy tool can split and open, or close and shut, intentional holes in bones."
	id = "advanced_saw"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_DATA = 5)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 800, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_OSMIUM = 1000)
	build_path = /obj/item/surgical/circular_saw/manager

/datum/design/science/medical/organ_ripper
	design_name = "Organ Ripper"
	desc = "A modern and horrifying take on an ancient practice, this tool is capable of rapidly removing an organ from a hopefully willing patient, without damaging it."
	id = "organ_ripper"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	materials = list (MAT_STEEL = 12500, MAT_PLASTIC = 8000, MAT_OSMIUM = 2500)
	build_path = /obj/item/surgical/scalpel/ripper

/datum/design/science/medical/bone_clamp
	design_name = "Bone Clamp"
	desc = "A miracle of modern science, this tool rapidly knits together bone, without the need for bone gel."
	id = "bone_clamp"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/surgical/bone_clamp

/datum/design/science/medical/switchtool
	design_name = "Surgical Multi-tool"
	desc = "A set of compact surgical instruments housed in a small handle, allowing surgical proccedures on the go."
	id = "surgery_switchtool"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list (MAT_STEEL = 12500, MAT_GLASS = 7500, MAT_SILVER = 2500)
	build_path = /obj/item/switchtool/surgery

/datum/design/science/medical/medical_analyzer
	design_name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	id = "medical_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/healthanalyzer

/datum/design/science/medical/improved_analyzer
	design_name = "improved health analyzer"
	desc = "A prototype version of the regular health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels."
	id = "improved_analyzer"
	req_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 1500)
	build_path = /obj/item/healthanalyzer/improved

/datum/design/science/medical/advanced_analyzer
	design_name = "advanced health analyzer"
	desc = "A prototype version of the improved health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels, and neurological analysis suites"
	id = "advanced_analyzer"
	req_tech = list(TECH_MAGNET = 6, TECH_BIO = 7, TECH_PHORON = 4)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1250, MAT_GOLD = 1750, MAT_URANIUM = 1000, MAT_PLASTIC = 500)
	build_path = /obj/item/healthanalyzer/advanced

/datum/design/science/medical/phasic_analyzer
	design_name = "phasic health analyzer"
	desc = "A prototype version of the advanced health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels, and neurological analysis suites. This analyzer even picks up chemicals in the patient's stomach."
	id = "phasic_analyzer"
	req_tech = list(TECH_MAGNET = 7, TECH_BIO = 8, TECH_BLUESPACE = 6, TECH_PHORON = 5)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1250, MAT_DIAMOND = 750, MAT_PHORON = 500, MAT_PLASTIC = 1000, MAT_OSMIUM = 500)
	build_path = /obj/item/healthanalyzer/phasic

/datum/design/science/medical/advanced_roller
	design_name = "advanced roller bed"
	desc = "A more advanced version of the regular roller bed, with inbuilt surgical stabilisers and an improved folding system."
	id = "roller_bed"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/roller/adv

//General stuff

/datum/design/item/medical/protohypospray
	design_name = "advanced hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 1500, MAT_SILVER = 2000, MAT_GOLD = 1500, MAT_URANIUM = 1000)
	build_path = /obj/item/hypospray/advanced

// ML-3M medigun and cells
/datum/design/science/medical/cell_based/generate_name(template)
	return "Cell-based medical prototype ([..()])"

/datum/design/science/medical/cell_based/cell_medigun_mag_advanced
	design_name = "advanced medical cell magazine"
	id = "cell_medigun_mag_advanced"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 4, TECH_BIO = 7)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 10000, MAT_GLASS = 5000, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 5000)
	build_path = /obj/item/ammo_magazine/cell_mag/medical/advanced

/datum/design/science/medigun_cell
	abstract_type = /datum/design/science/medigun_cell

/datum/design/science/medigun_cell/generate_name(template)
	return "Nanite cell prototype ([..()])"

//Tier 1

/datum/design/science/medigun_cell/toxin
	design_name = "TOXIN"
	id = "medigun_cell_toxin"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin

/datum/design/science/medigun_cell/omni
	design_name = "OMNI"
	id = "medigun_cell_omni"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni

/datum/design/science/medigun_cell/antirad
	design_name = "ANTIRAD"
	id = "medigun_cell_antirad"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250)
	build_path = /obj/item/ammo_casing/microbattery/medical/antirad

//Tier 2

/datum/design/science/medigun_cell/brute2
	design_name = "BRUTE-II"
	id = "medigun_cell_brute2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute2

/datum/design/science/medigun_cell/burn2
	design_name = "BURN-II"
	id = "medigun_cell_burn2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn2

/datum/design/science/medigun_cell/stabilize2
	design_name = "STABILIZE-II"
	id = "medigun_cell_stabilize2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_SILVER = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize2

/datum/design/science/medigun_cell/omni2
	design_name = "OMNI-II"
	id = "medigun_cell_omni2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni2

//Tier 3

/datum/design/science/medigun_cell/toxin2
	design_name = "TOXIN-II"
	id = "medigun_cell_toxin2"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 900, MAT_SILVER = 900, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin2

/datum/design/science/medigun_cell/haste
	design_name = "HASTE"
	id = "medigun_cell_haste"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900, MAT_SILVER = 900, MAT_DIAMOND = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/haste

/datum/design/science/medigun_cell/resist
	design_name = "RESIST"
	id = "medigun_cell_resist"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_GOLD = 900, MAT_URANIUM = 900, MAT_DIAMOND = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/resist

/datum/design/science/medigun_cell/corpse_mend
	design_name = "CORPSE MEND"
	id = "medigun_cell_corpse_mend"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_PHORON = 3000, MAT_DIAMOND = 3000)
	build_path = /obj/item/ammo_casing/microbattery/medical/corpse_mend

//Tier 4

/datum/design/science/medigun_cell/brute3
	design_name = "BRUTE-III"
	id = "medigun_cell_brute3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute3

/datum/design/science/medigun_cell/burn3
	design_name = "BURN-III"
	id = "medigun_cell_burn3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn3

/datum/design/science/medigun_cell/toxin3
	design_name = "TOXIN-III"
	id = "medigun_cell_toxin3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin3

/datum/design/science/medigun_cell/omni3
	design_name = "OMNI-III"
	id = "medigun_cell_omni3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_DIAMOND = 500, MAT_VERDANTIUM = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni3

//Tierless

/datum/design/science/medigun_cell/shrink
	design_name = "SHRINK"
	id = "medigun_cell_shrink"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 1800)
	build_path = /obj/item/ammo_casing/microbattery/medical/shrink

/datum/design/science/medigun_cell/grow
	design_name = "GROW"
	id = "medigun_cell_grow"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 1800)
	build_path = /obj/item/ammo_casing/microbattery/medical/grow

/datum/design/science/medigun_cell/normalsize
	design_name = "NORMALSIZE"
	id = "medigun_cell_normalsize"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 4500, MAT_GLASS = 4500, MAT_PLASTIC = 2250, MAT_URANIUM = 1800)
	build_path = /obj/item/ammo_casing/microbattery/medical/normalsize
