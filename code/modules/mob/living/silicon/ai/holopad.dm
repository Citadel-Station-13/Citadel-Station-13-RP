/mob/living/silicon/ai/proc/initiate_holopad_connection(obj/machinery/holopad/pad)

/mob/living/silicon/ai/proc/terminate_holopad_connection()
	#warn impl

#warn impl



//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Settings"

	if(check_unable())
		return

	var/input
	var/choice = alert("Would you like to select a hologram based on a (visible) crew member, switch to unique avatar, or load your character from your character slot?",,"Crew Member","Unique","My Character")

	switch(choice)
		if("Crew Member") //A seeable crew member (or a dog)
			var/list/targets = trackable_mobs()
			if(targets.len)
				input = input("Select a crew member:") as null|anything in targets //The definition of "crew member" is a little loose...
				//This is torture, I know. If someone knows a better way...
				if(!input) return
				var/new_holo = getHologramIcon(get_compound_icon(targets[input]))
				qdel(holo_icon)
				holo_icon = new_holo

			else
				alert("No suitable records found. Aborting.")

		if("My Character") //Loaded character slot
			var/appearance/looks = client?.prefs.render_to_appearance(
				PREF_COPY_TO_UNRESTRICTED_LOADOUT |
				PREF_COPY_TO_FOR_RENDER |
				PREF_COPY_TO_NO_CHECK_SPECIES
			)
			#warn impl
			if(!client || !client.prefs) return
			var/mob/living/carbon/human/dummy/dummy = new ()
			// bypass restrictions
			client.prefs.dress_preview_mob(dummy,
				PREF_COPY_TO_UNRESTRICTED_LOADOUT |
				PREF_COPY_TO_FOR_RENDER |
				PREF_COPY_TO_NO_CHECK_SPECIES
			)
			sleep(1 SECOND) //Strange bug in preview code? Without this, certain things won't show up. Yay race conditions?
			dummy.regenerate_icons()

			var/new_holo = getHologramIcon(get_compound_icon(dummy))
			qdel(holo_icon)
			qdel(dummy)
			holo_icon = new_holo

		else //A premade list from the dmi
			var/icon_list[] = list(

			)
			input = input("Please select a hologram:") as null|anything in icon_list //Holoprojection list
			if(input)
				qdel(holo_icon)
				switch(input)
		#warn convert above
