//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/design/generated/gun_component
	abstract_type = /datum/prototype/design/generated/gun_component
	category = DESIGN_CATEGORY_MODGUN

/datum/prototype/design/generated/gun_component/generate_name(template)
	return ..("modular gun component - [template]")

/**
 * A component used in guns with modular parts.
 *
 * * This is **not** an attachment system. This is for things integral to gun operation.
 */
/obj/item/gun_component
	name = "gun component"
	desc = "A thing, that probably goes in a gun. Why are you seeing this?"
	icon_state = "stock"

	/// component slot
	///
	/// * This is just a suggestion.
	/// * The actual APIs used are agnostic of this value.
	var/component_slot
	/// Conflict flags
	///
	/// * This is done with hard enforcement.
	var/component_conflict = NONE
	/// Component type.
	///
	/// * Two of the same component will never be allowed to be put on the same gun.
	/// * This defaults to the gun's typepath if unset.
	var/component_type


	/// should we be hidden from examine?
	var/show_on_examine = TRUE
	/// automatically hook firing iteration pre-fire? will call on_firing_cycle_iteration(cycle) if hooked.
	var/hook_iteration_pre_fire = FALSE
	/// automatically hook projectile injection? will call on_projectile_injection(cycle, projectile) if hooked.
	var/hook_projectile_injection = FALSE

	/// The gun we are installed in.
	var/obj/item/gun/installed
	/// Can we be removed? If this is FALSE, we won't even show in menus.
	var/can_remove = TRUE

/obj/item/gun_component/examine(mob/user, dist)
	. = ..()
	var/list/summarized = summarize_bullet_points()
	if(!length(summarized))
		return
	for(var/string in summarized)
		. += "<li>[string]</li>"

//* Attach / Detach *//

/**
 * returns if we should fit on a gun
 *
 * * we get the final say
 * * this includes if the gun is already overcrowded! be careful with this
 *
 * @params
 * * gun - the gun we tried to attach to
 * * gun_opinion - what the gun had to say about it
 * * gun_is_full - is the gun out of slots for us? we can still override but this is to separate it from gun_opinion.
 * * actor - person initiating it; this is mostly for message feedback
 * * silent - do not emit message to user on fail
 */
/obj/item/gun_component/proc/fits_on_gun(obj/item/gun/gun, gun_opinion, gun_is_full, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * called on attach
 */
/obj/item/gun_component/proc/on_install(obj/item/gun/gun, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(hook_iteration_pre_fire)
		RegisterSignal(gun, COMSIG_GUN_FIRING_PREFIRE, PROC_REF(on_firing_cycle_iteration))
	if(hook_projectile_injection)
		RegisterSignal(gun, COMSIG_GUN_FIRING_PROJECTILE_INJECTION, PROC_REF(on_projectile_injection))

/**
 * called on detach
 */
/obj/item/gun_component/proc/on_uninstall(obj/item/gun/gun, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(hook_iteration_pre_fire)
		UnregisterSignal(gun, COMSIG_GUN_FIRING_PREFIRE)
	if(hook_projectile_injection)
		UnregisterSignal(gun, COMSIG_GUN_FIRING_PROJECTILE_INJECTION)

//* Gun API - Hooks *//

/**
 * Called right before fire() is invoked, if [hook_iteration_pre_fire] is set.
 */
/obj/item/gun_component/proc/on_firing_cycle_iteration(datum/gun_firing_cycle/cycle)
	return

/**
 * Called right before the projectile itself is fire()'d, if [hook_projectile_injection] is set.
 *
 * * This is relatively low level compared to firing cycle iteration, and can be used to
 *   modify the projectile.
 */
/obj/item/gun_component/proc/on_projectile_injection(datum/gun_firing_cycle/cycle, obj/projectile/proj)
	return

//* Gun API - Actions *//

/obj/item/gun_component/proc/use_power(energy)
	return installed.modular_use_power(src, energy)

/obj/item/gun_component/proc/use_checked_power(energy, reserve)
	return installed.modular_use_checked_power(src, energy, reserve)

//* Information *//

/**
 * Called to query the stat bullet points of this component
 *
 * @params
 * * actor - (optional) actor data
 *
 * @return a list of data about us to put in bullet points, in raw HTML
 */
/obj/item/gun_component/proc/summarize_bullet_points(datum/event_args/actor/actor)
	return list()

/**
 * Called to return our examine name injection.
 */
/obj/item/gun_component/proc/get_examine_fragment()
	// todo: render as icon & name
	var/use_name = name
	var/list/summarized = summarize_bullet_points()
	if(!length(summarized))
		return SPAN_TOOLTIP(desc, use_name)
	var/list/transformed = list()
	for(var/string in summarized)
		transformed += "<li>[string]</li>"
	var/use_tooltip = {"
		[desc]
		[jointext(transformed, "")]
	"}
	return SPAN_TOOLTIP(use_tooltip, use_name)
