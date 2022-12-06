/datum/material/solid/boron
	name = "boron"
	uid = "solid_boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	legacy_flags = MATERIAL_FUSION_FUEL | MATERIAL_FISSIBLE

	// neutron_cross_section = 10
	// neutron_interactions = list(
	// 	INTERACTION_ABSORPTION = 2500
	// )
	// absorption_products = list(
	// 	/datum/material/solid/lithium = 0.5,
	// 	/datum/material/gas/helium = 0.5
	// )
	// neutron_absorption = 20

/datum/material/solid/lithium
	name = "lithium"
	uid = "solid_lithium"
	lore_text = "A chemical element, used as antidepressant."
	legacy_flags = MATERIAL_FUSION_FUEL
	// taste_lore_textription = "metal"
	color = "#808080"
	// value = 0.5
	// narcosis = 5

/datum/material/solid/carbon
	name = "carbon"
	uid = "solid_carbon"
	lore_text = "A chemical element, the building block of life."
	// taste_lore_textription = "sour chalk"
	// taste_mult = 1.5
	color = "#1c1300"
	// value = 0.5
	// dirtiness = 30
	stack_type = /obj/item/stack/material/carbon

/obj/item/stack/material/carbon
	name = "carbon sheet"
	icon_state = "sheet-metal"
	color = "#303030"
	default_type = MAT_CARBON

/*
/datum/material/solid/carbon/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)
*/

/datum/material/solid/phosphorus
	name = "phosphorus"
	uid = "solid_phosphorus"
	lore_text = "A chemical element, the backbone of biological energy carriers."
	// taste_lore_textription = "vinegar"
	color = "#832828"
	// value = 0.5


/datum/material/solid/silicon
	name = "silicon"
	uid = "solid_silicon"
	lore_text = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	color = "#a8a8a8"
	// value = 0.5


/datum/material/solid/sodium
	name = "sodium"
	uid = "solid_sodium"
	lore_text = "A chemical element, readily reacts with water."
	// taste_lore_textription = "salty metal"
	color = "#808080"
	// value = 0.5


/datum/material/solid/sulfur
	name = "sulfur"
	uid = "solid_sulfur"
	lore_text = "A chemical element with a pungent smell."
	// taste_lore_textription = "old eggs"
	color = "#bf8c00"
	// value = 0.5


/datum/material/solid/potassium
	name = "potassium"
	uid = "solid_potassium"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	// taste_lore_textription = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	color = "#a0a0a0"
	// value = 0.5

/*
/datum/material/solid/potassium/affect_blood(mob/living/M, removed, datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)
*/

/datum/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	color = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	color = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0
