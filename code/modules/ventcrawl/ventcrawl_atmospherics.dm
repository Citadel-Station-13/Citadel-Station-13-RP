/obj/machinery/atmospherics/var/image/pipe_image

/obj/machinery/atmospherics/Destroy()
	for(var/mob/living/M in src) //ventcrawling is serious business
		M.remove_ventcrawl()
		M.forceMove(get_turf(src))
		M.update_perspective()
	if(pipe_image)
		for(var/mob/living/M in player_list)
			if(M.client)
				M.client.images -= pipe_image
				M.pipes_shown -= pipe_image
		pipe_image = null
	. = ..()

/obj/machinery/atmospherics/legacy_ex_act(severity)
	for(var/atom/movable/A in src) //ventcrawling is serious business
		LEGACY_EX_ACT(A, severity, null)
	. = ..()

/obj/machinery/atmospherics/Entered(atom/movable/Obj)
	..()
	if(istype(Obj, /mob/living))
		var/mob/living/L = Obj
		L.ventcrawl_layer = layer

/obj/machinery/atmospherics/relaymove(mob/living/user, direction)
	if(user.loc != src || !(direction & initialize_directions)) //can't go in a way we aren't connecting to
		return
	ventcrawl_to(user,findConnecting(direction, user.ventcrawl_layer),direction)

/obj/machinery/atmospherics/proc/ventcrawl_to(mob/living/user, obj/machinery/atmospherics/target_move, direction)
	if(direction & (direction-1))//supresses Diagonal movement
		return
	if(target_move)
		if(is_type_in_list(target_move, ventcrawl_machinery) && target_move.can_crawl_through())
			user.remove_ventcrawl()
			user.forceMove(target_move.loc) //handles entering and so on
			user.update_perspective()
			user.visible_message("You hear something squeezing through the ducts.", "You climb out the ventilation system.")
		else if(target_move.can_crawl_through())
			if(target_move.return_network(target_move) != return_network(src))
				user.remove_ventcrawl()
				user.add_ventcrawl(target_move)
			user.forceMove(target_move)
			user.update_perspective()
			if(world.time > user.next_play_vent)
				user.next_play_vent = world.time+30
				playsound(src, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	else
		if((direction & initialize_directions) || is_type_in_list(src, ventcrawl_machinery) && src.can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
			user.remove_ventcrawl()
			user.forceMove(loc)
			user.update_perspective()
			user.visible_message("You hear something squeezing through the pipes.", "You climb out the ventilation system.")
	user.canmove = 0
	spawn(1)
		user.canmove = 1

/obj/machinery/atmospherics/proc/can_crawl_through()
	return 1

/obj/machinery/atmospherics/component/unary/can_crawl_through()
	if(welded)
		return 0

	. = ..()

/obj/machinery/atmospherics/proc/findConnecting(direction)
	for(var/obj/machinery/atmospherics/target in get_step(src,direction))
		if(target.initialize_directions & get_dir(target,src))
			if(isConnectable(target) && target.isConnectable(src))
				return target

/obj/machinery/atmospherics/proc/isConnectable(obj/machinery/atmospherics/target)
	return (target == node1 || target == node2)

/obj/machinery/atmospherics/pipe/manifold/isConnectable(obj/machinery/atmospherics/target)
	return (target == node3 || ..())

/obj/machinery/atmospherics/component/trinary/isConnectable(obj/machinery/atmospherics/target)
	return (target == node3 || ..())

/obj/machinery/atmospherics/pipe/manifold4w/isConnectable(obj/machinery/atmospherics/target)
	return (target == node3 || target == node4 || ..())

/obj/machinery/atmospherics/tvalve/isConnectable(obj/machinery/atmospherics/target)
	return (target == node3 || ..())

/obj/machinery/atmospherics/pipe/cap/isConnectable(obj/machinery/atmospherics/target)
	return (target == node || ..())

/obj/machinery/atmospherics/portables_connector/isConnectable(obj/machinery/atmospherics/target)
	return (target == node || ..())

/obj/machinery/atmospherics/component/unary/isConnectable(obj/machinery/atmospherics/target)
	return (target == node || ..())
