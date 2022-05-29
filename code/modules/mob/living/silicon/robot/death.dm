/mob/living/silicon/robot/dust()
	//Delete the MMI first so that it won't go popping out.
	if(mmi)
		QDEL_NULL(mmi)
	return ..()

/mob/living/silicon/robot/ash()
	if(mmi)
		QDEL_NULL(mmi)
	return ..()

/mob/living/silicon/robot/death(gibbed)
	if(camera)
		camera.status = 0
	if(module)
		var/obj/item/gripper/G = locate(/obj/item/gripper) in module
		if(G)
			G.drop_item()
		var/obj/item/dogborg/sleeper/S = locate(/obj/item/dogborg/sleeper) in module
		if(S)
			S.go_out()
	remove_robot_verbs()
	sql_report_cyborg_death(src)
	return ..(gibbed, "shudders violently for a moment, then becomes motionless, its eyes slowly darkening.")
