

// Underdark mob spawners
/obj/tether_away_spawner/underdark_drone_swarm
	name = "Underdark Drone Swarm Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 3,
	)

/obj/tether_away_spawner/underdark_normal
	name = "Underdark Normal Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/giant_spider/hunter = 3,
		/mob/living/simple_mob/animal/giant_spider/phorogenic/weak = 3,
		/mob/living/simple_mob/animal/giant_spider/tunneler = 3,
	)

/obj/tether_away_spawner/underdark_hard
	name = "Underdark Hard Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 3,
		/mob/living/simple_mob/vore/aggressive/rat/phoron = 6,
	)

/obj/tether_away_spawner/underdark_boss
	name = "Underdark Boss Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	//guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/dragon = 1
	)


//Mechbay
/obj/mecha/working/ripley/abandoned/Initialize(mapload)
	. = ..()
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)	//Deletes the beacon so it can't be found easily
		qdel(B)
