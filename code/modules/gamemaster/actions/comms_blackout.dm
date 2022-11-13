/datum/gm_action/comms_blackout
	name = "communications blackout"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_EVERYONE)
	chaotic = 45

/datum/gm_action/comms_blackout/get_weight()
	return 20 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20)

/datum/gm_action/comms_blackout/announce()
	if(prob(80))
		command_announcement.Announce("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT", new_sound = 'sound/misc/interference.ogg')
	// AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
	for(var/mob/living/silicon/ai/A in GLOB.player_list)
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT</b></span>")
		to_chat(A, "<br>")

/datum/gm_action/comms_blackout/start()
	..()
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		T.emp_act(1)
