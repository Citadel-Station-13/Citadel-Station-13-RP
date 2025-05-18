//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Glove-worn gauntlets usable for punching rock, creatures, objects, and people alike.
 */
/obj/item/kinetic_gauntlets
	name = "proto-kinetic gauntlets"
	icon = 'icons/modules/mining/tools/kinetic/kinetic_gauntlets.dmi'
	icon_state = "normal"
	base_icon_state = "normal"

	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = WEIGHT_VOLUME_SMALL
	slot_flags = SLOT_GLOVES

	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

	var/charged = FALSE
	// TODO: scale this by multiplying a define for 'standard melee attack speed'
	var/charge_delay = 1.8 SECONDS
	var/charge_timerid
	var/charge_sound = 'sound/weapons/kenetic_reload.ogg'

	/// recharge speed mult when breaking rock
	var/charge_delay_multiplier_rock = (1 / 2)
	/// recharge speed mult when breaking structures
	var/charge_delay_multiplier_structure = 1
	/// recharge speed mult on basic non-combo attack
	var/charge_delay_multiplier_basic = 1
	/// recharge speed mult on successful combo
	var/charge_delay_multiplier_combo = (1 / 2)

	/// our combo tracker
	///
	/// * WARNING, WARNING *
	///   DO NOT COPYPASTE THIS CODE ELSEWHERE
	///   IF YOU NEED MELEE COMBOS, FIGURE OUT A GENERIC WAY TO ATTACH THEM
	///   TO ITEMS. DO NOT COPYPASTE THIS CODE AROUND, THE HOOKING CODE
	///   IS COMPLEX AND SHOULD NOT BE UNNECESSARILY DUPLICATED.
	var/datum/combo_tracker/melee/intent_based/combo_tracker
	/// our combo set
	var/datum/combo_set/melee/combo_set
	/// only reapplied on un-equip/re-equip right now!
	var/combo_continuation_timeout = 3 SECONDS
	/// our combo is active; we won't go onto clickdelay until it falls off
	var/combo_continuation_active = FALSE
	/// multiplier to clickdelay on successful continuation
	var/combo_continuation_speedmod = 2 / 3
	/// sound to play on combo continuation
	var/combo_continuation_sfx =  'sound/weapons/resonator_blast.ogg'
	var/combo_continuation_damage = 5
	var/combo_continuation_damage_tier = 3
	var/combo_continuation_damage_type = DAMAGE_TYPE_BRUTE
	var/combo_continuation_damage_flag = ARMOR_BOMB
	var/combo_continuation_damage_mode = DAMAGE_MODE_ABLATING

	/// sound to play on combo fail
	var/combo_fail_sfx = /datum/soundbyte/sparks

	var/charged_structure_damage = 23.5
	var/charged_structure_damage_tier = 3
	var/charged_structure_damage_type = DAMAGE_TYPE_BRUTE
	var/charged_structure_damage_flag = ARMOR_BOMB
	var/charged_structure_damage_mode = DAMAGE_MODE_ABLATING
	var/charged_structure_sfx = 'sound/weapons/kenetic_accel.ogg'

	var/charged_mob_damage = 13.5
	var/charged_mob_damage_tier = 3
	var/charged_mob_damage_type = DAMAGE_TYPE_BRUTE
	var/charged_mob_damage_flag = ARMOR_BOMB
	var/charged_mob_damage_mode = DAMAGE_MODE_ABLATING
	var/charged_mob_sfx = 'sound/weapons/resonator_blast.ogg'

/obj/item/kinetic_gauntlets/Initialize(mapload)
	. = ..()
	discharge()
	if(!combo_set)
		// TODO: global caching of combo sets
		combo_set = new /datum/combo_set/melee/intent_based/kinetic_gauntlets

/obj/item/kinetic_gauntlets/update_icon()
	cut_overlays()
	. = ..()
	icon_state = "[base_icon_state]"
	worn_state = "[base_icon_state][charged ? "" : "-empty"]"
	if(!charged)
		add_overlay("[base_icon_state]-empty")
	update_worn_icon()

/obj/item/kinetic_gauntlets/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	if(slot != /datum/inventory_slot/inventory/gloves::id)
		return ..()
	if(istype(I, /obj/item/clothing/gloves/gauntlets))
		return ..()
	return TRUE

/obj/item/kinetic_gauntlets/examine_query_usage_hints(datum/event_args/examine/examining)
	. = ..()
	. += "Punching a rock wall on <b>harm intent</b>, while charged, will try to mine it with the gauntlets."
	. += "Punching a mob on <b>harm intent</b>, while charged, will apply additional damage and stagger it."
	. += "Punching a mob with a kinetic destabilization field on <b>harm intent</b>, while charged, will detonate the field."

/obj/item/kinetic_gauntlets/examine_query_stat_hints(datum/event_args/examine/examining)
	. = ..()
	.["Charge Delay (Base)"] = charge_delay

/obj/item/kinetic_gauntlets/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	.["toggle-fingerless"] = create_context_menu_tuple("Toggle Finger Caps", image(src), null, MOBILITY_CAN_USE, FALSE)

/obj/item/kinetic_gauntlets/context_menu_act(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return

/obj/item/kinetic_gauntlets/on_inv_equipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	if(slot_id_or_index != /datum/inventory_slot/inventory/gloves::id)
		return
	start_recharge()
	if(!combo_tracker)
		combo_tracker = new(combo_continuation_timeout)
		combo_tracker.on_continuation_begin = CALLBACK(src, PROC_REF(on_continuation_begin))
		combo_tracker.on_continuation_end = CALLBACK(src, PROC_REF(on_continuation_end))
	RegisterSignal(wearer, COMSIG_MOB_MELEE_INTENTFUL_HOOK, PROC_REF(on_user_melee_intent))
	RegisterSignal(wearer, COMSIG_MOB_MELEE_IMPACT_HOOK, PROC_REF(on_user_melee_impact))

/obj/item/kinetic_gauntlets/on_inv_unequipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	discharge()
	QDEL_NULL(combo_tracker)
	UnregisterSignal(wearer, COMSIG_MOB_MELEE_INTENTFUL_HOOK)
	UnregisterSignal(wearer, COMSIG_MOB_MELEE_IMPACT_HOOK)

/obj/item/kinetic_gauntlets/proc/on_continuation_begin()
	SHOULD_NOT_SLEEP(TRUE)
	combo_continuation_active = TRUE

/obj/item/kinetic_gauntlets/proc/on_continuation_end(list/stored_keys, timed_out)
	SHOULD_NOT_SLEEP(TRUE)
	discharge()
	combo_continuation_active = FALSE

/obj/item/kinetic_gauntlets/proc/recharge()
	charged = TRUE
	charge_timerid = null
	playsound(src, charge_sound, 50, TRUE)
	update_icon()

/**
 * Aborts charge cycle if it exists, and starts a new one.
 */
/obj/item/kinetic_gauntlets/proc/discharge(recharge_delay_mod = 1)
	charged = FALSE
	cancel_recharge()
	start_recharge(recharge_delay_mod)
	update_icon()

/**
 * Cancels recharge.
 */
/obj/item/kinetic_gauntlets/proc/cancel_recharge()
	if(charge_timerid)
		deltimer(charge_timerid)
		charge_timerid = null

/**
 * Will speed up current recharge cycle to be as fast as the requested
 * speed if it's not at least that fast.
 */
/obj/item/kinetic_gauntlets/proc/start_recharge(delay_mod = 1)
	if(worn_slot != /datum/inventory_slot/inventory/gloves::id)
		cancel_recharge()
		return
	var/charge_time = charge_delay * delay_mod
	if(charge_timerid)
		var/charge_timeleft = timeleft(charge_timerid)
		if(charge_timeleft >= charge_time)
			return
		deltimer(charge_timerid)
	charge_timerid = addtimer(CALLBACK(src, PROC_REF(recharge)), charge_time, TIMER_STOPPABLE)

/obj/item/kinetic_gauntlets/proc/run_excavation_fx(turf/location)
	new /obj/effect/temp_visual/kinetic_blast(location)
	playsound(location, 'sound/weapons/resonator_blast.ogg', 65, TRUE)

// TODO: this doesn't take into account missing as it's hooked in too high up on the clickchain.
//       we need to investigate how to make a generic attack roll system at some point.
/obj/item/kinetic_gauntlets/proc/on_user_melee_intent(datum/source, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SIGNAL_HANDLER
	if(!combo_tracker)
		return NONE
	if(!ismob(clickchain.target))
		return NONE
	var/mob/mob_target = clickchain.target
	// requires mark to be using combo, otherwise you can hit it twice and mark it then hit again
	var/datum/status_effect/grouped/proto_kinetic_mark/mark = mob_target.has_status_effect(/datum/status_effect/grouped/proto_kinetic_mark)
	if(!mark)
		return NONE
	var/inbound_key = clickchain.using_intent
	var/datum/combo/melee/executing_combo = combo_tracker.process_inbound(inbound_key, combo_set)
	if(!executing_combo)
		if(!length(combo_tracker.combo_possible))
			// failed
			execute_combo_fail(clickchain, clickchain_flags, combo_tracker, inbound_key)
			QDEL_NULL(mark)
		else
			// currently continuing
			execute_combo_step(clickchain, clickchain_flags, combo_tracker, inbound_key)
			clickchain.click_cooldown_multiplier *= combo_continuation_speedmod
		return RAISE_MOB_MELEE_INTENTFUL_ACTION | RAISE_MOB_MELEE_INTENTFUL_SKIP
	execute_combo(clickchain, clickchain_flags, executing_combo)
	QDEL_NULL(mark)
	discharge(charge_delay_multiplier_combo)
	return RAISE_MOB_MELEE_INTENTFUL_ACTION | RAISE_MOB_MELEE_INTENTFUL_SKIP

/obj/item/kinetic_gauntlets/proc/on_user_melee_impact(datum/source, list/melee_args)
	SIGNAL_HANDLER
	var/datum/event_args/actor/clickchain/clickchain = melee_args[CLICKCHAIN_MELEE_ATTACK_ARG_CLICKCHAIN]
	var/clickchain_flags = melee_args[CLICKCHAIN_MELEE_ATTACK_ARG_CLICKCHAIN_FLAGS]
	if(clickchain_flags & CLICKCHAIN_ATTACK_MISSED)
		return NONE
	if(!charged)
		return NONE
	var/atom/target = clickchain.target
	clickchain.performer.animate_swing_at_target(clickchain.target)
	clickchain.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[clickchain.performer] slams [target] with a kinetic blow from their gauntlets."),
		audible = SPAN_WARNING("You hear a detonation from a proto-kinetic impact."),
	)
	target.animate_hit_by_attack(ATTACK_ANIMATION_SMASH)
	if(istype(target, /turf/simulated/mineral))
		// TODO: unified mining excavation API
		var/turf/simulated/mineral/mineral_target = target
		mineral_target.GetDrilled(TRUE)
		discharge(charge_delay_multiplier_rock)
		if(charged_structure_sfx)
			playsound(src, charged_structure_sfx, 60, TRUE)
		return RAISE_MOB_MELEE_IMPACT_SKIP
	if(!ismob(target))
		var/atom/atom_target = target
		clickchain.data[ACTOR_DATA_KINETIC_IMPACT_LOG] = atom_target.run_damage_instance(
			charged_structure_damage,
			charged_structure_damage_type,
			charged_structure_damage_tier,
			charged_structure_damage_flag,
			charged_structure_damage_mode,
			attack_type = ATTACK_TYPE_MELEE,
			attack_source = clickchain,
			hit_zone = clickchain.target_zone,
		)
		discharge(charge_delay_multiplier_structure)
		if(charged_structure_sfx)
			playsound(src, charged_structure_sfx, 60, TRUE)
	else
		var/mob/mob_target = target
		clickchain.data[ACTOR_DATA_KINETIC_IMPACT_LOG] = mob_target.run_damage_instance(
			charged_mob_damage,
			charged_mob_damage_type,
			charged_mob_damage_tier,
			charged_mob_damage_flag,
			charged_mob_damage_mode,
			attack_type = ATTACK_TYPE_MELEE,
			attack_source = clickchain,
			hit_zone = clickchain.target_zone,
		)
		discharge(charge_delay_multiplier_basic)
		if(charged_mob_sfx)
			playsound(src, charged_mob_sfx, 60, TRUE)
	return RAISE_MOB_MELEE_IMPACT_SKIP

/obj/item/kinetic_gauntlets/proc/execute_combo(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/combo/melee/use_combo)
	var/atom/movable/target = clickchain.target
	use_combo.inflict(target, clickchain.target_zone, clickchain.performer, clickchain, FALSE)

/obj/item/kinetic_gauntlets/proc/execute_combo_step(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/combo_tracker/tracker, inbound_key)
	playsound(src, combo_continuation_sfx, 75, TRUE)
	clickchain.visible_feedback(
		target = clickchain.target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[clickchain.performer] strikes [clickchain.target] with a resonating blast!"),
		audible = SPAN_WARNING("You hear a resonating crack of metal against some kind of energy field."),
	)
	clickchain.performer.animate_swing_at_target(clickchain.target)
	clickchain.target?.animate_hit_by_attack(ATTACK_ANIMATION_DISARM)
	clickchain.target?.run_damage_instance(
		combo_continuation_damage,
		combo_continuation_damage_type,
		combo_continuation_damage_tier,
		combo_continuation_damage_flag,
		combo_continuation_damage_mode,
		attack_type = ATTACK_TYPE_MELEE,
		attack_source = clickchain,
		hit_zone = clickchain.target_zone,
	)

/obj/item/kinetic_gauntlets/proc/execute_combo_fail(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/combo_tracker/tracker, inbound_key)
	playsound(src, combo_fail_sfx, 75, TRUE)
	clickchain.performer.animate_swing_at_target(clickchain.target)
	clickchain.target?.animate_hit_by_attack(ATTACK_ANIMATION_DISARM)
	clickchain.visible_feedback(
		target = clickchain.target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[clickchain.performer] clumsily slaps [clickchain.target], collapsing their kinetic resonance field!"),
		audible = SPAN_WARNING("You hear an energy field fizzling out."),
	)
