//This file contains miscellaneous recipes that dont fit the other categories
//or categories that are to warrant their own file

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3


/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = "pacid"
	required_reagents = list("sacid" = 1, "chlorine" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/water
	name = "Water"
	id = "water"
	result = "water"
	required_reagents = list("oxygen" = 1, "hydrogen" = 2)
	result_amount = 1


/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminum" = 1, "iron" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = "silicate"
	result = "silicate"
	required_reagents = list("aluminum" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 3


/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 2)
	catalysts = list("phoron" = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = "coolant"
	result = "coolant"
	required_reagents = list("tungsten" = 1, "oxygen" = 1, "water" = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/luminol
	name = "Luminol"
	id = "luminol"
	result = "luminol"
	required_reagents = list("hydrogen" = 2, "carbon" = 2, "ammonia" = 2)
	result_amount = 6

/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	inhibitors = list("phoron" = 1) // Messes with lexorin
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("sodium" = 1, "chlorine" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = "potassium_chloride"
	required_reagents = list("sodiumchloride" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = "potassium_chlorophoride"
	required_reagents = list("potassium_chloride" = 1, "phoron" = 1, "chloralhydrate" = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = "zombiepowder"
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
	result_amount = 2


/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = "mindbreaker"
	required_reagents = list("silicon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = "lexorin"
	required_reagents = list("phoron" = 1, "hydrogen" = 1, "nitrogen" = 1)
	result_amount = 3

/* Toxins and neutralisations */
/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	result = "carpotoxin"
	required_reagents = list("spidertoxin" = 2, "biomass" = 1, "sifsap" = 2)
	catalysts = list("sifsap" = 10)
	inhibitors = list("radium" = 1)
	result_amount = 2

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	result = "neurotoxin"
	required_reagents = list("gargleblaster" = 1, "stoxin" = 1)
	result_amount = 2

/datum/chemical_reaction/neutralize_carpotoxin
	name = "Neutralize Carpotoxin"
	id = "carpotoxin_neutral"
	result = "protein"
	required_reagents = list("radium" = 1, "carpotoxin" = 1, "sifsap" = 1)
	catalysts = list("sifsap" = 10)
	result_amount = 2

/datum/chemical_reaction/neutralize_spidertoxin
	name = "Neutralize Spidertoxin"
	id = "spidertoxin_neutral"
	result = "protein"
	required_reagents = list("radium" = 1, "spidertoxin" = 1, "sifsap" = 1)
	catalysts = list("sifsap" = 10)
	result_amount = 2

/datum/chemical_reaction/neutralize_neurotoxic_protein
	name = "Neutralize Toxic Proteins"
	id = "neurotoxic_protein_neutral"
	result = "protein"
	required_reagents = list("anti_toxin" = 1, "neurotoxic_protein" = 2)
	result_amount = 2

/datum/chemical_reaction/hyrdophoron
	name = "Hydrophoron"
	id = "hydrophoron"
	result = "hydrophoron"
	required_reagents = list("hydrogen" = 1, "phoron" = 1)
	inhibitors = list("nitrogen" = 1) //So it doesn't mess with lexorin
	result_amount = 2

/* Solidification */
/datum/chemical_reaction/solidification
	name = "Solid Iron"
	id = "solidiron"
	result = null
	required_reagents = list("frostoil" = 5, "iron" = REAGENTS_PER_SHEET)
	result_amount = 1
	var/sheet_to_give = /obj/item/stack/material/iron

/datum/chemical_reaction/solidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new sheet_to_give(get_turf(holder.my_atom), created_volume)
	return


/datum/chemical_reaction/solidification/phoron
	name = "Solid Phoron"
	id = "solidphoron"
	required_reagents = list("frostoil" = 5, "phoron" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/phoron


/datum/chemical_reaction/solidification/silver
	name = "Solid Silver"
	id = "solidsilver"
	required_reagents = list("frostoil" = 5, "silver" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/silver


/datum/chemical_reaction/solidification/gold
	name = "Solid Gold"
	id = "solidgold"
	required_reagents = list("frostoil" = 5, "gold" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/gold


/datum/chemical_reaction/solidification/platinum
	name = "Solid Platinum"
	id = "solidplatinum"
	required_reagents = list("frostoil" = 5, "platinum" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/platinum


/datum/chemical_reaction/solidification/uranium
	name = "Solid Uranium"
	id = "soliduranium"
	required_reagents = list("frostoil" = 5, "uranium" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/uranium


/datum/chemical_reaction/solidification/hydrogen
	name = "Solid Hydrogen"
	id = "solidhydrogen"
	required_reagents = list("frostoil" = 100, "hydrogen" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/mhydrogen


// These are from Xenobio.
/datum/chemical_reaction/solidification/steel
	name = "Solid Steel"
	id = "solidsteel"
	required_reagents = list("frostoil" = 5, "steel" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/steel


/datum/chemical_reaction/solidification/plasteel
	name = "Solid Plasteel"
	id = "solidplasteel"
	required_reagents = list("frostoil" = 10, "plasteel" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/plasteel


/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list("pacid" = 1, "plasticide" = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return

/* Grenade reactions */
/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list("water" = 1, "potassium" = 1)
	result_amount = 2
	mix_message = null

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	//VOREStation Add Start
	else
		holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	//VORESTation Add End
	e.start()
	//holder.clear_reagents() //VOREStation Removal
	return

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = null

/datum/chemical_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume)
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
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Stun(5)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 20), round(created_volume / 18), round(created_volume / 14), 1)
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	//VOREStation Add Start
	else
		holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	//VOREStation Add End
	e.start()

	//holder.clear_reagents() //VOREStation Removal
	return

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list("aluminum" = 1, "phoron" = 1, "sacid" = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(/datum/gas/volatile_fuel, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent("napalm")
	return

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = 0.4

/datum/chemical_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2
	mix_message = "The solution violently bubbles!"

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")

	var/datum/effect_system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect_system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	return

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect_system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	return

/* Paint */
/datum/chemical_reaction/red_paint
	name = "Red paint"
	id = "red_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_red" = 1)
	result_amount = 5

/datum/chemical_reaction/red_paint/send_data()
	return "#FE191A"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	id = "orange_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_orange" = 1)
	result_amount = 5

/datum/chemical_reaction/orange_paint/send_data()
	return "#FFBE4F"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	id = "yellow_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_yellow" = 1)
	result_amount = 5

/datum/chemical_reaction/yellow_paint/send_data()
	return "#FDFE7D"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	id = "green_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_green" = 1)
	result_amount = 5

/datum/chemical_reaction/green_paint/send_data()
	return "#18A31A"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	id = "blue_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_blue" = 1)
	result_amount = 5

/datum/chemical_reaction/blue_paint/send_data()
	return "#247CFF"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	id = "purple_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_purple" = 1)
	result_amount = 5

/datum/chemical_reaction/purple_paint/send_data()
	return "#CC0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	id = "grey_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_grey" = 1)
	result_amount = 5

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	id = "brown_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_brown" = 1)
	result_amount = 5

/datum/chemical_reaction/brown_paint/send_data()
	return "#846F35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	id = "blood_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "blood" = 2)
	result_amount = 5

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#FE191A" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	id = "milk_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "milk" = 5)
	result_amount = 5

/datum/chemical_reaction/milk_paint/send_data()
	return "#F0F8FF"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "orangejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#E78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "tomatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "limejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365E30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carrotjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "berryjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "grapejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "poisonberryjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "watermelonjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#B83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "lemonjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#AFAF00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "banana" = 5)
	result_amount = 5

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#C3AF00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "potatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	id = "carbon_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carbon" = 1)
	result_amount = 5

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminum_paint
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "aluminum" = 1)
	result_amount = 5

/datum/chemical_reaction/aluminum_paint/send_data()
	return "#F0F8FF"

//R-UST Port
/datum/chemical_reaction/deuterium
	name = "Deuterium"
	id = "deuterium"
	result = null
	required_reagents = list("hydrophoron" = 5, "water" = 10)
	result_amount = 15

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

///////////////////////////////
//SLIME CORES BELOW HERE///////
///////////////////////////////

/datum/chemical_reaction/slime_food
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list("phoron" = 10, "slimejelly" = 5, "nutriment" = 20)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)

		var/list/borks = typesof(/obj/item/reagent_containers/food/snacks) - /obj/item/reagent_containers/food/snacks // BORK BORK BORK

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		for(var/i = 1, i <= 4 + rand(1,2), i++)
			var/chosen = pick(borks)
			var/obj/B = new chosen
			if(B)
				B.loc = get_turf(holder.my_atom)
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(B, pick(NORTH,SOUTH,EAST,WEST))




/datum/chemical_reaction/materials
	name = "Slime materials"
	id = "slimematerial"
	result = null
	required_reagents = list("phoron" = 20, "slimejelly" = 40, "aluminum" = 20) //Woah there! You have the possibility of making diamonds! 8 ground up slimes required for one of these, and you still have a 10% chance for it to fail.
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		var/fail_chance = rand(1,1000)
		if(fail_chance == 1) // 0.1% chance of exploding, so scientists don't exclusively abuse this to obtain materials.
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The solution begins to vibrate violently!</span>"), 1) // It was at this moment, the Xenobiologist knew... he fucked up.
			sleep(30)
			playsound(get_turf(holder.my_atom), 'sound/items/Welder2.ogg', 100, 1)
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The reaction begins to rapidly sizzle and swell outwards!</span>"), 1)
			sleep(20)
			explosion(get_turf(holder.my_atom), 0 ,4, 8) //Enough to cause severe damage in the area, but not so much that it'll instantly gib the person.
			empulse(get_turf(holder.my_atom), 3, 7) //Uh oh, it produced some uranium, too! EMP blast!
			return

		if(fail_chance < 101) // 10% chance of it not working at all.
			playsound(get_turf(holder.my_atom), 'sound/items/Welder.ogg', 100, 1)
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The slime core fizzles disappointingly.</span>"), 1)
			return

		var/blocked = list(/obj/item/stack/material, /obj/item/stack/material/cyborg, /obj/item/stack/material/cyborg/plastic, /obj/item/stack/material/cyborg/plasteel, /obj/item/stack/material/cyborg/glass/reinforced, /obj/item/stack/material/cyborg/wood, /obj/item/stack/material/animalhide/human, /obj/item/stack/material/animalhide/corgi, /obj/item/stack/material/animalhide/cat, /obj/item/stack/material/animalhide/monkey, /obj/item/stack/material/animalhide/lizard , /obj/item/stack/material/animalhide/xeno, /obj/item/stack/material/cyborg, /obj/item/stack/material/cyborg/glass/reinforced)
		var/list/material = typesof(/obj/item/stack/material) - blocked

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		var/spawn_amount = rand(1,50)
		var/chosen = pick(material)
		var/obj/item/stack/material/C = new chosen
		C.amount = spawn_amount
		C.loc = get_turf(holder.my_atom)


/datum/chemical_reaction/slimelight
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list("phoron" = 5, "slimejelly" = 5, "water" = 10) //Takes 10 water so it doesn't mess with the frost oil.
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'> The contents of the slime core harden and begin to emit a warm, bright light.</span>"), 1)
		var/obj/item/flashlight/slime/F = new /obj/item/flashlight/slime
		F.loc = get_turf(holder.my_atom)


/datum/chemical_reaction/slimephoron
	name = "Slime Phoron"
	id = "m_plasma"
	result = null
	required_reagents = list("phoron" = 20, "uranium" = 20, "slimejelly" = 20)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		var/obj/item/stack/material/phoron/P = new /obj/item/stack/material/phoron
		P.amount = 10
		P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slimefreeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list("phoron" = 10, "coolant" = 10, "slimejelly" = 10)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'>The slime extract begins to vibrate violently!</span>"), 1)
		sleep(50)
		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
			M.bodytemperature -= 140
			to_chat(M, "<span class='notice'> You suddenly feel a chill!</span>")


/datum/chemical_reaction/slimefrost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = "frostoil"
	required_reagents = list("phoron" = 5, "slimejelly" = 5, "water" = 5, "coolant" = 5)
	result_amount = 10


/datum/chemical_reaction/slimefire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list("phoron" = 60, "slimejelly" = 30, "potassium" = 30)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'>The slime extract begins to vibrate violently!</span>"), 1)
		sleep(50)
		var/turf/location = get_turf(holder.my_atom.loc)
		for(var/turf/simulated/floor/target_tile in range(0,location))
			target_tile.assume_gas(/datum/gas/phoron, 25, 1400)
			spawn (0) target_tile.hotspot_expose(700, 400)


/datum/chemical_reaction/slimeify
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin2"
	result = "advmutationtoxin"
	required_reagents = list("phoron" = 15, "slimejelly" = 15, "mutationtoxin" = 15) //In case a xenobiologist wants to become a fully fledged slime person.
	result_amount = 1


/datum/chemical_reaction/slimeheal //A slime healing mixture. Why not.
	name = "Slime Health"
	id = "slimeheal"
	result = "null"
	required_reagents = list("phoron" = 10, "bicaridine" = 10, "kelotane" = 10, "inaprovaline" = 10, "slimejelly" = 10)
	on_reaction(var/datum/reagents/holder, var/created_volume)
		for (var/mob/living/carbon/C in viewers(get_turf(holder.my_atom), null))
			to_chat(C, "<span class='notice'>A wave of energy suddenly invigorates you.</span>")
			C.adjustBruteLoss(-25)
			C.adjustFireLoss(-25)
			C.adjustToxLoss(-25)
			C.adjustOxyLoss(-25)
			C.adjustBrainLoss(-25)
			C.adjustCloneLoss(-25)
			C.updatehealth()

/datum/chemical_reaction/slimejelly
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("phoron" = 20, "sugar" = 50, "lithium" = 50) //In case a xenobiologist is impatient and is willing to drain their dispenser resources, along with plasma!
	result_amount = 5

/* //VORESTATION AI TEMPORARY REMOVAL
/datum/chemical_reaction/slimevore
	name = "Slime Vore" // Hostile vore mobs only
	id = "m_tele"
	result = null
	required_reagents = list("phoron" = 20, "nutriment" = 20, "sugar" = 20, "mutationtoxin" = 20) //Can't do slime jelly as it'll conflict with another, but mutation toxin will do.
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		var/mob_path = /mob/living/simple_mob
		var/blocked = list(
			/mob/living/simple_mob/hostile/mimic,
			/mob/living/simple_mob/animal/space/alien/queen,
			/mob/living/simple_mob/shadekin
			)//exclusion list for things you don't want the reaction to create.
		var/list/voremobs = typesof(mob_path) - mob_path - blocked // list of possible hostile mobs

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		var/spawn_count = rand(1,3)
		for(var/i = 1, i <= spawn_count, i++)
			var/chosen = pick(voremobs)
			var/mob/living/simple_mob/hostile/C = new chosen
			C.faction = "slimesummon"
			C.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(C, pick(NORTH,SOUTH,EAST,WEST))
*/


//Xenochimera revival
/datum/chemical_reaction/xenolazarus
	name = "Discount Lazarus"
	id = "discountlazarus"
	result = null
	required_reagents = list("monstertamer" = 5, "clonexadone" = 5)

/datum/chemical_reaction/xenolazarus/on_reaction(var/datum/reagents/holder, var/created_volume) //literally all this does is mash the regenerate button
	if(ishuman(holder.my_atom))
		var/mob/living/carbon/human/H = holder.my_atom
		if(H.stat == DEAD && (/mob/living/carbon/human/proc/reconstitute_form in H.verbs)) //no magical regen for non-regenners, and can't force the reaction on live ones
			if(H.hasnutriment()) // make sure it actually has the conditions to revive
				if(H.revive_ready >= 1) // if it's not reviving, start doing so
					H.revive_ready = REVIVING_READY // overrides the normal cooldown
					H.visible_message("<span class='info'>[H] shudders briefly, then relaxes, faint movements stirring within.</span>")
					H.chimera_regenerate()
				else if (/mob/living/carbon/human/proc/hatch in H.verbs)// already reviving, check if they're ready to hatch
					H.chimera_hatch()
					H.visible_message("<span class='danger'><p><font size=4>[H] violently convulses and then bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") // Hope you were wearing waterproofs, doc...
					H.adjustBrainLoss(10) // they're reviving from dead, so take 10 brainloss
				else //they're already reviving but haven't hatched. Give a little message to tell them to wait.
					H.visible_message("<span class='info'>[H] stirs faintly, but doesn't appear to be ready to wake up yet.</span>")
			else
				H.visible_message("<span class='info'>[H] twitches for a moment, but remains still.</span>") // no nutriment

