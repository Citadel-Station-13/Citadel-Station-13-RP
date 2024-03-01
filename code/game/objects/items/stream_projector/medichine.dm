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
ITEM_AUTO_BINDS_SINGLE_INTERFACE_TO_VAR(/obj/item/stream_projector/medichine, interface)
/obj/item/stream_projector/medichine
	name = "medichine stream projector"
	desc = "A specialized, locked-down variant of a nanite stream projector. Deploys medichines from a cartridge onto a target's surface."
	icon = 'icons/items/stream_projector/medichine.dmi'
	icon_state = "projector"
	base_icon_state = "projector"

	// todo: proper cataloguing fluff desc system
	description_fluff = "An expensive prototype first developed jointly by Vey-Med and Nanotrasen, the medichine stream projector is essentially a \
	somewhat perfected cross between a holofabricator's confinement stream and a just-in-time nanoswarm compiler. Due to the relative little \
	need for a powerful, laminar stream of particles, this has a far higher efficient range than a standard holofabricator. Nanites must \
	be provided with prepared medichine cartridges."

	process_while_active = TRUE

	/// installed cartridge
	var/obj/item/medichine_cell/inserted_cartridge
	/// standard injection rate (amount per second)
	var/injection_rate = 1
	/// interface to draw from if provided
	var/datum/item_interface/interface
	/// all beams
	var/list/datum/beam/beams_by_entity

/obj/item/stream_projector/medichine/valid_target(atom/entity)
	return isliving(entity)

/obj/item/stream_projector/medichine/attack_hand(mob/user, list/params)
	if(user.is_holding_inactive(src))
		if(isnull(inserted_cartridge))
			user.action_feedback(SPAN_WARNING("[src] has no vial loaded."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		user.put_in_hands_or_drop(inserted_cartridge)
		user.action_feedback(SPAN_NOTICE("You remove [inserted_cartridge] from [src]."), src)
		var/obj/item/medichine_cell/old_cell = inserted_cartridge
		inserted_cartridge = null
		playsound(src, 'sound/weapons/empty.ogg', 50, FALSE)
		update_icon()
		on_cell_swap(old_cell, null)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/stream_projector/medichine/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/medichine_cell))
		var/obj/item/medichine_cell/cell = I
		if(!user.transfer_item_to_loc(cell, src))
			user.action_feedback(SPAN_WARNING("[cell] is stuck to your hand!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/medichine_cell/old_cell = inserted_cartridge
		inserted_cartridge = cell
		if(!isnull(old_cell))
			user.action_feedback(SPAN_NOTICE("You quickly swap [old_cell] with [cell]."), src)
			user.put_in_hands_or_drop(old_cell)
		else
			user.action_feedback(SPAN_NOTICE("You insert [cell] into [src]."), src)
		playsound(src, 'sound/weapons/autoguninsert.ogg', 50, FALSE)
		update_icon()
		on_cell_swap(old_cell, cell)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/stream_projector/medichine/setup_target_visuals(atom/entity)
	. = ..()
	var/datum/beam/creating_beam = create_segmented_beam(src, entity, icon = 'icons/effects/beam.dmi', icon_state = "medbeam_tiled")
	LAZYSET(beams_by_entity, entity, creating_beam)
	#warn color beam

/obj/item/stream_projector/medichine/teardown_target_visuals(atom/entity)
	. = ..()
	var/datum/beam/their_beam = beams_by_entity[entity]
	beams_by_entity -= entity
	qdel(their_beam)

/obj/item/stream_projector/medichine/proc/on_cell_swap(obj/item/medichine_cell/old_cell, obj/item/medichine_cell/new_cell)
	// drop all targets if no new cell
	if(isnull(new_cell))
		drop_all_targets()
		return
	#warn recolor beams

/obj/item/stream_projector/medichine/process(delta_time)
	..()
	// if not injecting, drop
	if(!length(active_targets))
		return

	// get effective cell
	var/datum/medichine_cell/effective_package
	if(!isnull(interface))
		effective_package = interface.query_medichines()
	else
		effective_package = inserted_cartridge?.cell_datum
	// drop targets if not injecting
	if(isnull(effective_package))
		drop_all_targets()
		return

	// get injection rate
	var/effective_injection_rate = min(effective_package.injection_multiplier * injection_rate, effective_package.suspension_limit)

	// modulate injection rate
	var/requested_amount = 0
	for(var/mob/entity as anything in active_targets)
		var/datum/component/medichine_field/field = entity.GetComponent(/datum/component/medichine_field)
		if(isnull(field))
			requested_amount += effective_injection_rate
			continue
		requested_amount += min(effective_injection_rate, effective_package.suspension_limit - field.active[effective_package])

	// get allowed ratio
	var/allowed_ratio = (isnull(interface)? inserted_cartridge?.use(requested_amount) : interface.use_medichines(effective_package, requested_amount)) / requested_amount
	// drop if done
	if(!allowed_ratio)
		drop_all_targets()
		return

	// inject
	for(var/mob/entity as anything in active_targets)
		var/datum/component/medichine_field/field = entity.LoadComponent(/datum/component/medichine_field)
		field.inject_medichines(effective_package, allowed_ratio * effective_injection_rate)

/**
 * component used to form a mob's nanite cloud visuals + processing
 */
/datum/component/medichine_field
	/// active effect packages associated to nanite volume
	var/list/datum/medichine_cell/active
	/// cached total volume
	var/total_volume = 0
	/// what our color should be
	var/current_color = "#ffffff"
	/// our particles
	var/atom/movable/particle_render/renderer

/datum/component/medichine_field/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/medichine_field/Destroy()
	QDEL_NULL(renderer)
	return ..()

/datum/component/medichine_field/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_ON_LIFE, PROC_REF(on_life))

/datum/component/medichine_field/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOB_ON_LIFE)

/datum/component/medichine_field/proc/on_life(datum/source, seconds, times_fired)
	tick(seconds)

/**
 * called by on_life or process depending on if we're on a mob or normal atom.
 */
/datum/component/medichine_field/proc/tick(seconds)
	if(!isliving(parent)) // no support for atoms yet
		return
	var/mob/living/victim = parent
	#warn impl

/datum/component/medichine_field/proc/recalculate_color()
	var/list/blended = list(0, 0, 0)
	for(var/datum/medichine_cell/package as anything in active)
		var/ratio = (active[package] / total_volume)
		blended[1] += package.color_rgb_list[1] * ratio
		blended[2] += package.color_rgb_list[2] * ratio
		blended[3] += package.color_rgb_list[3] * ratio
	current_color = rgb(blended[1], blended[2], blended[3])
	#warn change renderer color

/datum/component/medichine_field/proc/inject_medichines(datum/medichine_cell/medichines, amount)
	LAZYINITLIST(active)
	active[medichines] += amount
	recalculate_color()
	ensure_visuals()

/datum/component/medichine_field/proc/ensure_visuals()
	if(!isnull(renderer))
		return
	renderer = new(null)
	if(ismovable(parent))
		var/atom/movable/entity = parent
		entity.vis_contents += renderer
	else
		var/atom/entity = parent
		renderer.loc = entity
	var/particles/particle_instance = new /particles/medichine_field
	renderer.particles = particle_instance
	renderer.particles.color = current_color

/particles/medichine_field
	width = 32
	height = 32
	count = 75
	spawning = 10
	fade = 3
	lifespan = 1
	velocity = list(0, 2.5, 0)
	position = generator("box", list(-8, -16, 0), list(8, 0, 0))

/**
 * medical beamgun cell
 */
/obj/item/medichine_cell
	name = "medichine cartridge (EMPTY)"
	desc = "A cartridge meant to hold medicinal nanites."
	icon = 'icons/items/stream_projector/medichine.dmi'
	icon_state = "cell"
	base_icon_state = "cell"

	/// path to cell datum
	var/datum/medichine_cell/cell_datum = /datum/medichine_cell
	/// units left
	var/volume = 100
	/// maximum units left
	var/max_volume = 100

/obj/item/medichine_cell/Initialize(mapload)
	. = ..()
	cell_datum = fetch_cached_medichine_cell_datum(cell_datum)
	update_icon()

/obj/item/medichine_cell/update_icon(updates)
	cut_overlays()
	. = ..()
	var/number = volume? round(volume / max_volume * 4) : 0
	if(number)
		var/image/I = image(icon, "[base_icon_state]-[number]")
		I.color = cell_datum.color
		add_overlay(I)

/obj/item/medichine_cell/proc/fill(amount)
	volume = clamp(volume + amount, 0, max_volume)

/obj/item/medichine_cell/proc/use(amount)
	volume = clamp(volume - amount, 0, max_volume)

// todo: after med rework all of these need a look-over

/obj/item/medichine_cell/seal_wounds
	name = "medichine cartridge (SEAL)"
	desc = "A cartridge of swirling dust. This will repair, disinfect, and seal open wounds."
	cell_datum = /datum/medichine_cell/seal_wounds

/obj/item/medichine_cell/seal_wounds/violently
	name = "medichine cartridge (DEBRIDE)"
	desc = "A cartridge of angrily swirling dust. This will repair, disinfect, and seal open wounds. Rapidly, and painfully."
	cell_datum = /datum/medichine_cell/seal_wounds/violently

/obj/item/medichine_cell/fortify
	name = "medichine cartridge (FORTIFY)"
	desc = "A cartridge of robust swirling dust. This will toughen someone's skin with an artificial layer of cohesive nanites."
	cell_datum = /datum/medichine_cell/fortify

/obj/item/medichine_cell/stabilize
	name = "medichine cartridge (STABILIZE)"
	desc = "A cartridge of cohesive swirling dust. This will stabilize someone's life functions and provide manual metabolism."
	cell_datum = /datum/medichine_cell/stabilize

/obj/item/medichine_cell/deathmend
	name = "medichine cartridge (DEATHMEND)"
	desc = "A cartridge of necromantic swirling dust. This will repair the wounds, even of the dead."
	cell_datum = /datum/medichine_cell/deathmend

/obj/item/medichine_cell/synth_repair
	name = "medichine cartridge (SYNTHFIX)"
	desc = "A cartridge of metallic swirling dust. This will patch up damaged limbs on a synthetic."
	cell_datum = /datum/medichine_cell/synth_repair

/obj/item/medichine_cell/synth_tuning
	name = "medichine cartridge (SYNTHTUNE)"
	desc = "A cartridge of glowing, swirling dust. This will act in cohesion with a synthetic, as a performance amplifier."
	cell_datum = /datum/medichine_cell/synth_tuning

/**
 * medical beamgun effect package
 */
/datum/medichine_cell
	/// list of effects; set to paths to init on new
	var/list/datum/medichine_effect/effects
	/// nanite consumption rate per second
	var/reaction_rate = 1
	/// projector injection rate multiplier
	var/injection_multiplier = 1
	/// amount of volume that can stick onto someone by default
	var/suspension_limit = 10
	/// minimum decay rate so the field doesn't stick forever
	var/decay_minimum_baseline = 0
	/// normal color
	var/color = "#ffffff"
	/// normal color as a list
	var/list/color_rgb_list

/datum/medichine_cell/New()
	color_rgb_list = ReadRGB(color)
	for(var/i in 1 to length(effects))
		var/datum/medichine_effect/effect = effects[i]
		if(istype(effect))
			continue
		effect = new effect
		effects[i] = effect

/datum/medichine_cell/seal_wounds
	injection_multiplier = 1
	#warn impl

/datum/medichine_cell/seal_wounds/violently
	injection_multiplier = 2
	// agony needs to tick first
	effects = list(
		/datum/medichine_effect/agony_from_open_wounds{
			strength_factor = 1;
			limits_utilization = FALSE;
		},
		/datum/medichine_effect/wound_healing{
			disinfect_strength = 2;
			seal_strength = 5;
			repair_strength_brute = 2;
			repair_strength_burn = 2;
		}
	)
	#warn impl

/datum/medichine_cell/fortify
	#warn impl

/datum/medichine_cell/stabilize
	#warn impl

/datum/medichine_cell/deathmend
	color = "#883333"
	#warn impl

/datum/medichine_cell/synth_repair
	#warn impl

/datum/medichine_cell/synth_tuning
	#warn impl

/**
 * medical beamgun effect
 */
/datum/medichine_effect
	/// are we relevant for 'how much are we using'?
	var/limits_utilization = TRUE

/**
 * as opposed to ticking on objs.
 *
 * @return 0 to 1 of ratio used; null for 'stop'
 */
/datum/medichine_effect/proc/tick_on_mob(obj/item/stream_projector/medichine/projector, mob/living/entity, volume)
	return null

/**
 * called when we're being applied to a carbon
 *
 * wounds can be empty
 *
 * @return 0 to 1 of ratio used; null for 'stop'
 */
/datum/medichine_effect/proc/tick_on_wounds(obj/item/stream_projector/medichine/projector, mob/living/carbon/entity, list/datum/wound/wounds)
	return null

/**
 * called on target add
 */
/datum/medichine_effect/proc/target_added(atom/entity)
	return

/**
 * called on target remove
 */
/datum/medichine_effect/proc/target_removed(atom/entity)
	return

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

/datum/medichine_effect/wound_healing/tick_on_wounds(mob/living/carbon/entity, list/datum/wound/wounds)


/datum/medichine_effect/stabilize

/datum/medichine_effect/stabilize/tick_on_mob(mob/living/entity, volume)


/datum/medichine_effect/forced_metabolism
	var/while_dead = FALSE

/datum/medichine_effect/forced_metabolism/tick_on_mob(mob/living/entity, volume)


/datum/medichine_effect/agony_from_open_wounds
	var/strength_constant = 0
	var/strength_factor = 0

/datum/medichine_effect/agony_from_open_wounds/tick_on_wounds(mob/living/carbon/entity, list/datum/wound/wounds)


/datum/medichine_effect/stoneskin

/datum/medichine_effect/stoneskin/tick_on_mob(mob/living/entity, volume)
	. = ..()


/datum/medichine_effect/dextrous_motion

/datum/medichine_effect/dextrous_motion/tick_on_mob(mob/living/entity, volume)
	. = ..()

