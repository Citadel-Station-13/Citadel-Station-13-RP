
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

// EMP arc shot
/obj/projectile/arc/emp_blast
	name = "emp blast"
	icon_state = "bluespace"

/obj/projectile/arc/emp_blast/on_impact(atom/target, impact_flags, def_zone, efficiency)
	var/turf/T = target
	empulse(T, 2, 4, 7, 10) // Normal EMP grenade.
	return impact_flags

/obj/projectile/arc/emp_blast/weak/on_impact(atom/target, impact_flags, def_zone, efficiency)
	var/turf/T = target
	empulse(T, 1, 2, 3, 4) // Sec EMP grenade.
	return impact_flags

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
