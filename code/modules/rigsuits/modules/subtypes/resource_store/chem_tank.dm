//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * chem tanks used to provide chemicals
 */
/obj/item/rig_module/resource_store/reagent_tank
	name = /obj/item/rig_module::name + " (gas tank)"
	desc = /obj/item/rig_module::desc + " This one provides gas storage."

#warn impl

/**
 * Classic one-chem-at-a-time with maybe- regeneration.
 */
/obj/item/rig_module/resource_store/reagent_tank/single_router
	/// reagent ids
	var/list/reagent_ids = list()
	/// can regen?
	var/regen = FALSE
	/// regen cost **kilojoules** per unit default
	var/regen_cost = 20
	/// regen cost overrides for reagent ids
	/// * lazy list
	var/list/regen_cost_override
	/// regen max power draw in kilowatts (yes we measure in kilowatts)
	/// * default is 2 units a second which is really fucking fast lol
	var/regen_draw = 40

/**
 * okay for station use
 */
/obj/item/rig_module/resource_store/reagent_tank/single_router/basic_meds
	reagent_ids = list(
		/datum/reagent/tricordrazine::id,
		/datum/reagent/inaprovaline::id,
		/datum/reagent/dylovene::id,
		/datum/reagent/dexalin::id,
		/datum/reagent/hyronalin::id,
		/datum/reagent/spaceacillin::id,
		/datum/reagent/paracetamol::id,
	)

/**
 * should proabbly be ert/antag only, if even that
 */
/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds
	reagent_ids = list(
		/datum/reagent/bicaridine::id,
		/datum/reagent/kelotane::id,
		/datum/reagent/dylovene::id,
		/datum/reagent/dexalin::id,
		/datum/reagent/inaprovaline::id,
		/datum/reagent/spaceacillin::id,
		/datum/reagent/hyronalin::id,
		/datum/reagent/tramadol::id,
	)

/**
 * put this in game regularly and i'll turn you into a gondola
 */
/obj/item/rig_module/resource_store/reagent_tank/single_router/combat_meds
	reagent_ids = list(
		/datum/reagent/bicaridine::id,
		/datum/reagent/kelotane::id,
		/datum/reagent/dylovene::id,
		/datum/reagent/dexalin::id,
		/datum/reagent/inaprovaline::id,
		/datum/reagent/hyperzine::id,
		/datum/reagent/spaceacillin::id,
		/datum/reagent/tramadol::id,
		/datum/reagent/oxycodone::id,
		/datum/reagent/myelamine::id,
		/datum/reagent/dexalinp::id,
		/datum/reagent/arithrazine::id,
	)
