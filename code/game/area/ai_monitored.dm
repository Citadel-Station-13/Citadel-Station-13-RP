/area/ai_monitored
	name = "AI Monitored Area"
	var/obj/machinery/camera/motioncamera = null

//hey i'm slapping his comment here as i'm refactoring new/init this is all shit and all of this should use /tg/ proximity monitors not this snowflake bullshit - kevinz000

/area/ai_monitored/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/area/ai_monitored/LateInitialize()
	for(var/obj/machinery/camera/M in src)
		if(M.isMotion())
			motioncamera = M
			M.area_motion = src

/area/ai_monitored/Entered(atom/movable/O)
	..()
	if (ismob(O) && motioncamera)
		motioncamera.newTarget(O)

/area/ai_monitored/Exited(atom/movable/O)
	if (ismob(O) && motioncamera)
		motioncamera.lostTarget(O)


