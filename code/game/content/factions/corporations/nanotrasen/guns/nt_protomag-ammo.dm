//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/ammo_casing/nt_protomag
	abstract_type = /obj/item/ammo_casing/nt_protomag
	name = "protomag casing"
	desc = "An obnoxiously long casing for some kind of rifle."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/protomag/ammo.dmi'
	icon_state = "slug"
	casing_caliber = /datum/ammo_caliber/nt_protomag
	casing_flags = CASING_DELETE

	/// override strip color
	var/stripe_color

/obj/item/ammo_casing/nt_protomag/Initialize(mapload)
	. = ..()
	var/image/stripe_image = image(icon, "[icon_state]-stripe")
	var/obj/projectile/nt_protomag/casted_projectile = projectile_type
	stripe_image.color = stripe_color || initial(casted_projectile.color)
	add_overlay(stripe_image, TRUE)

/obj/item/ammo_casing/nt_protomag/magboosted
	abstract_type = /obj/item/ammo_casing/nt_protomag/magboosted
	name = "protomag round"
	desc = "A slender bullet. It seems to have less propellant than usual."
	casing_primer = CASING_PRIMER_MAGNETIC | CASING_PRIMER_CHEMICAL
	casing_effective_mass_multiplier = /obj/item/ammo_casing/nt_protomag::casing_effective_mass_multiplier * 0.5

/obj/item/ammo_casing/nt_protomag/magboosted/process_fire(casing_primer)
	var/obj/projectile/nt_protomag/proj_or_firing_status = ..()
	if(!istype(proj_or_firing_status))
		return proj_or_firing_status
	if(!(casing_primer & CASING_PRIMER_MAGNETIC))
		proj_or_firing_status.penalize()
	return proj_or_firing_status

/obj/item/ammo_casing/nt_protomag/magboosted/standard
	projectile_type = /obj/projectile/nt_protomag/standard
	stripe_color = /obj/projectile/nt_protomag/standard::color
	materials_base = list(
		/datum/prototype/material/steel::id = 75,
		/datum/prototype/material/glass::id = 25,
	)

/obj/item/ammo_casing/nt_protomag/magboosted/sabot
	name = "protomag round (sabot)"
	desc = "A slender bullet. While lacking in stopping power, this round is designed to punch through thicker than usual armor."

	projectile_type = /obj/projectile/nt_protomag/sabot
	stripe_color = /obj/projectile/nt_protomag/sabot::color
	materials_base = list(
		/datum/prototype/material/steel::id = 125,
		/datum/prototype/material/glass::id = 25,
	)

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/item/ammo_casing/nt_protomag/magboosted/shredder
// 	name = "protomag round (shredder)"
// 	desc = "A slender bullet. While lacking in penetration, this round is designed to shred soft targets with ease."
//
//	projectile_type = /obj/projectile/nt_protomag/shredder
//	stripe_color = /obj/projectile/nt_protomag/shredder::color

/obj/item/ammo_casing/nt_protomag/magboosted/impact
	name = "protomag round (impact)"
	desc = "A slender bullet. This round is the magnetic equivalent of a beanbag. That said, it would be a bad idea to detain someone with a railgun, beanbag or not."

	projectile_type = /obj/projectile/nt_protomag/impact
	stripe_color = /obj/projectile/nt_protomag/impact::color
	materials_base = list(
		/datum/prototype/material/steel::id = 75,
		/datum/prototype/material/glass::id = 75,
	)

/obj/item/ammo_casing/nt_protomag/magboosted/practice
	name = "protomag round (practice)"
	desc = "A slender bullet. This round is just a practice round. While it is made out of relatively soft materials, you should still try to not get shot by this."

	projectile_type = /obj/projectile/nt_protomag/practice
	stripe_color = /obj/projectile/nt_protomag/practice::color
	materials_base = list(
		/datum/prototype/material/steel::id = 25,
		/datum/prototype/material/glass::id = 12.5,
	)

/obj/item/ammo_casing/nt_protomag/magnetic
	abstract_type = /obj/item/ammo_casing/nt_protomag/magnetic
	name = "protomag slug"
	desc = "A slender ferromagnetic slug. A bullet without propellant, for whatever reason."
	casing_primer = CASING_PRIMER_MAGNETIC

// todo: i refuse to do this until i can make it pretty
// /obj/item/ammo_casing/nt_protomag/magnetic/smoke
// 	name = "protomag slug (smoke)"
// 	desc = "A slender ferromagnetic slug. While lacking in penetration, this round releases a light smokescreen on impact."

// 	projectile_type = /obj/projectile/nt_protomag/smoke
// 	stripe_color = /obj/projectile/nt_protomag/smoke::color

/obj/item/ammo_casing/nt_protomag/magnetic/emp
	name = "protomag slug (emp)"
	desc = "A slender ferromagnetic slug. While lacking in penetration, this round releases a small electromagnetic burst on impact."

	projectile_type = /obj/projectile/nt_protomag/emp
	stripe_color = /obj/projectile/nt_protomag/emp::color
	materials_base = list(
		/datum/prototype/material/steel::id = 25,
		/datum/prototype/material/glass::id = 12.5,
		/datum/prototype/material/uranium::id = 25,
		/datum/prototype/material/silver::id = 25,
	)

// todo: this is currently disabled as simplemobs are not complex-AI enough for us to do this, and we don't need a PVP-only tool
// /obj/item/ammo_casing/nt_protomag/magnetic/concussive
// 	name = "protomag slug (concussive)"
// 	desc = "A slender ferromagnetic slug. While lacking in penetration, this round contains a small airburst charge that detonates on impact."

// 	projectile_type = /obj/projectile/nt_protomag/concussive
//	stripe_color = /obj/projectile/nt_protomag/concussive::color

/obj/item/ammo_casing/nt_protomag/magnetic/penetrator
	name = "protomag slug (penetrator)"
	desc = "A slender ferromagnetic slug. This one is made out of dense alloys, and is designed to punch through materials with ease. This round has very high recoil, as well as power draw."

	projectile_type = /obj/projectile/nt_protomag/penetrator
	stripe_color = /obj/projectile/nt_protomag/penetrator::color
	materials_base = list(
		/datum/prototype/material/steel::id = 25,
		/datum/prototype/material/glass::id = 12.5,
		/datum/prototype/material/uranium::id = 25,
		/datum/prototype/material/diamond::id = 35,
	)

/obj/item/ammo_casing/nt_protomag/magnetic/shock
	name = "protomag slug (shock)"
	desc = "A slender ferromagnetic slug. This one is designed to release a burst of energy on imapct for less-than-lethal takedowns. That said, it would probably still be a bad idea to detain someone with a railgun slug."

	projectile_type = /obj/projectile/nt_protomag/shock
	stripe_color = /obj/projectile/nt_protomag/shock::color
	materials_base = list(
		/datum/prototype/material/steel::id = 25,
		/datum/prototype/material/glass::id = 12.5,
		/datum/prototype/material/silver::id = 25,
		/datum/prototype/material/gold::id = 25,
	)

// todo: flare rounds should illuminate the target and a bit of the surroundings with
//       a weak glow. bright pyrotechnics would not fit into the round.
// /obj/item/ammo_casing/nt_protomag/magnetic/flare
// 	name = "protomag slug (flare)"
// 	desc = "A slender ferromagnetic slug. Shatters into a lingering chemical illuminant on impact."

// 	projectile_type = /obj/projectile/nt_protomag/flare
// 	stripe_color = /obj/projectile/nt_protomag/flare::color

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/item/ammo_casing/nt_protomag/magnetic/incendiary
// 	name = "protomag slug (incendiary)"
// 	desc = "A slender ferromagnetic slug. With almost no penetrating power whatsoever, this round is designed to explode into an incendiary material on impact"

// 	projectile_type = /obj/projectile/nt_protomag/incendiary
//	stripe_color = /obj/projectile/nt_protomag/incendiary::color

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/item/ammo_casing/nt_protomag/magnetic/reagent
// 	name = "protomag slug (chemical)"
// 	desc = "A slender ferromagnetic slug. Can be laced with a small amount of reagents, which will then splash onto and be injected into a hit target."

// 	projectile_type = /obj/projectile/nt_protomag/reagent
//	stripe_color = /obj/projectile/nt_protomag/reagent::color
