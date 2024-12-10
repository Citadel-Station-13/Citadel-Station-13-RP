/datum/chemical_reaction/distilling
	abstract_type = /datum/chemical_reaction/distilling
	reaction_half_life = 12 SECONDS

	// reaction_message_instant = "The solution churns."
	// reaction_sound_instant = 'sound/effects/slosh.ogg'

	temperature_low = T0C
	temperature_high = T20C

	required_container_path = /obj/item/reagent_containers/glass/distilling

	var/temp_shift = 0 // How much the temperature changes when the reaction occurs.

/datum/chemical_reaction/on_reaction_start(datum/reagent_holder/holder)
	. = ..()
	holder.my_atom.visible_message("<span class='notice'>\The [holder.my_atom] rumbles to life!</span>")

/datum/chemical_reaction/distilling/on_reaction_tick(datum/reagent_holder/holder, delta_time, multiplier)
	. = ..()
	if(prob(10))
		holder.my_atom.visible_message("<span class='notice'>\The [holder.my_atom] rumbles faintly...</span>")
	holder.temperature += temp_shift

/datum/chemical_reaction/distilling/on_reaction_finish(datum/reagent_holder/holder)
	. = ..()
	holder.my_atom.visible_message("<span class='notice'>\The [holder.my_atom]'s rumbling dies down...</span>")

// Subtypes //

// Biomass
/datum/chemical_reaction/distilling/biomass
	name = "Distilling Biomass"
	id = "distill_biomass"
	result = "biomass"
	required_reagents = list("blood" = 1, "sugar" = 1, MAT_PHORON = 0.5)
	result_amount = 1 // 40 units per sheet, requires actually using the machine, and having blood to spare.

	temperature_low = T0C + 100
	temperature_high = T0C + 150

	temp_shift = -2

// Medicinal
/datum/chemical_reaction/distilling/spacomycaze
	name = "Distilling Spacomycaze"
	id = "distill_spacomycaze"
	result = "spacomycaze"
	required_reagents = list("paracetamol" = 1, "spaceacillin" = 1, "foaming_agent" = 1)
	result_amount = 2

	reaction_half_life = 20 SECONDS
	temperature_low = T0C + 100
	temperature_high = T0C + 120

// Alcohol
/datum/chemical_reaction/distilling/beer
	name = "Distilling Beer"
	id = "distill_beer"
	result = "beer"
	required_reagents = list("nutriment" = 1, "water" = 1, "sugar" = 1)
	result_amount = 2

	reaction_half_life = 60 SECONDS
	temperature_low = T0C + 20
	temperature_high = T0C + 22

/datum/chemical_reaction/distilling/ale
	name = "Distilling Ale"
	id = "distill_ale"
	result = "ale"
	required_reagents = list("nutriment" = 1, "beer" = 1)
	inhibitors = list("water" = 1)
	result_amount = 2

	reaction_half_life = 60 SECONDS
	temperature_low = T0C + 7
	temperature_high = T0C + 13

	temp_shift = 0.5

// Unique
/datum/chemical_reaction/distilling/berserkjuice
	name = "Distilling Brute Juice"
	id = "distill_brutejuice"
	result = "berserkmed"
	required_reagents = list("biomass" = 1, "hyperzine" = 3, "synaptizine" = 2, MAT_PHORON = 1)
	result_amount = 3

	reaction_half_life = 30 SECONDS
	temperature_low = T0C + 600
	temperature_high = T0C + 700

	temp_shift = 4

/datum/chemical_reaction/distilling/berserkjuice/on_reaction_tick(datum/reagent_holder/holder, delta_time, multiplier)
	..()
	if(prob(1))
		var/turf/T = get_turf(holder.my_atom)
		explosion(T, -1, rand(-1, 1), rand(1,2), rand(3,5))

/datum/chemical_reaction/distilling/cryogel
	name = "Distilling Cryogellatin"
	id = "distill_cryoslurry"
	result = "cryoslurry"
	required_reagents = list("frostoil" = 7, "enzyme" = 3, "plasticide" = 3, "foaming_agent" = 2)
	inhibitors = list("water" = 5)
	result_amount = 1

	reaction_half_life = 15 SECONDS
	temperature_low = T0C
	temperature_high = T0C + 15

	temp_shift = 20

/datum/chemical_reaction/distilling/cryogel/on_reaction_tick(datum/reagent_holder/holder, delta_time, multiplier)
	..()
	if(prob(1))
		var/turf/T = get_turf(holder.my_atom)
		var/datum/effect_system/smoke_spread/frost/F = new (holder.my_atom)
		F.set_up(6, 0, T)
		F.start()

/datum/chemical_reaction/distilling/lichpowder
	name = "Distilling Lichpowder"
	id = "distill_lichpowder"
	result = "lichpowder"
	required_reagents = list("zombiepowder" = 2, "leporazine" = 1)
	result_amount = 2

	reaction_half_life = 16 SECONDS
	temperature_low = T0C + 100
	temperature_high = T0C + 150

/datum/chemical_reaction/distilling/necroxadone
	name = "Distilling Necroxadone"
	id = "distill_necroxadone"
	result = "necroxadone"
	required_reagents = list("lichpowder" = 1, "cryoxadone" = 1, "carthatoline" = 1)
	result_amount = 2

	catalysts = list(MAT_PHORON = 5)

	reaction_half_life = 40 SECONDS
	temperature_low = T0C + 90
	temperature_high = T0C + 95
