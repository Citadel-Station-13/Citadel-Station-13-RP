/**
 * Single Use Emergency Pouches
 */
/obj/item/storage/single_use/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/single_use/med_pouch.dmi'
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	icon_state = "pack0"
	opened = FALSE
	tear_sound = 'sound/effects/rip1.ogg'
	//material = /decl/material/solid/plastic
	var/injury_type = "generic"
	var/static/image/cross_overlay
	var/instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	\t8) Stay in place once they respond.\
		"}

/obj/item/storage/single_use/med_pouch/Initialize(mapload)
	. = ..()
	name = "emergency [injury_type] pouch"
	update_desc()
	if(length(contents))
		make_exact_fit()
	update_icon()


/obj/item/storage/single_use/med_pouch/update_icon()
	. = ..()
	if(!cross_overlay)
		cross_overlay = overlay_image(icon, "cross", flags = RESET_COLOR)
	add_overlay(cross_overlay)
	icon_state = "pack[opened]"

/* /obj/item/storage/single_use/med_pouch/examine(mob/user, dist)
	. = ..()
	. += instructions
*/

/obj/item/storage/single_use/med_pouch/update_desc(updates)
	. = ..()
	desc += instructions

/obj/item/storage/single_use/med_pouch/attack_self(mob/user, datum/event_args/clickchain/e_args)
	. = ..()
	if(.)
		return
	open(user)

/*handled by single_use
/obj/item/storage/single_use/med_pouch/open(mob/user)
	if(!opened)
		user.visible_message("<span class='notice'></span>", "<span class='notice'></span>")
	. = ..()*/

/obj/item/storage/single_use/med_pouch/trauma
	name = "Trauma Pouch"
	injury_type = "trauma"
	color = COLOR_RED
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Contact the medical team with your location.
	\t7) Stay in place once they respond.\
		"}
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_pain,
		/obj/item/reagent_containers/pill/inaprovaline/pouch,
		/obj/item/reagent_containers/pill/bicaridine/pouch,
		/obj/item/stack/medical/bruise_pack,
	)

/obj/item/storage/single_use/med_pouch/burn
	name = "Burn Pouch"
	injury_type = "burn"
	color = "#cc6600"//COLOR_SEDONA
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow the Kelotane pill.\n\
	\t5) Use ointment on any burns if required\n\
	\t6) Force the injured party to swallow the Spaceacillin pill.\n\
	\t6) Contact the medical team with your location.
	\t7) Stay in place once they respond.\
		"}
	starts_with = list(
		// /obj/item/chems/hypospray/autoinjector/pouch_auto/nanoblood, // Maybe we add nanoblood one day.
		/obj/item/reagent_containers/hypospray/autoinjector/burn_pouch, // Used to be an adrenaline one, but adrenaline is kinda bad here.
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_pain,
		/obj/item/reagent_containers/pill/kelotane,
		/obj/item/reagent_containers/pill/spaceacillin,
		/obj/item/stack/medical/ointment,
	)

/obj/item/storage/single_use/med_pouch/oxyloss
	name = "Low Oxygen Pouch"
	injury_type = "low oxygen"
	color = COLOR_BLUE
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	\t8) Stay in place once they respond.\
		"}
	starts_with = list(
		// /obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_oxy, // Used to be an inhaler.
		/obj/item/reagent_containers/pill/dexalin = 2,
		/obj/item/reagent_containers/pill/inaprovaline/pouch,
	)

/obj/item/storage/single_use/med_pouch/toxin
	name = "Toxin Pouch"
	injury_type = "toxin"
	color = COLOR_GREEN
	instructions = {"
	\t1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Stay in place once they respond.\
		"}
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/detox = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_tox,
		/obj/item/reagent_containers/pill/antitox = 2,
	)

/obj/item/storage/single_use/med_pouch/radiation
	name = "Radiation Pouch"
	injury_type = "radiation"
	color = "#ffbf00"//COLOR_AMBER
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	\t6) Stay in place once they respond.\
		"}
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/detox = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_rad = 2,
		/obj/item/reagent_containers/pill/antitox = 2,
	)

/obj/item/storage/single_use/med_pouch/overdose
	name = "Overdose Treatment Pouch"
	injury_type = "overdose"
	color = COLOR_PALE_BLUE_GRAY
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors and autoinhalers to the injured party. DO NOT give the injured party any pills, foods, or liquids.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	\t8) Stay in place once they respond.\
		"}
	starts_with = list(
		// /obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_antialcohol,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_oxy, // Used to be an inhaler.
		/obj/item/reagent_containers/pill/carbon,
	)

// Pills

/obj/item/reagent_containers/pill/inaprovaline/pouch
	name = "Emergency Inaprovaline Pill"
	icon_state = "pill2"

/obj/item/reagent_containers/pill/inaprovaline/pouch/Initialize(mapload)
	. = ..()
	reagents.add_reagent("inaprovaline", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/bicaridine/pouch
	name = "Emergency Bicaridine Pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/bicaridine/pouch/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bicaridine", 15)
	color = reagents.get_color()


// Injectors
/obj/item/reagent_containers/hypospray/autoinjector/burn_pouch
	name = "Autoinjector (Burn)"
	icon_state = "green"
	filled_reagents = list("kelotane" = 2.5, "dermaline" = 2.5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_oxy
	name = "Autoinjector (Dexaline Plus)"
	icon_state = "blue"
	filled_reagents = list("dexalinp" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_pain
	name = "Autoinjector (Tramadol)"
	icon_state = "blue"
	filled_reagents = list("tramadol" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_rad
	name = "Autoinjector (Hyronalin)"
	icon_state = "blue"
	filled_reagents = list("hyronalin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_tox
	name = "Critical Use Toxins Autoinjector"
	icon_state = "blue"
	filled_reagents = list("anti_toxin"=3, "carthatoline" = 2)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_antialcohol
	name = "Autoinjector (Ethylredoxrazine)"
	icon_state = "blue"
	filled_reagents = list("ethylredoxrazine"=5)
/*
/obj/item/chems/pill/pouch_pill
	name       = "emergency pill"
	desc       = "An emergency pill from an emergency medical pouch."
	icon_state = "pill2"
	volume     = 15
	abstract_type = /obj/item/chems/pill/pouch_pill

/obj/item/chems/pill/pouch_pill/Initialize(ml, material_key)
	. = ..()
	if(!reagents?.total_volume)
		log_warning("[log_info_line(src)] was deleted for containing no reagents during init!")
		return INITIALIZE_HINT_QDEL

/obj/item/chems/pill/pouch_pill/initialize_reagents(populate = TRUE)
	. = ..()
	if(populate && reagents?.get_primary_reagent_name())
		SetName("emergency [reagents.get_primary_reagent_name()] pill ([reagents.total_volume]u)")

/obj/item/chems/pill/pouch_pill/stabilizer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/stabilizer, reagents.maximum_volume)

/obj/item/chems/pill/pouch_pill/antitoxins/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antitoxins, reagents.maximum_volume)

/obj/item/chems/pill/pouch_pill/oxy_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/oxy_meds, reagents.maximum_volume)

/obj/item/chems/pill/pouch_pill/painkillers/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/painkillers, reagents.maximum_volume)

/obj/item/chems/pill/pouch_pill/brute_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/brute_meds, reagents.maximum_volume)

/obj/item/chems/pill/pouch_pill/burn_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/burn_meds, reagents.maximum_volume)
*/
// Injectors

/*
/obj/item/chems/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch."

/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer
	name = "emergency stabilizer autoinjector"
/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/stabilizer, 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers
	name = "emergency painkiller autoinjector"
/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/painkillers, 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins
	name = "emergency antitoxins autoinjector"
/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antitoxins, 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds
	name = "emergency oxygel autoinjector"
/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/oxy_meds, 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	amount_per_transfer_from_this = 8
/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/adrenaline, 8)

/obj/item/chems/hypospray/autoinjector/pouch_auto/nanoblood
	name = "emergency nanoblood autoinjector"
/obj/item/chems/hypospray/autoinjector/pouch_auto/nanoblood/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/nanoblood, 5)

// Inhalers

/obj/item/chems/inhaler/pouch_auto
	name = "emergency autoinhaler"
	desc = "An emergency autoinhaler from an emergency medical pouch."

/obj/item/chems/inhaler/pouch_auto/oxy_meds
	name = "emergency oxygel autoinhaler"
	detail_color = COLOR_CYAN

/obj/item/chems/inhaler/pouch_auto/oxy_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/oxy_meds, 5)

/obj/item/chems/inhaler/pouch_auto/detoxifier
	name = "emergency detoxifier autoinhaler"
	detail_color = COLOR_GREEN

/obj/item/chems/inhaler/pouch_auto/detoxifier/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/detoxifier, 5)
*/
