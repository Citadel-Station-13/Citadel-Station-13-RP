// This file holds things required for remote borg control by an AI.

GLOBAL_LIST_EMPTY(available_ai_shells)

/mob/living/silicon/robot
	var/shell = FALSE
	var/deployed = FALSE
	var/mob/living/silicon/ai/mainframe = null

// Premade AI shell, for roundstart shells.
/mob/living/silicon/robot/ai_shell/Initialize(mapload)
	mmi = new /obj/item/mmi/inert/ai_remote(src)
	post_mmi_setup()
	return ..()

// Call after inserting or instantiating an MMI.
/mob/living/silicon/robot/proc/post_mmi_setup()
	if(istype(mmi, /obj/item/mmi/inert/ai_remote))
		make_shell()
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
	else
		playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)
	return

/mob/living/silicon/robot/proc/make_shell()
	shell = TRUE
	braintype = "AI Shell"
	SetName("[modtype] AI Shell [num2text(ident)]")
	GLOB.available_ai_shells |= src
	if(!QDELETED(camera))
		camera.c_tag = real_name	//update the camera name too
	notify_ai(ROBOT_NOTIFICATION_AI_SHELL)
	updateicon()

/mob/living/silicon/robot/proc/revert_shell()
	if(!shell)
		return
	undeploy()
	shell = FALSE
	GLOB.available_ai_shells -= src
	if(!QDELETED(camera))
		camera.c_tag = real_name
	updateicon()

// This should be called before the AI client/mind is actually moved.
/mob/living/silicon/robot/proc/deploy_init(mob/living/silicon/ai/AI)
	// Set the name when the AI steps inside.
	SetName("[AI.real_name] shell [num2text(ident)]")
	if(isnull(sprite_name)) // For custom sprites. It can only chance once in case there are two AIs with custom borg sprites.
		sprite_name = AI.real_name
	if(!QDELETED(camera))
		camera.c_tag = real_name

	// Have the borg have eyes when active.
	mainframe = AI
	deployed = TRUE
	updateicon()

	// Laws.
	connected_ai = mainframe // So they share laws.
	mainframe.connected_robots |= src
	lawsync()

	// Give button to leave.
	verbs += /mob/living/silicon/robot/proc/undeploy_act
	to_chat(AI, SPAN_NOTICE("You have connected to an AI Shell remotely, and are now in control of it.<br>\
	To return to your core, use the <b>Release Control</b> verb."))

	// Languages and comms.
	languages = AI.languages.Copy()
	speech_synthesizer_langs = AI.speech_synthesizer_langs.Copy()
	if(radio && AI.aiRadio && module) //AI keeps all channels, including Syndie if it is an Infiltrator.
		radio.subspace_transmission = TRUE
		module.channels = AI.aiRadio.channels
		radio.recalculateChannels()

// Called after the AI transfers over.
/mob/living/silicon/robot/proc/post_deploy()
	if(!custom_sprite) // Check for custom sprite.
		set_custom_sprite()

/mob/living/silicon/robot/proc/undeploy(message)
	if(!deployed || !mind || !mainframe)
		return
	if(message)
		to_chat(src, SPAN_NOTICE(message))
	mind.transfer_to(mainframe)
	deployed = FALSE
	updateicon()
	mainframe.teleop = null
	mainframe.deployed_shell = null
	SetName("[modtype] AI Shell [num2text(ident)]")
	if(radio && module) //Return radio to normal
		module.channels = initial(module.channels)
		radio.recalculateChannels()
	if(!QDELETED(camera))
		camera.c_tag = real_name //update the camera name too
	if(mainframe.laws)
		mainframe.laws.show_laws(mainframe) //Always remind the AI when switching
	mainframe = null

/mob/living/silicon/robot/proc/undeploy_act()
	set name = "Release Control"
	set desc = "Release control of a remote drone."
	set category = "Robot Commands"

	undeploy("Remote session terminated.")

/mob/living/silicon/robot/attack_ai(mob/user)
	if(shell && config_legacy.allow_ai_shells && (!connected_ai || connected_ai == user))
		var/mob/living/silicon/ai/AI = user
		AI.deploy_to_shell(src)
	else
		return ..()

// Place this on your map to mark where a free AI shell will be.
// This can be turned off in the config (and is off by default).
// Note that mapping in more than one of these will result in multiple shells.
// TODO :USE A SPAWNER OBJECT DAMNIT
/obj/landmark/free_ai_shell
	name = "free ai shell spawner"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	delete_on_roundstart = TRUE

/obj/landmark/free_ai_shell/Initialize(mapload)
	if(config_legacy.allow_ai_shells && config_legacy.give_free_ai_shell)
		new /mob/living/silicon/robot/ai_shell(get_turf(src))
	return ..()
