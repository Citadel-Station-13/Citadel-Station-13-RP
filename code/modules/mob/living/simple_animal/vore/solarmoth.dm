/mob/living/simple_animal/retaliate/solarmoth
	name = "solarmoth"
	desc = "A majestic sparkling solarmoth. Also a slight engineering hazard."
	icon = 'icons/mob/solarmoth.dmi' //all of these are placeholders
	icon_state = "solarmoth"
	icon_living = "solarmoth"
	icon_dead = "solarmoth-dead"

	faction = "grubs"
	maxHealth = 500
	health = 500
	move_to_delay = 5

	melee_damage_lower = 1
	melee_damage_upper = 7

	speak_chance = 1
	emote_see = list("flutters")
	speed = 3

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	// solar moths are not affected by atmos
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	heat_damage_per_tick = 0 //Even if the atmos stuff doesn't work, at least it won't take any damage.

	armor = list(
				"melee" = 50,
				"bullet" = 90,
				"laser" = 90,
				"energy" = 90,
				"bomb" = 100,
				"bio" = 100,
				"rad" = 100)

	var/set_temperature = T0C + 5000	//Sets the target point of 5k degrees celsius
	var/heating_power = 50000		//This controls the strength at which it heats the environment.
	var/emp_heavy = 1
	var/emp_med = 2
	var/emp_light = 4
	var/emp_long = 5
	var/poison_per_bite = 5 //grubs cause a shock when they bite someone
	var/poison_type = "shockchem"
	var/poison_chance = 50
	var/emp_chance = 20 // Beware synths
//	isEdible = 0 //You can look, but you can't lick.



/mob/living/simple_animal/retaliate/solarmoth/PunchTarget()
	if(target_mob&& prob(emp_chance))
		target_mob.emp_act(4) //The weakest strength of EMP
		visible_message("<span class='danger'>The moth releases a powerful shock!</span>")
	..()

/mob/living/simple_animal/retaliate/solarmoth/PunchTarget()
	. = ..()
	if(isliving(.))
		var/mob/living/L = .
		if(L.reagents)
			if(prob(poison_chance))
				L << "<span class='warning'>You feel a shock rushing through your veins.</span>"
				L.reagents.add_reagent(poison_type, poison_per_bite)


/mob/living/simple_animal/retaliate/solarmoth/Life()
	. = ..()
	if(icon_state != icon_dead)
		var/datum/gas_mixture/env = loc.return_air() //Gets all the information on the local air.
		var/transfer_moles = 0.25 * env.total_moles //The bigger the room, the harder it is to heat the room.
		var/datum/gas_mixture/removed = env.remove(transfer_moles)
		var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
		if(heat_transfer > 0 && env.temperature < T0C + 350)	//This should start heating the room at a moderate pace up to 350 degrees celsius.
			heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater
			removed.add_thermal_energy(heat_transfer)

		else if(heat_transfer > 0 && env.temperature < set_temperature) //Set temperature is 5,000 degrees celsius. So this thing will start cooking crazy hot between the temperatures of 350C and 10,000C.
			heating_power = 9999999999 //FLAME ON! This will make the moth heat up the room at an incredible rate.
			heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater. Except it's hot, so yeah.
			removed.add_thermal_energy(heat_transfer)

		else
			return

		env.merge(removed)

var/global/list/moth_amount = list() //global moth list for the solargrub to read. Maybe want to transfer this to global variables file??
/mob/living/simple_animal/retaliate/solarmoth/New()
	moth_amount += src //when this thing is created, it adds itself to the global list
	. = ..()

/mob/living/simple_animal/retaliate/solarmoth/proc/explode()
	src.anchored = 0
	set_light(0)
	if(empulse(src, emp_heavy, emp_med, emp_light, emp_long))
		qdel(src)
	return

/mob/living/simple_animal/retaliate/solarmoth/death()
	explode()
	..()

/mob/living/simple_animal/retaliate/solarmoth/gib() //This baby will explode no matter what you do to it.
	explode()
	..()



/mob/living/simple_animal/retaliate/solarmoth/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(9.5, 1, COLOR_BLUE) //9.5 makes the brightness range super huge.
		return 1


/mob/living/simple_animal/retaliate/solarmoth //active noms
	vore_bump_chance = 50
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 0 //moths only eat incapacitated targets. It's too lazy burning you to a crisp to try to pounce you
	vore_default_mode = DM_DIGEST

