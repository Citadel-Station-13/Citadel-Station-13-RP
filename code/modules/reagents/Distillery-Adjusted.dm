/*The recipes former made in the distillery*/

/datum/chemical_reaction/spacomycaze
	// Biomass, for cloning and bioprinters
	name = "Spacomycaze"
	id = "spacomycaze"
	result = "spacomycaze"
	required_reagents = list("paracetamol" = 1, "spaceacillin" = 1, "foaming_agent" = 1)
	result_amount = 6	// Roughly 120u per phoron sheet

	min_temperature = T0C + 100
	max_temperature = T0C + 120

/datum/chemical_reaction/berserkjuice
	name = "Brute Juice"
	id = "brutejuice"
	result = "berserkmed"
	required_reagents = list("zombiepowder" = 1, "hyperzine" = 3, "shockchem" = 2, "phoron" = 1)
	result_amount = 3

	min_temperature = T0C + 600
	max_temperature = T0C + 700

/datum/chemical_reaction/berserkjuice/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()

	if(prob(1))
		var/turf/T = get_turf(holder.my_atom)
		explosion(T, -1, rand(-1, 1), rand(1,2), rand(3,5))
	return

/datum/chemical_reaction/cryogel
	name = "Cryogellatin"
	id = "cryoslurry"
	result = "cryoslurry"
	required_reagents = list("frostoil" = 7, "enzyme" = 3, "plasticide" = 3, "foaming_agent" = 2)
	inhibitors = list("water" = 5)
	result_amount = 1

	min_temperature = TCMB
	max_temperature = TCMB + 15

/datum/chemical_reaction/cryogel/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()

	if(prob(1))
		var/turf/T = get_turf(holder.my_atom)
		var/datum/effect_system/smoke_spread/frost/F = new (holder.my_atom)
		F.set_up(6, 0, T)
		F.start()
	return

/datum/chemical_reaction/lichpowder
	name = "Distilling Lichpowder"
	id = "distill_lichpowder"
	result = "lichpowder"
	required_reagents = list("zombiepowder" = 2, "leporazine" = 1)
	result_amount = 2

	min_temperature = T0C + 100
	max_temperature = T0C + 150

/datum/chemical_reaction/necroxadone
	name = "Necroxadone"
	id = "necroxadone"
	result = "necroxadone"
	required_reagents = list("lichpowder" = 1, "cryoxadone" = 1, "carthatoline" = 1)
	result_amount = 2

	catalysts = list("phoron" = 5)

	min_temperature = T0C + 90
	max_temperature = T0C + 95
