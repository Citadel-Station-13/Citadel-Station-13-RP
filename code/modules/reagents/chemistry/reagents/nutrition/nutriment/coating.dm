/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.
	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/

/datum/reagent/nutriment/coating
	name = "coating"
	id = "coating"
	nutriment_factor = 6 //Less dense than the food itself, but coatings still add extra calories
	var/messaged = 0
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"

/datum/reagent/nutriment/coating/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/datum/nutriment_data/data = M.ingested.get_reagent_data(src)
	//We'll assume that the batter isnt going to be regurgitated and eaten by someone else. Only show this once
	if(!data.cooked)
		if (!messaged)
			to_chat(M, "Ugh, this raw [name] tastes disgusting.")
			nutriment_factor *= 0.5
			messaged = 1

		//Raw coatings will sometimes cause vomiting
		if (prob(1))
			M.vomit()
	..()

/datum/reagent/nutriment/coating/compute_name_with_data(datum/nutriment_data/data)
	return data.cooked ? cooked_name : ..()

/datum/reagent/nutriment/coating/batter
	name = "batter mix"
	cooked_name = "batter"
	id = "batter"
	color = "#f5f4e9"
	reagent_state = REAGENT_LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"

/datum/reagent/nutriment/coating/beerbatter
	name = "beer batter mix"
	cooked_name = "beer batter"
	id = "beerbatter"
	color = "#f5f4e9"
	reagent_state = REAGENT_LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"

/datum/reagent/nutriment/coating/beerbatter/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	M.add_chemical_effect(CE_ALCOHOL, 0.02) //Very slightly alcoholic
