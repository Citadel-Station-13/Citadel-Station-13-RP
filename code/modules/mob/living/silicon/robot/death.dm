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
	var/obj/item/gripper/G = locate(/obj/item/gripper) in contents
	if(G)
		G.drop_item()
	var/obj/item/robot_builtin/dog_sleeper/S = locate(/obj/item/robot_builtin/dog_sleeper) in contents
	if(S)
		S.go_out()
	remove_robot_verbs()
	unbuckle_all_mobs(TRUE)
	SSblackbox.ReportDeath(src)
	return ..(gibbed, "shudders violently for a moment, then becomes motionless, its eyes slowly darkening.")
