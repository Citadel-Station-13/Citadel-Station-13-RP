//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: peristable repository
GLOBAL_LIST_EMPTY(medibeam_cell_datums)

/proc/fetch_cached_medibeam_cell_datum(datum/medibeam_cell/typepath)
	if(isnull(GLOB.medibeam_cell_datums))
		GLOB.medibeam_cell_datums[typepath] = new typepath
	return GLOB.medibeam_cell_datums[typepath]

/**
 * medical beamgun
 *
 * todo: should we use reagents instead..?
 */
/obj/item/stream_projector/medibeam

#warn impl all

/**
 * component used to form a mob's nanite cloud effect
 */
/datum/component/medibeam_visualizer
	/// color = strength
	var/list/colors_registered
	/// current color as r, g, b values
	var/list/current_color_rgb = list(255, 255, 255)
	/// total strength
	var/total_strength = 0

	/// our particles
	var/atom/movable/particle_render/renderer

/datum/component/medibeam_visualizer/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/medibeam_visualizer/Destroy()
	QDEL_NULL(renderer)
	return ..()

/datum/component/medibeam_visualizer/proc/register_beam(color, strength)
	ensure_visuals()

	LAZYINITLIST(colors_registered)
	colors_registered[color] = strength + colors_registered[color]
	var/new_total = total_strength + strength
	current_color_rgb = BlendRGBList(color, current_color_rgb, total_strength / new_total)
	total_strength = new_total

	update_visuals()

/datum/component/medibeam_visualizer/proc/unregister_beam(color, strength)
	#warn impl

/datum/component/medibeam_visualizer/proc/adjust_beam(old_color, old_strength, new_color, new_strength)
	#warn impl

/datum/component/medibeam_visualizer/proc/update_visuals()
	#warn impl

/datum/component/medibeam_visualizer/proc/ensure_visuals()
	if(!isnull(renderer))
		return
	renderer = new(null)
	if(ismovable(parent))
		var/atom/movable/entity = parent
		entity.vis_contents += renderer
	else
		var/atom/entity = parent
		renderer.loc = entity
	#warn impl - particles?

/**
 * medical beamgun cell
 */
/obj/item/medibeam_cell
	name = "medichine cartridge (EMPTY)"
	desc = "A cartridge meant to hold medicinal nanites."
	#warn impl

	/// path to cell datum
	var/datum/medibeam_cell/cell_datum = /datum/medibeam_cell
	/// units left
	var/volume = 100
	/// maximum units left
	var/max_volume = 100

#warn impl all

// todo: after med rework all of these need a look-over

/obj/item/medibeam_cell/seal_wounds
	name = "medichine cartridge (SEAL)"
	desc = "A cartridge of swirling dust. This will repair, disinfect, and seal open wounds."
	#warn impl
	cell_datum = /datum/medibeam_cell/seal_wounds

/obj/item/medibeam_cell/seal_wounds/violently
	name = "medichine cartridge (DEBRIDE)"
	desc = "A cartridge of angrily swirling dust. This will repair, disinfect, and seal open wounds. Rapidly, and painfully."
	#warn impl
	cell_datum = /datum/medibeam_cell/seal_wounds/violently

/obj/item/medibeam_cell/fortify
	#warn impl
	cell_datum = /datum/medibeam_cell/fortify

/obj/item/medibeam_cell/stabilize
	#warn impl
	cell_datum = /datum/medibeam_cell/stabilize

/obj/item/medibeam_cell/deathmend
	#warn impl
	cell_datum = /datum/medibeam_cell/deathmend

/obj/item/medibeam_cell/synth_repair
	#warn impl
	cell_datum = /datum/medibeam_cell/synth_repair

/obj/item/medibeam_cell/synth_tuning
	#warn impl
	cell_datum = /datum/medibeam_cell/synth_tuning

/**
 * medical beamgun effect package
 */
/datum/medibeam_cell
	/// list of effects; set to paths to init on new
	var/list/datum/medibeam_effect/effects
	/// stream consumption rate multiplier
	var/injection_multiplier = 1

/datum/medibeam_cell/New()
	#warn impl

/datum/medibeam_cell/seal_wounds

/datum/medibeam_cell/seal_wounds/violently
	injection_multiplier = 2
	// agony needs to tick first
	effects = list(
		/datum/medibeam_effect/agony_from_open_wounds{
			strength_factor = 1;
		},
		/datum/medibeam_effect/wound_healing{
			disinfect_strength = 2;
			seal_strength = 5;
			repair_strength_brute = 2;
			repair_strength_burn = 2;
		}
	)

/datum/medibeam_cell/fortify

/datum/medibeam_cell/stabilize

/datum/medibeam_cell/deathmend

/datum/medibeam_cell/synth_repair

/datum/medibeam_cell/synth_tuning

/**
 * medical beamgun effect
 */
/datum/medibeam_effect

/datum/medibeam_effect/wound_healing
	var/disinfect_strength = 0
	var/seal_strength = 0
	// per unit
	var/repair_strength_brute = 0
	// per unit
	var/repair_strength_burn = 0
	var/fix_synths = FALSE
	var/synth_only = FALSE
	var/while_dead = FALSE
	var/only_open = FALSE

#warn impl

/datum/medibeam_effect/stabilize

/datum/medibeam_effect/forced_metabolism
	var/while_dead = FALSE

/datum/medibeam_effect/agony_from_open_wounds
	var/strength_factor = 0

/datum/medibeam_effect/stoneskin

/datum/medibeam_effect/dextrous_motion
