/datum/category_item/catalogue/fauna/goliath/goliaths
	name = "Goliaths"
	desc = "The Goliath is native to KT-943, known commonly as Surt. Powerful and long-lived, early \
	NanoTrasen mining operations struggled to contend with these hardy beasts. Due to overhunting and \
	a presumed ecological disaster resulting from off-world exposure to contaminants, Goliaths were \
	classified as extinct. Recent seismic activity has since opened up fissures in the surface of \
	KT-943 which have provided fresh insights into the Goliath life cycle. Archaeological records \
	suggest the Goliath's form has not changed for millenia, implying that it is a 'perfect' lifeform\
	for its environment, akin to sharks and alligators on Old Earth."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/goliath)

/datum/category_item/catalogue/fauna/all_goliaths
	name = "Collection - Goliaths"
	desc = "You have scanned Goliaths at different parts of their life cycle, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/goliath,
		/datum/category_item/catalogue/fauna/goliath/calf,
		/datum/category_item/catalogue/fauna/goliath/ancient,
		/datum/category_item/catalogue/fauna/goliath/goliaths
		)

/datum/category_item/catalogue/fauna/goliath
	name = "Goliath"
	desc = "The common Goliath is easily recognizable. As KT-943's only known apex predator, it has left a \
	lasting impression on NanoTrasen miners and engineers. Goliaths are bulky quadrupeds with thick, leathery \
	hides which protect them from KT-943's volcanic atmosphere. At some point they evolved ambulatory tendrils \
	which are used primarly for hunting and mating. These tendrils are able to regenerate if severed, although \
	this process takes some time. Due to the way they employ their tendrils as weapons, it is difficult to \
	retain live specimens in captivity."
	value = CATALOGUER_REWARD_MEDIUM

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
	var/tentacle_warning = 3 SECONDS
	var/pre_attack_icon = "goliath2"
	var/breedable = 0
	var/pregnant = 0
	var/child_type = /mob/living/simple_mob/animal/goliath/calf

/datum/ai_holder/simple_mob/melee/goliath
	hostile = TRUE
	retaliate = TRUE
	mauling = TRUE

/datum/ai_holder/simple_mob/melee/goliath/calf
	hostile = TRUE
	retaliate = TRUE
	mauling = FALSE
	can_flee = TRUE

/datum/say_list/goliath
	emote_hear = list("flashes briefly.", "wails!", "shudders.", "trills.")
	emote_see = list ("glows faintly.", "rumbles.", "tenses up.")

/mob/living/simple_mob/animal/goliath/should_special_attack()
	. = ..()
	if(special_attack_cooldown <= world.time + special_attack_cooldown*0.25 && !pre_attack)
		pre_attack++
		update_icon()
	if(!pre_attack || stat)
		return

/mob/living/simple_mob/animal/goliath/do_special_attack(atom/target)
	var/tturf = get_turf(target)
	if(!isturf(tturf))
		return
	if(buckled)
		return
	if(get_dist(src, target) <= 7)//Screen range check, so you can't get tentacle'd offscreen
		visible_message("<span class='warning'>[src] digs its tentacles under [target]</span>")
		sleep(tentacle_warning)
		new /obj/effect/temporary_effect/goliath_tentacle/core(tturf, src)
		pre_attack = 0
		update_icon()

/mob/living/simple_mob/animal/goliath/update_icon()
	. = ..()
	if(!pre_attack && !stat)
		icon_state = initial(icon_state)
	else if(pre_attack && !stat)
		icon_state = pre_attack_icon


/mob/living/simple_mob/animal/goliath/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(prob(1))
		new /mob/living/simple_mob/animal/goliath/ancient(loc)
		return INITIALIZE_HINT_QDEL

/mob/living/simple_mob/animal/goliath/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/seeds/ashlander/bentars) && !breedable)
		to_chat(user, "<span class='danger'>You feed the [src] bentar seeds! Its tendrils begin to thrash softly!</span>")
		breedable = 1
		qdel(O)
	else
		return ..()

/mob/living/simple_mob/animal/goliath/proc/find_mate(var/mob/living/simple_mob/animal/goliath/G)
	for(var/mob/living/L in view(4,src))
		if(istype(L, /mob/living/simple_mob/animal/goliath))
			visible_message("<span class='warning'>The [src] seems to be performing some kind of dance using its tendrils.</span>")
			mate()
		else
			return

/mob/living/simple_mob/animal/goliath/proc/mate()
	visible_message("<span class='warning'>The [src] intertwines its tendrils with the goliath!</span>")
	pregnant = 1
	breedable = 0

/mob/living/simple_mob/animal/goliath/process(delta_time)
	if(breedable)
		find_mate()
	if(pregnant >= 1)
		pregnant += rand(0,2)
	if(pregnant >= 100)
		calve()

/mob/living/simple_mob/animal/goliath/proc/calve()
	visible_message("<span class='warning'>The [src] disgorges a small calf from a large fissure in its back!</span>")
	pregnant = 0
	new child_type(get_turf(src))

/mob/living/simple_mob/animal/goliath/death()
	STOP_PROCESSING(SSobj, src)
	return ..()

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

/obj/effect/temporary_effect/goliath_tentacle/core_weak/Initialize(mapload)
	. = ..()
	var/list/directions = list(1,2,4,6,8)
	for(var/i in 1 to 2)
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
	var/timerid = addtimer(CALLBACK(src, .proc/retract), 5, TIMER_STOPPABLE)
	for(var/mob/living/carbon/C in loc)
		if(C.stat == DEAD)
			continue
		visible_message("<span class='danger'>[src] grabs hold of [C]!</span>")
		tripanim()
		C.Stun(2)
		C.adjustBruteLoss(rand(5,10))
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

//Ancients
/datum/category_item/catalogue/fauna/goliath/ancient
	name = "Ancient Goliath"
	desc = "Goliaths are immortal, and the dating of several notable specimens confirms that some Goliaths \
	have been around for centuries. These truly ancient beasts possess a sharpened instinct. As Goliaths \
	age, their mineral intake passes into their hide, increasing its strength without sacrificing flexibility. \
	Due to this phenomena, Ancient Goliaths are considerably more resilient than their younger kin."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/goliath/ancient
	name = "ancient goliath"
	desc = "Goliaths are biologically immortal, and rare specimens have survived for centuries. This one is clearly ancient, and its tentacles constantly churn the earth around it."
	maxHealth = 400
	health = 400
	tentacle_warning = 1 SECOND

//Calves
/datum/category_item/catalogue/fauna/goliath/calf
	name = "Goliath Calf"
	desc = "Until recently, the nature by which Goliaths reproduced was unknown. Observation of Ashlander \
	farmers, however, has confirmed that Goliaths reproduce sexually, and give birth to calves. These young \
	beasts come out of the womb fully capable of movement and some limited level of self defense. Although \
	they possess an innate control over their tendrils, calves lack the muscle development to utilize all of them, \
	or to use them as effectively as mature specimens can. This does not make them less of a threat."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/goliath/calf
	name = "goliath calf"
	desc = "Goliaths may be naturally immortal, but they are still vulnerable. Calves are a rare sight on the surface, although they are becoming more common as Ashlander farms appear more frequently."
	icon_state = "goliath_baby"
	maxHealth = 150
	health = 150

	movement_cooldown = 7
	special_attack_min_range = 1
	special_attack_max_range = 4
	special_attack_cooldown = 15 SECONDS

	response_harm = "kicks"
	melee_damage_lower = 8
	melee_damage_upper = 15

	meat_amount = 1
	bone_amount = 2
	hide_amount = 2
	exotic_amount = 2

	ai_holder_type = /datum/ai_holder/simple_mob/melee/goliath/calf

	var/amount_grown = 1
	var/spawn_delay = 300
	var/list/grow_as = list(/mob/living/simple_mob/animal/goliath)

/mob/living/simple_mob/animal/goliath/calf/do_special_attack(atom/target)
	var/tturf = get_turf(target)
	if(!isturf(tturf))
		return
	if(get_dist(src, target) <= 7)//Screen range check, so you can't get tentacle'd offscreen
		visible_message("<span class='warning'>[src] digs its tentacles under [target]</span>")
		new /obj/effect/temporary_effect/goliath_tentacle/core_weak(tturf, src)
		pre_attack = 0

/mob/living/simple_mob/animal/goliath/calf/process(delta_time)
	if(amount_grown >= 0)
		amount_grown += rand(0,2)
	if(amount_grown >= 100)
		mature()

/mob/living/simple_mob/animal/goliath/calf/proc/mature()
	var/spawn_type = pick(grow_as)
	new spawn_type(src.loc, src)
	qdel(src)

/*
//Warning: I have copied my attempt and moved it down here. This needs more testing. It had some pretty annoying issues, and it's just really goddamn clunky.
Issues:
[] Retract did not fire correctly on this new system, causing tendrils to just disappear.
[] The core tendril would not match the others in terms of icon updating/looping.
[] Tendrils would sometimes loop animations for no discernable reason.

//Tentacles
//Okay so this shit got really convoluted really fast. Basically after lots of testing and iteration, the system here approximates an inutitive tendril system (on the player side.)
//It's kinda a nightmare, but basically, there are "Pre Tentacles" and "Tentacles".
//Pre Tentacles have no cross effect and are used to telegraph the spawn location.
//Tentacles do what you think they would for Goliaths, naturally.
//We also have Cores, which determine where Tentacles spawn. I changed this to spawn pre-tentacles, which themselves spawn the actual tentacles.
//Weak Cores are just nerfed cores for baby Goliaths to use.

//Current issues with this sytem:

/obj/effect/temporary_effect/goliath_tentacle_pre
	name = "goliath tentacle"
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "goliath_tentacle_pre"
	time_to_die = 0.5 SECONDS //Matches the original (unused) tentacle_warning variable at 0.5 Seconds.

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
			new /obj/effect/temporary_effect/goliath_tentacle_pre(T)

/obj/effect/temporary_effect/goliath_tentacle/core_weak/Initialize(mapload)
	. = ..()
	var/list/directions = list(1,2,4,6,8)
	for(var/i in 1 to 2)
		var/spawndir = pick_n_take(directions)
		var/turf/T = get_step(src, spawndir)
		if(T && !density)
			new /obj/effect/temporary_effect/goliath_tentacle_pre(T)

/obj/effect/temporary_effect/goliath_tentacle_pre/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	spawn(time_to_die) //I originally had this as spawn(rand(1,time_to_die)), which resulted in some interesting behavior. Maybe investigate this as a special thingy later?
		qdel(src)
		new /obj/effect/temporary_effect/goliath_tentacle(T)

/obj/effect/temporary_effect/goliath_tentacle/Crossed(atom/movable/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else
		trip(AM)

/obj/effect/temporary_effect/goliath_tentacle/proc/trip()
	var/latched = FALSE
	var/timerid = addtimer(CALLBACK(src, .proc/retract), 5, TIMER_STOPPABLE)
	for(var/mob/living/carbon/C in loc)
		if(C.stat == DEAD)
			continue
		visible_message("<span class='danger'>[src] grabs hold of [C]!</span>")
		tripanim()
		C.Stun(2)
		C.adjustBruteLoss(rand(5,10))
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
*/
