/datum/reagent/antibodies
	data = list("antibodies"=list())
	name = "Antibodies"
	taste_description = "slime"
	id = "antibodies"
	reagent_state = REAGENT_LIQUID
	color = "#0050F0"
	mrate_static = TRUE

/datum/reagent/antibodies/affect_blood(mob/living/carbon/M, alien, removed)
	if(src.data)
		M.antibodies |= src.data["antibodies"]
	..()
