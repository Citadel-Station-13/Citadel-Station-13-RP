/mob/living/silicon/ai/Logout()
	..()
	for(var/obj/machinery/ai_status_display/O in machines) //change status
		O.mode = 0
	view_core()
