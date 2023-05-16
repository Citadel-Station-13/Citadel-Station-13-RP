/datum/event/communications_blackout
	has_skybox_image = TRUE
	var/botEmagChance = 0
	var/list/players = list()

/datum/event/communications_blackout/get_skybox_image()
	var/color1 = color_matrix_multiply(color_matrix_rotate_hue(rand(-3, 3) * 15), rgba_auto_greyscale_matrix("#8888ff"))
	var/color2 = color_matrix_multiply(color_matrix_rotate_hue(rand(-3, 3) * 15), rgba_auto_greyscale_matrix("#88ff88"))
	var/image/res = image('icons/skybox/caelus.dmi', "aurora")
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	animate_color_shift(res, color1, color2, 1080 * 0.5, 1080 * 0.5)
	return res

/datum/event/communications_blackout/announce()
	var/alert = pick(	"Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
						"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v�-BZZZT", \
						"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT", \
						"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT", \
						"Ionospheri:%� MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>�%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in GLOB.player_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>[alert]</b></span>")
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		command_announcement.Announce(alert, new_sound = sound('sound/misc/interference.ogg', volume=25))


/datum/event/communications_blackout/start()
	if(!length(affecting_z))
		for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
			T.emp_act(1)
		for(var/obj/machinery/exonet_node/N in GLOB.machines)
			N.emp_act(1)
	else
		for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
			if(!(T.z in affecting_z))
				continue
			T.emp_act(1)
		for(var/obj/machinery/exonet_node/N in GLOB.machines)
			if(!(N.z in affecting_z))
				continue
			N.emp_act(1)

/datum/event/communications_blackout/overmap/announce()
	command_announcement.Announce("Ionospheric anomalies detected. Communications failing!", new_sound = sound('sound/misc/interference.ogg', volume=25))
	return
