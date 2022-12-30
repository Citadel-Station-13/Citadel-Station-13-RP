/obj/machinery/ore_unloader
	name = "ore unloader"
	desc = "A machine that automatically unloads ores from an ore box."
	icon = 'icons/modules/mining/machinery/unloader.dmi'
	icon_state = "unloader"
	#warn icon in dmi, dir with state
	density = TRUE

	#warn machinery processing brackets - tone it the fuck down if we're not active too
	#warn for brackets, we probably need 20 ore/tick for 5 tick/sec for 100/s
	#warn buildable, circuit, anchoring

	/// ores we can unload per tick
	var/ores_per_tick = 20

	// todo: BRACKET HERE

/obj/machinery/ore_unloader/process(delta_time)
	var/turf/rear = get_step(src, turn(dir, 180))
	if(!rear)
		return
	var/obj/structure/ore_box/box = locate() in rear
	if(!box)
		return
	var/turf/front = get_step(src, dir)
	if(!front)
		return
	for(var/i in 1 to ores_per_tick)
		box.deposit(front)
	var/lim = 0
	for(var/obj/item/ore/O in rear)
		if(!++lim)
			break
		O.forceMove(front)
