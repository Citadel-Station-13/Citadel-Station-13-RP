/datum/reagent/antibodies
	name = "Antibodies"
	taste_description = "slime"
	id = "antibodies"
	reagent_state = REAGENT_LIQUID
	color = "#0050F0"
	mrate_static = TRUE

/datum/reagent/antibodies/mix_data(datum/reagent_holder/holder, list/current_data, current_amount, list/new_data, new_amount)
	var/list/antibodies = current_data["antibodies"] | (new_data?["antibodies"] || list())
	return list(
		"antibodies" = antibodies,
	)

/datum/reagent/antibodies/applying_to_metabolism(mob/living/carbon/entity, application, organ_tag, volume, list/data)
	. = ..()
	entity.antibodies |= data["antibodies"]
