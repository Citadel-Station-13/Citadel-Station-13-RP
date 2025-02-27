/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = REAGENT_SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/on_touch_turf(turf/target, remaining, allocated, data)
	// todo: refactor
	if(allocated >= 5 && istype(target, /turf/simulated/wall))
		var/turf/simulated/wall/wall = target
		wall.thermite = TRUE
		wall.add_overlay(image('icons/effects/effects.dmi', icon_state = "#673910"))
		allocated -= 5
		. += 5
	return . + ..()

/datum/reagent/thermite/on_touch_mob(mob/target, remaining, allocated, data, zone)
	if(isliving(target))
		// todo: rework and actually use some
		var/mob/living/living_target = target
		living_target.adjust_fire_stacks(allocated / 5)
	return ..()

/datum/reagent/thermite/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustFireLoss(3 * removed)
