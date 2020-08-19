//Mob Spawners for D-Class Worlds
/obj/triumph_away_spawner/D/hound_spawner
	name = "Underdark Hard Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1
		)

/obj/triumph_away_spawner/D/drone_spawner
	name = "D World Drone Swarm Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 3,
	)

/obj/triumph_away_spawner/D/alien_easy
	name = "D World Easy Alien Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 1,
		/mob/living/simple_mob/animal/space/alien/drone = 2,
		/mob/living/simple_mob/animal/space/alien/sentinel = 1,
	)

/obj/triumph_away_spawner/D/alien_medium
	name = "D World Medium Alien Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 2,
		/mob/living/simple_mob/animal/space/alien/drone = 3,
		/mob/living/simple_mob/animal/space/alien/sentinel = 2,
		/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 1,
	)

/obj/triumph_away_spawner/D/alien_hard
	name = "D World Hard Alien Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 4,
		/mob/living/simple_mob/animal/space/alien/sentinel = 4,
		/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 2,
	)

/obj/triumph_away_spawner/D/carp_small
	name = "D World Carp Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1,
	)

/obj/triumph_away_spawner/D/carp_medium
	name = "D World Carp Medium Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 5,
		/mob/living/simple_mob/animal/space/carp/large = 2,
	)

/obj/triumph_away_spawner/D/carp_large
	name = "D World Carp Horde Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 8,
		/mob/living/simple_mob/animal/space/carp/large = 3,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1,
	)
