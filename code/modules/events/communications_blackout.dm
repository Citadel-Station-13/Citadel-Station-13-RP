/datum/event/communications_blackout
	has_skybox_image = TRUE
	var/botEmagChance = 0
	var/cloud_hueshift
	var/list/players = list()

/datum/event/communications_blackout/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3, 3) * 15)
	var/image/res = image('icons/skybox/caelus.dmi', "aurora")
	res.color = cloud_hueshift
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res



/datum/event/communications_blackout/announce()
	var/alert = pick(	"Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
						"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v¬-BZZZT", \
						"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT", \
						"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT", \
						"Ionospheri:%£ MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>£%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in player_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>[alert]</b></span>")
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		command_announcement.Announce(alert, new_sound = sound('sound/misc/interference.ogg', volume=25))


/datum/event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
	for(var/obj/machinery/exonet_node/N in machines)
		N.emp_act(1)

/datum/event/communications_blackout/overmap/announce()
	command_announcement.Announce("Ionospheric anomalies detected. Communications failing!", new_sound = sound('sound/misc/interference.ogg', volume=25))
	return