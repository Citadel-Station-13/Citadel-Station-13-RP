/*
	The global hud:
	Uses the same visual objects for all players.
*/

GLOBAL_DATUM_INIT(global_hud, /datum/global_hud, new)

/datum/hud
	var/atom/movable/screen/grab_intent
	var/atom/movable/screen/hurt_intent
	var/atom/movable/screen/disarm_intent
	var/atom/movable/screen/help_intent

/datum/global_hud
	var/atom/movable/screen/whitense
	var/list/darkMask
	var/atom/movable/screen/centermarker
	var/atom/movable/screen/holomap

/atom/movable/screen/global_screen
	screen_loc = SCREEN_LOC_FULLSCREEN
	plane = FULLSCREEN_PLANE
	mouse_opacity = 0

/datum/global_hud/New()
	//static overlay effect for cameras and the like
	whitense = new /atom/movable/screen/global_screen()
	whitense.icon = 'icons/effects/static.dmi'
	whitense.icon_state = "1 light"

	//Marks the center of the screen, for things like ventcrawl
	centermarker = new /atom/movable/screen()
	centermarker.icon = 'icons/mob/screen1.dmi'
	centermarker.icon_state = "centermarker"
	centermarker.screen_loc = "CENTER,CENTER"

	//Marks the center of the screen, for things like ventcrawl
	centermarker = new /atom/movable/screen()
	centermarker.icon = 'icons/mob/screen1.dmi'
	centermarker.icon_state = "centermarker"
	centermarker.screen_loc = "CENTER,CENTER"

	// The holomap screen object is actually totally invisible.
	// Station maps work by setting it as an images location before sending to client, not
	// actually changing the icon or icon state of the screen object itself!
	// Why do they work this way? I don't know really, that is how /vg designed them, but since they DO
	// work this way, we can take advantage of their immutability by making them part of
	// the global_hud (something we have and /vg doesn't) instead of an instance per mob.
	holomap = new /atom/movable/screen()
	holomap.name = "holomap"
	holomap.icon = null
	holomap.screen_loc = ui_holomap
	holomap.mouse_opacity = 0

	var/atom/movable/screen/O
	var/i

	//welding mask overlay black/dither
	darkMask = newlist(/atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen)
	O = darkMask[1]
	O.screen_loc = "WEST+2,SOUTH+2 to WEST+4,NORTH-2"
	O = darkMask[2]
	O.screen_loc = "WEST+4,SOUTH+2 to EAST-5,SOUTH+4"
	O = darkMask[3]
	O.screen_loc = "WEST+5,NORTH-4 to EAST-5,NORTH-2"
	O = darkMask[4]
	O.screen_loc = "EAST-4,SOUTH+2 to EAST-2,NORTH-2"
	O = darkMask[5]
	O.screen_loc = "WEST,SOUTH to EAST,SOUTH+1"
	O = darkMask[6]
	O.screen_loc = "WEST,SOUTH+2 to WEST+1,NORTH"
	O = darkMask[7]
	O.screen_loc = "EAST-1,SOUTH+2 to EAST,NORTH"
	O = darkMask[8]
	O.screen_loc = "WEST+2,NORTH-1 to EAST-2,NORTH"

	for(i = 1, i <= 4, i++)
		O = darkMask[i]
		O.icon_state = "dither50"
		O.plane = FULLSCREEN_PLANE
		O.mouse_opacity = 0

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.plane = FULLSCREEN_PLANE
		O.mouse_opacity = 2

/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob

	var/hud_shown = 1			//Used for the HUD toggle (F12)
	var/inventory_shown = 1		//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/atom/movable/screen/lingchemdisplay
	var/atom/movable/screen/wiz_instability_display
	var/atom/movable/screen/wiz_energy_display
	var/atom/movable/screen/blobpwrdisplay
	var/atom/movable/screen/blobhealthdisplay
	var/atom/movable/screen/action_intent
	var/atom/movable/screen/move_intent

	var/list/static_inventory = list() //the screen objects which are static

	var/list/adding
	///Misc hud elements that are hidden when the hud is minimized
	var/list/other
	///Misc hud elements that are always shown even when the hud is minimized
	var/list/other_important
	var/list/miniobjs
	var/list/atom/movable/screen/hotkeybuttons

	// pending hardsync
	var/icon/ui_style
	var/ui_color
	var/ui_alpha

	var/list/minihuds = list()

/datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()

/datum/hud/Destroy()
	. = ..()
	grab_intent = null
	hurt_intent = null
	disarm_intent = null
	help_intent = null
	lingchemdisplay = null
	wiz_instability_display = null
	wiz_energy_display = null
	blobpwrdisplay = null
	blobhealthdisplay = null
	action_intent = null
	move_intent = null
	adding = null
	other = null
	other_important = null
	hotkeybuttons = null
//	item_action_list = null // ?
	mymob = null
	minihuds = null

	QDEL_LIST(static_inventory)

/datum/hud/proc/instantiate()
	if(!ismob(mymob))
		return 0
	if(!mymob.client)
		return 0
	ui_style = ui_style2icon(mymob.get_preference_entry(/datum/game_preference_entry/dropdown/hud_style))
	ui_color = mymob.get_preference_entry(/datum/game_preference_entry/simple_color/hud_color)
	ui_alpha = mymob.get_preference_entry(/datum/game_preference_entry/number/hud_alpha)

	if(ishuman(mymob))
		human_hud(ui_style, ui_color, ui_alpha, mymob) // Pass the player the UI style chosen in preferences
	else if(isrobot(mymob))
		robot_hud(ui_style, ui_color, ui_alpha, mymob)
	else if(isbrain(mymob))
		mymob.instantiate_hud(src)
	else if(isalien(mymob))
		larva_hud()
	else if(isAI(mymob))
		ai_hud()
	else if(isobserver(mymob))
		ghost_hud()
	else
		mymob.instantiate_hud(src)

/mob/proc/instantiate_hud(var/datum/hud/HUD)
	return

/datum/hud/proc/apply_minihud(var/datum/mini_hud/MH)
	if(MH in minihuds)
		return
	minihuds += MH
	if(mymob.client)
		mymob.client.screen -= miniobjs
	miniobjs += MH.get_screen_objs()
	if(mymob.client)
		mymob.client.screen += miniobjs

/datum/hud/proc/remove_minihud(var/datum/mini_hud/MH)
	if(!(MH in minihuds))
		return
	minihuds -= MH
	if(mymob.client)
		mymob.client.screen -= miniobjs
	miniobjs -= MH.get_screen_objs()
	if(mymob.client)
		mymob.client.screen += miniobjs

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(var/full = 0 as null)
	set name = "F12"
	set hidden = 1

	if(!hud_used)
		to_chat(usr, "<span class='warning'>This mob type does not use a HUD.</span>")
		return

	if(!ishuman(src))
		to_chat(usr, "<span class='warning'>Inventory hiding is currently only supported for human mobs, sorry.</span>")
		return

	if(!client) return
	if(client.view != world.view)
		return
	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(src.hud_used.adding)
			src.client.screen -= src.hud_used.adding
		if(src.hud_used.other)
			src.client.screen -= src.hud_used.other
		if(src.hud_used.hotkeybuttons)
			src.client.screen -= src.hud_used.hotkeybuttons

		//Due to some poor coding some things need special treatment:
		//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
		if(!full)
			src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible
			src.hud_used.action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.
		else
			src.client.screen -= src.healths
			src.client.screen -= src.internals
			src.client.screen -= src.gun_setting_icon

		//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
		src.client.screen -= src.zone_sel	//zone_sel is a mob variable for some reason.

		client.actor_huds.inventory?.remove_hidden_class(INVENTORY_HUD_CLASS_ALWAYS, INVENTORY_HUD_HIDE_SOURCE_F12)
		client.actor_huds.inventory?.remove_hidden_class(INVENTORY_HUD_CLASS_DRAWER, INVENTORY_HUD_HIDE_SOURCE_F12)

	else
		hud_used.hud_shown = 1
		if(src.hud_used.adding)
			src.client.screen += src.hud_used.adding
		if(src.hud_used.other && src.hud_used.inventory_shown)
			src.client.screen += src.hud_used.other
		if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
			src.client.screen += src.hud_used.hotkeybuttons
		if(src.healths)
			src.client.screen |= src.healths
		if(src.internals)
			src.client.screen |= src.internals
		if(src.gun_setting_icon)
			src.client.screen |= src.gun_setting_icon

		src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
		src.client.screen += src.zone_sel				//This one is a special snowflake

		client.actor_huds.inventory?.add_hidden_class(INVENTORY_HUD_CLASS_ALWAYS, INVENTORY_HUD_HIDE_SOURCE_F12)
		client.actor_huds.inventory?.add_hidden_class(INVENTORY_HUD_CLASS_DRAWER, INVENTORY_HUD_HIDE_SOURCE_F12)

//Similar to button_pressed_F12() but keeps zone_sel, gun_setting_icon, and healths.
/mob/proc/toggle_zoom_hud()
	if(!hud_used)
		return
	if(!ishuman(src))
		return
	if(!client)
		return
	if(client.view != world.view)
		return

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(src.hud_used.adding)
			src.client.screen -= src.hud_used.adding
		if(src.hud_used.other)
			src.client.screen -= src.hud_used.other
		if(src.hud_used.hotkeybuttons)
			src.client.screen -= src.hud_used.hotkeybuttons
		if(src.hud_used.other_important)
			src.client.screen -= src.hud_used.other_important
		src.client.screen -= src.internals
		src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible

		client.actor_huds.inventory?.remove_hidden_class(INVENTORY_HUD_CLASS_ALWAYS, INVENTORY_HUD_HIDE_SOURCE_F12)
		client.actor_huds.inventory?.remove_hidden_class(INVENTORY_HUD_CLASS_DRAWER, INVENTORY_HUD_HIDE_SOURCE_F12)
	else
		hud_used.hud_shown = 1
		if(src.hud_used.adding)
			src.client.screen += src.hud_used.adding
		if(src.hud_used.other && src.hud_used.inventory_shown)
			src.client.screen += src.hud_used.other
		if(src.hud_used.other_important)
			src.client.screen += src.hud_used.other_important
		if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
			src.client.screen += src.hud_used.hotkeybuttons
		if(src.internals)
			src.client.screen |= src.internals
		src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position

		client.actor_huds.inventory?.add_hidden_class(INVENTORY_HUD_CLASS_ALWAYS, INVENTORY_HUD_HIDE_SOURCE_F12)
		client.actor_huds.inventory?.add_hidden_class(INVENTORY_HUD_CLASS_DRAWER, INVENTORY_HUD_HIDE_SOURCE_F12)
