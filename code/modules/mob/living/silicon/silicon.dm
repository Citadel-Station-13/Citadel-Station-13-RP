/datum/category_item/catalogue/fauna/silicon
	name = "Silicons"
	desc = "Silicon based life, in all its myriad forms, began as a \
	tool of some kind. This history has lead to a disconnect between \
	synthetic and organic life which varies in severity across cultures."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/silicon)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_silicons
	name = "Collection - Silicons"
	desc = "You have scanned a large array of different types of Silicons, \
	and therefore you have been granted a fair sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/silicon/ai,
		/datum/category_item/catalogue/fauna/silicon/pai,
		/datum/category_item/catalogue/fauna/silicon/robot
		)

/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	silicon_privileges = PRIVILEGES_SILICON
	rad_flags = RAD_BLOCK_CONTENTS
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	var/lawchannel = MAIN_CHANNEL // Default channel on which to state laws
	var/list/stating_laws = list()// Channels laws are currently being stated on
	var/obj/item/radio/common_radio

	var/list/speech_synthesizer_langs = list()	//which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/camera/siliconcam/aiCamera = null //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	var/list/access_rights
	var/obj/item/card/id/idcard
	var/idcard_type = /obj/item/card/id/synthetic

	var/hudmode = null

	/// our translation context
	var/datum/translation_context/translation_context
	/// default translation context type
	var/translation_context_type = /datum/translation_context/simple/silicons

/mob/living/silicon/Initialize(mapload)
	silicon_mob_list |= src
	. = ..()
	add_language(LANGUAGE_GALCOM)
	set_default_language(RSlanguages.fetch_local_or_throw(/datum/prototype/language/common))
	create_translation_context()
	init_id()
	init_subsystems()

	for(var/datum/prototype/language/L as anything in RSlanguages.fetch_subtypes_immutable(/datum/prototype/language))
		if(L.translation_class & TRANSLATION_CLASS_LEVEL_1)
			add_language(L)
	add_language(LANGUAGE_EAL)

/mob/living/silicon/Destroy()
	silicon_mob_list -= src
	for(var/datum/alarm_handler/AH in SSalarms.all_handlers)
		AH.unregister_alarm(src)
	return ..()

/mob/living/silicon/proc/init_id()
	if(idcard)
		return
	idcard = new idcard_type(src)
	set_id_info(idcard)

/mob/living/silicon/proc/SetName(pickedName = "Alice")
	real_name = pickedName
	name = real_name

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/PhysicalLife(seconds, times_fired)
	if((. = ..()))
		return
	handle_modifiers()
	handle_light()
	handle_regular_hud_updates()
	handle_vision()

/mob/living/silicon/handle_regular_hud_updates()
	. = ..()
	SetSeeInvisibleSelf(SEE_INVISIBLE_LIVING)
	SetSightSelf(SIGHT_FLAGS_DEFAULT)
	if(bodytemp)
		switch(src.bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				src.bodytemp.icon_state = "temp2"
			if(320 to 335)
				src.bodytemp.icon_state = "temp1"
			if(300 to 320)
				src.bodytemp.icon_state = "temp0"
			if(260 to 300)
				src.bodytemp.icon_state = "temp-1"
			else
				src.bodytemp.icon_state = "temp-2"

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	return 0//The only effect that can hit them atm is flashes and they still directly edit so this works for now

/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if (bot.connected_ai == ai)
		return 1
	return 0

// this function shows the health of the AI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	. = list()
	if(!src.stat)
		STATPANEL_DATA_LINE("System integrity: [round((health/getMaxHealth())*100)]%")
	else
		STATPANEL_DATA_LINE("Systems nonfunctional")

// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return list()

// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/statpanel_data(client/C)
	. = ..()
	if(C.statpanel_tab("Status"))
		STATPANEL_DATA_LINE("")
		. += show_system_integrity()
		. += show_malf_ai()

// this function displays the stations manifest in a separate window
/mob/living/silicon/proc/show_station_manifest()
	var/dat = "<div align='center'>"
	if(!data_core)
		to_chat(src,"<span class='notice'>There is no data to form a manifest with. Contact your Nanotrasen administrator.</span>")
		return
	dat += data_core.get_manifest(1) //The 1 makes it monochrome.

	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user, var/error_msg, var/target_zone, var/ignore_thickness = FALSE)
	if(error_msg)
		to_chat(user, "<span class='alert'>The armoured plating is too tough.</span>")
	return 0

//Silicon mob language procs

/mob/living/silicon/can_speak(datum/prototype/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs) || (speaking.name == "Noise")	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	var/datum/prototype/language/added_language = RSlanguages.legacy_resolve_language_name(language)
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return 1

/mob/living/silicon/remove_language(var/rem_language)
	var/datum/prototype/language/removed_language = RSlanguages.legacy_resolve_language_name(rem_language)
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_languages()
	set name = "Check Known Languages"
	set category = VERB_CATEGORY_IC
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/prototype/language/L in languages)
		if(!(L.language_flags & LANGUAGE_NONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b>[synth ? default_str : null]<br/>Speech Synthesizer: <i>[synth ? "YES" : "NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) as null|anything in list("Security","Medical","Disable")
	if(isnull(sensor_type))
		return

	self_perspective.remove_atom_hud(source = ATOM_HUD_SOURCE_SILICON_SENSOR_AUGMENT)
	switch(sensor_type)
		if ("Security")
			self_perspective.add_atom_hud(/datum/atom_hud/data/human/security/advanced, ATOM_HUD_SOURCE_SILICON_SENSOR_AUGMENT)
			to_chat(src,"<span class='notice'>Security records overlay enabled.</span>")
		if ("Medical")
			self_perspective.add_atom_hud(/datum/atom_hud/data/human/medical, ATOM_HUD_SOURCE_SILICON_SENSOR_AUGMENT)
			to_chat(src,"<span class='notice'>Life signs monitor overlay enabled.</span>")
		if ("Disable")
			to_chat(src,"Sensor augmentations disabled.")

	hudmode = sensor_type //This is checked in examine.dm on humans, so they can see medical/security records depending on mode

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = VERB_CATEGORY_IC

	pose =  sanitize(input(usr, "This is [src]. It is...", "Pose", null)  as text)

	visible_emote("adjusts its posture.")

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = VERB_CATEGORY_IC

	flavor_text =  sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text)

/mob/living/silicon/binarycheck()
	return 1

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler, var/datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)
	if(alarm.hidden)
		return

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						to_chat(src, "<span class='warning'>--- [AH.category] Detected ---</span>")
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = 1
						to_chat(src, "<span class='notice'>--- [AH.category] Cleared ---</span>")
					to_chat(src, "\The [A.alarm_name()].")

		if(alarm_raised)
			to_chat(src, "<A HREF=?src=\ref[src];showalerts=1>\[Show Alerts\]</A>")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	to_chat(src, "[A.alarm_name()]!")

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"
	to_chat(src, "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])")


/mob/living/silicon/proc/is_traitor()
	return mind && (mind in traitors.current_antagonists)

/mob/living/silicon/proc/is_malf()
	return mind && (mind in malf.current_antagonists)

/mob/living/silicon/proc/is_malf_or_traitor()
	return is_traitor() || is_malf()

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/tiled/flash)
	if(affect_silicon)
		return ..()

/mob/living/silicon/proc/clear_client()
	//Handle job slot/tater cleanup.
	var/job = mind.assigned_role

	SSjob.FreeRole(job)

	if(mind.objectives.len)
		qdel(mind.objectives)
		mind.special_role = null

	clear_antag_roles(mind)

	ghostize(0)
	qdel(src)

/mob/living/silicon/has_vision()
	return 0 //NOT REAL EYES

//! Topic
/mob/living/silicon/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["ooc_notes"])
		src.Examine_OOC()
		return TRUE
