/mob/living/simple_mob/animal/goliath
	name = "goliath"
	desc = "A massive beast that uses long tentacles to ensnare its prey, threatening them is not advised under any conditions."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "goliath"
	icon_living = "goliath"
	icon_dead = "goliath_dead"
	icon_gib = "syndicate_gib"

	maxHealth = 300
	health = 300
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1

	mob_class = MOB_CLASS_ANIMAL
	movement_cooldown = 10
	movement_sound = 'sound/weapons/heavysmash.ogg'
	special_attack_min_range = 2
	special_attack_max_range = 7
	special_attack_cooldown = 10 SECONDS

	response_harm = "harmlessly punches"
	melee_damage_lower = 18
	melee_damage_upper = 22

	attacktext = list ("pulverizes", "batters", "hammers")
	attack_sound = 'sound/weapons/punch1.ogg'

	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_VERY_STRONG
	pull_force = MOVE_FORCE_VERY_STRONG

	hide_type = /obj/item/stack/animalhide/goliath_hide
	exotic_type = /obj/item/stack/sinew
	meat_amount = 5
	bone_amount = 5
	hide_amount = 5
	exotic_amount = 5

	faction = "lavaland"
	speak_emote = list("bellows")
	say_list_type = /datum/say_list/goliath
	ai_holder_type = /datum/ai_holder/simple_mob/melee/goliath

	var/pre_attack = 0
	var/tentacle_warning = 0.5 SECONDS
	var/pre_attack_icon = "goliath2"

/datum/ai_holder/simple_mob/melee/goliath
	hostile = TRUE
	retaliate = TRUE
	mauling = TRUE

/datum/say_list/goliath
	emote_hear = list("flashes briefly.", "wails!", "shudders.", "trills.")
	emote_see = list ("glows faintly.", "rumbles.", "tenses up.")

/mob/living/simple_mob/animal/goliath/should_special_attack()
	. = ..()
	if(special_attack_cooldown <= world.time + special_attack_cooldown*0.25 && !pre_attack)
		pre_attack++
	if(!pre_attack || stat)
		return

/mob/living/simple_mob/animal/goliath/do_special_attack(atom/target)
	var/tturf = get_turf(target)
	if(!isturf(tturf))
		return
	if(get_dist(src, target) <= 7)//Screen range check, so you can't get tentacle'd offscreen
		visible_message("<span class='warning'>[src] digs its tentacles under [target]</span>")
		new /obj/effect/temporary_effect/goliath_tentacle/core(tturf, src)
		pre_attack = 0

//Lavaland Goliath

/mob/living/simple_mob/animal/goliath/Initialize(mapload)
	. = ..()
	if(prob(1))
		new /mob/living/simple_mob/animal/goliath/ancient(loc)
		return INITIALIZE_HINT_QDEL

/mob/living/simple_mob/animal/goliath/ancient
	name = "ancient goliath"
	desc = "Goliaths are biologically immortal, and rare specimens have survived for centuries. This one is clearly ancient, and its tentacles constantly churn the earth around it."
	maxHealth = 400
	health = 400
	var/list/cached_tentacle_turfs
	var/turf/last_location
	var/tentacle_recheck_cooldown = 100

//tentacles
/obj/effect/temporary_effect/goliath_tentacle
	name = "goliath tentacle"
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "goliath_tentacle_spawn"
	time_to_die = 7 SECONDS

/obj/effect/temporary_effect/goliath_tentacle/Initialize(mapload)
	. = ..()
	for(var/obj/effect/temporary_effect/goliath_tentacle/T in loc)
		if(T != src)
			return INITIALIZE_HINT_QDEL

	if(ismineralturf(loc))
		var/turf/simulated/mineral/M = loc
		M.GetDrilled()

/obj/effect/temporary_effect/goliath_tentacle/core/Initialize(mapload)
	. = ..()
	var/list/directions = list(1,2,4,6,8)
	for(var/i in 1 to 3)
		var/spawndir = pick_n_take(directions)
		var/turf/T = get_step(src, spawndir)
		if(T && !density)
			new /obj/effect/temporary_effect/goliath_tentacle(T)

/obj/effect/temporary_effect/goliath_tentacle/Crossed(atom/movable/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else
		trip(AM)

/obj/effect/temporary_effect/goliath_tentacle/proc/trip()
	var/latched = FALSE
	var/timerid = addtimer(CALLBACK(src, .proc/retract), 10, TIMER_STOPPABLE)
	for(var/mob/living/carbon/C in loc)
		if(C.stat == DEAD)
			continue
		visible_message("<span class='danger'>[src] grabs hold of [C]!</span>")
		tripanim()
		//var/mob/living/L
		C.slip()
		C.Stun(2)
		C.adjustBruteLoss(rand(15,20)) // Less stun more harm
		latched = TRUE
	for(var/obj/mecha/M in loc)
		M.take_damage(20, BRUTE, null, null, null, 25)
	if(!latched)
		retract()
	else
		deltimer(timerid)

/obj/effect/temporary_effect/goliath_tentacle/proc/tripanim()
	icon_state = "goliath_tentacle_wiggle"
	var/timerid = addtimer(CALLBACK(src, .proc/trip), 3, TIMER_STOPPABLE)
	deltimer(timerid)

/obj/effect/temporary_effect/goliath_tentacle/proc/retract()
	icon_state = "goliath_tentacle_retract"
	var/timerid = QDEL_IN(src, 7)
	deltimer(timerid)
