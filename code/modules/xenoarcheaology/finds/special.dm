//endless reagents!
/obj/item/reagent_containers/glass/replenishing
	var/spawning_id

/obj/item/reagent_containers/glass/replenishing/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	spawning_id = pick("blood","holywater","lube","stoxin","ethanol","ice","glycerol","fuel","cleaner")

/obj/item/reagent_containers/glass/replenishing/process(delta_time)
	reagents.add_reagent(spawning_id, 0.3)

//a talking gas mask!
/obj/item/clothing/mask/gas/poltergeist
	var/list/heard_talk = list()
	var/last_twitch = 0
	var/max_stored_messages = 100

/obj/item/clothing/mask/gas/poltergeist/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/gas/poltergeist/process(delta_time)
	if(heard_talk.len && istype(loc, /mob/living) && prob(10))
		var/mob/living/M = loc
		M.say(pick(heard_talk))

/obj/item/clothing/mask/gas/poltergeist/hear_talk(mob/M as mob, text)
	..()
	if(heard_talk.len > max_stored_messages)
		heard_talk.Remove(pick(heard_talk))
	heard_talk.Add(text)
	if(istype(loc, /mob/living) && world.time - last_twitch > 50)
		last_twitch = world.time

//a vampiric statuette
//todo: cult integration
/obj/item/vampiric
	name = "statuette"
	icon_state = "statuette1"
	icon = 'icons/obj/xenoarchaeology.dmi'
	var/charges = 0
	var/list/nearby_mobs = list()
	var/last_bloodcall = 0
	var/bloodcall_interval = 50
	var/last_eat = 0
	var/eat_interval = 100
	var/wight_check_index = 1
	var/list/shadow_wights = list()

/obj/item/vampiric/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/vampiric/process(delta_time)
	//see if we've identified anyone nearby
	if(world.time - last_bloodcall > bloodcall_interval && nearby_mobs.len)
		var/mob/living/carbon/human/M = pop(nearby_mobs)
		if(M in view(7,src) && M.health > 20)
			if(prob(50))
				bloodcall(M)
				nearby_mobs.Add(M)

	//suck up some blood to gain power
	if(world.time - last_eat > eat_interval)
		var/obj/effect/debris/cleanable/blood/B = locate() in range(2,src)
		if(B)
			last_eat = world.time
			B.loc = null
			if(istype(B, /obj/effect/debris/cleanable/blood/drip))
				charges += 0.25
			else
				charges += 1
				playsound(loc, 'sound/effects/splat.ogg', 50, 1, -3)

	//use up stored charges
	if(charges >= 10)
		charges -= 10
		new /obj/effect/spider/eggcluster(pick(RANGE_TURFS(1, src)))

	if(charges >= 3)
		if(prob(5))
			charges -= 1
			var/spawn_type = pick(/mob/living/simple_mob/creature)
			new spawn_type(pick(RANGE_TURFS(1, src)))
			playsound(loc, pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'), 50, 1, -3)

	if(charges >= 1)
		if(shadow_wights.len < 5 && prob(5))
			shadow_wights.Add(new /obj/effect/shadow_wight(get_turf(src)))
			playsound(loc, 'sound/effects/ghost.ogg', 50, 1, -3)
			charges -= 0.1

	if(charges >= 0.1)
		if(prob(5))
			visible_message(SPAN_WARNING("[icon2html(thing = src, target = world)] [src]'s eyes glow ruby red for a moment!"))
			charges -= 0.1

	//check on our shadow wights
	if(shadow_wights.len)
		wight_check_index++
		if(wight_check_index > shadow_wights.len)
			wight_check_index = 1

		var/obj/effect/shadow_wight/W = shadow_wights[wight_check_index]
		if(isnull(W))
			shadow_wights.Remove(wight_check_index)
		else if(isnull(W.loc))
			shadow_wights.Remove(wight_check_index)
		else if(get_dist(W, src) > 10)
			shadow_wights.Remove(wight_check_index)

/obj/item/vampiric/hear_talk(mob/M as mob, text)
	..()
	if(world.time - last_bloodcall >= bloodcall_interval && (M in view(7, src)))
		bloodcall(M)

/obj/item/vampiric/proc/bloodcall(var/mob/living/carbon/human/M)
	last_bloodcall = world.time
	if(istype(M))
		playsound(loc, pick('sound/hallucinations/wail.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/far_noise.ogg'), 50, 1, -3)
		nearby_mobs.Add(M)

		var/target = pick(M.organs_by_name)
		M.apply_damage(rand(5, 10), BRUTE, target)
		to_chat(M, "<font color='red'>The skin on your [parse_zone(target)] feels like it's ripping apart, and a stream of blood flies out.</font>")
		var/obj/effect/debris/cleanable/blood/splatter/animated/B = new(M.loc)
		B.target_turf = pick(range(1, src))
		B.blood_DNA = list()
		B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		M.vessel.remove_reagent("blood",rand(25,50))

//animated blood 2 SPOOKY
/obj/effect/debris/cleanable/blood/splatter/animated
	var/turf/target_turf
	var/loc_last_process

/obj/effect/debris/cleanable/blood/splatter/animated/Initialize(mapload)
	. = ..()
	loc_last_process = loc
	START_PROCESSING(SSobj, src)

/obj/effect/debris/cleanable/blood/splatter/animated/process(delta_time)
	if(target_turf && loc != target_turf)
		step_towards(src,target_turf)
		if(loc == loc_last_process)
			target_turf = null
		loc_last_process = loc

		//leave some drips behind
		if(prob(50))
			var/obj/effect/debris/cleanable/blood/drip/D = new(loc)
			D.blood_DNA = blood_DNA.Copy()
			if(prob(50))
				D = new(loc)
				D.blood_DNA = blood_DNA.Copy()
				if(prob(50))
					D = new(loc)
					D.blood_DNA = blood_DNA.Copy()
	else
		..()

/obj/effect/shadow_wight
	name = "shadow wight"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	density = 1

/obj/effect/shadow_wight/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/shadow_wight/process(delta_time)
	if(loc)
		loc = get_turf(pick(orange(1,src)))
		var/mob/living/carbon/M = locate() in loc
		if(M)
			playsound(loc, pick('sound/hallucinations/behind_you1.ogg',\
			'sound/hallucinations/behind_you2.ogg',\
			'sound/hallucinations/i_see_you1.ogg',\
			'sound/hallucinations/i_see_you2.ogg',\
			'sound/hallucinations/im_here1.ogg',\
			'sound/hallucinations/im_here2.ogg',\
			'sound/hallucinations/look_up1.ogg',\
			'sound/hallucinations/look_up2.ogg',\
			'sound/hallucinations/over_here1.ogg',\
			'sound/hallucinations/over_here2.ogg',\
			'sound/hallucinations/over_here3.ogg',\
			'sound/hallucinations/turn_around1.ogg',\
			'sound/hallucinations/turn_around2.ogg',\
			), 50, 1, -3)
			M.Sleeping(rand(5, 10))
			loc = null
	else
		STOP_PROCESSING(SSobj, src)

/obj/effect/shadow_wight/Bump(atom/obstacle)
	. = ..()
	to_chat(obstacle, "<font color='red'>You feel a chill run down your spine!</font>")
