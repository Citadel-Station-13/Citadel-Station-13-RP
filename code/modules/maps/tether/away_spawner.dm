/////////////////////////////
/obj/tether_away_spawner
	name = "RENAME ME, JERK"
	desc = "Spawns the mobs!"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101
	mouse_opacity = 0
	density = 0
	anchored = 1

	//Weighted with values (not %chance, but relative weight)
	//Can be left value-less for all equally likely
	var/list/mobs_to_pick_from

	//When the below chance fails, the spawner is marked as depleted and stops spawning
	var/prob_spawn = 100	//Chance of spawning a mob whenever they don't have one
	var/prob_fall = 5		//Above decreases by this much each time one spawns

	//Settings to help mappers/coders have their mobs do what they want in this case
	var/faction				//To prevent infighting if it spawns various mobs, set a faction
	var/atmos_comp			//TRUE will set all their survivability to be within 20% of the current air
	//var/guard				//# will set the mobs to remain nearby their spawn point within this dist

	//Internal use only
	var/mob/living/simple_mob/my_mob
	var/depleted = FALSE

/obj/tether_away_spawner/Initialize(mapload)
	. = ..()

	if(!LAZYLEN(mobs_to_pick_from))
		log_world("Mob spawner at [x],[y],[z] ([get_area(src)]) had no mobs_to_pick_from set on it!")
		return INITIALIZE_HINT_QDEL
	START_PROCESSING(SSobj, src)

/obj/tether_away_spawner/process()
	if(my_mob && my_mob.stat != DEAD)
		return //No need

	for(var/mob/living/L in view(src,world.view))
		if(L.client)
			return //I'll wait.

	if(prob(prob_spawn))
		prob_spawn -= prob_fall
		var/picked_type = pickweight(mobs_to_pick_from)
		my_mob = new picked_type(get_turf(src))
		my_mob.low_priority = TRUE

		if(faction)
			my_mob.faction = faction

		if(atmos_comp)
			var/turf/T = get_turf(src)
			var/datum/gas_mixture/env = T.return_air()
			if(env)
				if(my_mob.minbodytemp > env.temperature)
					my_mob.minbodytemp = env.temperature * 0.8
				if(my_mob.maxbodytemp < env.temperature)
					my_mob.maxbodytemp = env.temperature * 1.2

				var/list/gaslist = env.gas
				if(my_mob.min_oxy)
					my_mob.min_oxy = gaslist[/datum/gas/oxygen] * 0.8
				if(my_mob.min_tox)
					my_mob.min_tox = gaslist[/datum/gas/phoron] * 0.8
				if(my_mob.min_n2)
					my_mob.min_n2 = gaslist[/datum/gas/nitrogen] * 0.8
				if(my_mob.min_co2)
					my_mob.min_co2 = gaslist[/datum/gas/carbon_dioxide] * 0.8
				if(my_mob.max_oxy)
					my_mob.max_oxy = gaslist[/datum/gas/oxygen] * 1.2
				if(my_mob.max_tox)
					my_mob.max_tox = gaslist[/datum/gas/phoron] * 1.2
				if(my_mob.max_n2)
					my_mob.max_n2 = gaslist[/datum/gas/nitrogen] * 1.2
				if(my_mob.max_co2)
					my_mob.max_co2 = gaslist[/datum/gas/carbon_dioxide] * 1.2
		return
	else
		STOP_PROCESSING(SSobj, src)
		depleted = TRUE
		return

//Shadekin spawner. Could have them show up on any mission, so it's here.
//Make sure to put them away from others, so they don't get demolished by rude mobs.
/obj/tether_away_spawner/shadekin
	name = "Shadekin Spawner"
	icon = 'icons/mob/vore_shadekin.dmi'
	icon_state = "spawner"

	faction = "shadekin"
	prob_spawn = 1
	prob_fall = 1
	//guard = 10 //Don't wander too far, to stay alive.
	mobs_to_pick_from = list(
		/mob/living/simple_mob/shadekin
	)
