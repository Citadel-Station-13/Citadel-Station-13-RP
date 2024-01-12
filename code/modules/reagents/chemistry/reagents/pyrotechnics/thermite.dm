/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = REAGENT_SOLID
	color = "#673910"

/datum/reagent/thermite/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(volume / 5)

/datum/reagent/thermite/contact_expose_obj(obj/target, volume, list/data, vapor)
	. = ..()
	if(istype(target, /turf/simulated/wall))
		// todo: refactor thermite
		var/turf/simulated/wall/W = target
		W.thermite = 1
		W.add_overlay(image('icons/effects/effects.dmi', icon_state = "#673910"))
		. += 5

/datum/reagent/thermite/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	entity.adjustFireLoss(3 * removed)
