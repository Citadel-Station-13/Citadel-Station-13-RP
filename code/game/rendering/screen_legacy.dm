
/atom/movable/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/atom/movable/screen/item_action
	var/obj/item/owner

/atom/movable/screen/item_action/Destroy()
	. = ..()
	owner = null

/atom/movable/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(!usr.canClick())
		return

	if(usr.stat || usr.restrained() || !CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1

/atom/movable/screen/grab
	name = "grab"

/atom/movable/screen/grab/Click()
	var/obj/item/grab/G = master
	G.s_click(src)
	return 1

/atom/movable/screen/grab/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	return

/atom/movable/screen/grab/attackby()
	return

/// The UI Button to open the TGUI Crafting Menu
/atom/movable/screen/craft
	name = "crafting menu"
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "craft"
	screen_loc = ui_smallquad

/atom/movable/screen/craft/Click(location, control, params)
	var/datum/component/personal_crafting/C = usr.GetComponent(/datum/component/personal_crafting)
	C?.ui_interact(usr)

/atom/movable/screen/Click(location, control, params)
	..() //Why the FUCK was this not called before
	if(!usr)
		return TRUE
	switch(name)
		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("mov_intent")
			// todo: reworks
			if(isliving(usr))
				if(iscarbon(usr))
					var/mob/living/carbon/C = usr
					if(C.legcuffed)
						to_chat(C, "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>")
						C.m_intent = "walk"	//Just incase
						C.hud_used.move_intent.icon_state = "walking"
						return 1
				var/mob/living/L = usr
				L.toggle_move_intent()
		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(CHECK_MOBILITY(C, MOBILITY_CAN_USE))
					if(C.internal)
						C.internal = null
						to_chat(C, "<span class='notice'>No longer running on internals.</span>")
						if(C.internals)
							C.internals.icon_state = "internal0"
					else

						var/no_mask
						if(!(C.wear_mask && C.wear_mask.clothing_flags & ALLOWINTERNALS))
							var/mob/living/carbon/human/H = C
							if(!(H.head && H.head.clothing_flags & ALLOWINTERNALS))
								no_mask = 1

						if(no_mask)
							to_chat(C, "<span class='notice'>You are not wearing a suitable mask or helmet.</span>")
							return 1
						else
							// groan. lazy time.
							// location name
							var/list/locnames = list()
							// tank ref, can include nulls! FIRST VALID TANK FROM THIS IS CHOSEN.
							var/list/tanks = list()
							// first, hand
							locnames += "in your hand"
							tanks += C.get_active_held_item()
							// yes, the above can result in duplicates.
							// snowflake rig handling, second highest priority
							if(istype(C.back, /obj/item/hardsuit))
								var/obj/item/hardsuit/R = C.back
								if(R.air_supply && R?.is_activated())
									locnames += "in your hardsuit"
									tanks += R.air_supply
							// now, slots
							if(ishuman(C))
								var/mob/living/carbon/human/H = C
								// suit storage
								locnames += "on your suit"
								tanks += H.s_store
								// hands
								for(var/i in 1 to length(H.inventory?.held_items))
									tanks += H.inventory?.held_items[i]
									if(i <= 2)
										locnames += "in your [i == 1? "left" : "right"] hand"
									else
										locnames += "in your [ceil(i / 2)](th) [i % 2? "left" : "right"] hand"
								// pockets
								locnames += "in your left pocket"
								tanks += H.l_store
								locnames += "in your right pocket"
								tanks += H.r_store
								// belt
								locnames += "on your belt"
								tanks += H.belt
								// back
								locnames += "on your back"
								tanks += H.back
							else
								// hands
								for(var/i in 1 to length(C.inventory?.held_items))
									tanks += C.inventory?.held_items[i]
									if(i <= 2)
										locnames += "in your [i == 1? "left" : "right"] hand"
									else
										locnames += "in your [ceil(i / 2)](th) [i % 2? "left" : "right"] hand"
								// back
								locnames += "on your back"
								tanks += C.back
							// no more hugbox and stupid "smart" checks. take the first one we can find and use it. they can use active hand to override if needed.
							for(var/index = 1 to length(tanks))
								if(!istype(tanks[index], /obj/item/tank))
									continue
								C.internal = tanks[index]
								to_chat(C, "<span class='notice'>You are now running on internals from [tanks[index]] [locnames[index]]</span>")
								if(C.internals)
									C.internals.icon_state = "internal1"
								return
							to_chat(C, "<span class='warning'>You don't have an internals tank.</span>")
							return
		if("act_intent")
			usr.a_intent_change(INTENT_HOTKEY_RIGHT)
		if(INTENT_HELP)
			usr.a_intent = INTENT_HELP
			usr.hud_used.action_intent.icon_state = "intent_help"
		if(INTENT_HARM)
			usr.a_intent = INTENT_HARM
			usr.hud_used.action_intent.icon_state = "intent_harm"
		if(INTENT_GRAB)
			usr.a_intent = INTENT_GRAB
			usr.hud_used.action_intent.icon_state = "intent_grab"
		if(INTENT_DISARM)
			usr.a_intent = INTENT_DISARM
			usr.hud_used.action_intent.icon_state = "intent_disarm"

		if("pull")
			usr.stop_pulling()
		if("drop")
			if(usr.client)
				usr.client.drop_item()

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
//				if(R.module)
//					R.hud_used.toggle_show_robot_modules()
//					return 1
				R.pick_module()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					to_chat(R, "You haven't selected a module yet.")

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.uneq_active()
					R.hud_used.update_robot_modules_display()
				else
					to_chat(R, "You haven't selected a module yet.")

		if("module1")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(1)

		if("module2")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(2)

		if("module3")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(3)

		if("AI Core")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.view_core()

		if("Show Camera List")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/camera = input(AI) in AI.get_camera_list()
				AI.ai_camera_list(camera)

		if("Track With Camera")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/target_name = input(AI) in AI.trackable_mobs()
				AI.ai_camera_track(target_name)

		if("Toggle Camera Light")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.toggle_camera_light()

		if("Crew Monitoring")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.subsystem_crew_monitor()

		if("Show Crew Manifest")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_roster()

		if("Show Alerts")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.subsystem_alarm_monitor()

		if("Announcement")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_announcement()

		if("Call Emergency Shuttle")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_call_shuttle()

		if("State Laws")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_checklaws()

		if("PDA - Send Message")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.aiPDA.cmd_send_pdamesg(usr)

		if("PDA - Show Message Log")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.aiPDA.cmd_show_message_log(usr)

		if("Take Image")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.take_image()

		if("View Images")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.view_images()
		else
			return attempt_vr(src,"Click_vr",list(location,control,params))
	return 1

//! ## VR FILE MERGE ## !//

/atom/movable/screen/proc/Click_vr(location, control, params)
	if(!usr)	return 1
	switch(name)

		//Shadekin
		if("darkness")
			var/turf/T = get_turf(usr)
			var/darkness = round(1 - T.get_lumcount(),0.1)
			to_chat(usr,"<span class='notice'><b>Darkness:</b> [darkness]</span>")
		if("energy")
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/shadekin))
				to_chat(usr,"<span class='notice'><b>Energy:</b> [H.shadekin_get_energy(H)]</span>")

		if("danger level")
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/shapeshifter/xenochimera))
				if(H.feral > 50)
					to_chat(usr, "<span class='warning'>You are currently <b>completely feral.</b></span>")
				else if(H.feral > 10)
					to_chat(usr, "<span class='warning'>You are currently <b>crazed and confused.</b></span>")
				else if(H.feral > 0)
					to_chat(usr, "<span class='warning'>You are currently <b>acting on instinct.</b></span>")
				else
					to_chat(usr, "<span class='notice'>You are currently <b>calm and collected.</b></span>")
				if(H.feral > 0)
					var/feral_passing = TRUE
					if(H.traumatic_shock > min(60, H.nutrition/10))
						to_chat(usr, "<span class='warning'>Your pain prevents you from regaining focus.</span>")
						feral_passing = FALSE
					if(H.feral + H.nutrition < 150)
						to_chat(usr, "<span class='warning'>Your hunger prevents you from regaining focus.</span>")
						feral_passing = FALSE
					if(H.jitteriness >= 100)
						to_chat(usr, "<span class='warning'>Your jitterness prevents you from regaining focus.</span>")
						feral_passing = FALSE
					if(feral_passing)
						var/turf/T = get_turf(H)
						if(T.get_lumcount() <= 0.1)
							to_chat(usr, "<span class='notice'>You are slowly calming down in darkness' safety...</span>")
						else
							to_chat(usr, "<span class='notice'>You are slowly calming down... But safety of darkness is much preferred.</span>")
				else
					if(H.nutrition < 150)
						to_chat(usr, "<span class='warning'>Your hunger is slowly making you unstable.</span>")

		else
			return 0

	return 1


// Character setup stuff
/atom/movable/screen/setup_preview

	var/datum/preferences/pref

/atom/movable/screen/setup_preview/Destroy()
	pref = null
	return ..()

// Background 'floor'
/atom/movable/screen/setup_preview/bg
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/setup_preview/bg/Click(params)
	pref?.bgstate = next_list_item(pref.bgstate, pref.bgstate_options)
	pref?.update_character_previews()
