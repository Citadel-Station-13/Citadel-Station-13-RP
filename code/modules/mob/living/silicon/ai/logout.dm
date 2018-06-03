<<<<<<< HEAD
/mob/living/silicon/ai/Logout()
	..()
	for(var/obj/machinery/ai_status_display/O in machines) //change status
		O.mode = 0
	if(!isturf(loc))
		if (client)
			client.eye = loc
			client.perspective = EYE_PERSPECTIVE
	src.view_core()
=======
/mob/living/silicon/ai/Logout()
	..()
	for(var/obj/machinery/ai_status_display/O in machines) //change status
		O.mode = 0
	if(!isturf(loc))
		if (client)
			client.eye = loc
			client.perspective = EYE_PERSPECTIVE
	src.view_core()
>>>>>>> ad18753... Merge pull request #3813 from VOREStation/master
	return