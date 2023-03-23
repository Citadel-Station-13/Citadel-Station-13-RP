/mob/living/silicon/ai/proc/initiate_holopad_connection(obj/machinery/holopad/pad)
	if(holopad)
		terminate_holopad_connection()
	pad.initiate_ai_hologram(src)


/mob/living/silicon/ai/proc/terminate_holopad_connection()
	holopad?.kill_ai_hologram(src)

/mob/living/silicon/ai/proc/move_active_hologram(turf/target)
	hologram.move_to_target(target, TRUE)

/mob/living/silicon/ai/proc/stop_moving_hologram()
	hologram.stop_moving()

/**
 * get something we can feed into from_appearance() on a hologram
 */
/mob/living/silicon/ai/proc/hologram_appearance()
	// pre transform
	if(ispath(holomodel, /datum/hologram))
		var/datum/hologram/model = holomodel
		holomodel = GLOB.holograms[initial(model.name)]
	else if(istext(holomodel))
		holomodel = GLOB.holograms[holomodel]

	// process
	if(istype(holomodel, /datum/hologram))
		var/datum/hologram/model = holomodel
		return model
	if(isicon(holomodel))
		return image(icon = holomodel)
	else if(isimage(holomodel))
		return holomodel
	else if(IS_APPEARANCE(holomodel))
		return holomodel
	else
		var/static/datum/hologram/fallback_hologram = new /datum/hologram/general/holo_female
		return fallback_hologram

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Settings"

	if(check_unable())
		return

	var/choice = alert(src, "Would you like to select a hologram based on a (visible) crew member, switch to unique avatar, or load your character from your character slot?", "Hologram Change", "Crew Member", "Unique", "My Character")

	switch(choice)
		if("Crew Member") //A seeable crew member (or a dog)
			var/list/targets = trackable_mobs()
			if(!length(targets))
				alert("No suitable crew on tracking list.")
				return
			var/mob/gottem = tgui_input_list(src, "Select a trackable crew member:", "Holoclone", targets, timeout = 1 MINUTE)
			if(!gottem)
				return
			holomodel = make_hologram_appearance(gottem)
			to_chat(src, SPAN_NOTICE("Hologram set."), type = MESSAGE_TYPE_INFO)
		if("My Character")
			var/appearance/looks = client?.prefs.render_to_appearance(
				PREF_COPY_TO_UNRESTRICTED_LOADOUT | PREF_COPY_TO_FOR_RENDER | PREF_COPY_TO_NO_CHECK_SPECIES,
			)
			if(!looks)
				to_chat(src, SPAN_WARNING("Slot load-clone errored. Please report this to a coder."), type = MESSAGE_TYPE_WARNING)
				return
			holomodel = looks
			to_chat(src, SPAN_NOTICE("Hologram set."), type = MESSAGE_TYPE_INFO)
		if("Unique")
			var/model = tgui_input_list(src, "Select a hologram:", "Hologram Model", GLOB.holograms)
			if(!model)
				return
			holomodel = model
			to_chat(src, SPAN_NOTICE("Hologram set."), type = MESSAGE_TYPE_INFO)
