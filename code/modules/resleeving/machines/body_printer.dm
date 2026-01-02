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
	update_icon()

/obj/machinery/resleeving/body_printer/Destroy()
	QDEL_NULL(materials)
	if(currently_growing_body)
		#warn eject occupant
	return ..()

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
 * This is what creates the actual body.
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
