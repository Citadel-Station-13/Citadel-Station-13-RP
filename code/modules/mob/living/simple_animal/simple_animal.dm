// Resists out of things.
// Sometimes there are times you want SAs to be buckled to something, so override this for when that is needed.
/mob/living/simple_mob/proc/handle_resist()
	resist()

// Peforms the random walk wandering
/mob/living/simple_mob/proc/handle_wander_movement()
	if(isturf(src.loc) && !resting && !buckled && canmove) //Physically capable of moving?
		lifes_since_move++ //Increment turns since move (turns are life() cycles)
		if(lifes_since_move >= turns_per_move)
			if(!(stop_when_pulled && pulledby)) //Some animals don't move when pulled
				var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
				moving_to = pick(cardinal)
				dir = moving_to			//How about we turn them the direction they are moving, yay.
				var/turf/T = get_step(src,moving_to)
				if(avoid_turf(T))
					return
				Move(T)
				lifes_since_move = 0

// Checks to see if mob doesn't like this kind of turf
/mob/living/simple_mob/proc/avoid_turf(var/turf/turf)
	if(!turf)
		return TRUE //Avoid the nothing, yes

	if(istype(turf,/turf/simulated/sky))
		return TRUE //Mobs aren't that stupid, probably

	return FALSE //Override it on stuff to adjust

// Handles random chatter, called from Life() when stance = STANCE_IDLE
/mob/living/simple_mob/proc/handle_idle_speaking()
	if(rand(0,200) < speak_chance)
		if(speak && speak.len)
			if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
				var/length = speak.len
				if(emote_hear && emote_hear.len)
					length += emote_hear.len
				if(emote_see && emote_see.len)
					length += emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= speak.len)
					try_say_list(speak)
				else
					randomValue -= speak.len
					if(emote_see && randomValue <= emote_see.len)
						visible_emote("[pick(emote_see)].")
					else
						audible_emote("[pick(emote_hear)].")
			else
				try_say_list(speak)
		else
			if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				visible_emote("[pick(emote_see)].")
			if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
				audible_emote("[pick(emote_hear)].")
			if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				var/length = emote_hear.len + emote_see.len
				var/pick = rand(1,length)
				if(pick <= emote_see.len)
					visible_emote("[pick(emote_see)].")
				else
					audible_emote("[pick(emote_hear)].")

// Handle interacting with and taking damage from atmos
// TODO - Refactor this to use handle_environment() like a good /mob/living
/mob/living/simple_mob/proc/handle_atmos()
	var/atmos_unsuitable = 0

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)

			if( abs(Environment.temperature - bodytemperature) > 40 )
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy)
				if(Environment.gas[/datum/gas/oxygen] < min_oxy)
					atmos_unsuitable = 1
			if(max_oxy)
				if(Environment.gas[/datum/gas/oxygen] > max_oxy)
					atmos_unsuitable = 1
			if(min_tox)
				if(Environment.gas[/datum/gas/phoron] < min_tox)
					atmos_unsuitable = 2
			if(max_tox)
				if(Environment.gas[/datum/gas/phoron] > max_tox)
					atmos_unsuitable = 2
			if(min_n2)
				if(Environment.gas[/datum/gas/nitrogen] < min_n2)
					atmos_unsuitable = 1
			if(max_n2)
				if(Environment.gas[/datum/gas/nitrogen] > max_n2)
					atmos_unsuitable = 1
			if(min_co2)
				if(Environment.gas[/datum/gas/carbon_dioxide] < min_co2)
					atmos_unsuitable = 1
			if(max_co2)
				if(Environment.gas[/datum/gas/carbon_dioxide] > max_co2)
					atmos_unsuitable = 1

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
		if(fire)
			fire.icon_state = "fire1"
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
		if(fire)
			fire.icon_state = "fire2"
	else
		fire_alert = 0
		if(fire)
			fire.icon_state = "fire0"

	if(atmos_unsuitable)
		adjustBruteLoss(unsuitable_atoms_damage)
		if(oxygen)
			oxygen.icon_state = "oxy1"
	else if(oxygen)
		if(oxygen)
			oxygen.icon_state = "oxy0"

// For setting the stance WITHOUT processing it
/mob/living/simple_mob/proc/set_stance(var/new_stance)
	stance = new_stance
	stance_changed = world.time
	ai_log("set_stance() changing to [new_stance]",2)

// For proccessing the current stance, or setting and processing a new one
/mob/living/simple_mob/proc/handle_stance(var/new_stance)
	if(ai_inactive)
		stance = STANCE_IDLE
		return

	if(new_stance)
		set_stance(new_stance)

	switch(stance)
		if(STANCE_IDLE)
			target_mob = null
			a_intent = INTENT_HELP
			annoyed = max(0,annoyed--)

			//Yes I'm breaking this into two if()'s for ease of reading
			//If we ARE ALLOWED TO
			if(returns_home && home_turf && !astarpathing && (world.time - stance_changed) > 10 SECONDS)
				if(get_dist(src,home_turf) > wander_distance)
					move_to_delay = initial(move_to_delay)*2 //Walk back.
					GoHome()
				else
					stop_automated_movement = 0

			//Search for targets while idle
			if(hostile || specific_targets)
				FindTarget()
		if(STANCE_FOLLOW)
			annoyed = 15
			FollowTarget()
			if(follow_until_time && world.time > follow_until_time)
				LoseFollow()
				return
			if(hostile || specific_targets)
				FindTarget()
		if(STANCE_ATTACK)
			annoyed = 50
			a_intent = INTENT_HARM
			RequestHelp()
			MoveToTarget()
		if(STANCE_ATTACKING)
			annoyed = 50
			AttackTarget()

/mob/living/simple_mob/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_mob/gib()
	..(icon_gib,1,icon) // we need to specify where the gib animation is stored

/mob/living/simple_mob/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

/mob/living/simple_mob/bullet_act(var/obj/item/projectile/Proj)
	ai_log("bullet_act() I was shot by: [Proj.firer]",2)

	/* VOREStation Edit - Ace doesn't like bonus SA damage.
	//Projectiles with bonus SA damage
	if(!Proj.nodamage)
		if(!Proj.SA_vulnerability || Proj.SA_vulnerability == intelligence_level)
			Proj.damage += Proj.SA_bonus_damage
	*/ // VOREStation Edit End
	. = ..()

	if(Proj.firer)
		react_to_attack(Proj.firer)

// When someone clicks us with an empty hand
/mob/living/simple_mob/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(INTENT_HELP)
			if (health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")

		if(INTENT_DISARM)
			M.visible_message("<span class='notice'>[M] [response_disarm] \the [src].</span>")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(INTENT_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return
			if(!incapacitated(INCAPACITATION_ALL) && (stance != STANCE_IDLE) && prob(grab_resist))
				M.visible_message("<span class='warning'>[M] tries to grab [src] but fails!</span>")
				return

			var/obj/item/grab/G = new /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = M

			M.visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			M.do_attack_animation(src)
			ai_log("attack_hand() I was grabbed by: [M]",2)
			react_to_attack(M)

		if(INTENT_HARM)
			var/armor = run_armor_check(def_zone = null, attack_flag = "melee")
			apply_damage(damage = harm_intent_damage, damagetype = BURN, def_zone = null, blocked = armor, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE)
			M.visible_message("<span class='warning'>[M] [response_harm] \the [src]!</span>")
			M.do_attack_animation(src)
			ai_log("attack_hand() I was hit by: [M]",2)
			react_to_attack(M)

	return

// When somoene clicks us with an item in hand
/mob/living/simple_mob/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(health < getMaxHealth())
				if(MED.amount >= 1)
					adjustBruteLoss(-MED.heal_brute)
					MED.amount -= 1
					if(MED.amount <= 0)
						qdel(MED)
					for(var/mob/M in viewers(src, null))
						if ((M.client && !( M.blinded )))
							M.show_message("<span class='notice'>[user] applies the [MED] on [src].</span>")
		else
			var/datum/gender/T = gender_datums[src.get_visible_gender()]
			to_chat(user, "<span class='notice'>\The [src] is dead, medical items won't bring [T.him] back to life.</span>") // the gender lookup is somewhat overkill, but it functions identically to the obsolete gender macros and future-proofs this code
	if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/material/knife) || istype(O, /obj/item/material/knife/butch))
			harvest(user)
	else
		ai_log("attackby() I was weapon'd by: [user]",2)
		if(O.force)
			react_to_attack(user)

	return ..()

/mob/living/simple_mob/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	//Animals can't be stunned(?)
	if(O.damtype == HALLOSS)
		effective_force = 0
	if(supernatural && istype(O,/obj/item/nullrod))
		effective_force *= 2
		purge = 3
	if(O.force <= resistance)
		to_chat(user,"<span class='danger'>This weapon is ineffective, it does no damage.</span>")
		return 2

	ai_log("hit_with_weapon() I was h_w_weapon'd by: [user]",2)
	react_to_attack(user)

	. = ..()

// When someone throws something at us
/mob/living/simple_mob/hitby(atom/movable/AM)
	..()
	if(AM.thrower)
		react_to_attack(AM.thrower)

//SA vs SA basically
/mob/living/simple_mob/attack_generic(var/mob/attacker)
	if(attacker)
		react_to_attack(attacker)
	return ..()

/mob/living/simple_mob/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed

	if(force_max_speed)
		return -3

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.haste) && M.haste == TRUE)
			return -3
		if(!isnull(M.slowdown))
			tally += M.slowdown

	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	if(m_intent == "walk")
		tally *= 1.5

	return tally+config_legacy.animal_delay

/mob/living/simple_mob/Stat()
	..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / getMaxHealth()) * 100)]%")

/mob/living/simple_mob/lay_down()
	..()
	if(resting && icon_rest)
		icon_state = icon_rest
	else
		icon_state = icon_living
	update_icon()

/mob/living/simple_mob/death(gibbed, deathmessage = "dies!")
	density = 0 //We don't block even if we did before
	walk(src, 0) //We stop any background-processing walks
	resting = 0 //We can rest in peace later.

	if(faction_friends.len)
		faction_friends -= src

	if(loot_list.len) //Drop any loot
		for(var/path in loot_list)
			if(prob(loot_list[path]))
				new path(get_turf(src))

	spawn(3) //We'll update our icon in a sec
		update_icon()

	return ..(gibbed,deathmessage)

/mob/living/simple_mob/ex_act(severity)
	if(!blinded)
		flash_eyes()
	var/armor = run_armor_check(def_zone = null, attack_flag = "bomb")
	var/bombdam = 500
	switch (severity)
		if (1.0)
			bombdam = 500
		if (2.0)
			bombdam = 60
		if (3.0)
			bombdam = 30

	apply_damage(damage = bombdam, damagetype = BRUTE, def_zone = null, blocked = armor, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE)

	if(bombdam > maxHealth)
		gib()

// Check target_mob if worthy of attack (i.e. check if they are dead or empty mecha)
/mob/living/simple_mob/proc/SA_attackable(target_mob)
	ai_log("SA_attackable([target_mob])",3)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(L.stat != DEAD)
			return 1
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return 1
	ai_log("SA_attackable([target_mob]): no",3)
	return FALSE

/mob/living/simple_mob/say(var/message,var/datum/language/language)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_mob/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_mob/put_in_hands(var/obj/item/W) // No hands.
	if(has_hands)
		put_in_active_hand(W)
		return 1
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_mob/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()

/mob/living/simple_mob/handle_fire()
	return
/mob/living/simple_mob/update_fire()
	return
/mob/living/simple_mob/IgniteMob()
	return
/mob/living/simple_mob/ExtinguishMob()
	return

//We got hit! Consider hitting them back!
/mob/living/simple_mob/proc/react_to_attack(var/mob/living/M)
	if(ai_inactive || stat || M == target_mob) return //Not if we're dead or already hitting them
	if(M in friends || M.faction == faction) return //I'll overlook it THIS time...
	ai_log("react_to_attack([M])",1)
	if(retaliate && set_target(M, 1))
		handle_stance(STANCE_ATTACK)
		return M

	return FALSE

/mob/living/simple_mob/proc/set_target(var/mob/M, forced = 0)
	ai_log("SetTarget([M])",2)
	if(!M || (world.time - last_target_time < 5 SECONDS) && target_mob)
		ai_log("SetTarget() can't set it again so soon",3)
		return FALSE

	var/turf/seen = get_turf(M)

	if(investigates && (annoyed < 10))
		try_say_list(say_maybe_target)
		face_atom(seen)
		annoyed += 14
		sleep(1 SECOND) //For realism

	if(forced || (M in ListTargets(view_range)))
		try_say_list(say_got_target)
		target_mob = M
		last_target_time = world.time
		return M
	else if(investigates)
		spawn(1)
			WanderTowards(seen)

	return FALSE

// Set a follow target, with optional time for how long to follow them.
/mob/living/simple_mob/proc/set_follow(var/mob/M, var/follow_for = 0)
	ai_log("SetFollow([M]) for=[follow_for]",2)
	if(!M || (world.time - last_target_time < 4 SECONDS) && follow_mob)
		ai_log("SetFollow() can't set it again so soon",3)
		return FALSE

	follow_mob = M
	last_follow_time = world.time
	follow_until_time = !follow_for ? 0 : world.time + follow_for
	return 1

//Scan surroundings for a valid target
/mob/living/simple_mob/proc/FindTarget()
	var/atom/T = null
	for(var/atom/A in ListTargets(view_range))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break
		else if(specific_targets)
			return FALSE

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if(L.alpha <= EFFECTIVE_INVIS)
				continue
			else if(!SA_attackable(L))
				continue
			else if(!special_target_check(L))
				continue
			else
				T = L
				break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if(!SA_attackable(M))
				continue
			else if(!special_target_check(M))
				continue
			if((M.occupant.faction != src.faction) || attack_same)
				T = M
				break

	//You found one!
	if(T)
		ai_log("FindTarget() found [T]!",1)
		if(set_target(T))
			handle_stance(STANCE_ATTACK)

	return T

//Used for special targeting or reactions
/mob/living/simple_mob/proc/Found(var/atom/A)
	return

// Used for somewhat special targeting, but not to the extent of using Found()
/mob/living/simple_mob/proc/special_target_check(var/atom/A)
	return TRUE

//Requesting help from like-minded individuals
/mob/living/simple_mob/proc/RequestHelp()
	if(!cooperative || ((world.time - last_helpask_time) < 10 SECONDS))
		return

	ai_log("RequestHelp() to [faction_friends.len] friends",2)
	last_helpask_time = world.time
	for(var/mob/living/simple_mob/F in faction_friends)
		if(F == src) continue
		if(get_dist(src,F) <= F.assist_distance)
			spawn(0)
				if(F) //They could have died by now and some mobs delete themselves on death
					ai_log("RequestHelp() to [F]",3)
					F.HelpRequested(src)

//Someone wants help?
/mob/living/simple_mob/proc/HelpRequested(var/mob/living/simple_mob/F)
	if(target_mob || stat)
		ai_log("HelpRequested() by [F] but we're busy/dead",2)
		return
	if(get_dist(src,F) <= follow_dist)
		ai_log("HelpRequested() by [F] but we're already here",2)
		return
	if(get_dist(src,F) <= view_range)
		ai_log("HelpRequested() by [F] and within targetshare range",2)
		if(F.target_mob && set_target(F.target_mob))
			handle_stance(STANCE_ATTACK)
			return

	if(set_follow(F, 10 SECONDS))
		handle_stance(STANCE_FOLLOW)

// Can be used to conditionally do a ranged or melee attack.
// Note that the SA must be able to do an attack at the specified range or else it may get trapped in a loop of switching
// between STANCE_ATTACK and STANCE_ATTACKING, due to being told by MoveToTarget() that they're in range but being told by AttackTarget() that they're not.
/mob/living/simple_mob/proc/ClosestDistance()
	return ranged ? shoot_range - 1 : 1 // Shoot range -1 just because we don't want to constantly get kited

//Move to a target (or near if we're ranged)
/mob/living/simple_mob/proc/MoveToTarget()
	if(incapacitated(INCAPACITATION_DISABLED))
		ai_log("MoveToTarget() Bailing because we're disabled",2)
		return

	//If we were chasing someone and we can't anymore, give up.
	if(!target_mob || !SA_attackable(target_mob))
		ai_log("MoveToTarget() Losing target at top",2)
		LoseTarget()
		return

	//Don't wander
	stop_automated_movement = 1
	move_to_delay = initial(move_to_delay)

	//We recompute our path every time we're called if we can still see them
	if(target_mob in ListTargets(view_range))

		//Recompute the path if we were using one since we can still see them.
		if(astarpathing)
			ForgetPath()

		//Find out where we're getting to
		var/get_to = ClosestDistance()
		var/distance = get_dist(src,target_mob)
		ai_log("MoveToTarget() [src] get_to: [get_to] distance: [distance]",2)

		//We're here!
		if(distance <= get_to)
			ai_log("MoveToTarget() [src] attack range",2)
			handle_stance(STANCE_ATTACKING)
			return

		//We're just setting out, making a new path, or we can't path with A*
		if(!walk_list.len)
			ai_log("SA: MoveToTarget() pathing to [target_mob]",2)

			//GetPath failed for whatever reason, just smash into things towards them
			if(run_at_them || !GetPath(get_turf(target_mob),get_to))

				//We try the built-in way to stay close
				walk_to(src, target_mob, get_to, move_to_delay)
				ai_log("MoveToTarget() walk_to([src],[target_mob],[get_to],[move_to_delay])",3)

				//Break shit in their direction! LEME SMAHSH
				var/dir_to_mob = get_dir(src,target_mob)
				face_atom(target_mob)
				DestroySurroundings(dir_to_mob)
				ai_log("MoveToTarget() DestroySurroundings([get_dir(src,target_mob)])",3)

		//We have a path! We aren't already pathing it!
		if(!astarpathing && walk_list.len)
			ai_log("MoveToTarget() going to start a path",2)
			spawn(1)

				//Do the path!
				var/result = WalkPath(target_thing = target_mob, target_dist = get_to)
				ai_log("MoveToTarget() WalkPath r:[result]",2)

				//WalkPath failed, either interrupted for recalc, or something else
				if(!result)
					return

				//WalkPath either got close enough or we ran out of path
				else
					spawn(1)
						ai_log("MoveToTarget() resetting",2)
						MoveToTarget()

	//We can't see them, and we don't have a path we're trying to follow to find them
	else if(!astarpathing)
		ai_log("MoveToTarget() Losing target at bottom",2)
		LoseTarget() //Just forget it.

//Follow a target (and don't attempt to murder it horribly)
/mob/living/simple_mob/proc/FollowTarget()
	ai_log("FollowTarget() [follow_mob]",1)
	stop_automated_movement = 1
	//If we were chasing someone and we can't anymore, give up.
	if(!follow_mob || follow_mob.stat)
		ai_log("FollowTarget() Losing follow at top",2)
		LoseFollow()
		return

	if(incapacitated(INCAPACITATION_DISABLED))
		ai_log("FollowTarget() Bailing because we're disabled",2)
		LoseFollow()
		return

	if((get_dist(src,follow_mob) <= follow_dist))
		ai_log("FollowTarget() Already at target",2)
		return

	move_to_delay = initial(move_to_delay)
	var/start_distance = get_dist(src,follow_mob)

	//Bad pathing
	if(run_at_them)
		walk_to(src, follow_mob, follow_dist, move_to_delay)
		ai_log("FollowTarget() walk_to([src],[target_mob],2,[move_to_delay])",3)
		spawn(3 SECONDS)
			if(src && follow_mob && (stance == STANCE_FOLLOW) && (get_dist(src,follow_mob) >= start_distance))
				ai_log("FollowTarget() walk_to not making headway, giving up",3)
				LoseFollow()

	//Good pathing
	else
		GetPath(get_turf(follow_mob),follow_dist)
		if(!astarpathing && walk_list.len)
			spawn(1)
				ai_log("FollowTarget() A* path getting underway",2)
				//Do the path!
				var/result = WalkPath(target_thing = follow_mob, target_dist = follow_dist)
				ai_log("FollowTarget() WalkPath r:[result]",3)

		else
			ai_log("FollowTarget() GetPath can't path, giving up",3)
			LoseFollow()

//Just try one time to go look at something. Don't really focus much on it.
/mob/living/simple_mob/proc/WanderTowards(var/turf/T)
	if(!T) return
	ai_log("WanderTowards() [T.x],[T.y]",1)

	stop_automated_movement = 1
	GetPath(T,1)

	if(run_at_them || !walk_list.len)
		ai_log("WanderTowards() walk_to getting underway",2)
		walk_to(src, T, 1, move_to_delay)
	else
		if(!astarpathing)
			spawn(1)
				ai_log("WanderTowards() A* path getting underway",2)
				WalkPath(target_thing = T, target_dist = 1)

//A* now, try to a path to a target
/mob/living/simple_mob/proc/GetPath(var/turf/target,var/get_to = 1,var/max_distance = world.view*6)
	ai_log("GetPath([target],[get_to],[max_distance])",2)
	ForgetPath()
	var/list/new_path = AStar(get_turf(loc), target, astar_adjacent_proc, /turf/proc/Distance, min_target_dist = get_to, max_node_depth = max_distance, id = myid, exclude = obstacles)

	if(new_path && new_path.len)
		walk_list = new_path
		if(path_display)
			for(var/turf/T in walk_list)
				T.overlays |= path_overlay
	else
		return FALSE

	return walk_list.len

//Walk along our A* path, target_thing allows us to stop early if we're nearby
/mob/living/simple_mob/proc/WalkPath(var/atom/target_thing, var/target_dist = 1, var/proc/steps_callback = null, var/every_steps = 4)
	ai_log("WalkPath() (steps:[walk_list.len])",2)
	if(!walk_list || !walk_list.len)
		return

	astarpathing = 1
	var/step_count = 0
	var/failed_steps = 0
	while(1)
		//We're supposed to stop
		if(!astarpathing || incapacitated(INCAPACITATION_DISABLED))
			astarpathing = 0
			ai_log("WalkPath() was interrupted",2)
			return FALSE
		//Finished the path
		if(!walk_list.len)
			astarpathing = 0
			ai_log("WalkPath() exited naturally",2)
			return 1
		if(failed_steps >= 3)
			astarpathing = 0
			ai_log("WalkPath() failed too many steps",2)
			return FALSE

		//Take a step
		if(!MoveOnce())
			ai_log("WalkPath() failed a step",3)
			failed_steps++
		else
			ai_log("WalkPath() took a step",3)
			failed_steps = 0
			step_count++

		//If we have a particular target we care about, look for them
		if(target_thing && (get_dist(src,target_thing) <= target_dist))
			ai_log("WalkPath() returning due to proximity",2)
			return target_thing

		//If we have a callback
		if(steps_callback && (step_count >= every_steps))
			ai_log("WalkPath() doing callback",3)
			call(steps_callback)()

		//And wait for the time to our next step
		sleep(move_to_delay)

//Take one step along a path
/mob/living/simple_mob/proc/MoveOnce()
	if(!walk_list.len)
		return

	if(path_display)
		var/turf/T = src.walk_list[1]
		T.overlays -= path_overlay

	step_towards(src, src.walk_list[1])
	if(src.loc != src.walk_list[1])
		ai_log("MoveOnce() step_towards returning 0",3)
		return FALSE
	else
		walk_list -= src.walk_list[1]
		ai_log("MoveOnce() step_towards returning 1",3)
		return 1

//Forget the path entirely
/mob/living/simple_mob/proc/ForgetPath()
	ai_log("ForgetPath()",2)
	if(path_display)
		for(var/turf/T in walk_list)
			T.overlays -= path_overlay
	astarpathing = 0
	walk_list.Cut()

//Giving up on moving
/mob/living/simple_mob/proc/GiveUpMoving()
	ai_log("GiveUpMoving()",1)
	ForgetPath()
	walk(src, 0)
	stop_automated_movement = 0

//Return home, all-in-one proc (though does target scan and drop out if they see one)
/mob/living/simple_mob/proc/GoHome()
	if(!home_turf) return
	if(astarpathing) ForgetPath()
	ai_log("GoHome()",1)
	var/close_enough = 2
	var/look_in = 50
	if(GetPath(home_turf,close_enough,look_in))
		stop_automated_movement = 1
		spawn(1)
			if(WalkPath()) //If we made it without interruption
				ai_log("GoHome() got home",2)
				GiveUpMoving() //Go back to wandering

//Get into attack mode on a target
/mob/living/simple_mob/proc/AttackTarget()
	stop_automated_movement = 1
	if(incapacitated(INCAPACITATION_DISABLED))
		ai_log("AttackTarget() Bailing because we're disabled",2)
		LoseTarget()
		return FALSE
	if(!target_mob || !SA_attackable(target_mob) || (target_mob.alpha <= EFFECTIVE_INVIS)) //if the target went invisible, you can't follow it
		LoseTarget()
		return FALSE
	if(!(target_mob in ListTargets(view_range)))
		LostTarget()
		return FALSE

	ai_log("AttackTarget() vs. [target_mob]",1)
	var/distance = get_dist(src, target_mob)
	face_atom(target_mob)

	//Hadoooooken!
	if(prob(spattack_prob) && (distance >= spattack_min_range) && (distance <= spattack_max_range))
		ai_log("AttackTarget() special",3)
		if(SpecialAtkTarget()) //Might not succeed/be allowed, do something else.
			return 1
	//AAAAH!
	if(distance <= 1)
		ai_log("AttackTarget() melee",3)
		PunchTarget()
		return 1
	//Open fire!
	else if(ranged && (distance <= shoot_range))
		ai_log("AttackTarget() ranged",3)
		ShootTarget(target_mob)
		return 1
	//They ran away!
	else
		ai_log("AttackTarget() out of range!",3)
		stoplag(1) // Unfortunately this is needed to protect from ClosestDistance() sometimes not updating fast enough to prevent an infinite loop.
		handle_stance(STANCE_ATTACK)
		return FALSE

//Attack the target in melee
/mob/living/simple_mob/proc/PunchTarget()
	if(!Adjacent(target_mob))
		return
	if(!canClick())
		return
	setClickCooldown(get_attack_speed())
//	if(!client)
//		sleep(rand(melee_attack_minDelay, melee_attack_maxDelay))
	if(isliving(target_mob))
		var/mob/living/L = target_mob

		if(prob(melee_miss_chance))
			add_attack_logs(src,L,"Animal-attacked (miss)", admin_notify = FALSE)
			visible_message("<span class='danger'>[src] misses [L]!</span>")
			do_attack_animation(src)
			return L
		else
			DoPunch(L)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		DoPunch(M)
		return M

// This is the actual act of 'punching'.  Override for special behaviour.
/mob/living/simple_mob/proc/DoPunch(var/atom/A)
	if(!Adjacent(A) && !istype(A, /obj/structure/window) && !istype(A, /obj/machinery/door/window)) // They could've moved in the meantime. But a Window probably wouldn't have. This allows player simple-mobs to attack windows.
		return FALSE

	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	// SA attacks can be blocked with shields.
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.check_shields(damage = damage_to_do, damage_source = src, attacker = src, def_zone = null, attack_text = "the attack"))
			return FALSE

	if(A.attack_generic(src, damage_to_do, pick(attacktext), attack_armor_type, attack_armor_pen, attack_sharp, attack_edge) && attack_sound)
		playsound(src, attack_sound, 75, 1)

	return TRUE

//The actual top-level ranged attack proc
/mob/living/simple_mob/proc/ShootTarget()
	if(!canClick())
		return FALSE

	setClickCooldown(get_attack_speed())

	var/target = target_mob
	var/tturf = get_turf(target)

	if((firing_lines && !client) && !CheckFiringLine(tturf))
		step_rand(src)
		face_atom(tturf)
		return FALSE

	visible_message("<span class='danger'><b>[src]</b> fires at [target]!</span>")
	if(rapid)
		spawn(1)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(4)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(6)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
	else
		Shoot(target, src.loc, src)
		if(casingtype)
			new casingtype

	return TRUE

//Check firing lines for faction_friends (if we're not cooperative, we don't care)
/mob/living/simple_mob/proc/CheckFiringLine(var/turf/tturf)
	if(!tturf) return

	var/turf/list/crosses = list()
	var/this_turf = get_turf(src)

	while(this_turf != tturf)
		this_turf = get_step(this_turf,get_dir(this_turf,tturf))
		crosses += this_turf

	for(var/mob/living/FF in faction_friends)
		if(FF.loc in crosses)
			return FALSE

	for(var/mob/living/F in friends)
		if(F.loc in crosses)
			return FALSE

	return 1

//Special attacks, like grenades or blinding spit or whatever
/mob/living/simple_mob/proc/SpecialAtkTarget()
	return FALSE

//Shoot a bullet at someone
/mob/living/simple_animal/proc/Shoot(atom/target, atom/start, mob/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(user.loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return

//	if (!istype(target, /turf))
//		qdel(A)
//		return
	A.old_style_target(target)
	A.fire()

//We can't see the target
/mob/living/simple_mob/proc/LoseTarget()
	ai_log("LoseTarget() [target_mob]",2)
	target_mob = null
	handle_stance(STANCE_IDLE)
	GiveUpMoving()

//Target is no longer valid (?)
/mob/living/simple_mob/proc/LostTarget()
	handle_stance(STANCE_IDLE)
	GiveUpMoving()

//Forget a follow mode
/mob/living/simple_mob/proc/LoseFollow()
	ai_log("LoseFollow() [target_mob]",2)
	stop_automated_movement = 0
	follow_mob = null
	handle_stance(STANCE_IDLE)
	GiveUpMoving()

// Makes the simple mob stop everything.  Useful for when it get stunned.
/mob/living/simple_mob/proc/Disable()
	ai_log("Disable() [target_mob]",2)
	spawn(0)
		LoseTarget()
		LoseFollow()

/mob/living/simple_mob/Stun(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_mob/AdjustStunned(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_mob/Weaken(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_mob/AdjustWeakened(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_mob/Paralyse(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_mob/AdjustParalysis(amount)
	if(amount > 0)
		Disable()
	..(amount)

//Find me some targets
/mob/living/simple_mob/proc/ListTargets(var/dist = view_range)
	var/list/L = hearers(src, dist)

	for(var/obj/mecha/M in mechas_list)
		if ((M.z == src.z) && (get_dist(src, M) <= dist) && (isInSight(src,M)))
			L += M

	return L

//Break through windows/other things
/mob/living/simple_mob/proc/DestroySurroundings(var/direction)
	if(!direction)
		direction = pick(cardinal) //FLAIL WILDLY

	var/turf/problem_turf = get_step(src, direction)

	ai_log("DestroySurroundings([direction])",3)
	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	for(var/obj/structure/window/obstacle in problem_turf)
		if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
			ai_log("DestroySurroundings() directional window hit",3)
			obstacle.attack_generic(src, damage_to_do, pick(attacktext))
			return
		else if(obstacle.is_fulltile())
			ai_log("DestroySurroundings() full tile window hit",3)
			obstacle.attack_generic(src, damage_to_do, pick(attacktext))
			return

	var/obj/structure/obstacle = locate(/obj/structure, problem_turf)
	if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
		ai_log("DestroySurroundings() generic structure hit [obstacle]",3)
		obstacle.attack_generic(src, damage_to_do, pick(attacktext))
		return

	for(var/obj/machinery/door/baddoor in problem_turf) //Required since firelocks take up the same turf
		if(baddoor.density)
			ai_log("DestroySurroundings() door hit [baddoor]",3)
			baddoor.attack_generic(src, damage_to_do, pick(attacktext))
			return

//Check for shuttle bumrush
/mob/living/simple_mob/proc/check_horde()
	return FALSE
	if(SSemergencyshuttle.shuttle.location)
		if(!enroute && !target_mob)	//The shuttle docked, all monsters rush for the escape hallway
			if(!shuttletarget && escape_list.len) //Make sure we didn't already assign it a target, and that there are targets to pick
				shuttletarget = pick(escape_list) //Pick a shuttle target
			enroute = 1
			stop_automated_movement = 1
			spawn()
				if(!src.stat)
					horde()

		if(get_dist(src, shuttletarget) <= 2)		//The monster reached the escape hallway
			enroute = 0
			stop_automated_movement = 0

//Shuttle bumrush
/mob/living/simple_mob/proc/horde()
	var/turf/T = get_step_to(src, shuttletarget)
	for(var/atom/A in T)
		if(istype(A,/obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/D = A
			D.open(1)
		else if(istype(A,/obj/structure/simple_door))
			var/obj/structure/simple_door/D = A
			if(D.density)
				D.Open()
		else if(istype(A,/obj/structure/cult/pylon))
			A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper))
		else if(istype(A, /obj/structure/window) || istype(A, /obj/structure/closet) || istype(A, /obj/structure/table) || istype(A, /obj/structure/grille))
			A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper))
	Move(T)
	FindTarget()
	if(!target_mob || enroute)
		spawn(10)
			if(!src.stat)
				horde()

//Touches a wire, etc
/mob/living/simple_mob/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	shock_damage *= max(siemens_coeff - shock_resistance, 0)
	if (shock_damage < 1)
		return FALSE

	apply_damage(damage = shock_damage, damagetype = BURN, def_zone = null, blocked = null, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE)
	playsound(loc, "sparks", 50, 1, -1)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

//Shot with taser/stunvolver
/mob/living/simple_mob/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	if(taser_kill)
		var/stunDam = 0
		var/agonyDam = 0
		var/armor = run_armor_check(def_zone = null, attack_flag = "energy")

		if(stun_amount)
			stunDam += stun_amount * 0.5
			apply_damage(damage = stunDam, damagetype = BURN, def_zone = null, blocked = armor, blocked = resistance, used_weapon = used_weapon, sharp = FALSE, edge = FALSE)

		if(agony_amount)
			agonyDam += agony_amount * 0.5
			apply_damage(damage = agonyDam, damagetype = BURN, def_zone = null, blocked = armor, blocked = resistance, used_weapon = used_weapon, sharp = FALSE, edge = FALSE)

/mob/living/simple_mob/emp_act(severity)
	if(!isSynthetic())
		return
	switch(severity)
		if(1)
			adjustFireLoss(rand(15, 25))
		if(2)
			adjustFireLoss(rand(10, 18))
		if(3)
			adjustFireLoss(rand(5, 12))
		if(4)
			adjustFireLoss(rand(1, 6))

/mob/living/simple_mob/getarmor(def_zone, attack_flag)
	var/armorval = armor[attack_flag]
	if(!armorval)
		return FALSE
	else
		return armorval
/*
// Force it to target something
/mob/living/simple_mob/proc/taunt(var/mob/living/new_target, var/forced = FALSE)
	if(intelligence_level == SA_HUMANOID && !forced)
		return
	set_target(new_target)
*/
/mob/living/simple_mob/is_sentient()
	return intelligence_level != SA_PLANT && intelligence_level != SA_ROBOTIC

// Hand procs for player-controlled SA's
/mob/living/simple_mob/swap_hand()
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"
	return
/*
/mob/living/simple_mob/put_in_active_hand(var/obj/item/I)
	if(!has_hands || !istype(I))
		return
*/
//Puts the item into our active hand if possible. returns 1 on success.
/mob/living/simple_mob/put_in_active_hand(var/obj/item/W)
	if(!has_hands)
		return FALSE
	return (hand ? put_in_l_hand(W) : put_in_r_hand(W))

/mob/living/simple_mob/put_in_l_hand(var/obj/item/W)
	if(!..() || l_hand)
		return FALSE
	W.forceMove(src)
	l_hand = W
	W.equipped(src,slot_l_hand)
	W.add_fingerprint(src)
	update_inv_l_hand()
	return TRUE

/mob/living/simple_mob/put_in_r_hand(var/obj/item/W)
	if(!..() || r_hand)
		return FALSE
	W.forceMove(src)
	r_hand = W
	W.equipped(src,slot_r_hand)
	W.add_fingerprint(src)
	update_inv_r_hand()
	return TRUE

/mob/living/simple_mob/update_inv_r_hand()
	if(QDESTROYING(src))
		return

	if(r_hand)
		r_hand.screen_loc = ui_rhand	//TODO

		//determine icon state to use
		var/t_state
		if(r_hand.item_state_slots && r_hand.item_state_slots[slot_r_hand_str])
			t_state = r_hand.item_state_slots[slot_r_hand_str]
		else if(r_hand.item_state)
			t_state = r_hand.item_state
		else
			t_state = r_hand.icon_state

		//determine icon to use
		var/icon/t_icon
		if(r_hand.item_icons && (slot_r_hand_str in r_hand.item_icons))
			t_icon = r_hand.item_icons[slot_r_hand_str]
		else if(r_hand.icon_override)
			t_state += "_r"
			t_icon = r_hand.icon_override
		else
			t_icon = INV_R_HAND_DEF_ICON

		//apply color
		var/image/standing = image(icon = t_icon, icon_state = t_state)
		standing.color = r_hand.color

		r_hand_sprite = standing

	else
		r_hand_sprite = null

	update_icon()

/mob/living/simple_mob/update_inv_l_hand()
	if(QDESTROYING(src))
		return

	if(l_hand)
		l_hand.screen_loc = ui_lhand	//TODO

		//determine icon state to use
		var/t_state
		if(l_hand.item_state_slots && l_hand.item_state_slots[slot_l_hand_str])
			t_state = l_hand.item_state_slots[slot_l_hand_str]
		else if(l_hand.item_state)
			t_state = l_hand.item_state
		else
			t_state = l_hand.icon_state

		//determine icon to use
		var/icon/t_icon
		if(l_hand.item_icons && (slot_l_hand_str in l_hand.item_icons))
			t_icon = l_hand.item_icons[slot_l_hand_str]
		else if(l_hand.icon_override)
			t_state += "_l"
			t_icon = l_hand.icon_override
		else
			t_icon = INV_L_HAND_DEF_ICON

		//apply color
		var/image/standing = image(icon = t_icon, icon_state = t_state)
		standing.color = l_hand.color

		l_hand_sprite = standing

	else
		l_hand_sprite = null

	update_icon()

//If they can or cannot use tools/machines/etc
/mob/living/simple_mob/IsAdvancedToolUser()
	return has_hands

/mob/living/simple_mob/proc/IsHumanoidToolUser(var/atom/tool)
	if(!humanoid_hands)
		var/display_name = null
		if(tool)
			display_name = tool
		else
			display_name = "object"
		to_chat(src, "<span class='danger'>Your [hand_form] are not fit for use of \the [display_name].</span>")
	return humanoid_hands

/mob/living/simple_mob/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	. = ..(W, target)
	if(!target)
		target = src.loc
	if(.)
		W.forceMove(src.loc)

//Commands, reactions, etc
/mob/living/simple_mob/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if(!ai_inactive && reacts && speaker && (message in reactions) && (!hostile || isliving(speaker)) && say_understands(speaker,language))
		var/mob/living/L = speaker
		if(L.faction == faction)
			spawn(10)
				face_atom(speaker)
				say(reactions[message])

//Just some subpaths for easy searching
/mob/living/simple_mob/hostile
	faction = "not yours"
	hostile = 1
	retaliate = 1
	stop_when_pulled = 0
	destroy_surroundings = 1

/mob/living/simple_mob/retaliate
	retaliate = 1
	destroy_surroundings = 1

/mob/living/simple_mob/get_nametag_desc(mob/user)
	return "<i>[tt_desc]</i>"

/mob/living/simple_animal
	var/vore_active = 0					// If vore behavior is enabled for this mob
	var/vore_capacity = 1				// The capacity (in people) this person can hold
	var/vore_max_size = RESIZE_HUGE		// The max size this mob will consider eating
	var/vore_min_size = RESIZE_TINY 	// The min size this mob will consider eating
	var/vore_bump_chance = 0			// Chance of trying to eat anyone that bumps into them, regardless of hostility
	var/vore_bump_emote	= "grabs hold of"	// Allow messages for bumpnom mobs to have a flavorful bumpnom
	var/vore_pounce_chance = 5			// Chance of this mob knocking down an opponent
	var/vore_pounce_cooldown = 0		// Cooldown timer - if it fails a pounce it won't pounce again for a while
	var/vore_pounce_successrate	= 100	// Chance of a pounce succeeding against a theoretical 0-health opponent
	var/vore_pounce_falloff = 1			// Success rate falloff per %health of target mob.
	var/vore_pounce_maxhealth = 80		// Mob will not attempt to pounce targets above this %health
	var/vore_standing_too = 0			// Can also eat non-stunned mobs
	var/vore_ignores_undigestable = 1	// Refuse to eat mobs who are undigestable by the prefs toggle.
	var/swallowsound = null				// What noise plays when you succeed in eating the mob.

	var/vore_default_mode = DM_DIGEST	// Default bellymode (DM_DIGEST, DM_HOLD, DM_ABSORB)
	var/vore_default_flags = DM_FLAG_ITEMWEAK // Itemweak by default
	var/vore_digest_chance = 25			// Chance to switch to digest mode if resisted
	var/vore_absorb_chance = 0			// Chance to switch to absorb mode if resisted
	var/vore_escape_chance = 25			// Chance of resisting out of mob

	var/vore_stomach_name				// The name for the first belly if not "stomach"
	var/vore_stomach_flavor				// The flavortext for the first belly if not the default

	var/vore_fullness = 0				// How "full" the belly is (controls icons)
	var/vore_icons = 0					// Bitfield for which fields we have vore icons for.

	var/mount_offset_x = 5				// Horizontal riding offset.
	var/mount_offset_y = 8				// Vertical riding offset

// Release belly contents before being gc'd!
/mob/living/simple_animal/Destroy()
	release_vore_contents()
	prey_excludes.Cut()
	. = ..()

//For all those ID-having mobs
/mob/living/simple_animal/GetIdCard()
	if(myid)
		return myid

// Update fullness based on size & quantity of belly contents
/mob/living/simple_animal/proc/update_fullness()
	var/new_fullness = 0
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		for(var/mob/living/M in B)
			new_fullness += M.size_multiplier
	new_fullness = round(new_fullness, 1) // Because intervals of 0.25 are going to make sprite artists cry.
	vore_fullness = min(vore_capacity, new_fullness)

/mob/living/simple_animal/proc/update_vore_icon()
	if(!vore_active)
		return FALSE
	update_fullness()
	if(!vore_fullness)
		return FALSE
	else if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)) && (vore_icons & SA_ICON_LIVING))
		return "[icon_living]-[vore_fullness]"
	else if(stat >= DEAD && (vore_icons & SA_ICON_DEAD))
		return "[icon_dead]-[vore_fullness]"
	else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest && (vore_icons & SA_ICON_REST))
		return "[icon_rest]-[vore_fullness]"

/mob/living/simple_animal/proc/will_eat(var/mob/living/M)
	if(client) //You do this yourself, dick!
		ai_log("vr/wont eat [M] because we're player-controlled", 3)
		return FALSE
	if(!istype(M)) //Can't eat 'em if they ain't /mob/living
		ai_log("vr/wont eat [M] because they are not /mob/living", 3)
		return FALSE
	if(src == M) //Don't eat YOURSELF dork
		ai_log("vr/won't eat [M] because it's me!", 3)
		return FALSE
	if(vore_ignores_undigestable && !M.digestable) //Don't eat people with nogurgle prefs
		ai_log("vr/wont eat [M] because I am picky", 3)
		return FALSE
	if(!M.allowmobvore) // Don't eat people who don't want to be ate by mobs
		ai_log("vr/wont eat [M] because they don't allow mob vore", 3)
		return FALSE
	if(M in prey_excludes) // They're excluded
		ai_log("vr/wont eat [M] because they are excluded", 3)
		return FALSE
	if(M.size_multiplier < vore_min_size || M.size_multiplier > vore_max_size)
		ai_log("vr/wont eat [M] because they too small or too big", 3)
		return FALSE
	if(vore_capacity != 0 && (vore_fullness >= vore_capacity)) // We're too full to fit them
		ai_log("vr/wont eat [M] because I am too full", 3)
		return FALSE
	return 1

/mob/living/simple_animal/PunchTarget()
	ai_log("vr/PunchTarget() [target_mob]", 3)

	// If we're not hungry, call the sideways "parent" to do normal punching
	if(!vore_active)
		return ..()

	// If target is standing we might pounce and knock them down instead of attacking
	var/pouncechance = CanPounceTarget()
	if(pouncechance)
		return PounceTarget(pouncechance)

	// We're not attempting a pounce, if they're down or we can eat standing, do it as long as they're edible. Otherwise, hit normally.
	if(will_eat(target_mob) && (!target_mob.canmove || vore_standing_too))
		return EatTarget()
	else
		return ..()

/mob/living/simple_animal/proc/CanPounceTarget() //returns either FALSE or a %chance of success
	if(!target_mob.canmove || issilicon(target_mob) || world.time < vore_pounce_cooldown) //eliminate situations where pouncing CANNOT happen
		return FALSE
	if(!prob(vore_pounce_chance)) //mob doesn't want to pounce
		return FALSE
	if(will_eat(target_mob) && vore_standing_too) //100% chance of hitting people we can eat on the spot
		return 100
	var/TargetHealthPercent = (target_mob.health/target_mob.getMaxHealth())*100 //now we start looking at the target itself
	if (TargetHealthPercent > vore_pounce_maxhealth) //target is too healthy to pounce
		return FALSE
	else
		return max(0,(vore_pounce_successrate - (vore_pounce_falloff * TargetHealthPercent)))


/mob/living/simple_animal/proc/PounceTarget(var/successrate = 100)
	vore_pounce_cooldown = world.time + 20 SECONDS // don't attempt another pounce for a while
	if(prob(successrate)) // pounce success!
		target_mob.Weaken(5)
		target_mob.visible_message("<span class='danger'>\the [src] pounces on \the [target_mob]!</span>!")
	else // pounce misses!
		target_mob.visible_message("<span class='danger'>\the [src] attempts to pounce \the [target_mob] but misses!</span>!")
		playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

	if(will_eat(target_mob) && (!target_mob.canmove || vore_standing_too)) //if they're edible then eat them too
		return EatTarget()
	else
		return //just leave them

// Attempt to eat target
// TODO - Review this.  Could be some issues here
/mob/living/simple_animal/proc/EatTarget()
	ai_log("vr/EatTarget() [target_mob]",2)
	stop_automated_movement = 1
	var/old_target = target_mob
	handle_stance(STANCE_BUSY)
	. = animal_nom(target_mob)
	playsound(src, swallowsound, 50, 1)
	update_icon()

	if(.)
		// If we succesfully ate them, lose the target
		LoseTarget()
		return old_target
	else if(old_target == target_mob)
		// If we didn't but they are still our target, go back to attack.
		// but don't run the handler immediately, wait until next tick
		// Otherwise we'll be in a possibly infinate loop
		set_stance(STANCE_ATTACK)
	stop_automated_movement = 0

/mob/living/simple_animal/death()
	release_vore_contents()
	. = ..()

// Make sure you don't call ..() on this one, otherwise you duplicate work.
/mob/living/simple_animal/init_vore()
	if(!vore_active || no_vore)
		return

	if(!IsAdvancedToolUser())
		verbs |= /mob/living/simple_animal/proc/animal_nom
		verbs |= /mob/living/proc/shred_limb

	if(LAZYLEN(vore_organs))
		return

	//A much more detailed version of the default /living implementation
	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = 1
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.desc = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
	B.digest_mode = vore_default_mode
	B.mode_flags = vore_default_flags
	B.escapable = vore_escape_chance > 0
	B.escapechance = vore_escape_chance
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = swallowTime
	B.nonhuman_prey_swallow_time = swallowTime
	B.vore_verb = "swallow"
	B.emote_lists[DM_HOLD] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you gently for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes harmlessly.",
		"The predator's calm breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads harmlessly against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements gently force you into a different position.")
	B.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")

/mob/living/simple_animal/Bumped(var/atom/movable/AM, yes)
	if(ismob(AM))
		var/mob/tmob = AM
		if(will_eat(tmob) && !istype(tmob, type) && prob(vore_bump_chance) && !ckey) //check if they decide to eat. Includes sanity check to prevent cannibalism.
			if(tmob.canmove && prob(vore_pounce_chance)) //if they'd pounce for other noms, pounce for these too, otherwise still try and eat them if they hold still
				tmob.Weaken(5)
			tmob.visible_message("<span class='danger'>\the [src] [vore_bump_emote] \the [tmob]!</span>!")
			stop_automated_movement = 1
			animal_nom(tmob)
			update_icon()
			stop_automated_movement = 0
	..()

// Checks to see if mob doesn't like this kind of turf
/mob/living/simple_animal/avoid_turf(var/turf/turf)
	//So we only check if the parent didn't find anything terrible
	if((. = ..(turf)))
		return .

	if(istype(turf,/turf/unsimulated/floor/sky))
		return TRUE //Mobs aren't that stupid, probably

//Grab = Nomf
/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()

	if(a_intent == INTENT_GRAB && isliving(A) && !has_hands)
		animal_nom(A)

// Riding
/datum/riding/simple_animal
	keytype = /obj/item/material/twohanded/fluff/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/simple_animal/handle_vehicle_layer()
	ridden.layer = initial(ridden.layer)

/datum/riding/simple_animal/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/simple_animal/force_dismount(mob/M)
	. =..()
	ridden.visible_message("<span class='notice'>[M] stops riding [ridden]!</span>")

/datum/riding/simple_animal/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/simple_animal/L = ridden
	var/scale = L.size_multiplier

	var/list/values = list(
		"[NORTH]" = list(0, L.mount_offset_y*scale, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, L.mount_offset_y*scale, BELOW_MOB_LAYER),
		"[EAST]" = list(-L.mount_offset_x*scale, L.mount_offset_y*scale, ABOVE_MOB_LAYER),
		"[WEST]" = list(L.mount_offset_x*scale, L.mount_offset_y*scale, ABOVE_MOB_LAYER))

	return values

/mob/living/simple_animal/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..() // Skip our checks
	if(!riding_datum)
		return FALSE
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
	if(M.size_multiplier > size_multiplier * 1.2)
		to_chat(src,"<span class='warning'>This isn't a pony show! You need to be bigger for them to ride.</span>")
		return FALSE

	var/mob/living/carbon/human/H = M

	if(H.loc != src.loc)
		if(H.Adjacent(src))
			H.forceMove(get_turf(src))

	. = ..()
	if(.)
		buckled_mobs[H] = "riding"

/mob/living/simple_animal/attack_hand(mob/user as mob)
	if(riding_datum && LAZYLEN(buckled_mobs))
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		. = ..()

/mob/living/simple_animal/proc/animal_mount(var/mob/living/M in living_mobs(1))
	set name = "Animal Mount/Dismount"
	set category = "Abilities"
	set desc = "Let people ride on you."

	if(LAZYLEN(buckled_mobs))
		for(var/rider in buckled_mobs)
			riding_datum.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message("<span class='notice'>[M] starts riding [name]!</span>")
