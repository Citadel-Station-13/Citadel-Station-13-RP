//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy/nt_isd
	abstract_type = /datum/firemode/energy/nt_isd

/**
 * Weapons for NT's Internal Security.
 *
 * * Above-average energy weapons
 * * Expensive
 * * Joint with Hephaestus / Vey-Med, canonically
 * * There's probably a neat amount of these just floating around the Frontier now from losses.
 *
 * Things to keep in mind:
 *
 * * Stun does not mean something is cheap as, or cheaper than, lethal.
 * * Stun in this codebase is not treated as any special or even preferable damage type.
 * * Nanotrasen uses stun weaponry for arrests, but in-canon security is rarely having to
 *   use physical and ranged force against other employees.
 * * Stun weapons should generally be worse at stunning than lethal modes of that weapon
 *   are at downing someone who is armored.
 */
/obj/item/gun/projectile/energy/nt_isd
	abstract_type = /obj/item/gun/projectile/energy/nt_isd

//* Energy Sidearm *//

/datum/firemode/energy/nt_isd/sidearm
	abstract_type = /datum/firemode/energy/nt_isd/sidearm

/datum/firemode/energy/nt_isd/sidearm/stun
	name = "disrupt"
	render_color = "#ffff00"
	charge_cost = 2400 / 8
	projectile_type = /obj/projectile/nt_isd/electrode

/datum/firemode/energy/nt_isd/sidearm/disable
	name = "disable"
	render_color = "#77ffff"
	charge_cost = 2400 / 20
	projectile_type = /obj/projectile/nt_isd/disable

/datum/firemode/energy/nt_isd/sidearm/lethal
	name = "kill"
	render_color = "#ff0000"
	charge_cost = 2400 / 12
	projectile_type = /obj/projectile/nt_isd/laser/sidearm
	considered_lethal = TRUE

/obj/item/gun/projectile/energy/nt_isd/sidearm
	name = "hybrid taser"
	desc = "A versatile energy sidearm used by corporate security."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/isd/sidearm.dmi'
	icon_state = "sidearm"
	base_icon_state = "sidearm"
	worn_render_flags = NONE
	description_fluff = {"
		A sidearm designed and manufactured by the Nanotrasen Research Division for its internal
		security needs. Specialized in non-lethal takedowns of high-risk perpetrators, the ENP-17
		is reminiscent of older electro-neural disruption devices used by less advanced societies in
		how it operates.

		After an increase in the presence of non-humanoid threats against Nanotrasen's operations in the
		Frontier, this standard sidearm received an upgrade adding a more powerful focusing lens used for
		a lethal setting that can be used in emergencies.
	"}
	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_isd/sidearm/stun,
		/datum/firemode/energy/nt_isd/sidearm/disable,
		/datum/firemode/energy/nt_isd/sidearm/lethal,
	)
	item_renderer = /datum/gun_item_renderer/segments{
		count = 4;
		offset_x = 2;
		independent_colored_firemode = TRUE;
		use_color = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_single = TRUE;
		use_color = TRUE;
		use_empty = TRUE;
	}
	attachment_alignment = list(
		GUN_ATTACHMENT_SLOT_SIDEBARREL = list(
			28,
			14,
		)
	)

/obj/item/gun/projectile/energy/nt_isd/sidearm/with_light
	attachments = list(
		/obj/item/gun_attachment/flashlight/maglight,
	)

//* Energy Carbine *//

/datum/firemode/energy/nt_isd/carbine
	abstract_type = /datum/firemode/energy/nt_isd/carbine

/datum/firemode/energy/nt_isd/carbine/disable
	name = "disable"
	render_color = "#77ffff"
	charge_cost = 2400 / 20
	projectile_type = /obj/projectile/nt_isd/disable

/datum/firemode/energy/nt_isd/carbine/shock
	name = "shock"
	render_color = "#ffff00"
	charge_cost = 2400 / 10
	projectile_type = /obj/projectile/nt_isd/shock
	considered_lethal = TRUE

/datum/firemode/energy/nt_isd/carbine/kill
	name = "kill"
	render_color = "#ff0000"
	charge_cost = 2400 / 12
	projectile_type = /obj/projectile/nt_isd/laser/rifle
	considered_lethal = TRUE
	cycle_cooldown = 0.45 SECONDS

/obj/item/gun/projectile/energy/nt_isd/carbine
	name = "energy carbine"
	desc = "A versatile energy carbine often seen in the hands of frontier groups."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/isd/carbine.dmi'
	icon_state = "carbine"
	base_icon_state = "carbine"
	worn_render_flags = NONE
	description_fluff = {"
		A production model energy weapon developed in joint between the Nanotrasen Research Division
		and Hephaestus Industries. Containing multiple focusing modes for its integrated particle
		projector, the weapon has quickly proliferated to be a common sight on the Frontier.

		An unfortunate consequence of this has been the equal proliferation of protective gear meant to
		counteract this weapon's capabilities - with many threat-actors and even certain strains of lifeforms
		developing augmented resistance to the weapon's stun settings - much to Nanotrasen's displeasure.
		While Nanotrasen has many times attempted to replace this weapon's place in the staples of its
		security divisions, all attempts to date have thus far fell short.
	"}
	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_isd/carbine/disable,
		/datum/firemode/energy/nt_isd/carbine/shock,
		/datum/firemode/energy/nt_isd/carbine/kill,
	)
	item_renderer = /datum/gun_item_renderer/segments{
		count = 4;
		offset_x = 3;
		independent_colored_firemode = TRUE;
		use_color = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_single = TRUE;
		use_color = TRUE;
		use_empty = TRUE;
	}

//* Energy Lance *//

/datum/firemode/energy/nt_isd/lance
	abstract_type = /datum/firemode/energy/nt_isd/lance

/datum/firemode/energy/nt_isd/lance/kill
	name = "kill"
	render_color = "#00ff00"
	charge_cost = 2400 / 15
	projectile_type = /obj/projectile/nt_isd/laser/lance

/obj/item/gun/projectile/energy/nt_isd/lance
	name = "energy lance"
	desc = "A particle rifle used by corporate security. Shoots focused particle beams."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/isd/lance.dmi'
	icon_state = "lance"
	base_icon_state = "lance"
	worn_render_flags = NONE
	description_fluff = {"
		Developed and used primarily by the Nanotrasen Research Division, the ENR-18 was
		designed to be a specialized anti-armour weapon supplied to response teams and sparingly
		stocked on installations operating in the most high-risk sectors.

		Unfortunately, the march of modern technology and weaponry has forced the Research Division
		to proliferate this weapon to many more of Nanotrasen's holdings due to the low, but
		non-negligible risk of an incursion resistant to the standard Hephaestus weaponry used
		at the time by Nanotrasen's internal security.
	"}
	w_class = WEIGHT_CLASS_BULKY
	firemodes = list(
		/datum/firemode/energy/nt_isd/lance/kill,
	)
	item_renderer = /datum/gun_item_renderer/segments{
		offset_x = 3
		count = 4;
		use_color = TRUE;
		independent_colored_firemode = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		count = 4;
		use_empty = TRUE;
	}

//* Multiphase Sidearm *//

/datum/firemode/energy/nt_isd/multiphase

/datum/firemode/energy/nt_isd/multiphase/disable
	name = "disable"
	render_color = "#77ffff"
	projectile_type = /obj/projectile/nt_isd/disable
	charge_cost = 2400 / 20

/datum/firemode/energy/nt_isd/multiphase/kill
	name = "kill"
	render_color = "#ff0000"
	projectile_type = /obj/projectile/nt_isd/laser/multiphase
	charge_cost = 2400 / 12
	considered_lethal = TRUE
	cycle_cooldown = 0.6 SECONDS

// todo: this is an ion beam, not an EMP pulse
/datum/firemode/energy/nt_isd/multiphase/ion
	name = "ion"
	render_color = "#45a3aa"
	projectile_type = /obj/projectile/nt_isd/ion
	charge_cost = 2400 / 6
	considered_lethal = TRUE
	cycle_cooldown = 0.8 SECONDS

/obj/item/gun/projectile/energy/nt_isd/multiphase
	name = "multiphase sidearm"
	desc = "A prototype sidearm for high-ranking corporate security."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/isd/multiphase.dmi'
	icon_state = "multiphase"
	base_icon_state = "multiphase"
	worn_render_flags = NONE
	description_fluff = {"
		A very expensive development of the Nanotrasen Research Division, the ENP-19 is
		a durable sidearm manufactured for usage by the leaders of many internal security teams.
		Containing a particle generation system closer to those used in Nanotrasen's secretive
		pulse rifles than that of common Frontier energy eaponry, this weapon can be used in a variety
		of scenarios.
	"}
	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_isd/multiphase/disable,
		/datum/firemode/energy/nt_isd/multiphase/kill,
		/datum/firemode/energy/nt_isd/multiphase/ion,
	)
	item_renderer = /datum/gun_item_renderer/segments{
		offset_x = 4
		count = 4;
		use_color = TRUE;
		independent_colored_firemode = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_color = TRUE;
		use_empty = TRUE;
		use_single = TRUE;
	}

//* Projectiles *//

/obj/projectile/nt_isd
	abstract_type = /obj/projectile/nt_isd
	icon = 'icons/modules/projectiles/projectile.dmi'
	tracer_icon = 'icons/modules/projectiles/projectile-tracer.dmi'
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY

/obj/projectile/nt_isd/laser
	abstract_type = /obj/projectile/nt_isd/laser
	pass_flags = ATOM_PASS_FLAGS_BEAM
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER
	hitscan = TRUE
	color = "#ff1100"
	tracer_icon_state = "laser-1"
	tracer_add_state = TRUE
	tracer_add_state_alpha = 65
	auto_emissive_strength = 192
	fire_sound = /datum/soundbyte/guns/energy/laser_1
	eyeblur = 2
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_PHOTONIC

/obj/projectile/nt_isd/laser/rifle
	name = "laser"
	damage_force = 35
	damage_tier = 4

/obj/projectile/nt_isd/laser/sidearm
	name = "phaser blast"
	damage_force = 20
	damage_tier = 4
	fire_sound = /datum/soundbyte/guns/energy/laser_3/pistol

/obj/projectile/nt_isd/laser/multiphase
	name = "focused laser"
	damage_force = 35
	damage_tier = 4.75
	fire_sound = /datum/soundbyte/guns/energy/laser_3/rifle

/obj/projectile/nt_isd/laser/lance
	name = "particle beam"
	color = "#00ff00"
	damage_force = 35
	damage_tier = 5
	fire_sound = /datum/soundbyte/guns/energy/laser_2

/obj/projectile/nt_isd/shock
	name = "energy beam"
	color = "#ffff94"
	tracer_icon_state = "discharge-1"
	tracer_add_state = TRUE
	tracer_add_state_alpha = 65
	auto_emissive_strength = 192
	hitscan = TRUE
	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_energy = 50;
			shock_damage = 7.5;
			shock_agony = 32.5;
			shock_flags = ELECTROCUTE_ACT_FLAG_DISTRIBUTE;
		}
	)
	fire_sound = /datum/soundbyte/guns/energy/taser_2
	impact_sound = /datum/soundbyte/guns/energy/taser_hit
	projectile_type = PROJECTILE_TYPE_BEAM

/obj/projectile/nt_isd/electrode
	name = "stun bolt"
	color = "#ffff00"
	icon_state = "discharge-1"
	base_projectile_effects = list(
		/datum/projectile_effect/electrical_probe{
			status_effect_path = /datum/status_effect/taser_stun/nt_isd;
			status_effect_duration = 3 SECONDS;
		}
	)
	fire_sound = /datum/soundbyte/guns/energy/taser_1
	impact_sound = /datum/soundbyte/guns/energy/taser_hit
	auto_emissive_strength = 192
	projectile_type = PROJECTILE_TYPE_ENERGY

/obj/projectile/nt_isd/disable
	name = "disabler beam"
	color = "#00ffff"
	tracer_icon_state = "laser-1"
	tracer_add_state = TRUE
	tracer_add_state_alpha = 65
	auto_emissive_strength = 192
	hitscan = TRUE
	damage_flag = ARMOR_ENERGY
	damage_force = 20
	damage_type = DAMAGE_TYPE_HALLOSS
	fire_sound = /datum/soundbyte/guns/energy/disabler_1
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_PHOTONIC

// todo: this shouldn't be an emp, this should be like synthetik's
/obj/projectile/nt_isd/ion
	name = "ion beam"
	icon_state = "particle-1"
	base_projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_2 = 1;
			sev_3 = 2;
		},
	)
	color = "#0048ff"
	fire_sound = /datum/soundbyte/guns/energy/ion_pulse
	auto_emissive_strength = 192
	projectile_type = PROJECTILE_TYPE_ENERGY
