/**
 * This is for things going off (usually pyrotechnics).
 */
/datum/chemical_reaction/detonation
	abstract_type = /datum/chemical_reaction/detonation
	important_for_logging = TRUE

/datum/chemical_reaction/detonation/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	var/turf/where_we_are = get_turf(holder.my_atom)
	if(!isturf(where_we_are))
		return
	on_detonation(holder, multiplier, where_we_are)

/**
 * standard abstraction for detonation reactions
 */
/datum/chemical_reaction/detonation/proc/on_detonation(datum/reagent_holder/holder, multiplier, turf/epicenter)
	return

/datum/chemical_reaction/detonation/explosion_potassium
	name = "Potassium-Water Explosion"
	id = "explosion_potassium"
	required_reagents = list("water" = 1, "potassium" = 1)

/datum/chemical_reaction/detonation/explosion_potassium/on_detonation(datum/reagent_holder/holder, multiplier, turf/epicenter)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(round(multiplier / 5, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
	e.start()

/datum/chemical_reaction/detonation/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )

/datum/chemical_reaction/detonation/flash_powder/on_detonation(datum/reagent_holder/holder, multiplier, turf/epicenter)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.afflict_paralyze(20 * 15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.afflict_stun(20 * 5)

/datum/chemical_reaction/detonation/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	required_reagents = list(MAT_URANIUM = 1, MAT_IRON = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense

/datum/chemical_reaction/detonation/emp_pulse/on_detonation(datum/reagent_holder/holder, multiplier, turf/epicenter)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(multiplier / 12), round(multiplier / 10), round(multiplier / 9), round(multiplier / 7), 1)

/datum/chemical_reaction/detonation/napalm
	name = "Napalm"
	id = "napalm"
	required_reagents = list("aluminum" = 1, MAT_PHORON = 1, "sacid" = 1 )

/datum/chemical_reaction/detonation/napalm/on_detonation(datum/reagent_holder/holder, multiplier, turf/epicenter)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(GAS_ID_VOLATILE_FUEL, multiplier, 400+T0C)
		spawn(0)
			target_tile.hotspot_expose(700, 400)

/datum/chemical_reaction/detonation/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)

/datum/chemical_reaction/detonation/nitroglycerin/on_detonation(datum/reagent_holder/holder, multiplier, turf/epicenter)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(round(multiplier, 1), holder.my_atom, 0, 0)
	e.amount *= 0.5
	var/mob/living/L = holder.my_atom
	if(L.stat!=DEAD)
		e.amount *= 0.5
	e.start()
