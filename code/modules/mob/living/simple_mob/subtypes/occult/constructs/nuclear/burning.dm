////////////////////////////
//		Burning Runner
////////////////////////////

/datum/category_item/catalogue/fauna/nuclear_spirits/burning
	name = "Burning Runner"
	desc = "A paranatural creature resembling a burning humanoid. \
	More energy then anything solid it aborbs heat into its body \
	however it has a low tolerance for kinectic energy and quickly \
	falls apart into a charred husk from blunt attacks. The Burning \
	Runner charges its foes fearlessly attempting to spread its blaze \
	to its victims. Perhaps it seeks to share its eternal agony."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/nuclear/burning
	name = "Burning Runner"
	real_name = "Burning Runner"
	desc = "The burning man shares its fire with all."
	icon_state = "burning"
	icon_living = "burning"
	icon_dead = "burning_dead"
	maxHealth = 50
	health = 50
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	attacktext = list("swipes")
	friendly = list("caresses")
	movement_cooldown = -1
	var/original_temp = null //Value to remember temp
	var/set_temperature = T0C + 250 //A bit above the smoke point of lard
	var/heating_power = 50000 //1/2 a Solar moth

	catalogue_data = list(/datum/category_item/catalogue/fauna/nuclear_spirits/burning)

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

	armor_legacy_mob = list( 				//Mob Gimmick, highly resistant to E weapons			//Mob Gimmick, absorbs normal burn damage,
				"melee" = -0,
				"bullet" = 0,
				"laser" = 80,
				"energy" = 80,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/nuclear/burning/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_ORANGE)
		return 1

/mob/living/simple_mob/construct/nuclear/burning/apply_melee_effects(mob/living/carbon/M, alien, removed)
	if(M.fire_stacks <= 2)
		M.adjust_fire_stacks(1)
		M.IgniteMob()

/mob/living/simple_mob/vore/solarmoth/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		var/datum/gas_mixture/env = loc.return_air() //Gets all the information on the local air.
		var/transfer_moles = 0.25 * env.total_moles //The bigger the room, the harder it is to heat the room.
		var/datum/gas_mixture/removed = env.remove(transfer_moles)
		var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
		if(heat_transfer > 0 && env.temperature < T0C + 200)	//This should start heating the room at a moderate pace up to 200 degrees celsius.
			heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater
			removed.adjust_thermal_energy(heat_transfer)

		else if(heat_transfer > 0 && env.temperature < set_temperature) //Set temperature is 250 degrees celsius. Heating rate should increase between 200 and 450 C.
			heating_power = original_temp*100
			heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater. Except it's hot, so yeah.
			removed.adjust_thermal_energy(heat_transfer)

		else
			return

		env.merge(removed)

	original_temp = heating_power
