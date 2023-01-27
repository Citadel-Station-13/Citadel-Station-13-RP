/mob/living/silicon/ai
	var/mob/living/silicon/robot/drone/controlling_drone

/mob/living/silicon/robot/drone
	var/mob/living/silicon/ai/controlling_ai

/mob/living/silicon/robot/drone/attack_ai(var/mob/living/silicon/ai/user)

	if(!istype(user) || controlling_ai || !config_legacy.allow_drone_spawn || !config_legacy.allow_ai_drones)
		return

	if(client || key)
		to_chat(user, SPAN_WARNING("You cannot take control of an autonomous, active drone."))
		return

	if(health < -35 || emagged)
		to_chat(user, SPAN_NOTICE("<b>WARNING:</b> connection timed out."))
		return

	user.controlling_drone = src
	user.teleop = src
	radio.channels = user.aiRadio.keyslot2.channels
	controlling_ai = user
	add_verb(src, /mob/living/silicon/robot/drone/proc/release_ai_control_verb)
	local_transmit = FALSE
	languages = controlling_ai.languages.Copy()
	speech_synthesizer_langs = controlling_ai.speech_synthesizer_langs.Copy()
	set_stat(CONSCIOUS)
	if(user.mind)
		user.mind.transfer_to(src)
	else
		key = user.key
	updatename()
	to_chat(src, SPAN_NOTICE("<b>You have shunted your primary control loop into \a [initial(name)].</b> Use the <b>Release Control</b> verb to return to your core."))

/obj/machinery/drone_fabricator/attack_ai(var/mob/living/silicon/ai/user as mob)

	if(!istype(user) || user.controlling_drone || !config_legacy.allow_drone_spawn || !config_legacy.allow_ai_drones)
		return

	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] is unpowered."))
		return

	if(!produce_drones)
		to_chat(user, SPAN_WARNING("\The [src] is disabled."))
		return

	if(drone_progress < 100)
		to_chat(user, SPAN_WARNING("\The [src] is not ready to produce a new drone."))
		return

	if(count_drones() >= config_legacy.max_maint_drones)
		to_chat(user, SPAN_WARNING("The drone control subsystems are tasked to capacity; they cannot support any more drones."))
		return

	var/mob/living/silicon/robot/drone/new_drone = create_drone()
	user.controlling_drone = new_drone
	user.teleop = new_drone
	new_drone.radio.channels = user.aiRadio.keyslot2.channels
	new_drone.controlling_ai = user
	add_verb(new_drone, /mob/living/silicon/robot/drone/proc/release_ai_control_verb)
	new_drone.local_transmit = FALSE
	new_drone.languages = new_drone.controlling_ai.languages.Copy()
	new_drone.speech_synthesizer_langs = new_drone.controlling_ai.speech_synthesizer_langs.Copy()

	if(user.mind)
		user.mind.transfer_to(new_drone)
	else
		new_drone.key = user.key
	new_drone.updatename()

	to_chat(new_drone, SPAN_NOTICE("<b>You have shunted your primary control loop into \a [initial(new_drone.name)].</b> Use the <b>Release Control</b> verb to return to your core."))

/mob/living/silicon/robot/drone/proc/release_ai_control_verb()
	set name = "Release Control"
	set desc = "Release control of a remote drone."
	set category = "Silicon Commands"

	release_ai_control("Remote session terminated.")

/mob/living/silicon/robot/drone/proc/release_ai_control(var/message = "Connection terminated.")

	if(controlling_ai)
		if(mind)
			mind.transfer_to(controlling_ai)
		else
			controlling_ai.key = key
		to_chat(controlling_ai, SPAN_NOTICE("[message]"))
		controlling_ai.controlling_drone = null
		controlling_ai.teleop = null
		controlling_ai = null

	radio.channels = module.channels
	remove_verb(src, /mob/living/silicon/robot/drone/proc/release_ai_control_verb)
	module.remove_languages(src) //Removes excess, adds 'default'.
	remove_language("Robot Talk")
	add_language("Robot Talk", 0)
	add_language("Drone Talk", 1)
	local_transmit = TRUE
	full_law_reset()
	updatename()
	death()
