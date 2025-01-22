//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: peristable repository
GLOBAL_LIST_EMPTY(medichine_cell_datums)

/proc/fetch_cached_medichine_cell_datum(datum/medichine_cell/typepath)
	if(isnull(GLOB.medichine_cell_datums[typepath]))
		GLOB.medichine_cell_datums[typepath] = new typepath
	return GLOB.medichine_cell_datums[typepath]

//? Projector

/**
 * medical beamgun
 *
 * todo: should we use reagents instead..?
 */
/obj/item/stream_projector/medichine
	prototype_id = "ItemMedichineProjector"
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
	var/injection_rate = 2
	/// standard suspension limit multiplier
	var/suspension_multiplier = 1
	/// all beams
	var/list/datum/beam/beams_by_entity
	/// maximum distance
	var/maximum_distance = 10
	/// multiplier to distance when dividing by distance
	var/distance_divisor_multiplier = 0.5
	/// distance allowed before starting to apply penalty
	var/distance_penalty_start = 1

/obj/item/stream_projector/medichine/examine(mob/user, dist)
	. = ..()
	. += SPAN_RED("[src] loses some efficiency based on its distance to a target.")
	if(isnull(inserted_cartridge))
		. += "[src] has nothing loaded."
	else
		. += "[src] has [inserted_cartridge] loaded. It has [CEILING(inserted_cartridge.volume, 0.01)]/[inserted_cartridge.max_volume] left."

/obj/item/stream_projector/medichine/valid_target(atom/entity)
	return isliving(entity)

/obj/item/stream_projector/medichine/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
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

/obj/item/stream_projector/medichine/try_lock_target(atom/entity, datum/event_args/actor/actor, silent)
	var/datum/medichine_cell/effective_cell = effective_cell_datum()
	if(isnull(effective_cell))
		actor.chat_feedback(
			SPAN_WARNING("There's no medichines loaded."),
			target = src,
		)
		return FALSE
	var/turf/where_we_are = get_turf(src)
	var/turf/where_they_are = get_turf(entity)
	if(get_dist(where_we_are, where_they_are) > maximum_distance)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("That is out of range."),
				target = src,
			)
		return FALSE
	if(get_dist(where_we_are, where_they_are) <= 1 && !where_we_are.TurfAdjacency(where_they_are))
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("Something is in the way!"),
				target = src,
			)
		return FALSE
	var/list/turf/line_to_them = getline(where_we_are, get_turf(entity))
	if(isnull(line_to_them))
		return FALSE
	var/atom/blocking
	for(var/turf/potential_blocker in line_to_them)
		if(potential_blocker.density && !(potential_blocker.pass_flags_self & ATOM_PASS_CLICK))
			blocking = potential_blocker
			break
		for(var/obj/object in potential_blocker)
			if(object.density && !(object.pass_flags_self & ATOM_PASS_CLICK))
				blocking = object
				break
		if(!isnull(blocking))
			break
	if(!isnull(blocking))
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("Something is in the way!"),
				target = src,
			)
		return FALSE
	return ..()

/obj/item/stream_projector/medichine/setup_target_visuals(atom/entity)
	. = ..()
	var/datum/beam/creating_beam = create_segmented_beam(src, entity, icon = 'icons/items/stream_projector/medichine.dmi', icon_state = "beam", collider_type = /atom/movable/beam_collider)
	creating_beam.shift_start_towards_target = 8
	creating_beam.shift_end_towards_source = 8
	LAZYSET(beams_by_entity, entity, creating_beam)
	var/datum/medichine_cell/effective_cell = effective_cell_datum()
	if(!isnull(effective_cell))
		creating_beam.segmentation.color = beam_color(effective_cell.color)
	RegisterSignal(creating_beam, COMSIG_BEAM_REDRAW, PROC_REF(on_beam_redraw))
	RegisterSignal(creating_beam, COMSIG_BEAM_CROSSED, PROC_REF(on_beam_crossed))

/obj/item/stream_projector/medichine/proc/on_beam_redraw(datum/beam/source)
	var/atom/movable/target = source.beam_target
	if(get_dist(src, target) > maximum_distance)
		drop_target(target)

/obj/item/stream_projector/medichine/proc/on_beam_crossed(datum/beam/source, atom/what)
	if(what.pass_flags_self & ATOM_PASS_CLICK)
		return
	if(!what.density)
		return
	drop_target(source.beam_target)

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
	var/datum/medichine_cell/effective_cell = effective_cell_datum()
	if(!isnull(effective_cell))
		var/beam_color = beam_color(effective_cell.color)
		for(var/atom/entity as anything in beams_by_entity)
			var/datum/beam/entity_beam = beams_by_entity[entity]
			entity_beam.segmentation.color = beam_color

/obj/item/stream_projector/medichine/proc/beam_color(color)
	var/list/decoded = rgb2num(color)
	return list(
		decoded[1] / 255, decoded[2] / 255, decoded[3] / 255,
		0, 0, 0,
		1, 1, 1,
	)

/obj/item/stream_projector/medichine/proc/effective_cell_datum()
	return inserted_cartridge?.cell_datum

/obj/item/stream_projector/medichine/process(delta_time)
	..()
	// if not injecting, drop
	if(!length(active_targets))
		return

	// get effective cell
	var/datum/medichine_cell/effective_package = effective_cell_datum()
	// drop targets if not injecting
	if(isnull(effective_package))
		drop_all_targets()
		return
	// todo: this is for multi-cell support; implement that.
	// todo: this needs to work for mounts and item interfaces, so... how do we do that?
	var/list/datum/medichine_cell/injecting_packages = list(effective_package)
	// for each cell
	for(var/datum/medichine_cell/injecting_package as anything in injecting_packages)
		// get effective suspension limit and injection rates
		var/injecting_suspension = max(0, injecting_package.suspension_limit * suspension_multiplier)
		var/injecting_rate = clamp(injection_rate * injecting_package.injection_multiplier, 0, injecting_suspension)
		// inject to active targets
		for(var/mob/entity in active_targets)
			var/datum/component/medichine_field/field = entity.LoadComponent(/datum/component/medichine_field)
			var/distance_multiplier = 1 / max(1, 1 + max(get_dist(src, entity) - distance_penalty_start, 0) * distance_divisor_multiplier)
			var/requested = min(injecting_rate * distance_multiplier, max(0, injecting_suspension - field.active?[injecting_package]))
			var/allowed = inserted_cartridge?.use(injecting_package, requested)
			field.inject_medichines(injecting_package, allowed)

//? Field

/**
 * component used to form a mob's nanite cloud visuals + processing
 *
 * todo: scale / whatever properly to large mobs, including taurs
 * todo: fields might need to pull from projectors, rather than projectors pushing to fields. this prevents oscillation.
 * todo: the current anti-oscillation is a little overpowered for buff effects, as buff effects won't generally check for amount.
 */
/datum/component/medichine_field
	registered_type = /datum/component/medichine_field
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

/datum/component/medichine_field/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_PHYSICAL_LIFE, PROC_REF(on_life))

/datum/component/medichine_field/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOB_PHYSICAL_LIFE)
	QDEL_NULL(renderer)

/datum/component/medichine_field/proc/on_life(datum/source, seconds, times_fired)
	tick(seconds)

/**
 * called by on_life or process depending on if we're on a mob or normal atom.
 */
/datum/component/medichine_field/proc/tick(seconds)
	if(!isliving(parent)) // no support for atoms yet
		return
	var/mob/living/victim = parent
	var/removed_something = FALSE
	for(var/datum/medichine_cell/cell_package as anything in active)
		var/cell_volume = active[cell_package]
		var/reacting = min(cell_package.reaction_rate, cell_volume)
		var/reacted_ratio = 0

		// if we were already at 0, remove
		if(reacting <= 0)
			active -= cell_package
			for(var/datum/medichine_effect/cell_effect as anything in cell_package.effects)
				cell_effect.target_removed(victim)
			removed_something = TRUE
		// else, tick
		else if(reacting > 0)
			// perform tick
			for(var/datum/medichine_effect/cell_effect as anything in cell_package.effects)
				var/used_ratio
				used_ratio = cell_effect.tick_on_mob(src, victim, reacting)
				if(isnull(used_ratio))
					continue
				reacted_ratio = max(reacted_ratio, used_ratio)

			var/decaying = max(cell_package.decay_minimum_baseline, reacting * reacted_ratio, 0)
			active[cell_package] -= decaying
			total_volume -= decaying
			// if we're at 0, we do nothing; it's removed next tick
			// this way, if the projector adds more before next tick, we don't oscillate as hard.
	if(removed_something)
		if(!length(active))
			qdel(src)
		else
			recalculate_color()

/datum/component/medichine_field/proc/recalculate_color()
	if(!total_volume)
		current_color = "#ffffff"
	else
		var/list/blended = list(0, 0, 0)
		for(var/datum/medichine_cell/package as anything in active)
			var/ratio = 1 / length(active)
			blended[1] += package.color_rgb_list[1] * ratio
			blended[2] += package.color_rgb_list[2] * ratio
			blended[3] += package.color_rgb_list[3] * ratio
		current_color = rgb(blended[1], blended[2], blended[3])
	renderer.particles.color = current_color

/datum/component/medichine_field/proc/inject_medichines(datum/medichine_cell/medichines, amount)
	LAZYINITLIST(active)
	ensure_visuals()
	var/wasnt_there
	if(isnull(active[medichines]))
		wasnt_there = TRUE
	active[medichines] += amount
	total_volume += amount
	if(wasnt_there)
		for(var/datum/medichine_effect/effect as anything in medichines.effects)
			effect.target_added(parent)
		recalculate_color()

/datum/component/medichine_field/proc/ensure_visuals()
	if(!isnull(renderer))
		return
	renderer = new /atom/movable/particle_render/medichine_field(null)
	if(ismovable(parent))
		var/atom/movable/entity = parent
		entity.vis_contents += renderer
	else
		var/atom/entity = parent
		renderer.loc = entity
	var/particles/particle_instance = new /particles/medichine_field
	particle_instance.color = current_color
	renderer.particles = particle_instance

//? VFX

/atom/movable/particle_render/medichine_field
	alpha = 200

/particles/medichine_field
	width = 32
	height = 32
	count = 75
	spawning = 0.65
	fade = 3
	lifespan = 3
	velocity = list(0, 2.5, 0)
	icon = 'icons/items/stream_projector/medichine.dmi'
	icon_state = list(
		"particle-plus" = 1,
	)
	position = generator("box", list(-4, -16, 0), list(6, 0, 0))

//? Cell

/**
 * medical beamgun cell
 */
/obj/item/medichine_cell
	prototype_id = "ItemMedichineCell"
	name = "medichine cartridge (EMPTY)"
	desc = "A cartridge meant to hold medicinal nanites."
	icon = 'icons/items/stream_projector/medichine.dmi'
	icon_state = "cell"
	base_icon_state = "cell"
	materials_base = list(
		MAT_STEEL = 500,
		MAT_PLASTIC = 500,
		MAT_GLASS = 250,
	)

	/// path to cell datum
	var/datum/medichine_cell/cell_datum = /datum/medichine_cell
	/// units left
	var/volume = 100
	/// maximum units left
	var/max_volume = 100

	/// materials needed per unit of nanites
	var/list/materials_per_volume_unit = list()

/obj/item/medichine_cell/Initialize(mapload)
	. = ..()
	cell_datum = fetch_cached_medichine_cell_datum(cell_datum)
	update_icon()

/obj/item/medichine_cell/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("Its gauge reads [CEILING(volume, 0.01)]/[max_volume].")

/obj/item/medichine_cell/update_icon(updates)
	cut_overlays()
	. = ..()
	var/number = volume? round(volume / max_volume * 4) : 0
	if(number)
		var/image/I = image(icon, "[base_icon_state]-[number]")
		I.color = cell_datum.color
		add_overlay(I, TRUE)

/obj/item/medichine_cell/serialize()
	. = ..()
	// todo: id
	.["cell"] = "[cell_datum.type]"
	.["volume"] = volume
	// todo: how do we know when we should serialize varedits? we have a serious potential desync issue otherwise
	.["max_volume"] = max_volume

/obj/item/medichine_cell/deserialize(list/data)
	// todo: id
	if(data["cell"])
		var/datum/medichine_cell/cell_found = fetch_cached_medichine_cell_datum(text2path(data["cell"]))
		if(cell_found)
			cell_datum = cell_found
	if(!isnull(data["volume"]))
		volume = data["volume"]
	if(!isnull(data["max_volume"]))
		max_volume = data["max_volume"]
	return ..()

/obj/item/medichine_cell/proc/fill(amount)
	. = min(amount, volume)
	if(!.)
		return
	volume = clamp(volume + amount, 0, max_volume)

/obj/item/medichine_cell/proc/use(datum/medichine_cell/requested, amount)
	if(requested != cell_datum)
		return 0
	. = min(amount, volume)
	if(!.)
		return
	volume = clamp(volume - amount, 0, max_volume)
	update_icon()

/obj/item/medichine_cell/detect_material_base_costs()
	. = ..()
	for(var/key in materials_per_volume_unit)
		var/val = materials_per_volume_unit[key]
		.[key] += round(val * volume)

/obj/item/medichine_cell/get_materials(respect_multiplier)
	. = ..()
	var/multiplier = respect_multiplier? material_multiplier : 1
	for(var/key in materials_per_volume_unit)
		var/val = materials_per_volume_unit[key]
		.[key] += round(val * volume) * multiplier

// todo: after med rework all of these need a look-over

/obj/item/medichine_cell/seal_wounds
	name = "medichine cartridge (SEAL)"
	desc = "A cartridge of swirling dust. This will repair, disinfect, and seal open wounds."
	cell_datum = /datum/medichine_cell/seal_wounds
	materials_per_volume_unit = list(
		MAT_GLASS = 2,
		MAT_STEEL = 2,
	)

/obj/item/medichine_cell/seal_wounds/violently
	name = "medichine cartridge (DEBRIDE)"
	desc = "A cartridge of angrily swirling dust. This will repair, disinfect, and seal open wounds. Rapidly, and painfully."
	cell_datum = /datum/medichine_cell/seal_wounds/violently
	materials_per_volume_unit = list(
		MAT_GLASS = 2,
		MAT_STEEL = 2,
		MAT_SILVER = 2.5,
		MAT_DIAMOND = 1,
	)

// /obj/item/medichine_cell/fortify
// 	name = "medichine cartridge (FORTIFY)"
// 	desc = "A cartridge of robust swirling dust. This will toughen someone's skin with an artificial layer of cohesive nanites."
// 	cell_datum = /datum/medichine_cell/fortify

/obj/item/medichine_cell/stabilize
	name = "medichine cartridge (STABILIZE)"
	desc = "A cartridge of cohesive swirling dust. This will stabilize someone's life functions and provide manual metabolism."
	cell_datum = /datum/medichine_cell/stabilize
	materials_per_volume_unit = list(
		MAT_GLASS = 2,
		MAT_STEEL = 2,
		MAT_PLASTIC = 2,
		MAT_SILVER = 2,
	)

/obj/item/medichine_cell/deathmend
	name = "medichine cartridge (DEATHMEND)"
	desc = "A cartridge of necromantic swirling dust. This will repair the wounds, even of the dead."
	cell_datum = /datum/medichine_cell/deathmend
	materials_per_volume_unit = list(
		MAT_GLASS = 2,
		MAT_STEEL = 2,
		MAT_PLASTIC = 1.5,
		MAT_URANIUM = 1.5,
		MAT_SILVER = 2,
		MAT_GOLD = 1.5,
	)

/obj/item/medichine_cell/synth_repair
	name = "medichine cartridge (SYNTHFIX)"
	desc = "A cartridge of metallic swirling dust. This will patch up damaged limbs on a synthetic."
	cell_datum = /datum/medichine_cell/synth_repair
	materials_per_volume_unit = list(
		MAT_GLASS = 2,
		MAT_STEEL = 2,
		MAT_PLASTIC = 1.5,
		MAT_DIAMOND = 2,
	)

//? Effect Packages

// /obj/item/medichine_cell/synth_tuning
// 	name = "medichine cartridge (SYNTHTUNE)"
// 	desc = "A cartridge of glowing, swirling dust. This will act in cohesion with a synthetic, as a performance amplifier."
// 	cell_datum = /datum/medichine_cell/synth_tuning

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
	var/decay_minimum_baseline = 0.1
	/// normal color
	var/color = "#ffffff"
	/// normal color as a list
	var/list/color_rgb_list

/datum/medichine_cell/New()
	color_rgb_list = rgb2num(color)
	for(var/i in 1 to length(effects))
		var/datum/medichine_effect/effect = effects[i]
		if(istype(effect))
			continue
		effect = new effect
		effects[i] = effect

/datum/medichine_cell/seal_wounds
	// each cell heals 400
	effects = list(
		/datum/medichine_effect/wound_healing{
			biology_types = BIOLOGY_TYPES_FLESHY;
			disinfect_wounds = TRUE;
			seal_wounds = TRUE;
			repair_strength_brute = 2.5;
			repair_strength_burn = 2.5;
		}
	)
	color = "#aa0000"

/datum/medichine_cell/seal_wounds/violently
	reaction_rate = 2
	// agony needs to tick first
	// each cell heals 400, but faster
	effects = list(
		/datum/medichine_effect/agony_from_open_wounds{
			hard_limit = 50;
		},
		/datum/medichine_effect/wound_healing{
			biology_types = BIOLOGY_TYPES_FLESHY;
			disinfect_wounds = TRUE;
			seal_wounds = TRUE;
			repair_strength_brute = 5;
			repair_strength_burn = 5;
		},
	)
	color = "#ff3300"

// /datum/medichine_cell/fortify
// 	#warn impl

/datum/medichine_cell/stabilize
	effects = list(
		/datum/medichine_effect/stabilize{
			ignore_consumption = FALSE;
		},
		/datum/medichine_effect/forced_metabolism{
			ignore_consumption = FALSE;
			only_dead = TRUE;
		},
		/datum/medichine_effect/oxygenate{
			strength = 5;
			only_while_above = 40;
		},
	)
	// 30 seconds
	suspension_limit = 10
	// constant draw, 5 minutes of stabilization per cell
	reaction_rate = (1 / 3)
	decay_minimum_baseline = (1 / 3)
	color = "#9999ff"

/datum/medichine_cell/deathmend
	// each cell heals 600-1200 (!!)
	effects = list(
		/datum/medichine_effect/wound_healing{
			biology_types = BIOLOGY_TYPES_FLESHY;
			disinfect_wounds = TRUE;
			seal_wounds = TRUE;
			repair_strength_brute = 6;
			repair_strength_burn = 6;
		}
	)
	suspension_limit = 5
	// 18-36 hp/s
	reaction_rate = 3
	color = "#883333"

/datum/medichine_cell/synth_repair
	// each cell heals 400
	effects = list(
		/datum/medichine_effect/wound_healing{
			biology_types = BIOLOGY_TYPES_SYNTHETIC;
			seal_wounds = TRUE;
			disinfect_wounds = TRUE;
			repair_strength_brute = 4;
			repair_strength_burn = 4;
		}
	)
	color = "#888844"
	// no pre-buffing allowed!
	suspension_limit = 5
	decay_minimum_baseline = 0.5

// /datum/medichine_cell/synth_tuning
// 	#warn impl

//? Effects

/**
 * medical beamgun effect
 */
/datum/medichine_effect
	/// completely ignore us for calculations by assuming we are never using any nanite volume
	/// set from the /datum/medichine_cell side to allow for 'side' effects that don't necessarily
	/// use any nanite volume and are always just there.
	var/ignore_consumption = FALSE

/**
 * as opposed to ticking on objs.
 *
 * @return 0 to 1 of ratio used; null for 'stop' / 'hibernate'
 */
/datum/medichine_effect/proc/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	return 1

/**
 * called on target add
 */
/datum/medichine_effect/proc/target_added(datum/component/medichine_field/field, atom/entity)
	return

/**
 * called on target remove
 */
/datum/medichine_effect/proc/target_removed(datum/component/medichine_field/field, atom/entity)
	return

/datum/medichine_effect/wound_healing
	/// allowed biologies
	var/biology_types = NONE
	// todo: strength, not instant
	var/seal_wounds = FALSE
	// todo: strength, not instant
	var/disinfect_wounds = FALSE
	/// per unit
	var/repair_strength_brute = 0
	/// per unit
	var/repair_strength_burn = 0
	/// works on the dead
	var/while_dead = FALSE
	/// only fixes open wounds, will not seal until it's closed
	var/only_open = FALSE

/datum/medichine_effect/wound_healing/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	var/brute_healing_total = volume * repair_strength_brute
	var/burn_healing_total = volume * repair_strength_burn
	var/brute_healing_left = brute_healing_total
	var/burn_healing_left = burn_healing_total
	var/mob/living/carbon/humanlike = entity
	// do simple healing for simplemobs
	if(!istype(humanlike))
		brute_healing_left -= entity.heal_brute_loss(brute_healing_total)
		burn_healing_left -= entity.heal_fire_loss(burn_healing_total)
		return max(1 - (burn_healing_left / burn_healing_total), 1 - (brute_healing_left / brute_healing_total))
	var/brute_loss_instances = 0
	var/burn_loss_instances = 0
	var/list/datum/wound/wounds_healing = list()
	for(var/obj/item/organ/external/ext as anything in humanlike.bad_external_organs)
		if(!ext.is_any_biology_type(biology_types))
			continue
		// only heal 15 wounds at a time thank you!
		if(length(wounds_healing) > 15)
			break
		for(var/datum/wound/wound as anything in ext.wounds)
			// only heal 15 wounds at a time thank you!
			if(length(wounds_healing) > 15)
				break
			if(!wound.damage)
				continue
			if(wound.internal)
				continue
			if(only_open && (wound.is_treated()))
				continue
			if(wound.wound_type == WOUND_TYPE_BURN)
				burn_loss_instances++
			else
				brute_loss_instances++
			wounds_healing += wound
	var/burn_heal_per = burn_loss_instances && (burn_healing_left / burn_loss_instances)
	var/brute_heal_per = brute_loss_instances && (brute_healing_left / brute_loss_instances)
	burn_heal_per = CEILING(burn_heal_per, 1)
	brute_heal_per = CEILING(brute_heal_per, 1)
	var/burn_heal_overrun = 0
	var/brute_heal_overrun = 0
	for(var/datum/wound/wound as anything in wounds_healing)
		var/effective_heal
		if(wound.wound_type == WOUND_TYPE_BURN)
			if(!burn_healing_left)
				continue
			effective_heal = min(burn_heal_per + burn_heal_overrun, burn_healing_left)
			if(wound.damage > effective_heal)
				wound.heal_damage(effective_heal)
				burn_heal_overrun = 0
				burn_healing_left -= effective_heal
			else
				burn_heal_overrun = effective_heal - wound.damage
				wound.heal_damage(wound.damage)
		else
			if(!brute_healing_left)
				continue
			effective_heal = min(brute_heal_per + brute_heal_overrun, brute_healing_left)
			if(wound.damage > effective_heal)
				wound.heal_damage(effective_heal)
				brute_healing_left -= effective_heal
				brute_heal_overrun = 0
			else
				brute_heal_overrun = effective_heal - wound.damage
				wound.heal_damage(wound.damage)
		if(!wound.damage)
			if(seal_wounds)
				wound.bandage()
				wound.salve()
			if(disinfect_wounds)
				wound.disinfect()
	return max(burn_healing_total && (1 - (burn_healing_left / burn_healing_total)), brute_healing_total && (1 - (brute_healing_left / brute_healing_total)))

/datum/medichine_effect/oxygenate
	/// works on the dead
	var/while_dead = FALSE
	/// amount per volume
	var/strength = 0
	/// don't heal above that much damage
	var/only_while_above = INFINITY

/datum/medichine_effect/oxygenate/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	if(STAT_IS_DEAD(entity.stat) && !while_dead)
		return null
	var/amount_to_heal = min(strength * volume, entity.getOxyLoss() - only_while_above)
	if(amount_to_heal <= 0)
		return 0
	return entity.heal_oxy_loss(amount_to_heal) / amount_to_heal

/datum/medichine_effect/toxfilter
	/// works on the dead
	var/while_dead = FALSE
	/// amount per volume
	var/strength = 0
	/// don't heal above that much damage
	var/only_while_above = INFINITY

/datum/medichine_effect/toxfilter/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	if(STAT_IS_DEAD(entity.stat) && !while_dead)
		return null
	var/amount_to_heal = min(strength * volume, entity.getToxLoss(), only_while_above)
	if(amount_to_heal <= 0)
		return 0
	return entity.heal_tox_loss(amount_to_heal) / amount_to_heal

/datum/medichine_effect/stabilize

/datum/medichine_effect/stabilize/target_added(datum/component/medichine_field/field, atom/entity)
	ADD_TRAIT(entity, TRAIT_MECHANICAL_VENTILATION, "medichine-[REF(src)]")
	ADD_TRAIT(entity, TRAIT_MECHANICAL_CIRCULATION, "medichine-[REF(src)]")

/datum/medichine_effect/stabilize/target_removed(datum/component/medichine_field/field, atom/entity)
	REMOVE_TRAIT(entity, TRAIT_MECHANICAL_VENTILATION, "medichine-[REF(src)]")
	REMOVE_TRAIT(entity, TRAIT_MECHANICAL_CIRCULATION, "medichine-[REF(src)]")

/datum/medichine_effect/forced_metabolism
	/// time multiplier; 2 = tick 2 seconds per second
	/// this is the constant before volume is added.
	var/scale_rate_constant = 0
	/// scale time multiplier to volume used; if non-0, each 1 volume adds this much rate.
	var/scale_rate_to_volume = 1
	/// continue to force metabolism while dead?
	var/while_dead = FALSE
	/// only while dead? overrides [while_dead].
	var/only_dead = FALSE

/datum/medichine_effect/forced_metabolism/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	if(STAT_IS_DEAD(entity.stat))
		if(!while_dead || only_dead)
			return null
	else
		if(only_dead)
			return null
	var/real_rate = scale_rate_constant * seconds + volume * scale_rate_to_volume
	entity.forced_metabolism(real_rate)
	return 1

/datum/medichine_effect/agony_from_open_wounds
	// it makes no sense to use this for consumption rate most of the time.
	ignore_consumption = TRUE
	/// hard limit to agony
	var/hard_limit = 0
	/// grace threshold above hard limit we can deal to so we don't oscillate too hard
	var/hard_overrun_allowed = 5
	/// agony multiplier
	var/global_multiplier = 1
	/// agony per open damage
	var/per_damage = 0.5
	/// increase rate per missing (minimum 1)
	var/gain_rate_scaling = 0.15
	/// limit by bodypart based on bodypart ratio
	/// if 0.5, it means 'agony can only be half of the bodypart's ratio or less'
	/// you therefore usually want it way above say, 10, because 0.4 ratio with 100 ratio_scaling would be 40.
	var/ratio_scaling = 100

/datum/medichine_effect/agony_from_open_wounds/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	var/mob/living/carbon/humanlike = entity
	if(!istype(humanlike))
		return null
	if(humanlike.halloss >= hard_limit)
		return 0
	var/can_deal = (hard_limit + hard_overrun_allowed) - humanlike.halloss
	var/will_deal = 0
	for(var/obj/item/organ/external/ext as anything in humanlike.bad_external_organs)
		var/size_ratio = organ_rel_size[ext.organ_tag] / GLOB.organ_combined_size
		if(!size_ratio)
			continue
		var/organ_limit = ratio_scaling * size_ratio
		var/total_damage = 0
		for(var/datum/wound/wound as anything in ext.wounds)
			if(wound.internal)
				continue
			if(wound.is_treated())
				continue
			total_damage += wound.damage
		will_deal += min(organ_limit, per_damage * total_damage)
	var/missing = humanlike.halloss - will_deal
	var/dealing = min(can_deal, missing * gain_rate_scaling + 1)
	humanlike.adjustHalLoss(dealing)
	// todo: actually calculate consumption rate based on something..?
	return 1

// /datum/medichine_effect/stoneskin

// /datum/medichine_effect/stoneskin/tick_on_mob(mob/living/entity, volume)

// /datum/medichine_effect/dextrous_motion

// /datum/medichine_effect/dextrous_motion/tick_on_mob(mob/living/entity, volume)
