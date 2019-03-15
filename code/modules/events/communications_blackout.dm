/datum/event/communications_blackout/announce()
	var/alert = pick(	"Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
						"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v¬-BZZZT", \
						"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT", \
						"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT", \
						"Ionospheri:%£ MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>£%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in player_list)	//AIs are always aware of communication blackouts.
		A << "<br>"
		A << "<span class='warning'><b>[alert]</b></span>"
		A << "<br>"

	if(prob(80))	//most of the time, we do want an announcement, because no one plays AI
		command_announcement.Announce(alert, new_sound = sound('sound/misc/interference.ogg', volume=25))


/datum/event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
	for(var/obj/machinery/exonet_node/N in machines)
		N.emp_act(1)
