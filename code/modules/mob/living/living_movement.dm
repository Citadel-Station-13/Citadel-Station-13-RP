/mob/living/CanPass(atom/movable/mover, turf/target, height, air_group)
	/* DEATH TO ZAS	*/
	if(air_group || height == 0)
		return TRUE
	/*				*/
	if((mover.pass_flags & PASSMOB))
		return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	if(mover.throwing)
//		return (!density || !(mobility_flags & MOBILITY_STAND))
		return (!density || lying)
	if(buckled == mover)
		return TRUE
	if(istype(mover, /obj/structure/blob) && faction == "blob") //Blobs should ignore things on their faction.		//snowflake code
		return TRUE
	if(isliving(mover))
		var/mob/living/moving_mob = mover
		if(mover in buckled_mobs)
			return TRUE

		if ((other_mobs && moving_mob.other_mobs))		//REFACTOR GRABS ALREADY REE
			return 1

//	return (!mover.density || !density || !(mobility_flags & MOBILITY_STAND))
	return (!mover.density || !density || lying)		//Get rid of this when mobility flags are done obviously






/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		return 0

/mob/living/Bump(atom/movable/AM)
	if(now_pushing || !loc)
		return
	now_pushing = 1
	if (istype(AM, /mob/living))
		var/mob/living/tmob = AM

		//Even if we don't push/swap places, we "touched" them, so spread fire
		spread_fire(tmob)

		for(var/mob/living/M in range(tmob, 1))
			if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, tmob.grabbed_by.len)) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
				now_pushing = 0
				return
			if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
				now_pushing = 0
				return

		//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
		var/dense = 0
		if(loc.density)
			dense = 1
		for(var/atom/movable/A in loc)
			if(A == src)
				continue
			if(A.density)
				if(A.flags&ON_BORDER)
					dense = !A.CanPass(src, src.loc)
				else
					dense = 1
			if(dense) break

		//Leaping mobs just land on the tile, no pushing, no anything.
		if(status_flags & LEAPING)
			loc = tmob.loc
			status_flags &= ~LEAPING
			now_pushing = 0
			return

		if((tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())) && tmob.canmove && canmove && !tmob.buckled && !buckled && !dense && can_move_mob(tmob, 1, 0)) // mutual brohugs all around!
			var/turf/oldloc = loc
			forceMove(tmob.loc)
			tmob.forceMove(oldloc)
			now_pushing = 0
			return

		if(!can_move_mob(tmob, 0, 0))
			now_pushing = 0
			return
		if(a_intent == I_HELP || src.restrained())
			now_pushing = 0
			return
		if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
			if(prob(40) && !(FAT in src.mutations))
				to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
				now_pushing = 0
				return
		if(tmob.r_hand && istype(tmob.r_hand, /obj/item/weapon/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(tmob.l_hand && istype(tmob.l_hand, /obj/item/weapon/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(!(tmob.status_flags & CANPUSH))
			now_pushing = 0
			return

		tmob.LAssailant = src

	now_pushing = 0
	. = ..()
	if (!istype(AM, /atom/movable) || AM.anchored)
		if(confused && prob(50) && m_intent=="run")
			Weaken(2)
			playsound(loc, "punch", 25, 1, -1)
			visible_message("<span class='warning'>[src] [pick("ran", "slammed")] into \the [AM]!</span>")
			src.apply_damage(5, BRUTE)
			to_chat(src, "<span class='warning'>You just [pick("ran", "slammed")] into \the [AM]!</span>")
		return
	if (!now_pushing)
		if(isobj(AM))
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				return
		now_pushing = 1

		var/t = get_dir(src, AM)
		if (istype(AM, /obj/structure/window))
			for(var/obj/structure/window/win in get_step(AM,t))
				now_pushing = 0
				return
		step(AM, t)
		if(ishuman(AM) && AM:grabbed_by)
			for(var/obj/item/weapon/grab/G in AM:grabbed_by)
				step(G:assailant, get_dir(G:assailant, AM))
				G.adjust_position()
		now_pushing = 0




/*

//Generic Bump(). Override MobBump() and ObjBump() instead of this.
/mob/living/Bump(atom/A)
	if(..()) //we are thrown onto something
		return
	if (buckled || now_pushing)
		return
	if(ismob(A))
		var/mob/M = A
		if(MobBump(M))
			return
	if(isobj(A))
		var/obj/O = A
		if(ObjBump(O))
			return
	if(ismovableatom(A))
		var/atom/movable/AM = A
		if(PushAM(AM, move_force))
			return

/mob/living/Bumped(atom/movable/AM)
	..()
	last_bumped = world.time

//Called when we bump onto a mob
/mob/living/proc/MobBump(mob/M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)

	if(now_pushing)
		return TRUE

	if(isliving(M))
		var/mob/living/L = M
		//Also spread diseases
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				L.ContactContractDisease(D)

		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				ContactContractDisease(D)

		//Should stop you pushing a restrained person out of the way
		if(L.pulledby && L.pulledby != src && L.restrained())
			if(!(world.time % 5))
				to_chat(src, "<span class='warning'>[L] is restrained, you cannot push past.</span>")
			return 1

		if(L.pulling)
			if(ismob(L.pulling))
				var/mob/P = L.pulling
				if(P.restrained())
					if(!(world.time % 5))
						to_chat(src, "<span class='warning'>[L] is restraining [P], you cannot push past.</span>")
					return 1

	if(moving_diagonally)//no mob swap during diagonal moves.
		return 1

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap = FALSE
		//the puller can always swap with its victim if on grab intent
		if(M.pulledby == src && a_intent == INTENT_GRAB)
			mob_swap = TRUE
		else if(M.has_trait(TRAIT_NOMOBSWAP) || has_trait(TRAIT_NOMOBSWAP))
			mob_swap = FALSE
		//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
		else if((M.restrained() || M.a_intent == INTENT_HELP) && (restrained() || a_intent == INTENT_HELP))
			mob_swap = TRUE
		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return 1
			now_pushing = 1
			var/oldloc = loc
			var/oldMloc = M.loc


			var/M_passmob = (M.pass_flags & PASSMOB) // we give PASSMOB to both mobs to avoid bumping other mobs during swap.
			var/src_passmob = (pass_flags & PASSMOB)
			M.pass_flags |= PASSMOB
			pass_flags |= PASSMOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			if(!M_passmob)
				M.pass_flags &= ~PASSMOB

			now_pushing = 0

			if(!move_failed)
				return 1

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return 1
	if(isliving(M))
		var/mob/living/L = M
		if(L.has_trait(TRAIT_PUSHIMMUNE))
			return 1
	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return 1

//Called when we bump onto an obj
/mob/living/proc/ObjBump(obj/O)
	return

//Called when we want to push an atom/movable
/mob/living/proc/PushAM(atom/movable/AM, force = move_force)
	if(now_pushing)
		return TRUE
	if(moving_diagonally)// no pushing during diagonal moves.
		return TRUE
	if(!client && (mob_size < MOB_SIZE_SMALL))
		return
	now_pushing = TRUE
	var/t = get_dir(src, AM)
	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, t))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)			//trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, t, push_anchored))
			push_anchored = TRUE
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return
	if (istype(AM, /obj/structure/window))
		var/obj/structure/window/W = AM
		if(W.fulltile)
			for(var/obj/structure/window/win in get_step(W,t))
				now_pushing = FALSE
				return
	if(pulling == AM)
		stop_pulling()
	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	if(step(AM, t))
		step(src, t)
	if(current_dir)
		AM.setDir(current_dir)
	now_pushing = FALSE
*/
