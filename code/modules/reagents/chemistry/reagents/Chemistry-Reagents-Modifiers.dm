/*
 * Modifier-applying chemicals.
 */

/datum/reagent/modapplying
	name = "brute juice"
	id = "berserkmed"
	description = "A liquid that is capable of causing a prolonged state of heightened aggression and durability."
	taste_description = "metal"
	reagent_state = REAGENT_LIQUID
	color = "#ff5555"
	metabolism_rate = REM

	var/modifier_to_add = /datum/modifier/berserk
	var/modifier_duration = 2 SECONDS	// How long, per unit dose, will this last?

/datum/reagent/modapplying/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	M.add_modifier(modifier_to_add, metabolism.total_processed_dose * modifier_duration)

/datum/reagent/modapplying/cryofluid
	name = "cryogenic slurry"
	id = "cryoslurry"
	description = "An incredibly strange liquid that rapidly absorbs thermal energy from materials it contacts."
	taste_description = "siberian hellscape"
	color = "#4CDBDB"
	metabolism_rate = REM * 0.5

	modifier_to_add = /datum/modifier/cryogelled
	modifier_duration = 3 SECONDS

/datum/reagent/modapplying/cryofluid/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..(M, alien, removed)
	M.bodytemperature -= removed * 20

/datum/reagent/modapplying/cryofluid/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_blood(M, alien, removed * 2.5, metabolism)

/datum/reagent/modapplying/cryofluid/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_blood(M, alien, removed * 0.6, metabolism)

/datum/reagent/modapplying/cryofluid/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()

	var/mob/M = target
	if(isliving(M))
		var/mob/living/L = M
		for(var/I = 1 to rand(1, round(allocated + 1)))
			L.add_modifier(modifier_to_add, allocated * rand(modifier_duration / 2, modifier_duration * 2))

/datum/reagent/modapplying/cryofluid/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/turf/T = target
	if(istype(T, /turf/simulated/floor/water) && prob(allocated))
		T.visible_message("<span class='danger'>\The [T] crackles loudly as the cryogenic fluid causes it to boil away, leaving behind a hard layer of ice.</span>")
		T.ChangeTurf(/turf/simulated/floor/outdoors/ice, 1, 1, TRUE)
	else
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.freeze_floor()
