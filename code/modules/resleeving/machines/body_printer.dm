/**
 * Body printers are a generic way to rebuild mobs from DNA, resleeving backups, templates, and more.
 */
/obj/machinery/resleeving/body_printer
	name = "body printer"
	desc = "Some kind of advanced device for printing humanoid bodies. Who came up with this?"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/clonepod
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(ACCESS_SCIENCE_GENETICS) // For premature unlocking.

	active_power_usage = 5000
	idle_power_usage = 10

	/// can grow organic tissue
	var/allow_organic = FALSE
	/// can fab synthetic limbs
	var/allow_synthetic = FALSE

	/// materials container
	var/datum/material_container/materials
	/// inserted reagent containers
	var/list/obj/item/bottles
	var/bottles_limit = 3

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
	var/c_biological_biomass_cost = 30
	/// for now, just a flat cost per human mob
	var/c_synthetic_metal_cost = 15 * SHEET_MATERIAL_AMOUNT
	/// for now, just a flat cost per human mob
	var/c_synthetic_glass_cost = 7.5 * SHEET_MATERIAL_AMOUNT

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
	#warn reagents / materials
	if(!allow_organic)
		bottles_limit = 0
	if(allow_synthetic)
		materials = new /datum/material_container(list(
			/datum/prototype/material/steel::id = 15 * SHEET_MATERIAL_AMOUNT * 3,
			/datum/prototype/material/glass::id = 7.5 * SHEET_MATERIAL_AMOUNT * 3,
		))
	update_icon()

/obj/machinery/resleeving/body_printer/Destroy()
	QDEL_NULL(materials)
	if(currently_growing_body)
		#warn eject occupant
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
			for(var/id in materials)
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
	#warn drop materials

/obj/machinery/resleeving/body_printer/proc/is_compatible_with_body(datum/resleeving_body_backup/backup)
	#warn impl

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


	var/mob/living/created = create_body_impl(backup)
	#warn impl

	locked = TRUE
	progress_recalc_last_time = world.time
	progress_recalc_strikes = 0

	update_icon()

/**
 * This is what creates the actual body; [create_body_impl] is called to create the physical body,
 * this does more standardized things.
 */
/obj/machinery/resleeving/body_printer/proc/create_body(datum/resleeving_body_backup/backup) as /mob/living
	// backups are always human right now
	var/mob/living/carbon/human/created_human = create_body_impl(backup)

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

/**
 * This is what creates the actual body; the organs/whatnot should be made here.
 */
/obj/machinery/resleeving/body_printer/proc/create_body_impl(datum/resleeving_body_backup/backup) as /mob/living
	// backups are always human right now
	var/mob/living/carbon/human/created_human = new(src)

	// honestly not sure if this works properly for synths buuuuut..
	created_human.set_species(backup.legacy_species_uid)
	// this is for legacy stuff; i don't even know what uses it
	created_human.dna.base_species = backup.legacy_dna.dna.base_species

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


	#warn impl

/**
 * Continues to grow the mob.
 * * Will set `currently_growing_xyz` variables.
 *
 * @return TRUE if mob is done, FALSE otherwise
 */
/obj/machinery/resleeving/body_printer/proc/grow_body(dt)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	grow_body_impl(dt)

	return currently_growing_progress_estimate_ratio >= 1

/obj/machinery/resleeving/body_printer/proc/grow_body_impl(dt)


/obj/machinery/resleeving/body_printer/proc/eject_body()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	#warn impl

	update_icon()

/**
 * Recalculates our progress on the clone, ejecting them if they've failed to improve
 * too many times (stuck machine / unviable clone)
 */
/obj/machinery/resleeving/body_printer/proc/handle_progress_recalc()


/obj/machinery/resleeving/body_printer/process(delta_time)
	if(!currently_growing)
		return
	if(!powered())
		#warn depowered_autoeject_time, depowered_last
		return

	#warn impl

//* ADMIN VV WRAPPERS *//

// prints a body immediately if we have space
/obj/machinery/resleeving/body_printer/proc/admin_print_one_shot(datum/resleeving_body_backup/backup)
	if(!start_body(backup))
		return FALSE
	grow_body(INFINITY)
	eject_body()
