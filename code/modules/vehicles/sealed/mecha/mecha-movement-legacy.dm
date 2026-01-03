
// Mech Code
/obj/vehicle/sealed/mecha/handle_fall(turf/landing)
	// First things first, break any lattice
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, loc)
	if(lattice)
		// Lattices seem a bit too flimsy to hold up a massive exosuit.
		lattice.visible_message(SPAN_DANGER("\The [lattice] collapses under the weight of \the [src]!"))
		qdel(lattice)

	// Then call parent to have us actually fall
	return ..()

/obj/vehicle/sealed/mecha/fall_impact(var/atom/hit_atom, var/damage_min = 15, var/damage_max = 30, var/silent = FALSE, var/planetary = FALSE)
	// Anything on the same tile as the landing tile is gonna have a bad day.
	for(var/mob/living/L in hit_atom.contents)
		L.visible_message(SPAN_DANGER("\The [src] crushes \the [L] as it lands on them!"))
		L.adjustBruteLoss(rand(70, 100))
		L.afflict_paralyze(20 * 8)

	var/turf/landing = get_turf(hit_atom)

	if(planetary && src.CanParachute())
		if(!silent)
			visible_message(
				SPAN_WARNING("\The [src] glides in from above and lands on \the [landing]!"),
				SPAN_DANGER("You land on \the [landing]!"),
				SPAN_HEAR("You hear something land \the [landing]."),
			)
		return
	else if(!planetary && src.softfall) // Falling one floor and falling one atmosphere are very different things
		if(!silent)
			visible_message(
				SPAN_WARNING("\The [src] falls from above and lands on \the [landing]!"),
				SPAN_DANGER("You land on \the [landing]!"),
				SPAN_HEAR("You hear something land \the [landing]."),
			)
		return
	else
		if(!silent)
			if(planetary)
				visible_message(
					SPAN_USERDANGER("\A [src] falls out of the sky and crashes into \the [landing]!"),
					SPAN_USERDANGER("You fall out of the skiy and crash into \the [landing]!"),
					SPAN_HEAR("You hear something slam into \the [landing]."),
				)
				var/turf/T = get_turf(landing)
				explosion(T, 0, 1, 2)
			else
				visible_message(
					SPAN_WARNING("\The [src] falls from above and slams into \the [landing]!"),
					SPAN_DANGER("You fall off and hit \the [landing]!"),
					SPAN_HEAR("You hear something slam into \the [landing]."),
				)
			playsound(loc, "punch", 25, TRUE, -1)

	// And now to hurt the mech.
	if(!planetary)
		run_damage_instance(
			50,
			DAMAGE_TYPE_BRUTE,
			4,
			ARMOR_MELEE,
			NONE,
		)
	else
		// you dun fucked up
		for(var/i in 1 to 5)
			run_damage_instance(
				35,
				DAMAGE_TYPE_BRUTE,
				5.5,
				ARMOR_MELEE,
				NONE,
			)

	// And hurt the floor.
	if(istype(hit_atom, /turf/simulated/floor))
		var/turf/simulated/floor/ground = hit_atom
		ground.break_tile()
