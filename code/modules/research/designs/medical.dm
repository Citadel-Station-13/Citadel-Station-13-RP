/datum/design/item/medical
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Medical equipment prototype ([item_name])"

// Surgical devices

/datum/design/item/medical/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500)
	build_path = /obj/item/surgical/scalpel/laser1
	sort_string = "KAAAA"

/datum/design/item/medical/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 2500)
	build_path = /obj/item/surgical/scalpel/laser2
	sort_string = "KAAAB"

/datum/design/item/medical/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 2000, "gold" = 1500)
	build_path = /obj/item/surgical/scalpel/laser3
	sort_string = "KAAAC"

/datum/design/item/medical/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 1500, "gold" = 1500, "diamond" = 750)
	build_path = /obj/item/surgical/scalpel/manager
	sort_string = "KAAAD"

/datum/design/item/medical/saw_manager
	name = "Energetic Bone Diverter"
	desc = "A strange development following the I.M.S., this heavy tool can split and open, or close and shut, intentional holes in bones."
	id = "advanced_saw"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_DATA = 5)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, MAT_PLASTIC = 800, "silver" = 1500, "gold" = 1500, MAT_OSMIUM = 1000)
	build_path = /obj/item/surgical/circular_saw/manager
	sort_string = "KAAAE"

/datum/design/item/medical/organ_ripper
	name = "Organ Ripper"
	desc = "A modern and horrifying take on an ancient practice, this tool is capable of rapidly removing an organ from a hopefully willing patient, without damaging it."
	id = "organ_ripper"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, MAT_PLASTIC = 8000, MAT_OSMIUM = 2500)
	build_path = /obj/item/surgical/scalpel/ripper
	sort_string = "KAAAF"

/datum/design/item/medical/bone_clamp
	name = "Bone Clamp"
	desc = "A miracle of modern science, this tool rapidly knits together bone, without the need for bone gel."
	id = "bone_clamp"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 2500)
	build_path = /obj/item/surgical/bone_clamp
	sort_string = "KAABA"

/datum/design/item/medical/medical_analyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	id = "medical_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	build_path = /obj/item/healthanalyzer
	sort_string = "KBAAA"

/datum/design/item/medical/improved_analyzer
	name = "improved health analyzer"
	desc = "A prototype version of the regular health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels."
	id = "improved_analyzer"
	req_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "silver" = 1000, "gold" = 1500)
	build_path = /obj/item/healthanalyzer/improved
	sort_string = "KBAAB"

/datum/design/item/medical/advanced_analyzer
	name = "advanced health analyzer"
	desc = "A prototype version of the improved health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels, and neurological analysis suites"
	id = "advanced_analyzer"
	req_tech = list(TECH_MAGNET = 6, TECH_BIO = 7, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "silver" = 1250, "gold" = 1750, "uranium" = 1000, "plastic" = 500)
	build_path = /obj/item/healthanalyzer/advanced
	sort_string = "KBAAC"

/datum/design/item/medical/phasic_analyzer
	name = "phasic health analyzer"
	desc = "A prototype version of the advanced health analyzer, able to distinguish the location of more serious injuries as well as accurately determine radiation levels, and neurological analysis suites. This analyzer even picks up chemicals in the patient's stomach."
	id = "phasic_analyzer"
	req_tech = list(TECH_MAGNET = 7, TECH_BIO = 8, TECH_BLUESPACE = 6, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "silver" = 1500, "gold" = 2000, "uranium" = 1250, "diamond" = 750, "phoron" = 500, "plastic" = 1000, "osmium" = 500)
	build_path = /obj/item/healthanalyzer/phasic
	sort_string = "KBAAD"

/datum/design/item/medical/advanced_roller
	name = "advanced roller bed"
	desc = "A more advanced version of the regular roller bed, with inbuilt surgical stabilisers and an improved folding system."
	id = "roller_bed"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "phoron" = 2000)
	build_path = /obj/item/roller/adv
	sort_string = "KCAAA"

/*
	KV - ML3M stuff
		KVA - gun
		KVB - magazines
		KVC - cells
			KVCA - tier 0
			KVCB - tier 1
			KVCC - tier 2
			KVCD - tier 3
			KVCE - tier 4
			KVCO - tierless
*/

//General stuff

/datum/design/item/medical/sleevemate
	name = "SleeveMate 3700"
	id = "sleevemate"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/sleevemate
	sort_string = "KCAVA"

/datum/design/item/medical/protohypospray
	name = "prototype hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 1500, "silver" = 2000, "gold" = 1500, "uranium" = 1000)
	build_path = /obj/item/reagent_containers/hypospray/science
	sort_string = "KCAVB"

// ML-3M medigun and cells
/datum/design/item/medical/cell_based/AssembleDesignName()
	..()
	name = "Cell-based medical prototype ([item_name])"

/datum/design/item/medical/cell_based/cell_medigun
	name = "cell-loaded medigun"
	id = "cell_medigun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plastic" = 8000, "glass" = 5000, "silver" = 1000, "gold" = 1000, "uranium" = 1000)
	build_path = /obj/item/gun/projectile/cell_loaded/medical
	sort_string = "KVAAA"

/datum/design/item/medical/cell_based/cell_medigun_mag
	name = "medical cell magazine"
	id = "cell_medigun_mag"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "plastic" = 6000, "glass" = 3000, "silver" = 500, "gold" = 500)
	build_path = /obj/item/ammo_magazine/cell_mag/medical
	sort_string = "KVBAA"

/datum/design/item/medical/cell_based/cell_medigun_mag_advanced
	name = "advanced medical cell magazine"
	id = "cell_medigun_mag_advanced"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 4, TECH_BIO = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plastic" = 10000, "glass" = 5000, "silver" = 1500, "gold" = 1500, "diamond" = 5000)
	build_path = /obj/item/ammo_magazine/cell_mag/medical/advanced
	sort_string = "KVBAB"

/datum/design/item/ml3m_cell/AssembleDesignName()
	..()
	name = "Nanite cell prototype ([name])"

//Tier 0

/datum/design/item/ml3m_cell/brute
	name = "BRUTE"
	id = "ml3m_cell_brute"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute
	sort_string = "KVCAA"

/datum/design/item/ml3m_cell/burn
	name = "BURN"
	id = "ml3m_cell_burn"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn
	sort_string = "KVCAB"

/datum/design/item/ml3m_cell/stabilize
	name = "STABILIZE"
	id = "ml3m_cell_stabilize"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize
	sort_string = "KVCAC"

//Tier 1

/datum/design/item/ml3m_cell/toxin
	name = "TOXIN"
	id = "ml3m_cell_toxin"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin
	sort_string = "KVCBA"

/datum/design/item/ml3m_cell/omni
	name = "OMNI"
	id = "ml3m_cell_omni"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni
	sort_string = "KVCBB"

/datum/design/item/ml3m_cell/antirad
	name = "ANTIRAD"
	id = "ml3m_cell_antirad"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250)
	build_path = /obj/item/ammo_casing/microbattery/medical/antirad
	sort_string = "KVCBC"

//Tier 2

/datum/design/item/ml3m_cell/brute2
	name = "BRUTE-II"
	id = "ml3m_cell_brute2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "gold" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute2
	sort_string = "KVCCA"

/datum/design/item/ml3m_cell/burn2
	name = "BURN-II"
	id = "ml3m_cell_burn2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "gold" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn2
	sort_string = "KVCCB"

/datum/design/item/ml3m_cell/stabilize2
	name = "STABILIZE-II"
	id = "ml3m_cell_stabilize2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "silver" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize2
	sort_string = "KVCCC"

/datum/design/item/ml3m_cell/omni2
	name = "OMNI-II"
	id = "ml3m_cell_omni2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "uranium" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni2
	sort_string = "KVCCD"

//Tier 3

/datum/design/item/ml3m_cell/toxin2
	name = "TOXIN-II"
	id = "ml3m_cell_toxin2"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "uranium" = 900, "silver" = 900, "diamond" = 500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin2
	sort_string = "KVCDA"

/datum/design/item/ml3m_cell/haste
	name = "HASTE"
	id = "ml3m_cell_haste"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "gold" = 900, "silver" = 900, "diamond" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/haste
	sort_string = "KVCDB"

/datum/design/item/ml3m_cell/resist
	name = "RESIST"
	id = "ml3m_cell_resist"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "gold" = 900, "uranium" = 900, "diamond" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/resist
	sort_string = "KVCDC"

/datum/design/item/ml3m_cell/corpse_mend
	name = "CORPSE MEND"
	id = "ml3m_cell_corpse_mend"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "phoron" = 3000, "diamond" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/medical/corpse_mend
	sort_string = "KVCDD"

//Tier 4

/datum/design/item/ml3m_cell/brute3
	name = "BRUTE-III"
	id = "ml3m_cell_brute3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "diamond" = 500, "verdantium" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute3
	sort_string = "KVCEA"

/datum/design/item/ml3m_cell/burn3
	name = "BURN-III"
	id = "ml3m_cell_burn3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "diamond" = 500, "verdantium" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn3
	sort_string = "KVCEB"

/datum/design/item/ml3m_cell/toxin3
	name = "TOXIN-III"
	id = "ml3m_cell_toxin3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "diamond" = 500, "verdantium" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin3
	sort_string = "KVCEC"

/datum/design/item/ml3m_cell/omni3
	name = "OMNI-III"
	id = "ml3m_cell_omni3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "diamond" = 500, "verdantium" = 900)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni3
	sort_string = "KVCED"

//Tierless

/datum/design/item/ml3m_cell/shrink
	name = "SHRINK"
	id = "ml3m_cell_shrink"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "uranium" = 1800)
	build_path = /obj/item/ammo_casing/microbattery/medical/shrink
	sort_string = "KVCOA"

/datum/design/item/ml3m_cell/grow
	name = "GROW"
	id = "ml3m_cell_grow"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "uranium" = 1800)
	build_path = /obj/item/ammo_casing/microbattery/medical/grow
	sort_string = "KVCOB"

/datum/design/item/ml3m_cell/normalsize
	name = "NORMALSIZE"
	id = "ml3m_cell_normalsize"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4500, "glass" = 4500, "plastic" = 2250, "uranium" = 1800)
	build_path = /obj/item/ammo_casing/microbattery/medical/normalsize
	sort_string = "KVCOC"