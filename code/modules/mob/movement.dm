//DO NOT USE THIS UNLESS YOU ABSOLUTELY HAVE TO. THIS IS BEING PHASED OUT FOR THE MOVESPEED MODIFICATION SYSTEM.
//See code/modules/movespeed/movespeed_modifier.dm
/mob/proc/movement_delay()	//update /living/movement_delay() if you change this
	SHOULD_CALL_PARENT(TRUE)
	return cached_multiplicative_slowdown

/mob/proc/applyMoveCooldown(amount)
	move_delay = max(move_delay, world.time + amount)

/mob/proc/check_move_cooldown()
	return move_delay <= world.time

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living))
		var/mob/living/L = mob
		L.swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return

/client/verb/drop_item()
	set hidden = 1

	if(isrobot(mob))
		return
	if(mob.stat != CONSCIOUS)
		return
	if(!isturf(mob.loc) && !isbelly(mob.loc))
		return
	mob.drop_active_held_item()

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))

/mob/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	// thrown things still hit us even when nondense
	if(!mover.density && !mover.throwing)
		return TRUE

/mob/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if((buckled?.loc == target) && ismovable(blocker))
		var/atom/movable/AM = blocker
		if(AM.pass_flags & ATOM_PASS_BUCKLED)
			return TRUE
	return ..()

/**
  * Toggle the move intent of the mob
  *
  * triggers an update the move intent hud as well
  */
/mob/proc/toggle_move_intent(mob/user)
	if(m_intent == MOVE_INTENT_RUN)
		m_intent = MOVE_INTENT_WALK
	else
		m_intent = MOVE_INTENT_RUN
/*
	if(hud_used && hud_used.static_inventory)
		for(var/atom/movable/screen/mov_intent/selector in hud_used.static_inventory)
			selector.update_icon()
*/
	// nah, vorecode bad.
	hud_used?.move_intent?.icon_state = (m_intent == MOVE_INTENT_RUN)? "running" : "walking"

/**
  * Move a client in a direction
  *
  * Huge proc, has a lot of functionality
  *
  * Mostly it will despatch to the mob that you are the owner of to actually move
  * in the physical realm
  *
  * Things that stop you moving as a mob:
  * * world time being less than your next move_delay
  * * not being in a mob, or that mob not having a loc
  * * missing the n and direction parameters
  * * being in remote control of an object (calls Moveobject instead)
  * * being dead (it ghosts you instead)
  *
  * Things that stop you moving as a mob living (why even have OO if you're just shoving it all
  * in the parent proc with istype checks right?):
  * * having incorporeal_move set (calls Process_Incorpmove() instead)
  * * being grabbed
  * * being buckled  (relaymove() is called to the buckled atom instead)
  * * having your loc be some other mob (relaymove() is called on that mob instead)
  * * Not having MOBILITY_MOVE
  * * Failing Process_Spacemove() call
  *
  * At this point, if the mob is is confused, then a random direction and target turf will be calculated for you to travel to instead
  *
  * Now the parent call is made (to the byond builtin move), which moves you
  *
  * Some final move delay calculations (doubling if you moved diagonally successfully)
  *
  * if mob throwing is set I believe it's unset at this point via a call to finalize
  *
  * Finally if you're pulling an object and it's dense, you are turned 180 after the move
  * (if you ask me, this should be at the top of the move so you don't dance around)
  *
  */

/client/Move(n, direct)
	if(!mob.check_move_cooldown()) //do not move anything ahead of this check please
		return FALSE
	else
		next_move_dir_add = 0
		next_move_dir_sub = 0
	// no tile, or new dir, or mob is transforming
	if(!n || !direct || mob.transforming) // i'm moving something ahead of that check
		return FALSE
	// commented out - not needed without momentum preservation
	var/old_delay = mob.move_delay
	// prevent more than one move per tick if we get interrupted from normal movement
	mob.move_delay = world.time + world.tick_lag
	// admin control (?)
	if(mob.control_object)
		return Move_object(direct)
	//* movement intercept
	if(mob.movement_intercept?.intercept_mob_move(mob, direct))
		return
	// nonliving get handled differently
	if(!isliving(mob))
		mob.move_delay = world.time + mob.cached_multiplicative_slowdown
		return mob.Move(n, direct)
	// autoghost if needed
	if((mob.stat == DEAD) && isliving(mob) && !mob.forbid_seeing_deadchat)
		mob.ghostize()
		return FALSE
	// don't move if there's a forced movement datum on us
/*
	if(mob.force_moving)
		return FALSE
*/
	// already istype'd earlier ; cast for checks
	var/mob/living/L = mob
	// check for incorpmove aka move through walls
	if(L.incorporeal_move)
		Process_Incorpmove(direct)
		return FALSE
	// todo: proper relaymove system
	// remote controlling something; relay move to that
/*
	if(mob.remote_control)					//we're controlling something, our movement is relayed to it
		return mob.remote_control.relaymove(mob, direct)
*/
	// we have an eye; relay to that
	if(mob.eyeobj)
		return mob.EyeMove(n,direct)
	// ai move specials
/*
	if(isAI(mob))
		return AIMove(n,direct,mob)
*/
	//! WARNING: LEGACY CODE START
	// unzoom
	// todo: component/element/signal/datum/anything but this
	if(isliving(mob))
		if(mob.client)
			if(mob.client.view != world.view) // If mob moves while zoomed in with device, unzoom them.
				for(var/obj/item/item in mob.contents)
					if(item.zoom)
						item.zoom(user = mob)
						break

	// restrained by someone's grip
	// todo: move intercept at mob level
	if(Process_Grab()) //are we restrained by someone's grip?
		return
	//! END

	// todo: proper relaymove system
	// buckled ; relaymove to buckled
	if(mob.buckled)
		return mob.buckled.relaymove_from_buckled(mob, direct)

	// todo: mobility refactor & move to mob
	// mobility check
	if(!mob.canmove)
		return

	// new mobility flags check todo
/*
	if(!(L.mobility_flags & MOBILITY_MOVE))
		return FALSE
*/

	// todo: proper relaymove handling
	// machine might process relaymove
	if(mob.machine)
		var/result = mob.machine.relaymove(mob, direct)
		if(result)
			return result

	// todo: proper relaymove handling
	// inside something ; relay to them
	if(!isturf(mob.loc))
		var/atom/A = mob.loc
		return A.relaymove_from_contents(mob, direct)

	// todo: this should probably be on mob or something
	// check for gravity
	if(!mob.Process_Spacemove(direct))
		return FALSE

	//! WARNING: SHITCODE
	// .... why
	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)
	//! End

	//? All exceptions / modifiers handled, proceed to proper movement

	//! SIKE, MORE
	if(mob.restrained() && mob.pulledby)//Why being pulled while cuffed prevents you from moving
		to_chat(src, "<span class='warning'>You're restrained! You can't move!</span>")
		mob.move_delay = world.time + 5 // 5 ds delay
		return FALSE
	if(length(mob.pinned))
		mob.move_delay = world.time + 5 // 5 ds delay
		to_chat(src, "<font color=#4F49AF>You're pinned to a wall by [mob.pinned[1]]!</font>")
		return FALSE
	//! End

	//? NOW we try to move.

	// get additional delay from this move
	var/add_delay = mob.movement_delay()
	// for grabs (legacy code moment)
	var/add_delay_grab = 0

	//! WARNING: LEGACY CODE; I don't know how this works and I'm afraid to ask.
	if(mob.pulledby || mob.buckled) // Wheelchair driving!		//this is shitcode
		if(istype(mob.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
			return mob.pulledby.relaymove(mob, direct)
		else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
			if(ishuman(mob))
				var/mob/living/carbon/human/driver = mob
				var/obj/item/organ/external/l_hand = driver.get_organ("l_hand")
				var/obj/item/organ/external/r_hand = driver.get_organ("r_hand")
				if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
					return // No hands to drive your chair? Tough luck!
			//drunk wheelchair driving
			else if(mob.confused)
				switch(mob.m_intent)
					if("run")
						if(prob(50))	direct = turn(direct, pick(90, -90))
					if("walk")
						if(prob(25))	direct = turn(direct, pick(90, -90))
			add_delay += 2
			return mob.buckled.relaymove(mob,direct)
	//! oh god I hate this so much todo proper relaymove system for pulling fr fr

	//! WARNING: LEGACY CODE I give up at this point
	//We are now going to move
	//Something with pulling things
	if(locate(/obj/item/grab, mob))
		add_delay_grab = 7
		var/list/grabbed = mob.ret_grab()
		if(grabbed)
			if(grabbed.len == 2)
				grabbed -= mob
				var/mob/M = grabbed[1]
				if(M)
					if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
						var/turf/T = mob.loc
						. = mob.SelfMove(n, direct)
						if (isturf(M.loc))
							var/diag = get_dir(mob, M)
							if ((diag - 1) & diag)
							else
								diag = null
							if ((get_dist(mob, M) > 1 || diag))
								step(M, get_dir(M.loc, T))
			else
				for(var/mob/M in grabbed)
					M.other_mobs = 1
					if(mob != M)
						M.animate_movement = 3
				for(var/mob/M in grabbed)
					spawn( 0 )
						step(M, direct)
						return
					spawn( 1 )
						M.other_mobs = null
						M.animate_movement = 2
						return
	else
		if(mob.confused)
			switch(mob.m_intent)
				if("run")
					if(prob(75))
						direct = turn(direct, pick(90, -90))
						n = get_step(mob, direct)
				if("walk")
					if(prob(25))
						direct = turn(direct, pick(90, -90))
						n = get_step(mob, direct)
		. = mob.SelfMove(n, direct)
	//! End

	//! WARNING: MORE LEGACY CODE
	for (var/obj/item/grab/G in mob)
		if (G.state == GRAB_NECK)
			mob.setDir(global.reverse_dir[direct])
		G.adjust_position()
	for (var/obj/item/grab/G in mob.grabbed_by)
		G.adjust_position()
	//! End

	// take lower of the two
	add_delay = max(add_delay, add_delay_grab)

	// moved diagonally; obey euclidean dist
	if((direct & (direct - 1)) && mob.loc == n)
		add_delay *= SQRT_2

	// round to tick to prevent lurching instead of preserving momentum
	// mob.move_delay = world.time + round(add_delay, world.tick_lag)

	// preserve momentum: for non-evenly-0.5-multiple movespeeds (HELLO, DIAGONAL MOVES),
	// we need to store how much we're cheated out of our tick and carry it through
	// make an intelligent guess at if they're trying to keep moving, tho!
	if(mob.last_move_time > (world.time - add_delay * 1.25))
		mob.move_delay = old_delay + add_delay
	else
		mob.move_delay = world.time + add_delay

	SMOOTH_GLIDE_SIZE(mob, DELAY_TO_GLIDE_SIZE(add_delay))

	mob.last_move_time = world.time

/mob/proc/SelfMove(turf/T, dir)
	. = Move(T, dir)
	if(.)
		throwing?.terminate()
	if(pulling && !ismob(pulling) && pulling.density)
		setDir(turn(dir, 180))	// face pulling

///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)

	switch(mob.incorporeal_move)
		if(1)
			var/turf/T = get_step(mob, direct)
			if(!T)
				return
			mob.forceMove(get_step(mob, direct))
			mob.setDir(direct)
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				mob.forceMove(locate(locx,locy,mobloc.z))
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, mob.loc))
						spawn(0)
							anim(T,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
				mob.forceMove(get_step(mob, direct))
			mob.dir = direct
	// Crossed is always a bit iffy
	for(var/obj/S in mob.loc)
		if(istype(S,/obj/effect/step_trigger) || istype(S,/obj/effect/beam))
			S.Crossed(mob)

	var/area/A = get_area_master(mob)
	if(A)
		A.Entered(mob)
	if(isturf(mob.loc))
		var/turf/T = mob.loc
		T.Entered(mob)
	mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

///Process_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/Process_Spacemove(direction)
	. = ..()
	if(.)
		return
	if(Check_Dense_Object())
		update_floating(TRUE)
		return TRUE

/mob/proc/Check_Dense_Object() //checks for anything to push off in the vicinity. also handles magboots on gravity-less floors tiles

	var/dense_object = 0
	var/shoegrip

	for(var/turf/turf in oview(1,src))
		if(istype(turf,/turf/space))
			continue

		if(istype(turf,/turf/simulated/floor)) // Floors don't count if they don't have gravity
			var/area/A = turf.loc
			if(istype(A) && A.has_gravity == 0)
				if(shoegrip == null)
					shoegrip = Check_Shoegrip() //Shoegrip is only ever checked when a zero-gravity floor is encountered to reduce load
				if(!shoegrip)
					continue

		dense_object++
		break

	if(!dense_object && (locate(/obj/structure/lattice) in oview(1, src)))
		dense_object++

	if(!dense_object && (locate(/obj/structure/catwalk) in oview(1, src)))
		dense_object++


	//Lastly attempt to locate any dense objects we could push off of
	//TODO: If we implement objects drifing in space this needs to really push them
	//Due to a few issues only anchored and dense objects will now work.
	if(!dense_object)
		for(var/obj/O in oview(1, src))
			if((O) && (O.density) && (O.anchored))
				dense_object++
				break

	return dense_object

/mob/proc/Check_Shoegrip()
	if(flying)	// Checks to see if they are flying.
		return 1
	return 0

/mob/proc/Process_Spaceslipping(var/prob_slip = 5)
	//Setup slipage
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0  // Changing this to zero to make it line up with the comment.

	prob_slip = round(prob_slip)
	return(prob_slip)

/mob/proc/mob_has_gravity(turf/T)
	return has_gravity(src, T)

/mob/proc/update_gravity()
	return

// Called when a mob successfully moves.
// Would've been an /atom/movable proc but it caused issues.
/mob/Moved(atom/oldloc)
	. = ..()
	client?.parallax_holder?.Update()
	for(var/obj/O in contents)
		O.on_loc_moved(oldloc)
	reset_pixel_shifting()

// Received from Moved(), useful for items that need to know that their loc just moved.
/obj/proc/on_loc_moved(atom/oldloc)
	return

/obj/item/storage/on_loc_moved(atom/oldloc)
	for(var/obj/O in contents)
		O.on_loc_moved(oldloc)

// facing verbs
/**
  * Returns true if a mob can turn to face things
  *
  * Conditions:
  * * client.last_turn > world.time
  * * not dead or unconcious
  * * not anchored
  * * no transform not set
  * * we are not restrained
  */
/mob/proc/canface()
	if(world.time <= last_turn)
		return FALSE
	if(stat == DEAD || stat == UNCONSCIOUS)
		return FALSE
	if(transforming)
		return FALSE
	if(restrained())
		return FALSE
	return TRUE

///Hidden verb to turn east
/mob/verb/eastface()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	setDir(EAST)
	last_turn = world.time
	return TRUE

///Hidden verb to turn west
/mob/verb/westface()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	setDir(WEST)
	last_turn = world.time
	return TRUE

///Hidden verb to turn north
/mob/verb/northface()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	setDir(NORTH)
	last_turn = world.time
	return TRUE

///Hidden verb to turn south
/mob/verb/southface()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	setDir(SOUTH)
	last_turn = world.time
	return TRUE

//! Pixel Shifting
/mob/verb/eastshift()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	if(shift_pixel_x < 16)
		adjust_pixel_shift_x(1)

/mob/verb/westshift()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	if(shift_pixel_x > -16)
		adjust_pixel_shift_x(-1)

/mob/verb/northshift()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	if(shift_pixel_y < 16)
		adjust_pixel_shift_y(1)

/mob/verb/southshift()
	set hidden = TRUE
	set src = usr
	if(!canface())
		return FALSE
	if(shift_pixel_y > -16)
		adjust_pixel_shift_y(-1)

//? Movement Intercepts

/mob/proc/request_movement_intercept(datum/requesting)
	if(movement_intercept)
		if(requesting == movement_intercept)
			return TRUE
		return FALSE
	movement_intercept = requesting
	return TRUE

/mob/proc/clear_movement_intercept()
	movement_intercept = null
	return TRUE

/datum/proc/intercept_mob_move(mob/moving, dir)
	return
