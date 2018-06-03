<<<<<<< HEAD
/mob/living/silicon/decoy/death(gibbed)
	if(stat == DEAD)	return
	icon_state = "ai-crash"
	spawn(10)
		explosion(loc, 3, 6, 12, 15)
	for(var/obj/machinery/ai_status_display/O in machines) //change status
		O.mode = 2
=======
/mob/living/silicon/decoy/death(gibbed)
	if(stat == DEAD)	return
	icon_state = "ai-crash"
	spawn(10)
		explosion(loc, 3, 6, 12, 15)
	for(var/obj/machinery/ai_status_display/O in machines) //change status
		O.mode = 2
>>>>>>> ad18753... Merge pull request #3813 from VOREStation/master
	return ..(gibbed)