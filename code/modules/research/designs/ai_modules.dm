/datum/design/aimodule
	abstract_type = /datum/design/aimodule
	lathe_type = LATHE_TYPE_CIRCUIT
	materials = list(MAT_GLASS = 2000, MAT_GOLD = 100)

/datum/design/aimodule/AssembleDesignName()
	design_name = "AI module design ([name])"

/datum/design/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."

/datum/design/aimodule/safeguard
	design_name = "Safeguard"
	id = "safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/safeguard

/datum/design/aimodule/onehuman
	design_name = "OneCrewMember"
	id = "onehuman"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/oneHuman

/datum/design/aimodule/protectstation
	design_name = "ProtectStation"
	id = "protectstation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/protectStation

/datum/design/aimodule/notele
	design_name = "TeleporterOffline"
	id = "notele"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/aiModule/teleporterOffline

/datum/design/aimodule/quarantine
	design_name = "Quarantine"
	id = "quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/quarantine

/datum/design/aimodule/oxygen
	design_name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/oxygen

/datum/design/aimodule/freeform
	design_name = "Freeform"
	id = "freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/freeform

/datum/design/aimodule/reset
	design_name = "Reset"
	id = "reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/reset

/datum/design/aimodule/purge
	design_name = "Purge"
	id = "purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/purge

// Core modules
/datum/design/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/aimodule/core/AssembleDesignName()
	design_name = "AI core module design ([name])"

/datum/design/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

/datum/design/aimodule/core/freeformcore
	design_name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/aiModule/freeformcore

/datum/design/aimodule/core/asimov
	design_name = "Asimov"
	id = "asimov"
	build_path = /obj/item/aiModule/asimov

/datum/design/aimodule/core/paladin
	design_name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/aiModule/paladin

/datum/design/aimodule/core/tyrant
	design_name = "T.Y.R.A.N.T."
	id = "tyrant"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/tyrant

// AI file, AI tool
/datum/design/science/intellicard
	design_name = "'intelliCore', AI preservation and transportation system"
	desc = "Allows for the construction of an intelliCore."
	id = "intellicore"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/aicard
