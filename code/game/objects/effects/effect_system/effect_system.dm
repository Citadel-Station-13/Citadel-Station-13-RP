
/obj/effect/particle_effect
	name = "particle effect"
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GRILLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

/datum/effect_system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = 0

/datum/effect_system/Destroy()
	holder = null
	location = null
	return..()

/datum/effect_system/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc
	setup = 1

/datum/effect_system/proc/attach(atom/atom)
	holder = atom

/datum/effect_system/proc/start()

