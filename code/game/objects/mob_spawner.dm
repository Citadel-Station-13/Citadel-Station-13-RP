////////////////////////////////////
//Mob spawner structure. This one is an on map structure that players can see, sometimes break.
////////////////////////////////////
/obj/structure/mob_spawner
	name = "mob spawner"
	desc = "This shouldn't be seen, yell at a dev."
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	anchored = 1

	var/last_spawn = 0
	var/spawn_delay = 10 MINUTES

	var/list/spawn_types = list(
	/mob/living/simple_mob/animal/passive/dog/corgi = 100,
	/mob/living/simple_mob/animal/passive/cat = 25
	)

	var/total_spawns = -1 //Total mob spawns, over all time, -1 for no limiteee
	var/simultaneous_spawns = 3 //Max spawned mobs active at one time
	var/mob_faction

	var/destructible = 0
	var/health = 50

	var/list/spawned_mobs = list()

/obj/structure/mob_spawner/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_spawn = world.time + rand(0,spawn_delay)

/obj/structure/mob_spawner/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/L in spawned_mobs)
		L.source_spawner = null
	spawned_mobs.Cut()
	return ..()

/obj/structure/mob_spawner/process()
	if(!can_spawn())
		return
	var/chosen_mob = choose_spawn()
	if(chosen_mob)
		do_spawn(chosen_mob)

/obj/structure/mob_spawner/proc/can_spawn()
	if(!total_spawns)
		return 0
	if(spawned_mobs.len >= simultaneous_spawns)
		return 0
	if(world.time < last_spawn + spawn_delay)
		return 0
	return 1

/obj/structure/mob_spawner/proc/choose_spawn()
	return pickweight(spawn_types)

/obj/structure/mob_spawner/proc/do_spawn(var/mob_path)
	if(!ispath(mob_path))
		return 0
	var/mob/living/L = new mob_path(get_turf(src))
	L.source_spawner = src
	spawned_mobs.Add(L)
	last_spawn = world.time
	if(total_spawns > 0)
		total_spawns--
	if(mob_faction)
		L.faction = mob_faction
	return L

/obj/structure/mob_spawner/proc/get_death_report(var/mob/living/L)
	if(L in spawned_mobs)
		spawned_mobs.Remove(L)

/obj/structure/mob_spawner/attackby(var/obj/item/I, var/mob/living/user)
	if(!I.force || I.item_flags & ITEM_NOBLUDGEON || !destructible)
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	visible_message("<span class='warning'>\The [src] has been [I.get_attack_verb(src, user)] with \the [I] by [user].</span>")
	take_damage(I.force)

/obj/structure/mob_spawner/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(destructible)
		take_damage(Proj.get_structure_damage())

/obj/structure/mob_spawner/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks apart!</span>")
		qdel(src)

/obj/structure/mob_spawner/clear_zlevel/can_spawn()
	if(!..())
		return 0
	var/turf/T = get_turf(src)
	if(!T)
		return 0
	for(var/mob/living/L in GLOB.player_list)
		var/turf/L_T
		if(L.stat == DEAD)
			continue
		L_T = get_turf(L)
		if(T.z == L_T.z)
			return 0
	return 1


/*
This code is based on the mob spawner and the proximity sensor, the idea is to lazy load mobs to avoid having the server use mobs when they arent needed.
It also makes it so a ghost wont know where all the goodies/mobs are.
*/

/obj/structure/mob_spawner/scanner
	name ="Lazy Mob Spawner"
	var/range = 10 //range in tiles from the spawner to detect moving stuff

/obj/structure/mob_spawner/scanner/process()
	if(!can_spawn())
		return
	if(world.time > last_spawn + spawn_delay)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range,mainloc))
			if ((A.faction != mob_faction) && (A.move_speed < 12))
				var/chosen_mob = choose_spawn()
				if(chosen_mob)
					do_spawn(chosen_mob)

//////////////
// Spawners //
/////////////

//Non-Scanners
/obj/structure/mob_spawner/goliath
	name = "Deep Warrens Rift"
	desc = "This hole leads deep underground. Although possibly large enough for you to enter, something seems to compel you not to. Occasionally, a deep, choral rumbling can be heard far below."
	icon_state = "tunnel_hole"
	spawn_delay = 20 MINUTES
	simultaneous_spawns = 1
	mob_faction = "lavaland"
	total_spawns = 6
	anchored = 1
	destructible = 1
	health = 500
	spawn_types = list(
	/mob/living/simple_mob/animal/goliath = 100
	)

/obj/structure/mob_spawner/gutshank
	name = "Gutshank Hive"
	desc = "This telltale pile of debris and hardened sand marks this as the entrance to a Gutshank hive."
	icon_state = "eggy_tunnel"
	spawn_delay = 10 MINUTES
	simultaneous_spawns = 3
	mob_faction = "lavaland"
	total_spawns = 12
	anchored = 1
	destructible = 1
	health = 400
	spawn_types = list(
	/mob/living/simple_mob/animal/gutshank = 100
	)

/obj/structure/mob_spawner/stormdrifter
	name = "Violent Downdraft"
	desc = "The air here seems especially hot. A swirling wind agitates the ash and sand, kicking up eddies and small dust devils."
	icon_state = "punch"
	spawn_delay = 10 MINUTES
	simultaneous_spawns = 6
	mob_faction = "lavaland"
	total_spawns = 12
	anchored = 1
	destructible = 1
	health = 1000
	spawn_types = list(
	/mob/living/simple_mob/animal/stormdrifter = 60,
	/mob/living/simple_mob/animal/stormdrifter/bull = 30
	)

//Scanners
/obj/structure/mob_spawner/scanner/corgi
	name = "Corgi Lazy Spawner"
	desc = "This is a proof of concept, not sure why you would use this one"
	spawn_delay = 3 MINUTES
	mob_faction = "Corgi"
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/dog/corgi = 75,
	/mob/living/simple_mob/animal/passive/dog/corgi/puppy = 50
	)

	simultaneous_spawns = 5
	range = 7
	destructible = 1
	health = 200
	total_spawns = 100

/obj/structure/mob_spawner/scanner/wild_animals
	name = "Wilderness Lazy Spawner"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "wild animal"
	total_spawns = -1
	destructible = 0
	anchored = 1
	invisibility = 101
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/gaslamp = 20,
//	/mob/living/simple_mob/otie/feral = 10,
	/mob/living/simple_mob/vore/aggressive/dino/virgo3b = 5,
	/mob/living/simple_mob/vore/aggressive/dragon/virgo3b = 1
	)

/obj/structure/mob_spawner/scanner/xenos
	name = "Xenomorph Egg"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "xeno"
	total_spawns = -1
	destructible = 1
	health = 50
	anchored = 1
	icon = 'icons/screen/actions/actions.dmi'
	icon_state = "alien_egg"
	spawn_types = list(
	/mob/living/simple_mob/animal/space/alien/drone = 20,
	/mob/living/simple_mob/animal/space/alien = 10,
	/mob/living/simple_mob/animal/space/alien/sentinel = 5,
	/mob/living/simple_mob/animal/space/alien/queen = 1
	)

/obj/structure/mob_spawner/scanner/xenos/royal
	name = "Royal Xenomorph Egg"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "xeno"
	total_spawns = 1
	destructible = 1
	health = 50
	anchored = 1
	icon = 'icons/screen/actions/actions.dmi'
	icon_state = "alien_egg"
	spawn_types = list(
	/mob/living/simple_mob/animal/space/alien/queen = 5
	)

////////////////////////////////////
//Invisible mob spawner. This one spawns mobs until depleted. Often used in caves.
////////////////////////////////////
/obj/mob_spawner
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

/obj/mob_spawner/Initialize(mapload)
	. = ..()

	if(!LAZYLEN(mobs_to_pick_from))
		log_world("Mob spawner at [x],[y],[z] ([get_area(src)]) had no mobs_to_pick_from set on it!")
		return INITIALIZE_HINT_QDEL
	START_PROCESSING(SSobj, src)

/obj/mob_spawner/process()
	if(my_mob && my_mob.stat != DEAD)
		return //No need

	if(LAZYLEN(loc.human_mobs(world.view)))
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
				my_mob.minbodytemp = env.temperature * 0.8
				my_mob.maxbodytemp = env.temperature * 1.2

				var/list/gaslist = env.gas
				my_mob.min_oxy = gaslist[/datum/gas/oxygen] * 0.8
				my_mob.min_tox = gaslist[/datum/gas/phoron] * 0.8
				my_mob.min_n2 = gaslist[/datum/gas/nitrogen] * 0.8
				my_mob.min_co2 = gaslist[/datum/gas/carbon_dioxide] * 0.8
				my_mob.max_oxy = gaslist[/datum/gas/oxygen] * 1.2
				my_mob.max_tox = gaslist[/datum/gas/phoron] * 1.2
				my_mob.max_n2 = gaslist[/datum/gas/nitrogen] * 1.2
				my_mob.max_co2 = gaslist[/datum/gas/carbon_dioxide] * 1.2
		return
	else
		STOP_PROCESSING(SSobj, src)
		depleted = TRUE
		return

/obj/mob_spawner/carp
	name = "Carp Spawner"
	prob_fall = 15
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1
	)

/obj/mob_spawner/carp/small
	prob_fall = 30
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1,
	)

/obj/mob_spawner/carp/hard
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp/large = 2,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1
	)

/obj/mob_spawner/carp/medium
	prob_fall = 10
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 5,
		/mob/living/simple_mob/animal/space/carp/large = 2
	)

/obj/mob_spawner/carp/large
	name = "Carp Horde Spawner"
	prob_fall = 10
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 8,
		/mob/living/simple_mob/animal/space/carp/large = 3,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1
	)

/obj/mob_spawner/derelict
	name = "Derelict random mob spawner"
	faction = "derelict"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 2,
		/mob/living/simple_mob/mechanical/infectionbot = 3,
		/mob/living/simple_mob/mechanical/combat_drone = 1
	)

/obj/mob_spawner/derelict/corrupt_maint_swarm
	name = "Derelict maint swarm"
	faction = "derelict"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 4
	)

/obj/mob_spawner/derelict/mech_wizard
	name = "Derelict wizard"
	faction = "derelict"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/technomancer_golem = 2
	)

/obj/mob_spawner/hound_spawner
	name = "Corrupt Hound Spawner"
	prob_fall = 50
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1
		)

/obj/mob_spawner/drone_spawner
	name = "Drone Swarm Spawner"
	prob_fall = 10
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 3
	)

/obj/mob_spawner/alien
	name = "Alien Spawner"
	prob_fall = 10
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 1
	)

/obj/mob_spawner/alien/easy
	name = "Easy Alien Spawner"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 1,
		/mob/living/simple_mob/animal/space/alien/drone = 2,
		/mob/living/simple_mob/animal/space/alien/sentinel = 1,
	)

/obj/mob_spawner/alien/medium
	name = "Medium Alien Spawner"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 2,
		/mob/living/simple_mob/animal/space/alien/drone = 3,
		/mob/living/simple_mob/animal/space/alien/sentinel = 2,
		/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 1
	)

/obj/mob_spawner/alien/hard
	name = "Hard Alien Spawner"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/alien = 4,
		/mob/living/simple_mob/animal/space/alien/sentinel = 4,
		/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 2
	)

/obj/structure/mob_spawner/scanner/corgi
	name = "Corgi Lazy Spawner"
	desc = "This is a proof of concept, not sure why you would use this one"
	spawn_delay = 3 MINUTES
	mob_faction = "Corgi"
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/dog/corgi = 75,
	/mob/living/simple_mob/animal/passive/dog/corgi/puppy = 50
	)

	simultaneous_spawns = 5
	range = 7
	destructible = 1
	health = 200
	total_spawns = 100

/obj/structure/mob_spawner/scanner/wild_animals
	name = "Wilderness Lazy Spawner"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "wild animal"
	total_spawns = -1
	destructible = 0
	anchored = 1
	invisibility = 101
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/gaslamp = 20,
//	/mob/living/simple_mob/otie/feral = 10,
	/mob/living/simple_mob/vore/aggressive/dino/virgo3b = 5,
	/mob/living/simple_mob/vore/aggressive/dragon/virgo3b = 1
	)

/obj/structure/mob_spawner/scanner/xenos
	name = "Xenomorph Egg"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "xeno"
	total_spawns = -1
	destructible = 1
	health = 50
	anchored = 1
	icon = 'icons/screen/actions/actions.dmi'
	icon_state = "alien_egg"
	spawn_types = list(
	/mob/living/simple_mob/animal/space/alien/drone = 20,
	/mob/living/simple_mob/animal/space/alien = 10,
	/mob/living/simple_mob/animal/space/alien/sentinel = 5,
	/mob/living/simple_mob/animal/space/alien/queen = 1
	)

/obj/structure/mob_spawner/scanner/xenos/royal
	name = "Royal Xenomorph Egg"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "xeno"
	total_spawns = 1
	destructible = 1
	health = 50
	anchored = 1
	icon = 'icons/screen/actions/actions.dmi'
	icon_state = "alien_egg"
	spawn_types = list(
	/mob/living/simple_mob/animal/space/alien/queen = 5,
	)
