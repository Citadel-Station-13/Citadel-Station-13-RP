/// How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
#define WATER_LATENT_HEAT 19000
/datum/reagent/water
	name = "Water"
	id = "water"
	taste_description = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = REAGENT_LIQUID
	color = "#0064C877"
	metabolism_rate = REM * 10

	glass_name = "water"
	glass_desc = "The father of all refreshments."

	cup_name = "water"
	cup_desc = "The father of all refreshments."

/datum/reagent/water/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/datum/gas_mixture/environment = target.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/atom/movable/fire) in target)
	if(hotspot && !istype(target, /turf/space))
		var/datum/gas_mixture/lowertemp = target.remove_cell_volume()
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		target.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, allocated * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.adjust_thermal_energy(-removed_heat)
		if (prob(5))
			target.visible_message("<span class='warning'>The water sizzles as it lands on \the [target]!</span>")
	else if(allocated >= 10)
		if(istype(target, /turf/simulated))
			var/turf/simulated/simulated_target = target
			simulated_target.wet_floor(1)

/datum/reagent/water/on_touch_obj(obj/target, remaining, allocated, data)
	if(istype(target, /obj/item/reagent_containers/food/snacks/monkeycube))
		var/obj/item/reagent_containers/food/snacks/monkeycube/cube = target
		if(!cube.wrapped)
			cube.Expand()
	else
		target.water_act(allocated / 5)
	var/effective = allocated || 10
	target.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (effective / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (effective / 10)))
	return ..()

/datum/reagent/water/on_touch_mob(mob/target, remaining, allocated, data, zone)
	if(isliving(target))
		var/mob/living/living_target = target
		// First, kill slimes.
		if(istype(living_target, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = living_target
			var/amt = 15 * allocated * (1-S.water_resist)
			if(amt>0)
				S.adjustToxLoss(amt)
				S.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")

		// Then extinguish people on fire.
		var/needed = living_target.fire_stacks * 5
		if(allocated > needed)
			living_target.ExtinguishMob()
		living_target.adjust_fire_stacks(-(allocated / 5))
		allocated -= needed
		. += needed

	var/effective = allocated || 10
	target.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (effective / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (effective / 10)))
	return . + ..()

/datum/reagent/water/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	//else
	M.adjust_hydration(removed * 10)
	..()
