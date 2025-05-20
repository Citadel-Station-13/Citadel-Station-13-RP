// These hivebots are intended for general damage causing, at range.

/mob/living/simple_mob/mechanical/hivebot/ranged_damage
	name = "ranged hivebot"
	desc = "A hivebot with a makeshift integrated ballistic weapon."
	icon_state = "ranged"
	icon_living = "ranged"
	maxHealth = 2 LASERS_TO_KILL // 60 health
	health = 2 LASERS_TO_KILL
	projectiletype = /obj/projectile/bullet/hivebot
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/ranged)


// This one shoots quickly, and is considerably more dangerous.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid
	name = "gunner hivebot"
	desc = "A hive with a fast firing but crude magentic weapon."
	base_attack_cooldown = 5 // Two attacks a second or so.
	player_msg = "You have a <b>rapid fire attack</b>."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/rapid)

/mob/living/simple_mob/mechanical/hivebot/ranged_damage/coil
	name = "piercer hivebot"
	desc = "A hivebot with a powerful flecette launcher."
	icon_state = "coil"
	icon_living = "coil"
	projectilesound = 'sound/weapons/railgun.ogg'
	projectiletype = /obj/projectile/bullet/magnetic/flechette
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/coil)

// Shoots deadly lasers.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser
	name = "laser hivebot"
	desc = "A hivebot equipped with a laser weapon."
	icon_state = "laser"
	icon_living = "laser"
	projectiletype = /obj/projectile/beam/blue
	projectilesound = 'sound/weapons/Laser.ogg'
	player_msg = "You have a <b>laser attack</b>."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/laser)

// Shoots EMPs, to screw over other robots.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion
	name = "ionic hivebot"
	desc = "A hivebot with an electromagnetic pulse projector."
	icon_state = "ion"
	icon_living = "ion"
	projectiletype = /obj/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'
	player_msg = "You have a <b>ranged ion attack</b>, which is very strong against other synthetics.<br>\
	Be careful to not hit yourself or your team, as it will affect you as well."

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/ion)

// Beefy and ranged.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong
	name = "reinforced hivebot"
	desc = "A hivebot with a crude ballistic weapon and strong armor."
	maxHealth = 4 LASERS_TO_KILL // 120 health.
	health = 4 LASERS_TO_KILL
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 15
	base_attack_cooldown = 5

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/strong)


// Inflicts a damage-over-time modifier on things it hits.
// It is able to stack with repeated attacks.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/dot
	name = "ember hivebot"
	desc = "A hivebot that appears to utilize a primitive incediary weapon."
	icon_state = "ember"
	icon_living = "ember"

	projectiletype = /obj/projectile/fire
	heat_resist = 1
	player_msg = "Your attacks inflict a <b>damage over time</b> effect, that will \
	harm your target slowly. The effect stacks with further attacks.<br>\
	You are also immune to fire."

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/fire)

/obj/projectile/fire
	name = "ember"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	modifier_type_to_apply = /datum/modifier/fire
	modifier_duration = 6 SECONDS // About 15 damage per stack, as Life() ticks every two seconds.
	damage_force = 0
	nodamage = TRUE


// Close to mid-ranged shooter that arcs over other things, ideal if allies are in front of it.
// Difference from siege hivebots is that siege hivebots have limited charges for their attacks, are very long range, and
// the projectiles have an AoE component, where as backline hivebots do not.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/backline
	name = "lobber hivebot"
	desc = "A hivebot that equipped with a novel energy weapon that arcs short distances."
	icon_state = "bombard"
	icon_living = "bombard"
	projectiletype = /obj/projectile/arc/blue_energy
	projectilesound = 'sound/weapons/Laser.ogg'
	player_msg = "Your attacks are short-ranged, but can <b>arc over obstructions</b> such as allies \
	or barriers."

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/lobber)

/mob/living/simple_mob/mechanical/hivebot/ranged_damage/sniper
	name = "sniper hivebot"
	desc = "A hivebot that equipped with a long range magenetic weapon."
	icon_state = "sniper"
	icon_living = "sniper"
	base_attack_cooldown = 60
	projectiletype = /obj/projectile/bullet/magnetic
	projectilesound = 'sound/weapons/railgun.ogg'
	player_msg = "Your attacks are short-ranged, but can <b>arc over obstructions</b> such as allies \
	or barriers."

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/sniper

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/lobber)


/obj/projectile/arc/blue_energy
	name = "energy missile"
	icon_state = "force_missile"
	// A bit stronger since arcing projectiles are much easier to avoid than traditional ones.
	damage_force = 15 // A bit stronger since arcing projectiles are much easier to avoid than traditional ones.
	damage_type = DAMAGE_TYPE_BURN

// Very long ranged hivebot that rains down hell.
// Their projectiles arc, meaning they go over everything until it hits the ground.
// This means they're somewhat easier to avoid, but go over most defenses (like allies, or barriers),
// and tend to do more harm than a regular projectile, due to being AoE.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege
	name = "bombard hivebot"
	desc = "An upsized hivebot capable of attacking from extreme range."
	projectiletype = /obj/projectile/arc/blue_energy

	icon_scale_x = 2
	icon_scale_y = 2
	icon_state = "bombard"
	icon_living = "bombard"

	maxHealth = 4 LASERS_TO_KILL // 120 health.
	health = 4 LASERS_TO_KILL

	base_attack_cooldown = 5

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/sniper
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/siege)

	player_msg = "You are capable of firing <b>very long range bombardment attacks</b>.<br>\
	To use, click on a tile or enemy at a long range. Note that the projectile arcs in the air, \
	so it will fly over everything inbetween you and the target.<br>\
	The bombardment is most effective when attacking a static structure, as it cannot avoid your fire."

// Fires EMP blasts.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/emp
	name = "ionic artillery hivebot"
	desc = "An upsized hivebot designed to destroy mechs and synthetics."
	projectiletype = /obj/projectile/arc/emp_blast/weak

	icon_state = "ionart"
	icon_living = "ionart"

	base_attack_cooldown = 60

/obj/projectile/arc/emp_blast
	name = "emp blast"
	icon_state = "bluespace"
	var/emp_dev = 2
	var/emp_heavy = 4
	var/emp_med = 7
	var/emp_light = 10

/obj/projectile/arc/emp_blast/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	empulse(target, emp_dev, emp_heavy, emp_med, emp_light) // Normal EMP grenade.
	return . | PROJECTILE_IMPACT_DELETE

/obj/projectile/arc/emp_blast/weak
	emp_dev = 1
	emp_heavy = 2
	emp_med = 3
	emp_light = 4

// Fires shots that irradiate the tile hit.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/radiation
	name = "irradiator hivebot"
	desc = "A upsized hivebot capable of irradiating a large area from afar."

	icon_state = "rad"
	icon_living = "rad"

	base_attack_cooldown = 60

	projectiletype = /obj/projectile/arc/radioactive


// Essentially a long ranged frag grenade.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/fragmentation
	name = "mortar hivebot"
	desc = "A upsized hivebot capable of delivering fragmentation shells to rip apart their fleshy enemies."

	icon_state = "frag"
	icon_living = "frag"

	base_attack_cooldown = 60

	projectiletype = /obj/projectile/arc/fragmentation/mortar


//kiting hivebot, punishes indecisive behavior and overly-reliant melee, extremely weak to staying on their butt. not too stronk
//relatively weak bullets, but high armor pen for consistent damage. do not use in large quantities
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/kiting
	name = "hivebot lurker"
	desc = "A hivebot with an attached plasma gun, and what seems to be mild cloaking-technology that reflects visible-wavelength."
	icon_state = "lurker"
	icon_living = "lurker"
	alpha = 200
	movement_base_speed = 10 / 0.7 SECONDS

	projectiletype = /obj/projectile/beam/xray
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/sniper

	icon_scale_x = 1.4
	icon_scale_y = 1.4
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/lurker)



//faster-moving hivebot that would love to get to know you more personal-like. causes light damage and also halloss, no armor pen. sorta-miniboss, more a 'hey, look at me RIGHT NOW' type of deal
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/suppressor
	name = "hivebot suppressor"
	desc = "A hivebot with two weak, but rapid-fire shock-guns that fire painful bolts. Less-lethal, but rapid-firing."
	icon_living = "suppressor"
	icon_state = "suppressor"
	base_attack_cooldown = 6
	movement_base_speed = 10 / 0.5 SECONDS
	projectiletype = /obj/projectile/beam/smalllaser/hivebot

	maxHealth = 4 LASERS_TO_KILL
	health = 4 LASERS_TO_KILL

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/suppressor)


/obj/projectile/beam/smalllaser/hivebot
	damage_force = 25
	damage_inflict_agony = 20
	legacy_muzzle_type = /obj/effect/projectile/muzzle/lightning
	legacy_tracer_type = /obj/effect/projectile/tracer/lightning
	legacy_impact_type = /obj/effect/projectile/impact/lightning


// stronker hivey, rare but very visible
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/scorcher
	name = "hivebot scorcher"
	desc = "A hivebot with a vicious-looking, strange weapon attached to its arm."

	icon_state = "scorcher"
	icon_living = "scorcher"

	maxHealth = 3 LASERS_TO_KILL
	health = 3 LASERS_TO_KILL

	projectiletype = /obj/projectile/beam/cyan/hivebot

	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/scorcher)


/obj/projectile/beam/cyan/hivebot
	damage_force = 45
	damage_tier = 4
