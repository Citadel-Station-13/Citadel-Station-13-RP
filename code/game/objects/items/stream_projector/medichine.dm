//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: peristable repository
GLOBAL_LIST_EMPTY(medichine_cell_datums)

/proc/fetch_cached_medichine_cell_datum(datum/medichine_cell/typepath)
	if(isnull(GLOB.medichine_cell_datums))
		GLOB.medichine_cell_datums[typepath] = new typepath
	return GLOB.medichine_cell_datums[typepath]

/**
 * medical beamgun
 *
 * todo: should we use reagents instead..?
 */
/obj/item/stream_projector/medichine
	name = "medichine stream projector"
	desc = "A specialized, locked-down variant of a nanite stream projector. Deploys medichines from a cartridge onto a target's surface."
	#warn icon

	// todo: proper cataloguing fluff desc system
	description_fluff = "An expensive prototype first developed jointly by Vey-Med and Nanotrasen, the medichine stream projector is essentially a \
	somewhat perfected cross between a holofabricator's confinement stream and a just-in-time nanoswarm compiler. Due to the relative little \
	need for a powerful, laminar stream of particles, this has a far higher efficient range than a standard holofabricator. Nanites must \
	be provided with prepared medichine cartridges."

	process_while_active = TRUE

	#warn impl

	/// installed cartridge
	var/obj/item/medichine_cell/inserted_cartridge
	/// standard injection rate (amount per second)
	var/injection_rate = 1


/obj/item/stream_projector/medichine/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("This projector's injection rate is inversely proportional to distance from a given target. Use close-by for best results.")

/obj/item/stream_projector/medichine/valid_target(atom/entity)
	return isliving(entity)

/obj/item/stream_projector/medichine/process(delta_time)
	for(var/mob/entity as anything in active_targets)
	#warn impl

/obj/item/stream_projector/medichine/setup_target_visuals(atom/entity)
	var/datum/component/medichine_visualizer/visualizer = entity.LoadComponent(/datum/component/medichine_visualizer)
	#warn impl

/obj/item/stream_projector/medichine/teardown_target_visuals(atom/entity)
	var/datum/component/medichine_visualizer/visualizer = entity.LoadComponent(/datum/component/medichine_visualizer)
	#warn impl
	if(!visualizer.total_strength)
		qdel(visualizer)

#warn impl all

/**
 * component used to form a mob's nanite cloud effect
 */
/datum/component/medichine_visualizer
	/// color = strength
	var/list/colors_registered
	/// current color as r, g, b values
	var/list/current_color_rgb = list(255, 255, 255)
	/// total strength
	var/total_strength = 0

	/// our particles
	var/atom/movable/particle_render/renderer

/datum/component/medichine_visualizer/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/medichine_visualizer/Destroy()
	QDEL_NULL(renderer)
	return ..()

/datum/component/medichine_visualizer/proc/register_beam(color, strength)
	ensure_visuals()

	LAZYINITLIST(colors_registered)
	colors_registered[color] = strength + colors_registered[color]
	var/new_total = total_strength + strength
	current_color_rgb = BlendRGBList(color, current_color_rgb, total_strength / new_total)
	total_strength = new_total

	update_visuals()

/datum/component/medichine_visualizer/proc/unregister_beam(color, strength)
	#warn impl

/datum/component/medichine_visualizer/proc/adjust_beam(old_color, old_strength, new_color, new_strength)
	#warn impl

/datum/component/medichine_visualizer/proc/update_visuals()
	#warn impl

/datum/component/medichine_visualizer/proc/ensure_visuals()
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
/obj/item/medichine_cell
	name = "medichine cartridge (EMPTY)"
	desc = "A cartridge meant to hold medicinal nanites."
	#warn impl

	/// path to cell datum
	var/datum/medichine_cell/cell_datum = /datum/medichine_cell
	/// units left
	var/volume = 100
	/// maximum units left
	var/max_volume = 100

#warn impl all

// todo: after med rework all of these need a look-over

/obj/item/medichine_cell/seal_wounds
	name = "medichine cartridge (SEAL)"
	desc = "A cartridge of swirling dust. This will repair, disinfect, and seal open wounds."
	#warn impl
	cell_datum = /datum/medichine_cell/seal_wounds

/obj/item/medichine_cell/seal_wounds/violently
	name = "medichine cartridge (DEBRIDE)"
	desc = "A cartridge of angrily swirling dust. This will repair, disinfect, and seal open wounds. Rapidly, and painfully."
	#warn impl
	cell_datum = /datum/medichine_cell/seal_wounds/violently

/obj/item/medichine_cell/fortify
	#warn impl
	cell_datum = /datum/medichine_cell/fortify

/obj/item/medichine_cell/stabilize
	#warn impl
	cell_datum = /datum/medichine_cell/stabilize

/obj/item/medichine_cell/deathmend
	#warn impl
	cell_datum = /datum/medichine_cell/deathmend

/obj/item/medichine_cell/synth_repair
	#warn impl
	cell_datum = /datum/medichine_cell/synth_repair

/obj/item/medichine_cell/synth_tuning
	#warn impl
	cell_datum = /datum/medichine_cell/synth_tuning

/**
 * medical beamgun effect package
 */
/datum/medichine_cell
	/// list of effects; set to paths to init on new
	var/list/datum/medichine_effect/effects
	/// stream consumption rate multiplier
	var/injection_multiplier = 1

/datum/medichine_cell/New()
	#warn impl

/datum/medichine_cell/seal_wounds

/datum/medichine_cell/seal_wounds/violently
	injection_multiplier = 2
	// agony needs to tick first
	effects = list(
		/datum/medichine_effect/agony_from_open_wounds{
			strength_factor = 1;
		},
		/datum/medichine_effect/wound_healing{
			disinfect_strength = 2;
			seal_strength = 5;
			repair_strength_brute = 2;
			repair_strength_burn = 2;
		}
	)

/datum/medichine_cell/fortify

/datum/medichine_cell/stabilize

/datum/medichine_cell/deathmend

/datum/medichine_cell/synth_repair

/datum/medichine_cell/synth_tuning

/**
 * medical beamgun effect
 */
/datum/medichine_effect

/**
 * as opposed to ticking on objs.
 *
 * @return FALSE if there's nothing left to do
 */
/datum/medichine_effect/proc/tick_on_mob(mob/living/entity, volume)
	return FALSE

/datum/medichine_effect/wound_healing
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

/datum/medichine_effect/stabilize

/datum/medichine_effect/forced_metabolism
	var/while_dead = FALSE

/datum/medichine_effect/agony_from_open_wounds
	var/strength_factor = 0

/datum/medichine_effect/stoneskin

/datum/medichine_effect/dextrous_motion
