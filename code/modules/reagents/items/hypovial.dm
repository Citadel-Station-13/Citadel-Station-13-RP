
/obj/item/reagent_containers/glass/hypovial
	name = "hypospray vial"
	desc = "A standard issue vial used for hyposprays."
	icon = 'icons/modules/reagents/items/hyposprays.dmi'
	icon_state = "vial"
	w_class = WEIGHT_CLASS_TINY // 14 fits in a box, not 7
	volume = 60

/obj/item/reagent_containers/glass/hypovial/large
	name = "large hypospray vial"
	desc = "A larger variant of the common hypospray vial. Only compatible with advanced units."
	icon_state = "vial-l"
	w_class = WEIGHT_CLASS_SMALL
	volume = 120

/obj/item/reagent_containers/glass/hypovial/bluespace
	name = "bluespace hypospray vial"
	desc = "A prototype hypospray vial with the ability to hold reagents in a quasi-compressed state."
	icon_state = "vial-bs"
	volume = 120

#warn vial: vial1, vial2, vial3
#warn vial-bs:
#warn vial-l: vial-l1, vial-l2, vial-l3, vial-l4, l4 is 100% but l3 is 50%

//* subtypes - regular

/obj/item/reagent_containers/glass/hypovial/bicaridine
	start_reagent = /datum/reagent/bicaridine

/obj/item/reagent_containers/glass/hypovial/kelotane
	start_reagent = /datum/reagent/kelotane

/obj/item/reagent_containers/glass/hypovial/dylovene
	start_reagent = /datum/reagent/dylovene

/obj/item/reagent_containers/glass/hypovial/dexalin
	start_reagent = /datum/reagent/dexalin

/obj/item/reagent_containers/glass/hypovial/tricordrazine
	start_reagent = /datum/reagent/tricordrazine

/obj/item/reagent_containers/glass/hypovial/peridaxon
	start_reagent = /datum/reagent/peridaxon

/obj/item/reagent_containers/glass/hypovial/tramadol
	start_reagent = /datum/reagent/tramadol

/obj/item/reagent_containers/glass/hypovial/inaprovaline
	start_reagent = /datum/reagent/inaprovaline

/obj/item/reagent_containers/glass/hypovial/imidalky
	start_with = list(
		/datum/reagent/imidazoline = 30,
		/datum/reagent/alkysine = 30,
	)

//* subtypes - large

/obj/item/reagent_containers/glass/hypovial/large/bicaridine
	start_reagent = /datum/reagent/bicaridine

/obj/item/reagent_containers/glass/hypovial/large/kelotane
	start_reagent = /datum/reagent/kelotane

/obj/item/reagent_containers/glass/hypovial/large/dylovene
	start_reagent = /datum/reagent/dylovene

/obj/item/reagent_containers/glass/hypovial/large/dexalin
	start_reagent = /datum/reagent/dexalin

/obj/item/reagent_containers/glass/hypovial/large/tricordrazine
	start_reagent = /datum/reagent/tricordrazine

/obj/item/reagent_containers/glass/hypovial/large/peridaxon
	start_reagent = /datum/reagent/peridaxon

/obj/item/reagent_containers/glass/hypovial/large/tramadol
	start_reagent = /datum/reagent/tramadol

/obj/item/reagent_containers/glass/hypovial/large/inaprovaline
	start_reagent = /datum/reagent/inaprovaline

/obj/item/reagent_containers/glass/hypovial/large/imidalky
	start_with = list(
		/datum/reagent/imidazoline = 30,
		/datum/reagent/alkysine = 30,
	)
