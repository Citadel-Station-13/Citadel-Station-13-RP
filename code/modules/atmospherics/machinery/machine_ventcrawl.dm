/obj/machinery/atmospherics/examine(mob/user)
	. = ..()
	if(is_type_in_list(src, GLOB.ventcrawl_machinery) && isliving(user))
		var/mob/living/L = user
		if(SEND_SIGNAL(L, COMSIG_CHECK_VENTCRAWL))
			. += "<span class='notice'>Alt-click to crawl through it.</span>"

/obj/machinery/atmospherics/Entered(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.ventcrawl_layer = pipe_layer
	return ..()

#define VENT_SOUND_DELAY 30

/obj/machinery/atmospherics/relaymove(mob/living/user, direction)
	direction &= initialize_directions
	if(!direction || !(direction in GLOB.cardinals)) //cant go this way.
		return

	if(user in buckled_mobs)// fixes buckle ventcrawl edgecase fuck bug
		return

	var/obj/machinery/atmospherics/target_move = FindConnecting(direction, user.ventcrawl_layer)
	if(target_move)
		if(target_move.can_crawl_through())
			if(is_type_in_typecache(target_move, GLOB.ventcrawl_machinery))
				user.forceMove(target_move.loc) //handle entering and so on.
				user.visible_message("<span class='notice'>You hear something squeezing through the ducts...</span>", "<span class='notice'>You climb out the ventilation system.")
			else
				var/list/pipenetdiff = ReturnPipelines() ^ target_move.ReturnPipelines()
				if(pipenetdiff.len)
					user.update_pipe_vision(target_move)
				user.forceMove(target_move)
				user.client.eye = target_move  //Byond only updates the eye every tick, This smooths out the movement
				if(world.time - user.last_played_vent > VENT_SOUND_DELAY)
					user.last_played_vent = world.time
					playsound(src, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	else if(is_type_in_typecache(src, GLOB.ventcrawl_machinery) && can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
		user.forceMove(loc)
		user.visible_message("<span class='notice'>You hear something squeezing through the ducts...</span>", "<span class='notice'>You climb out the ventilation system.")

/obj/machinery/atmospherics/AltClick(mob/living/L)
	if(is_type_in_typecache(src, GLOB.ventcrawl_machinery))
		return SEND_SIGNAL(L, COMSIG_HANDLE_VENTCRAWL, src)
	return ..()

/obj/machinery/atmospherics/proc/can_crawl_through()
	return TRUE

/obj/machinery/atmospherics/update_remote_sight(mob/user)
	user.sight |= (SEE_TURFS|BLIND)

//Used for certain children of obj/machinery/atmospherics to not show pipe vision when mob is inside it.
/obj/machinery/atmospherics/proc/can_see_pipes()
	return TRUE
