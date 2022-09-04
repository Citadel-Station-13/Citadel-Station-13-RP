/mob/living/carbon/human/instantiate_hud(var/datum/hud/HUD, var/ui_style, var/ui_color, var/ui_alpha)
	HUD.human_hud(ui_style, ui_color, ui_alpha, src)

/datum/hud/proc/human_hud(var/ui_style='icons/mob/screen1_White.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255, var/mob/living/carbon/human/target)
	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()
	else
		hud_data = target.species.hud

	if(hud_data.icon)
		ui_style = hud_data.icon

	src.adding = list()
	src.other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey users
	slot_info = list()
	hand_info = list()

	var/list/hud_elements = list()
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/slot/inv_box

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)

		inv_box = new /atom/movable/screen/inventory/slot()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  hud_data.gear[gear_slot]
		inv_box.name =        gear_slot
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]
		slot_info["[inv_box.slot_id]"] = inv_box.screen_loc

		if(slot_data["dir"])
			inv_box.setDir(slot_data["dir"])

		if(slot_data["toggle"])
			src.other += inv_box
			has_hidden_gear = 1
		else
			src.adding += inv_box

	if(has_hidden_gear)
		using = new /atom/movable/screen()
		using.name = "toggle"
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.hud_layerise()
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)

		using = new /atom/movable/screen()
		using.name = "act_intent"
		using.icon = ui_style
		using.icon_state = "intent_"+mymob.a_intent
		using.screen_loc = ui_acti
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		action_intent = using

		hud_elements |= using

		//intent small hud objects
		var/icon/ico

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
		using = new /atom/movable/screen()
		using.name = INTENT_HELP
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		using.layer = LAYER_HUD_ITEM //These sit on the intent box
		src.adding += using
		help_intent = using

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
		using = new /atom/movable/screen()
		using.name = INTENT_DISARM
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		using.layer = LAYER_HUD_ITEM
		src.adding += using
		disarm_intent = using

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
		using = new /atom/movable/screen()
		using.name = INTENT_GRAB
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		using.layer = LAYER_HUD_ITEM
		src.adding += using
		grab_intent = using

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
		using = new /atom/movable/screen()
		using.name = INTENT_HARM
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		using.layer = LAYER_HUD_ITEM
		src.adding += using
		hurt_intent = using
		//end intent small hud objects

	if(hud_data.has_m_intent)
		using = new /atom/movable/screen()
		using.name = "mov_intent"
		using.icon = ui_style
		using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
		using.screen_loc = ui_movi
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /atom/movable/screen()
		using.name = "drop"
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_hands)

		using = new /atom/movable/screen()
		using.name = "equip"
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		var/atom/movable/screen/inventory/hand/right/right_hand = new
		right_hand.index = 2
		using = right_hand
		using.hud = src
		using.name = "r_hand"
		using.icon = ui_style
		using.icon_state = "r_hand_inactive"
		if(!target.hand)	//This being 0 or null means the right hand is in use
			using.icon_state = "r_hand_active"
		using.screen_loc = ui_rhand
		using.color = ui_color
		using.alpha = ui_alpha
		src.r_hand_hud_object = using
		src.adding += using
		hand_info["2"] = using.screen_loc

		var/atom/movable/screen/inventory/hand/left/left_hand = new
		left_hand.index = 1
		using = left_hand
		using.hud = src
		using.name = "l_hand"
		using.icon = ui_style
		using.icon_state = "l_hand_inactive"
		if(target.hand)	//This being 1 means the left hand is in use
			using.icon_state = "l_hand_active"
		using.screen_loc = ui_lhand
		using.color = ui_color
		using.alpha = ui_alpha
		src.l_hand_hud_object = using
		src.adding += using
		hand_info["1"] = using.screen_loc

		using = new /atom/movable/screen/inventory/swap_hands
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = ui_swaphand1
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		using = new /atom/movable/screen/inventory/swap_hands
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = ui_swaphand2
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	if(hud_data.has_resist)
		using = new /atom/movable/screen()
		using.name = "resist"
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_throw)
		mymob.throw_icon = new /atom/movable/screen/hud/throwmode(null, src)
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

		mymob.pullin = new /atom/movable/screen()
		mymob.pullin.icon = ui_style
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.name = "pull"
		mymob.pullin.screen_loc = ui_pull_resist
		src.hotkeybuttons += mymob.pullin
		hud_elements |= mymob.pullin

	if(hud_data.has_internals)
		mymob.internals = new /atom/movable/screen()
		mymob.internals.icon = ui_style
		mymob.internals.icon_state = "internal0"
		mymob.internals.name = "internal"
		mymob.internals.screen_loc = ui_internal
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.healths = new /atom/movable/screen/healths()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.name = "health"
		mymob.healths.screen_loc = ui_health
		hud_elements |= mymob.healths

		mymob.oxygen = new /atom/movable/screen/oxygen()
		mymob.oxygen.icon = 'icons/mob/status_indicators_hud.dmi'
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.name = "oxygen"
		mymob.oxygen.screen_loc = ui_temp
		hud_elements |= mymob.oxygen

		mymob.toxin = new /atom/movable/screen/toxins()
		mymob.toxin.icon = 'icons/mob/status_indicators_hud.dmi'
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.name = "toxin"
		mymob.toxin.screen_loc = ui_temp
		hud_elements |= mymob.toxin

		mymob.fire = new /atom/movable/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.name = "fire"
		mymob.fire.screen_loc = ui_fire
		hud_elements |= mymob.fire

	if(hud_data.has_pressure)
		mymob.pressure = new /atom/movable/screen/pressure()
		mymob.pressure.icon = 'icons/mob/status_indicators_hud.dmi'
		mymob.pressure.icon_state = "pressure0"
		mymob.pressure.name = "pressure"
		mymob.pressure.screen_loc = ui_temp
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /atom/movable/screen/bodytemperature()
		mymob.bodytemp.icon = 'icons/mob/status_indicators_hud.dmi'
		mymob.bodytemp.icon_state = "temp1"
		mymob.bodytemp.name = "body temperature"
		mymob.bodytemp.screen_loc = ui_temp
		hud_elements |= mymob.bodytemp

	if(target.isSynthetic()) //are we a synth?
		mymob.synthbattery_icon = new /atom/movable/screen()
		mymob.synthbattery_icon.icon = 'icons/mob/screen1_robot.dmi' //dont define a new ui_style when we are only changing a single entry
		mymob.synthbattery_icon.icon_state = "charge0" //use the power cell icons for robots; burger icons OUT
		mymob.synthbattery_icon.name = "cell"
		mymob.synthbattery_icon.screen_loc = ui_nutrition
		hud_elements |= mymob.synthbattery_icon

	else if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /atom/movable/screen/food()
		mymob.nutrition_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.nutrition_icon.pixel_w = 8
		mymob.nutrition_icon.icon_state = "nutrition1"
		mymob.nutrition_icon.name = "nutrition"
		mymob.nutrition_icon.screen_loc = ui_nutrition_small
		hud_elements |= mymob.nutrition_icon

		mymob.hydration_icon = new /atom/movable/screen/drink()
		mymob.hydration_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.hydration_icon.icon_state = "hydration1"
		mymob.hydration_icon.name = "hydration"
		mymob.hydration_icon.screen_loc = ui_nutrition_small
		hud_elements |= mymob.hydration_icon

	mymob.shadekin_display = new /atom/movable/screen/shadekin()
	mymob.shadekin_display.screen_loc = ui_shadekin_display
	mymob.shadekin_display.icon_state = "shadekin"
	hud_elements |= mymob.shadekin_display

	mymob.xenochimera_danger_display = new /atom/movable/screen/xenochimera/danger_level()
	mymob.xenochimera_danger_display.screen_loc = ui_xenochimera_danger_display
	mymob.xenochimera_danger_display.icon_state = "danger00"
	hud_elements |= mymob.xenochimera_danger_display

	mymob.ling_chem_display = new /atom/movable/screen/ling/chems()
	mymob.ling_chem_display.screen_loc = ui_ling_chemical_display
	mymob.ling_chem_display.icon_state = "ling_chems"
	hud_elements |= mymob.ling_chem_display

	mymob.wiz_instability_display = new /atom/movable/screen/wizard/instability()
	mymob.wiz_instability_display.screen_loc = ui_wiz_instability_display
	mymob.wiz_instability_display.icon_state = "wiz_instability_none"
	hud_elements |= mymob.wiz_instability_display

	mymob.wiz_energy_display = new/atom/movable/screen/wizard/energy()
	mymob.wiz_energy_display.screen_loc = ui_wiz_energy_display
	mymob.wiz_energy_display.icon_state = "wiz_energy"
	hud_elements |= mymob.wiz_energy_display


	mymob.pain = new /atom/movable/screen( null )

	mymob.zone_sel = new /atom/movable/screen/zone_sel( null )
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_color
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")
	hud_elements |= mymob.zone_sel

	/*
	mymob.crafting = new /atom/movable/screen/crafting(null)
	mymob.crafting.icon = ui_style
	mymob.crafting.color = ui_color
	mymob.crafting.alpha = ui_alpha
	hud_elements |= mymob.crafting
	*/

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.color = ui_color
	mymob.gun_setting_icon.alpha = ui_alpha
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon = new /atom/movable/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.color = ui_color
	mymob.item_use_icon.alpha = ui_alpha

	mymob.gun_move_icon = new /atom/movable/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.color = ui_color
	mymob.gun_move_icon.alpha = ui_alpha

	mymob.radio_use_icon = new /atom/movable/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.color = ui_color
	mymob.radio_use_icon.alpha = ui_alpha

	mymob.client.screen = list()

	mymob.client.screen += hud_elements
	mymob.client.screen += src.adding + src.hotkeybuttons
	inventory_shown = 0

	mymob.reload_rendering()

	return


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

//Used for new human mobs created by cloning/goleming/etc.
/mob/living/carbon/human/proc/set_cloned_appearance()
	f_style = "Shaved"
	if(dna.species == SPECIES_HUMAN) //no more xenos losing ears/tentacles
		h_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")
	all_underwear.Cut()
	regenerate_icons()

/atom/movable/screen/ling
	invisibility = 101

/atom/movable/screen/ling/chems
	name = "chemical storage"
	icon_state = "power_display"

/atom/movable/screen/wizard
	invisibility = 101

/atom/movable/screen/wizard/instability
	name = "instability"
	icon_state = "instability-1"
	invisibility = 0

/atom/movable/screen/wizard/energy
	name = "energy"
	icon_state = "wiz_energy"

/atom/movable/screen/healths/Click_vr()
	if(istype(usr) && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.help_shake_act(C)

/atom/movable/screen/food/Click_vr()
	if(istype(usr) && usr.nutrition_icon == src)
		switch(icon_state)
			if("nutrition0")
				to_chat(usr, SPAN_WARNING("You are completely stuffed."))
			if("nutrition1")
				to_chat(usr, SPAN_NOTICE("You are not hungry."))
			if("nutrition2")
				to_chat(usr, SPAN_NOTICE("You are a bit peckish."))
			if("nutrition3")
				to_chat(usr, SPAN_WARNING("You are quite hungry."))
			if("nutrition4")
				to_chat(usr, SPAN_DANGER("You are starving!"))

/atom/movable/screen/drink/Click_vr()
	if(istype(usr) && usr.hydration_icon == src)
		switch(icon_state)
			if("hydration0")
				to_chat(usr, SPAN_WARNING("You are overhydrated."))
			if("hydration1")
				to_chat(usr, SPAN_NOTICE("You are not thirsty."))
			if("hydration2")
				to_chat(usr, SPAN_NOTICE("You are a bit thirsty."))
			if("hydration3")
				to_chat(usr, SPAN_WARNING("You are quite thirsty."))
			if("hydration4")
				to_chat(usr, SPAN_DANGER("You are dying of thirst!"))

/atom/movable/screen/bodytemperature/Click_vr()
	if(istype(usr) && usr.bodytemp == src)
		switch(icon_state)
			if("temp4")
				to_chat(usr, SPAN_DANGER("You are being cooked alive!"))
			if("temp3")
				to_chat(usr, SPAN_DANGER("Your body is burning up!"))
			if("temp2")
				to_chat(usr, SPAN_DANGER("You are overheating."))
			if("temp1")
				to_chat(usr, SPAN_WARNING("You are uncomfortably hot."))
			if("temp-4")
				to_chat(usr, SPAN_DANGER("You are being frozen solid!"))
			if("temp-3")
				to_chat(usr, SPAN_DANGER("You are freezing cold!"))
			if("temp-2")
				to_chat(usr, SPAN_WARNING("You are dangerously chilled"))
			if("temp-1")
				to_chat(usr, SPAN_NOTICE("You are uncomfortably cold."))
			else
				to_chat(usr, SPAN_NOTICE("Your body is at a comfortable temperature."))

/atom/movable/screen/pressure/Click_vr()
	if(istype(usr) && usr.pressure == src)
		switch(icon_state)
			if("pressure2")
				to_chat(usr, SPAN_DANGER("The air pressure here is crushing!"))
			if("pressure1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously high."))
			if("pressure-1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously low."))
			if("pressure-2")
				to_chat(usr, SPAN_DANGER("There is nearly no air pressure here!"))
			else
				to_chat(usr, SPAN_NOTICE("The local air pressure is comfortable."))

/atom/movable/screen/toxins/Click_vr()
	if(istype(usr) && usr.toxin == src)
		if(icon_state == "tox0")
			to_chat(usr, SPAN_NOTICE("The air is clear of toxins."))
		else
			to_chat(usr, SPAN_DANGER("The air is eating away at your skin!"))

/atom/movable/screen/oxygen/Click_vr()
	if(istype(usr) && usr.oxygen == src)
		if(icon_state == "oxy0")
			to_chat(usr, SPAN_NOTICE("You are breathing easy."))
		else
			to_chat(usr, SPAN_DANGER("You cannot breathe!"))
