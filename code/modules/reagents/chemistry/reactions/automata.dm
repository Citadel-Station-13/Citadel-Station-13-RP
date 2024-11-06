/datum/chemical_reaction/automata
	abstract_type = /datum/chemical_reaction/automata
	important_for_logging = TRUE

/datum/chemical_reaction/automata/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)

/datum/chemical_reaction/automata/chemsmoke/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()

	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, multiplier * 0.4, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()

/datum/chemical_reaction/automata/foam
	name = "Foam"
	id = "foam"
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	reaction_message_instant = "The solution violently bubbles!"

/datum/chemical_reaction/automata/foam/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()

	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")

	var/datum/effect_system/foam_spread/s = new()
	s.set_up(multiplier * 2, location, holder, 0)
	s.start()

/datum/chemical_reaction/automata/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)

/datum/chemical_reaction/automata/metalfoam/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()

	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect_system/foam_spread/s = new()
	s.set_up(multiplier * 5, location, holder, 1)
	s.start()

/datum/chemical_reaction/automata/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	required_reagents = list(MAT_IRON = 3, "foaming_agent" = 1, "pacid" = 1)

/datum/chemical_reaction/automata/ironfoam/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()

	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect_system/foam_spread/s = new()
	s.set_up(multiplier * 5, location, holder, 2)
	s.start()
