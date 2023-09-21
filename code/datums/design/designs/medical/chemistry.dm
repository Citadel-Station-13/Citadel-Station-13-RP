/datum/design/medical/chemistry
	abstract_type = /datum/design/medical/chemistry

/datum/design/medical/chemistry/beaker
	id = "ChemistryBeaker"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/glass/beaker

/datum/design/medical/chemistry/beaker/large
	id = "ChemistryBeakerLarge"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/glass/beaker/large

/datum/design/medical/chemistry/vial
	id = "ChemistryVial"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/glass/beaker/vial

/datum/design/medical/chemistry/hypovial
	id = "ChemistryHypovial"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/glass/hypovial

/datum/design/medical/chemistry/hypovial/large
	id = "ChemistryHypovialLarge"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/glass/hypovial/large

/datum/design/medical/chemistry/syringe
	id = "ChemistrySyringe"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/syringe

/datum/design/medical/chemistry/autoinjector
	id = "ChemistryAutoinjector"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/reagent_containers/hypospray/autoinjector/empty
	materials = list(
		MAT_STEEL = 250,
		MAT_GLASS = 250,
	)
