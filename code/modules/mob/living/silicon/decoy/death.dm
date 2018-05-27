<<<<<<< HEAD
/mob/living/silicon/decoy/death(gibbed)
	if(stat == DEAD)	return
	icon_state = "ai-crash"
	spawn(10)
		explosion(loc, 3, 6, 12, 15)
	for(var/obj/machinery/ai_status_display/O in world) //change status
		O.mode = 2
=======
/mob/living/silicon/decoy/death(gibbed)
	if(stat == DEAD)	return
	icon_state = "ai-crash"
	spawn(10)
		explosion(loc, 3, 6, 12, 15)
	for(var/obj/machinery/ai_status_display/O in machines) //change status
		O.mode = 2
>>>>>>> 4cddf6c... Merge pull request #3762 from VOREStation/aro-sync-05-25-2018
	return ..(gibbed)