
//////////////
//	Subtypes
//////////////

// This is a test projectile in the sense that its testing the code to make sure it works,
// as opposed to a 'can I hit this thing' projectile.
/obj/projectile/arc/test/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(!isturf(target))
		return
	var/turf/T = target
	new /obj/effect/explosion(T)
	T.color = "#FF0000"

// Generic, Hivebot related
/obj/projectile/arc/blue_energy
	name = "energy missile"
	icon_state = "force_missile"
	damage_force = 15
	damage_type = DAMAGE_TYPE_BURN

/obj/projectile/arc/blue_energy/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(!isturf(target))
		return
	var/turf/T = target
	for(var/mob/living/L in T)
		impact(L)

/obj/projectile/arc/blue_energy/priest
	name = "nanite cloud"
	icon_state = "particle-heavy"
	damage_force = 15
	damage_type = DAMAGE_TYPE_BRUTE

/obj/projectile/arc/blue_energy/priest/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.Confuse(rand(3,5))

/obj/projectile/arc/radioactive/priest
	name  = "superheated plama discharge"
	icon_state = "plasma3"
	rad_power = RAD_INTENSITY_PROJ_ARC_HORROR_PRIEST

/obj/projectile/arc/radioactive/priest/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(!isturf(target))
		return
	var/turf/T = target
	new /obj/effect/explosion(T)
	explosion(T, 0, 1, 4)

// Fragmentation arc shot
/obj/projectile/arc/fragmentation
	name = "fragmentation shot"
	icon_state = "shell"
	var/list/fragment_types = list(
		/obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment, \
		/obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong
		)
	var/fragment_amount = 63 // Same as a grenade.
	var/spread_range = 7

/obj/projectile/arc/fragmentation/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(!isturf(target))
		return
	var/turf/T = target
	T.shrapnel_explosion(fragment_amount, spread_range, fragment_types, src, name, firer)

/obj/projectile/arc/fragmentation/mortar
	icon_state = "mortar"
	fragment_amount = 10
	spread_range = 3

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

// Radiation arc shot
/obj/projectile/arc/radioactive
	name = "radiation blast"
	icon_state = "green_pellet"
	icon_scale_x = 2
	icon_scale_y = 2
	var/rad_power = RAD_INTENSITY_PROJ_ARC

/obj/projectile/arc/radioactive/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(!isturf(target))
		return
	var/turf/T = target
	radiation_pulse(T, rad_power)

// Arcing rocket projectile that produces a weak explosion when it lands.
// Shouldn't punch holes in the floor, but will still hurt.
/obj/projectile/arc/explosive_rocket
	name = "rocket"
	icon_state = "mortar"

/obj/projectile/arc/explosive_rocket/on_impact(turf/T)
	new /obj/effect/explosion(T) // Weak explosions don't produce this on their own, apparently.
	explosion(T, 0, 0, 2, adminlog = FALSE)

/obj/projectile/arc/microsingulo
	name = "micro singularity"
	icon_state = "bluespace"

/obj/projectile/arc/microsingulo/on_impact(turf/T)
	new /obj/effect/temporary_effect/pulse/microsingulo(T)

/obj/effect/temporary_effect/pulse/microsingulo
	name = "micro singularity"
	desc = "It's sucking everything in!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	light_range = 4
	light_power = 5
	light_color = "#2ECCFA"
	pulses_remaining = 10
	pulse_delay = 2 SECONDS
	var/pull_radius = 3
	var/pull_strength = STAGE_THREE

/obj/effect/temporary_effect/pulse/microsingulo/on_pulse()
	for(var/atom/A in range(pull_radius, src))
		A.singularity_pull(src, pull_strength)

/obj/projectile/arc/hag30
	name ="155mm shell"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "big_shell"
	damage_force = 300 // This thing is meant to hit like a truck, it's an anti tank/building weapon. Gun can only be used on massive mechs.
	speed = 120 //If you get hit by this, skissue.
	damage_tier = 6
	base_projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_explosion{
    		sev_1 = 1;
    		sev_2 = 3;
    		sev_3 = 5;
    	},
	)
