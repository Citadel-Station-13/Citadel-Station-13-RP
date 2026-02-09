/**
 * Body printers are a generic way to rebuild mobs from DNA, resleeving backups, templates, and more.
 */
/obj/machinery/resleeving/body_printer
	name = "body printer"
	desc = "Some kind of advanced device for printing humanoid bodies. Who came up with this?"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/clonepod
	icon = 'icons/modules/resleeving/machinery/body_printer.dmi'
	icon_state = "grower"
	base_icon_state = "grower"
	req_access = list(ACCESS_SCIENCE_GENETICS) // For premature unlocking.

	// 15 kilowatts :trol:
	active_power_usage = 15000
	idle_power_usage = 10

	/// icon_state append when working
	var/icon_state_running_append = "-active"

	/// can grow organic tissue
	var/allow_organic = FALSE
	/// can fab synthetic limbs
	var/allow_synthetic = FALSE

	/// materials container
	var/datum/material_container/materials
	/// materials limit, passed to materials
	/// * if this is null, materials container is not made
	var/materials_limit
	/// inserted reagent containers
	var/list/obj/item/bottles
	/// max bottles, bottle support is off if this is 0
	var/bottles_limit = 0

	/// current project record
	var/datum/resleeving_body_backup/currently_growing
	/// held occupant (current project)
	var/mob/living/currently_growing_body
	/// 0 to 1 ratio
	var/currently_growing_progress_estimate_ratio

	/// are we locked? premature ejection can only done if unlocked.
	var/locked = FALSE

	/// speed multiplier; different from the `c_` variables which are read-only configurations.
	var/speed_multiplier

	/// ratio of health to create with
	var/c_create_body_health_ratio = 0.2
	/// stabilize them while they're inside. you REALLY shouldn't turn this off.
	var/c_always_stabilize_body = TRUE
	/// ratio to regenerate per second; by default, cycle finishes in 3 minutes.
	var/c_regen_body_health_radio_per_second = 1 / ((3 MINUTES) / (1 SECOND))
	/// for now, just a flat cost per human mob
	var/c_biological_biomass_cost = 0
	/// for now, just a flat cost per human mob
	var/c_synthetic_metal_cost = 0
	/// for now, just a flat cost per human mob
	var/c_synthetic_glass_cost = 0
	/// * only applied to non-synths for now
	var/c_cloning_sickness_low = 15 MINUTES
	/// * only applied to non-synths for now
	var/c_cloning_sickness_high = 22.5 MINUTES
	/// eject at percent of effective maxhealth
	var/c_eject_at_health_ratio = 0.75

	/// since when have we been without power
	/// * null while powered
	var/depowered_started_at = null
	/// eject at time
	var/depowered_autoeject_time = 30 SECONDS

	/// when did we fully tabluate the mob
	var/progress_recalc_last_time
	/// last progress ratio
	var/progress_recalc_last_ratio
	/// how often to recalculate progress
	var/progress_recalc_delay = 10 SECONDS
	/// how many times progress has failed to go up
	var/progress_recalc_strikes = 0
	/// how many times progress can fail to go up
	var/progress_recalc_strike_limit = 3
	/// how much progress must be going up to be considered valid
	var/progress_recalc_working_threshold_ratio = 0.025

/obj/machinery/resleeving/body_printer/Initialize(mapload)
	. = ..()
	if(materials_limit)
		materials = new /datum/material_container(list(
			/datum/prototype/material/steel::id = materials_limit,
			/datum/prototype/material/glass::id = materials_limit,
		))
	update_icon()

/obj/machinery/resleeving/body_printer/Destroy()
	QDEL_NULL(materials)
	if(currently_growing_body)
		eject_body()
	QDEL_LAZYLIST(bottles)
	return ..()

/obj/machinery/resleeving/body_printer/RefreshParts()
	var/scanner_amt = 0
	var/scanner_tot = 0
	var/manip_amt   = 0
	var/manip_tot   = 0
	var/bin_amt     = 0
	var/bin_tot     = 0
	for(var/obj/item/stock_parts/scanning_module/scanner in component_parts)
		++scanner_amt
		scanner_tot += scanner.rating
	for(var/obj/item/stock_parts/manipulator/manipulator in component_parts)
		++manip_amt
		manip_tot += manipulator.rating
	for(var/obj/item/stock_parts/matter_bin/bin          in component_parts)
		++bin_amt
		bin_tot += bin.rating

	var/scanner_avg = scanner_amt / scanner_tot
	var/manip_avg = manip_amt / manip_tot
	speed_multiplier = 1 + 0.2 * scanner_avg + 0.2 * manip_avg

	// ignore bins for now, you really don't need that much storage lol
	bin_amt = bin_amt
	bin_tot = bin_tot

/obj/machinery/resleeving/body_printer/examine(mob/user, dist)
	. = ..()
	if(allow_synthetic)
		if(dist <= 3)
			for(var/id in materials.capacity)
				. += SPAN_NOTICE("It has [materials.stored[id]]/[materials.capacity[id]]cm3 of [id] stored.")
	if(allow_organic)
		if(dist <= 3)
			. += SPAN_NOTICE("It has [length(bottles)] / [bottles_limit] bottles of (hopefully) biomass inserted.")
	if(currently_growing)
		if(dist <= 3)
			. += SPAN_NOTICE("The current cloning cycle is ~[currently_growing_progress_estimate_ratio * 100]% complete.")

/obj/machinery/resleeving/body_printer/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(currently_growing)
		clickchain.chat_feedback(
			SPAN_NOTICE("The current cloning cycle is ~[currently_growing_progress_estimate_ratio * 100]% complete."),
			target = src,
		)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/machinery/resleeving/body_printer/drop_products(method, atom/where)
	. = ..()
	materials.dump_everything(where)
	if(bottles)
		for(var/obj/item/I in bottles)
			I.forceMove(where)
		bottles = null

/obj/machinery/resleeving/body_printer/Exited(atom/movable/AM, atom/newLoc)
	..()
	if(AM == currently_growing_body)
		eject_body(do_not_move = TRUE)
	if(AM in bottles)
		bottles -= AM

/obj/machinery/resleeving/body_printer/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(bottles_limit > 0)
		.["eject-bottles"] = create_context_menu_tuple("eject beakers", image(src), 1, MOBILITY_CAN_USE, FALSE)

/obj/machinery/resleeving/body_printer/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("eject-bottles")
			var/turf/where = drop_location()
			if(!where)
				return TRUE
			if(bottles)
				for(var/obj/item/I in bottles)
					I.forceMove(where)
				bottles = null
			return TRUE

/obj/machinery/resleeving/body_printer/proc/is_compatible_with_body(datum/resleeving_body_backup/backup)
	if(backup.legacy_synthetic)
		if(!allow_synthetic)
			return FALSE
	else
		if(!allow_organic)
			return FALSE
	return TRUE

/obj/machinery/resleeving/body_printer/proc/try_start_body(datum/resleeving_body_backup/backup)
	if(!is_compatible_with_body(backup))
		send_audible_system_message("Error; body is not compatible with printer.")
		return FALSE
	if(currently_growing_body || currently_growing)
		send_audible_system_message("Error; system busy!")
		return FALSE
	if(backup.legacy_synthetic)
		if(c_synthetic_glass_cost || c_synthetic_metal_cost)
			if(!materials_has_amounts(list(
				/datum/prototype/material/glass::id = c_synthetic_glass_cost,
				/datum/prototype/material/steel::id = c_synthetic_metal_cost,
			)))
				send_audible_system_message("Error; insufficient metal/gass remaining.")
				return FALSE
	else
		if(c_biological_biomass_cost)
			if(!biomass_has_remaining(c_biological_biomass_cost))
				send_audible_system_message("Error; insufficient biomass remaining.")
				return FALSE
	return start_body(backup)

/**
 * Builds the initial mob.
 * * Will set `currently_growing_xyz` variables.
 * * The API for this only accepts backups. If you're trying to use DNA records,
 *   write a wrapper, don't override the proc.
 *
 * @return TRUE on success, FALSE on failure
 */
/obj/machinery/resleeving/body_printer/proc/start_body(datum/resleeving_body_backup/backup)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(currently_growing_body || currently_growing)
		send_audible_system_message("Error; system busy!")
		return FALSE

	if(backup.legacy_synthetic)
		if(c_synthetic_glass_cost || c_synthetic_metal_cost)
			materials_use_amounts(list(
				/datum/prototype/material/glass::id = c_synthetic_glass_cost,
				/datum/prototype/material/steel::id = c_synthetic_metal_cost,
			))
	else
		if(c_biological_biomass_cost)
			biomass_use_remaining(c_biological_biomass_cost)

	if(/datum/modifier/no_clone in backup.legacy_genetic_modifiers)
		send_audible_system_message("Error; Body record has corrupted genetic data.")
		return FALSE

	var/mob/living/created = create_body_impl(backup)

	if(!created)
		return FALSE

	currently_growing = backup
	currently_growing_body = created
	currently_growing_progress_estimate_ratio = 0

	locked = TRUE
	progress_recalc_last_time = world.time
	progress_recalc_strikes = 0

	if(ishuman(created))
		var/mob/living/carbon/human/casted_human = created
		// damage them to this much
		var/ratio_to_damage_to = c_create_body_health_ratio
		if(casted_human.isSynthetic())
			// synths: yeah uhhh shit we should refactor everything because synths shouldn't die from
			//         limb damage lol that way we can do more damage here
			var/amt = (1 - ratio_to_damage_to) * (casted_human.maxHealth + 100) * 0.5
			casted_human.take_overall_damage(amt, amt, DAMAGE_MODE_GRADUAL)
		else
			// organics: just cloneloss i can't be arsed
			casted_human.adjustCloneLoss((casted_human.maxHealth + 100) * ratio_to_damage_to)

	ADD_TRAIT(created, TRAIT_MOB_UNCONSCIOUS, TRAIT_SOURCE_MACHINE_BODY_GROWER)
	ADD_TRAIT(created, TRAIT_MECHANICAL_CIRCULATION, TRAIT_SOURCE_MACHINE_BODY_GROWER)
	ADD_TRAIT(created, TRAIT_MECHANICAL_VENTILATION, TRAIT_SOURCE_MACHINE_BODY_GROWER)
	created.update_stat()

	update_icon()
	return TRUE

/**
 * This is what creates the actual body; [create_body_impl] is called to create the physical body,
 * this does more standardized things.
 */
/obj/machinery/resleeving/body_printer/proc/create_body(datum/resleeving_body_backup/backup) as /mob/living
	// backups are always human right now
	var/mob/living/carbon/human/created_human = create_body_impl(backup)
	// check if it was made properly
	if(!created_human)
		return
	if(!ishuman(created_human))
		CRASH("expected human, got [created_human.type]")
	. = created_human

	// copy ooc notes / flavor text manually
	created_human.ooc_notes = backup.legacy_ooc_notes || ""
	created_human.flavor_texts = backup.legacy_dna?.flavor?.Copy() || list()
	// other legacy properties
	created_human.resize(backup.legacy_sizemult)
	created_human.weight = backup.legacy_weight
	if(backup.legacy_custom_species_name)
		created_human.custom_species = backup.legacy_custom_species_name
	// sleevelock them
	created_human.resleeving_place_mind_lock(backup.mind_ref)

	// full rebuild icons and whatnot
	// arguably all this shouldn't be needed but whatever
	created_human.UpdateAppearance()
	created_human.sync_organ_dna()
	created_human.regenerate_icons()

	// apply cloning sickness to non-synths; this should be a status effect
	if(!created_human.isSynthetic() && created_human.species?.cloning_modifier)
		created_human.add_modifier(created_human.species.cloning_modifier, rand(c_cloning_sickness_low, c_cloning_sickness_high))
	// add cloned modifier to everyone; this should be a status effect
	created_human.add_modifier(/datum/modifier/cloned)

	// this is really stupid, transfer rest of legacy crap
	for(var/modifier_type in backup.legacy_genetic_modifiers)
		created_human.add_modifier(modifier_type)
	created_human.dna.UpdateSE()
	created_human.dna.UpdateUI()

/**
 * This is what creates the actual body; the organs/whatnot should be made here.
 */
/obj/machinery/resleeving/body_printer/proc/create_body_impl(datum/resleeving_body_backup/backup) as /mob/living
	// backups are always human right now
	var/mob/living/carbon/human/created_human = new(src)
	. = created_human

	// set gender first; legacy set species code might blow up less. we need a helper at some point.
	created_human.gender = backup.legacy_gender

	// honestly not sure if this works properly for synths buuuuut..
	created_human.set_species(backup.legacy_species_uid)
	// this is for legacy stuff; i don't even know what uses it
	created_human.dna.base_species = backup.legacy_dna.dna.base_species

	created_human.dna = backup.legacy_dna.dna.Clone()
	created_human.real_name = created_human.dna.real_name = backup.legacy_dna.dna.real_name || created_human.real_name
	created_human.descriptors = backup.legacy_dna.body_descriptors.Copy()

	created_human.set_cloned_appearance()

	// This is the weird part. We sorta obey 'can make organic/synthetic' but .. not really?
	// We will never make a non-viable clone, basically. Or at least try not to. This still might, who knows.

	// -- patch external organs --
	for(var/bp_tag in backup.legacy_limb_data)
		var/status = backup.legacy_limb_data[bp_tag]
		var/obj/item/organ/external/limb = created_human.organs_by_name[bp_tag]
		switch(status)
			if(null)
				// ignore
			if(0)
				// missing
				if(bp_tag != BP_TORSO)
					limb.remove_rejuv()
			if(1)
				// normal
				if(allow_organic)
					// TODO: organic-ize it if needed
				else
					// obliterate if we don't support it
					if(bp_tag != BP_TORSO)
						limb.remove_rejuv()
			else
				// robolimb manufacturer
				if(allow_synthetic)
					// robotize it
					limb.robotize(status)
				else
					// obliterate it if we don't support it
					if(bp_tag != BP_TORSO)
						limb.remove_rejuv()

	// -- patch internal organs --
	// we currently ignore if we can actually make robotic organs because
	// it can cause serious issues if we don't due to legacy code
	// in the future, this should only robotize if it can / replace with robot organs if
	// it needs to, etc.
	for(var/organ_tag in backup.legacy_organ_data)
		var/status = backup.legacy_organ_data[organ_tag]
		var/obj/item/organ/internal/organ = created_human.internal_organs_by_name[organ_tag]
		switch(status)
			if(null)
				// ignore
			if(0)
				// organic
			if(1)
				// assisted
				organ.mechassist()
			if(2)
				// mechanical
				organ.robotize()
			if(3)
				// digital
				organ.digitize()
			if(4)
				// nanite ; do not make under any circumstances
				// this is hardcoded not for lore enforcement reasons but because we have
				// no good way to do it yet
				stack_trace("attempted to clone a nanite organ; obliterating...")

/**
 * Continues to grow the mob.
 * * Will change `currently_growing_xyz` variables.
 * * This can eject the body.
 *
 * @return TRUE if mob is done, FALSE otherwise
 */
/obj/machinery/resleeving/body_printer/proc/grow_body(dt)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(currently_growing_body.stat == DEAD)
		eject_body()
		send_audible_system_message("Contained body deceased; resetting...")
		return TRUE

	grow_body_impl(dt)

	return currently_growing_progress_estimate_ratio >= 1

/obj/machinery/resleeving/body_printer/proc/grow_body_impl(dt)
	// human only for now
	if(!ishuman(currently_growing_body))
		return
	var/mob/living/carbon/human/casted_human = currently_growing_body

	var/ratio_to_heal = c_regen_body_health_radio_per_second * speed_multiplier

	var/heal_organic
	var/heal_synthetic
	if(allow_organic)
		heal_organic = TRUE
		// heal clone damage
		casted_human.adjustCloneLoss(-(casted_human.maxHealth * dt * ratio_to_heal))
		// they're oxygenated by the machine
		casted_human.adjustOxyLoss(-3.5 * speed_multiplier * dt)
	if(allow_synthetic)
		heal_synthetic = TRUE

	for(var/obj/item/organ/internal/internal_organ as anything in casted_human.internal_organs)
		internal_organ.heal_damage_i(0.5 * speed_multiplier * dt)
	for(var/obj/item/organ/external/external_organ as anything in casted_human.get_external_organs())
		if((external_organ.robotic >= ORGAN_ROBOT) && !heal_synthetic)
			continue
		if((external_organ.robotic <= ORGAN_ASSISTED) && !heal_organic)
			continue
		var/amt_to_heal = ratio_to_heal * external_organ.max_damage
		external_organ.heal_damage(amt_to_heal, amt_to_heal, TRUE, TRUE)

/obj/machinery/resleeving/body_printer/proc/eject_body(do_not_move)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!currently_growing_body)
		return FALSE

	REMOVE_TRAIT(currently_growing_body, TRAIT_MOB_UNCONSCIOUS, TRAIT_SOURCE_MACHINE_BODY_GROWER)
	REMOVE_TRAIT(currently_growing_body, TRAIT_MECHANICAL_CIRCULATION, TRAIT_SOURCE_MACHINE_BODY_GROWER)
	REMOVE_TRAIT(currently_growing_body, TRAIT_MECHANICAL_VENTILATION, TRAIT_SOURCE_MACHINE_BODY_GROWER)

	if(!do_not_move)
		currently_growing_body.forceMove(drop_location())
	currently_growing_body = null

	update_icon()
	return TRUE

/**
 * Recalculates our progress on the clone, ejecting them if they've failed to improve
 * too many times (stuck machine / unviable clone)
 * * This can eject the body.
 */
/obj/machinery/resleeving/body_printer/proc/handle_progress_recalc()
	var/mob/them = currently_growing_body
	var/ratio = 1

	if(ishuman(them))
		var/mob/living/carbon/human/casted_human = them
		// 100 to comp for the -100 to 100 system
		casted_human.update_health()
		ratio = min(ratio, (casted_human.health + 100) / (casted_human.maxHealth + 100))

	if(ratio < progress_recalc_last_ratio + progress_recalc_working_threshold_ratio)
		++progress_recalc_strikes
	progress_recalc_last_ratio = ratio
	progress_recalc_last_time = world.time

	if(progress_recalc_strikes > progress_recalc_strike_limit)
		send_audible_system_message("Ejecting body due to lack of progress. The pod has likely stalled!")
		eject_body()
	else if(ratio > c_eject_at_health_ratio)
		send_audible_system_message("Entity construction cycle complete.")
		eject_body()

/obj/machinery/resleeving/body_printer/process(delta_time)
	if(!currently_growing)
		return
	if(!powered())
		if(isnull(depowered_started_at))
			depowered_started_at = world.time
		if(depowered_started_at < world.time - depowered_autoeject_time)
			send_audible_system_message("Ejecting body due to prolonged critical power loss.")
			eject_body()
		return
	depowered_started_at = null

	var/should_recalc_progress = world.time > progress_recalc_last_time + progress_recalc_delay

	if(should_recalc_progress)
		var/elapsed = world.time - progress_recalc_last_time
		handle_progress_recalc()
		if(!currently_growing)
			// handle progress recalc kicks them out
			return

		// we only grow body on progress recalc for now
		// in the future we can have this be every tick if needed
		if(elapsed > 0)
			grow_body(elapsed * 0.1)

// TODO: emag behavior?

/obj/machinery/resleeving/body_printer/proc/biomass_get_remaining()
	. = 0
	for(var/obj/item/container in bottles)
		. += container.reagents?.reagent_volumes?[/datum/reagent/nutriment/biomass::id]

/obj/machinery/resleeving/body_printer/proc/biomass_has_remaining(amt)
	return biomass_get_remaining() >= amt

/obj/machinery/resleeving/body_printer/proc/biomass_use_remaining(amt) as num
	. = 0
	for(var/obj/item/container in bottles)
		var/avail = container.reagents?.reagent_volumes?[/datum/reagent/nutriment/biomass::id]
		if(!avail)
			continue
		avail = min(avail, amt)
		amt -= avail
		container.reagents.remove_reagent(/datum/reagent/nutriment/biomass::id, avail)
		. += avail

/obj/machinery/resleeving/body_printer/proc/materials_get_amounts()
	return src.materials.stored

/obj/machinery/resleeving/body_printer/proc/materials_has_amounts(list/materials)
	return src.materials.has_multiple(materials) >= 1

/obj/machinery/resleeving/body_printer/proc/materials_use_amounts(list/materials)
	return src.materials.use(materials, 1)

//* ADMIN VV WRAPPERS *//

// prints a body immediately if we have space
/obj/machinery/resleeving/body_printer/proc/admin_print_one_shot(datum/resleeving_body_backup/backup)
	if(!start_body(backup))
		return FALSE
	grow_body(INFINITY)
	eject_body()
	return TRUE
