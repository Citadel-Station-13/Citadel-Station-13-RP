/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.
	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/
/datum/reagent/nutriment/coating
	nutriment_factor = 6 //Less dense than the food itself, but coatings still add extra calories
	var/messaged = 0
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"

/datum/reagent/nutriment/coating/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)

	//We'll assume that the batter isnt going to be regurgitated and eaten by someone else. Only show this once
	if (data["cooked"] != 1)
		if (!messaged)
			M << "Ugh, this raw [name] tastes disgusting."
			nutriment_factor *= 0.5
			messaged = 1

		//Raw coatings will sometimes cause vomiting
		if (prob(1))
			M.vomit()
	..()

/datum/reagent/nutriment/coating/initialize_data(var/newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list()
	else
		if (isnull(data["cooked"]))
			data["cooked"] = 0
		return
	data["cooked"] = 0
	if (holder && holder.my_atom && istype(holder.my_atom,/obj/item/weapon/reagent_containers/food/snacks))
		data["cooked"] = 1
		name = cooked_name

		//Batter which is part of objects at compiletime spawns in a cooked state


//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/coating/mix_data(var/newdata, var/newamount)
	if (!data)
		data = list()

	data["cooked"] = newdata["cooked"]

/datum/reagent/nutriment/coating/batter
	name = "batter mix"
	cooked_name = "batter"
	id = "batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"

/datum/reagent/nutriment/coating/beerbatter
	name = "beer batter mix"
	cooked_name = "beer batter"
	id = "beerbatter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"

/datum/reagent/nutriment/coating/beerbatter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ALCOHOL, 0.02) //Very slightly alcoholic

//=========================
//Fats
//=========================
/datum/reagent/nutriment/triglyceride
	name = "triglyceride"
	id = "triglyceride"
	description = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	reagent_state = SOLID
	nutriment_factor = 27//The caloric ratio of carb/protein/fat is 4:4:9
	color = "#CCCCCC"

/datum/reagent/nutriment/triglyceride/oil
	//Having this base class incase we want to add more variants of oil
	name = "Oil"
	id = "oil"
	description = "Oils are liquid fats."
	reagent_state = LIQUID
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0

/datum/reagent/nutriment/triglyceride/oil/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	if(volume >= 3)
		T.wet_floor(2)

/datum/reagent/nutriment/triglyceride/oil/initialize_data(var/newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list("temperature" = T20C)

//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/triglyceride/oil/mix_data(var/newdata, var/newamount)

	if (!data)
		data = list()

	var/ouramount = volume - newamount
	if (ouramount <= 0 || !data["temperature"] || !volume)
		//If we get here, then this reagent has just been created, just copy the temperature exactly
		data["temperature"] = newdata["temperature"]

	else
		//Our temperature is set to the mean of the two mixtures, taking volume into account
		var/total = (data["temperature"] * ouramount) + (newdata["temperature"] * newamount)
		data["temperature"] = total / volume

	return ..()


//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/datum/reagent/nutriment/triglyceride/oil/proc/heatdamage(var/mob/living/carbon/M)
	var/threshold = 360//Human heatdamage threshold
	var/datum/species/S = M.get_species(1)
	if (S && istype(S))
		threshold = S.heat_level_1

	//If temperature is too low to burn, return a factor of 0. no damage
	if (data["temperature"] < threshold)
		return 0

	//Step = degrees above heat level 1 for 1.0 multiplier
	var/step = 60
	if (S && istype(S))
		step = (S.heat_level_2 - S.heat_level_1)*1.5

	. = data["temperature"] - threshold
	. /= step
	. = min(., 2.5)//Cap multiplier at 2.5

/datum/reagent/nutriment/triglyceride/oil/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/dfactor = heatdamage(M)
	if (dfactor)
		M.take_organ_damage(0, removed * 1.5 * dfactor)
		data["temperature"] -= (6 * removed) / (1 + volume*0.1)//Cools off as it burns you
		if (lastburnmessage+100 < world.time	)
			M << span("danger", "Searing hot oil burns you, wash it off quick!")
			lastburnmessage = world.time


/datum/reagent/nutriment/triglyceride/oil/corn
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."

//SYNNONO MEME FOODS EXPANSION - Credit to Synnono

/datum/reagent/spacespice
	name = "Space Spice"
	id = "spacespice"
	description = "An exotic blend of spices for cooking. Definitely not worms."
	reagent_state = SOLID
	color = "#e08702"

/datum/reagent/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	description = "A dry mix for making delicious brownies."
	reagent_state = SOLID
	color = "#441a03"