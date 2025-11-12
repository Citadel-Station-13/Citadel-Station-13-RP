//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * mortar rounds; uses ammo system
 */
/obj/item/ammo_casing/mortar
	name = "mortar shell"
	desc = "A shell that presumably goes into a mortar."
	icon = 'icons/modules/sectors/air_support/mortar_shell.dmi'
	icon_state = "shell"

	casing_caliber = /datum/ammo_caliber/mortar
	projectile_type = /obj/projectile/mortar

	/// sound to play pre-impact
	var/pre_impact_sound = 'sound/modules/sectors/air_support/mortar_travel.ogg'
	/// volume to play pre-impact
	/// * this will be modulated by impact distance
	var/pre_impact_volume = 75
	/// full volume range
	var/pre_impact_volume_inner_radius = 4
	/// no volume range
	var/pre_impact_volume_outer_radius = 16
	/// pre-impact sound duration
	var/pre_impact_sound_duration = 4 SECONDS
	/// when to play pre impact
	/// * will not lengthen pre impact sound too much; will stretch/squeeze as needed.
	var/pre_impact_sound_telegraph = 5 SECONDS

	/// standard stripe color, if any
	var/apply_stripe_color
	/// force stripe state
	var/apply_stripe_state

	/// mortar effects list, set to typepaths to init
	/// * THIS IS A TYPELIST, DO NOT MODIFY AT RUNTIME
	var/list/datum/mortar_effect/mortar_effects
	var/list/datum/mortar_effect/mortar_effects_additional

/obj/item/ammo_casing/mortar/Initialize(mapload)
	. = ..()
	#warn resolve mortar effects

/obj/item/ammo_casing/mortar/update_icon()
	cut_overlays()
	. = ..()

	if(apply_stripe_color)
		var/image/stripe = image(icon, "[apply_stripe_state || base_icon_state || icon_state]-stripe")
		stripe.color = apply_stripe_color
		add_overlay(stripe)

/**
 * play pre-impact sound
 */
/obj/item/ammo_casing/mortar/proc/whzhzhhzhh(turf/epicenter)
	if(!pre_impact_sound)
		return
	#warn impl

/**
 * * This should never delete self.
 *
 * @params
 * * epicenter - where we hit
 */
/obj/item/ammo_casing/mortar/proc/on_detonate(turf/epicenter)
	var/list/datum/mortar_effect/effects = resolve_mortar_effects()
	for(var/datum/mortar_effect/effect as anything in effects)
		effect.on_detonate(epicenter)

/**
 * @return /datum/mortar_effect instance list; DO NOT MUTATE RETURNED LIST OR CONTENTS.
 */
/obj/item/ammo_casing/mortar/proc/resolve_mortar_effects() as /list
	if(mortar_effects_additional)
		. = (mortar_effects?.Copy() || list()) + mortar_effects_additional
	else
		. = mortar_effects

/obj/item/ammo_casing/mortar/standard
	casing_caliber = /datum/ammo_caliber/mortar

/obj/item/ammo_casing/mortar/standard/high_explosive
	mortar_effects = list(
		/datum/mortar_effect/legacy_explosion{
			sev_1 = 1;
			sev_2 = 4;
			sev_3 = 7;
		},
	)
	apply_stripe_color = "#ff0000"

/obj/item/ammo_casing/mortar/standard/emp
	mortar_effects = list(
		/datum/mortar_effect/legacy_emp{
			sev_1 = 3;
			sev_2 = 6;
			sev_3 = 9;
			sev_4 = 12;
		},
	)
	apply_stripe_color = "#00ffff"

/obj/item/ammo_casing/mortar/standard/shrapnel
	mortar_effects = list(
		/datum/mortar_effect/legacy_explosion{
			sev_2 = 1;
			sev_3 = 3;
		},
		/datum/mortar_effect/shrapnel{
			pellet_count = 55;
			pellet_type = /obj/projectile/bullet/pellet/fragment/strong;
		},
	)
	apply_stripe_color = "#444444"

// TODO: better fire sim
// /obj/item/ammo_casing/mortar/standard/incendiary
