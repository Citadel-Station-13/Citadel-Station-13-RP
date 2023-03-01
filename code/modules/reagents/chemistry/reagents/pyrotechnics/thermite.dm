/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = REAGENT_SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/touch_turf(turf/T)
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.add_overlay(image('icons/effects/effects.dmi', icon_state = "#673910"))
			remove_self(5)
	return

/datum/reagent/thermite/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/thermite/affect_blood(mob/living/carbon/M, alien, removed)
	M.adjustFireLoss(3 * removed)
