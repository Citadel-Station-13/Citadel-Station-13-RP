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
	var/datum/medichine_cell/effective_cell = effective_cell_datum()
	if(!isnull(effective_cell))
		creating_beam.line_renderer.color = effective_cell.color

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
		for(var/atom/entity as anything in beams_by_entity)
			var/datum/beam/entity_beam = beams_by_entity[entity]
			entity_beam.line_renderer.color = effective_cell.color

/obj/item/stream_projector/medichine/proc/effective_cell_datum()
	return isnull(interface)? inserted_cartridge?.cell_datum : interface.query_medichines()

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
	var/removed_something = FALSE
	for(var/datum/medichine_cell/cell_package as anything in active)
		var/cell_volume = active[cell_package]
		var/reacting = cell_package.reaction_rate
		var/reacted_ratio = 0

		// perform tick
		for(var/datum/medichine_effect/cell_effect as anything in cell_package.effects)
			var/used_ratio
			used_ratio = cell_effect.tick_on_mob(src, victim, reacting)
			if(isnull(used_ratio))
				continue
			reacted_ratio = max(reacted_ratio, used_ratio)

		active[cell_package] -= max(cell_package.decay_minimum_baseline, reacting * reacted_ratio)
		if(active[cell_package] < 0)
			active -= cell_package
			for(var/datum/medichine_effect/cell_effect as anything in cell_package.effects)
				cell_effect.target_removed(victim)
			removed_something = TRUE
	if(removed_something)
		recalculate_color()

/datum/component/medichine_field/proc/recalculate_color()
	var/list/blended = list(0, 0, 0)
	for(var/datum/medichine_cell/package as anything in active)
		var/ratio = (active[package] / total_volume)
		blended[1] += package.color_rgb_list[1] * ratio
		blended[2] += package.color_rgb_list[2] * ratio
		blended[3] += package.color_rgb_list[3] * ratio
	current_color = rgb(blended[1], blended[2], blended[3])
	renderer.color = current_color

/datum/component/medichine_field/proc/inject_medichines(datum/medichine_cell/medichines, amount)
	LAZYINITLIST(active)
	if(isnull(active[medichines]))
		for(var/datum/medichine_effect/effect as anything in medichines.effects)
			effect.target_added(parent)
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
	renderer.color = current_color

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
	effects = list(
		/datum/medichine_effect/wound_healing{
			disinfect_strength = 2;
			seal_strength = 5;
			repair_strength_brute = 2;
			repair_strength_burn = 2;
		}
	)
	color = "#aa0000"
	#warn impl

/datum/medichine_cell/seal_wounds/violently
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
	color = "#ff3300"
	#warn impl

// /datum/medichine_cell/fortify
// 	#warn impl

/datum/medichine_cell/stabilize
	effects = list(
		/datum/medichine_effect/stabilize{
			ignore_consumption = FALSE;
		},
		/datum/medichine_effect/forced_metabolism{
			ignore_consumption = FALSE;
		},
	)
	// we always draw 1 per tick.
	reaction_rate = 1
	// we always draw 1 per tick.
	decay_minimum_baseline = 1
	color = "#9999ff"
	#warn impl

/datum/medichine_cell/deathmend
	color = "#883333"
	#warn impl

/datum/medichine_cell/synth_repair
	effects = list(
		/datum/medichine_effect/wound_healing{
			biology_types = BIOLOGY_TYPES_SYNTHETIC;
			seal_strength = 5;
			repair_strength_brute = 2;
			repair_strength_burn = 2;
		}
	)
	color = "#888844"
	#warn impl

// /datum/medichine_cell/synth_tuning
// 	#warn impl

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
 * @return 0 to 1 of ratio used; null for 'stop'
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
	var/biology_types = BIOLOGY_TYPES_SYNTHETIC
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
		burn_healing_left -= entity.heal_burn_loss(burn_healing_total)
		return max(1 - (burn_healing_left / burn_healing_total), 1 - (brute_healing_left / brute_healing_total))
	var/brute_loss_total = 0
	var/burn_loss_total = 0
	var/list/datum/wound/wounds_healing = list()
	for(var/obj/item/organ/external/ext as anything in humanlike.bad_external_organs)
		for(var/datum/wound/wound as anything in ext.wounds)
			if(wound.internal)
				continue
			if(only_open && (wound.is_treated()))
				continue
			if(wound.damage_type == BURN)
				burn_loss_total += wound.damage
			else
				brute_loss_total += wound.damage
	var/burn_heal_per = burn_healing_left / burn_loss_total
	var/brute_heal_per = brute_healing_left / brute_loss_total
	burn_heal_per = CEILING(burn_heal_per, 1)
	brute_heal_per = CEILING(brute_heal_per, 1)
	for(var/datum/wound/wound as anything in wounds_healing)
		if(wound.damage_type == BURN)
			#warn burn
		else
			#warn brute
	#warn impl
	return max(1 - (burn_healing_left / burn_healing_total), 1 - (brute_healing_left / brute_healing_total))

#warn oxygenate
#warn toxfilter


/datum/medichine_effect/oxygenate
	/// works on the dead
	var/while_dead = FALSE
	/// amount per volume
	var/strength = 0

/datum/medichine_effect/oxygenate/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	#warn impl

/datum/medichine_effect/toxfilter
	/// works on the dead
	var/while_dead = FALSE
	/// amount per volume
	var/strength = 0

/datum/medichine_effect/toxfilter/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	#warn impl

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

/datum/medichine_effect/forced_metabolism/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	if(STAT_IS_DEAD(entity.stat) && !while_dead)
		return null
	var/real_rate = scale_rate_constant * seconds + volume * scale_rate_to_volume
	entity.forced_metabolism(real_rate)
	return 1

/datum/medichine_effect/agony_from_open_wounds

	var/strength_constant = 0
	var/strength_factor = 0

/datum/medichine_effect/agony_from_open_wounds/tick_on_mob(datum/component/medichine_field/field, mob/living/entity, volume, seconds)
	var/mob/living/carbon/humanlike = entity
	if(!istype(humanlike))
		return
	for(var/obj/item/organ/external/ext as anything in humanlike.bad_external_organs)
		var/size_ratio = organ_rel_size[ext.organ_tag] / GLOB.organ_combined_size
		if(!size_ratio)
			continue
	#warn impl

// /datum/medichine_effect/stoneskin

// /datum/medichine_effect/stoneskin/tick_on_mob(mob/living/entity, volume)

// /datum/medichine_effect/dextrous_motion

// /datum/medichine_effect/dextrous_motion/tick_on_mob(mob/living/entity, volume)
