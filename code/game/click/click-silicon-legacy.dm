#warn audit
/atom/proc/attack_ai(mob/user as mob)

/atom/proc/attack_robot(mob/user as mob)
	attack_ai(user)

/mob/living/silicon/ai/snowflake_ai_vision_adjacency(var/turf/T)
	return (GLOB.cameranet && GLOB.cameranet.checkTurfVis(T))
