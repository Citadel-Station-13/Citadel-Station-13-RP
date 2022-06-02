/// mutex to prevent more than one from generating at once
GLOBAL_VAR(deepmaint_generating)

/atom/movable/landmark/deepmaint_root/proc/_lock_for_generation()
	while(GLOB.deepmaint_generating != src)
		if(QDELETED(src))
			return FALSE
		stoplag(1)
	GLOB.deepmaint_generating = src
	return TRUE

/atom/movable/landmark/deepmaint_root/proc/_unlock_from_generation()
	if(GLOB.deepmaint_generating != src)
		CRASH("wasn't even our turn")
	GLOB.deepmaint_generating = null
	return TRUE
