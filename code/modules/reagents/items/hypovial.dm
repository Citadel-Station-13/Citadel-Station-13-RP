
/obj/item/reagent_containers/glass/hypovial
	name = "hypospray vial"
	desc = "A standard issue vial used for hyposprays."
	icon = 'icons/modules/reagents/items/hypospray.dmi'
	icon_state = "vial"
	w_class = WEIGHT_CLASS_TINY // 14 fits in a box, not 7
	volume = 60
	/// how many [state][#] overlays we have for reagents remaining
	var/overlay_count = 3

/obj/item/reagent_containers/glass/hypovial/update_icon(updates)
	cut_overlays()
	. = ..()
	if(overlay_count)
		var/num = clamp(round((reagents.total_volume / reagents.maximum_volume) * overlay_count, 1), 0, 1)
		if(num)
			var/mutable_appearance/overlay = mutable_appearance(icon, "[icon_state][num]")
			overlay.color = reagents.get_color()
			add_overlay(overlay)

/obj/item/reagent_containers/glass/hypovial/large
	name = "large hypospray vial"
	desc = "A larger variant of the common hypospray vial. Only compatible with advanced units."
	icon_state = "vial-l"
	w_class = WEIGHT_CLASS_SMALL
	volume = 120
	overlay_count = 4

/obj/item/reagent_containers/glass/hypovial/bluespace
	name = "bluespace hypospray vial"
	desc = "A prototype hypospray vial with the ability to hold reagents in a quasi-compressed state."
	icon_state = "vial-bs"
	volume = 120
	overlay_count = 0

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

/obj/item/reagent_containers/glass/hypovial/arithrazine
	start_reagent = /datum/reagent/arithrazine

/obj/item/reagent_containers/glass/hypovial/spaceacillin
	start_reagent = /datum/reagent/spaceacillin

/obj/item/reagent_containers/glass/hypovial/dexalin_plus
	start_reagent = /datum/reagent/dexalinp

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

/obj/item/reagent_containers/glass/hypovial/large/arithrazine
	start_reagent = /datum/reagent/arithrazine

/obj/item/reagent_containers/glass/hypovial/large/spaceacillin
	start_reagent = /datum/reagent/spaceacillin

/obj/item/reagent_containers/glass/hypovial/large/dexalin_plus
	start_reagent = /datum/reagent/dexalinp
