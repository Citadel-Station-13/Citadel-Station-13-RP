/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = REAGENT_SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/touch_expose_mob(mob/target, volume, list/data, organ_tag)
	. = ..()
	target.adjust_fire_stacks(volume / 5)

/datum/reagent/thermite/contact_expose_object(obj/target, volume, list/data, vapor)
	. = ..()
	if(istype(target, /turf/simulated/wall))
		// todo: refactor thermite
		var/turf/simulated/wall/W = target
		W.thermite = 1
		W.add_overlay(image('icons/effects/effects.dmi', icon_state = "#673910"))
		. += 5

/datum/reagent/thermite/on_metabolize_tick(mob/living/carbon/entity, application, datum/reagent_metabolism/metabolism, organ_tag, list/data, removed)
	. = ..()
	if(application == REAGENT_APPLY_INJECT)
		entity.adjustFireLoss(3 * removed)
