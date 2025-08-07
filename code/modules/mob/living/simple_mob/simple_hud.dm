/mob/living/simple_mob/instantiate_hud(var/datum/hud/hud)
	if(!client)
		return //Why bother.

	var/ui_style = 'icons/mob/screen1_animal.dmi'
	if(ui_icons)
		hud.ui_style = ui_icons
		ui_style = ui_icons

	var/ui_color = "#ffffff"
	var/ui_alpha = 255

	var/list/adding = list()
	var/list/other = list()
	var/list/hotkeybuttons = list()


	hud.adding = adding
	hud.other = other
	hud.hotkeybuttons = hotkeybuttons

	var/list/hud_elements = list()
	var/atom/movable/screen/using

	//Intent Backdrop
	using = new /atom/movable/screen()
	using.name = "act_intent"
	using.icon = ui_style
	using.icon_state = "intent_"+a_intent
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	hud.adding += using
	hud.action_intent = using

	hud_elements |= using

	//Small intent quarters
	var/icon/ico

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
	using = new /atom/movable/screen()
	using.name = INTENT_HELP
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = HUD_LAYER_ABOVE //These sit on the intent box
	hud.adding += using
	hud.help_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
	using = new /atom/movable/screen()
	using.name = INTENT_DISARM
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = HUD_LAYER_ABOVE
	hud.adding += using
	hud.disarm_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
	using = new /atom/movable/screen()
	using.name = INTENT_GRAB
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = HUD_LAYER_ABOVE
	hud.adding += using
	hud.grab_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
	using = new /atom/movable/screen()
	using.name = INTENT_HARM
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = HUD_LAYER_ABOVE
	hud.adding += using
	hud.hurt_intent = using

	//Move intent (walk/run)
	using = new /atom/movable/screen()
	using.name = "mov_intent"
	using.icon = ui_style
	using.icon_state = (m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	hud.adding += using
	hud.move_intent = using

	//Resist button
	using = new /atom/movable/screen()
	using.name = "resist"
	using.icon = ui_style
	using.icon_state = "act_resist"
	using.screen_loc = ui_pull_resist
	using.color = ui_color
	using.alpha = ui_alpha
	hud.hotkeybuttons += using

	//Pull button
	pullin = new /atom/movable/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.name = "pull"
	pullin.screen_loc = ui_pull_resist
	hud.hotkeybuttons += pullin
	hud_elements |= pullin

	//Health status
	healths = new /atom/movable/screen()
	healths.icon = ui_style
	healths.icon_state = "health0"
	healths.name = "health"
	healths.screen_loc = ui_health
	hud_elements |= healths

	//Oxygen dep icon
	oxygen = new /atom/movable/screen()
	oxygen.icon = ui_style
	oxygen.icon_state = "oxy0"
	oxygen.name = "oxygen"
	oxygen.screen_loc = ui_oxygen
	hud_elements |= oxygen

	//Toxins present icon
	toxin = new /atom/movable/screen()
	toxin.icon = ui_style
	toxin.icon_state = "tox0"
	toxin.name = "toxin"
	toxin.screen_loc = ui_toxin
	hud_elements |= toxin

	//Fire warning
	fire = new /atom/movable/screen()
	fire.icon = ui_style
	fire.icon_state = "fire0"
	fire.name = "fire"
	fire.screen_loc = ui_fire
	hud_elements |= fire

	//Pressure warning
	pressure = new /atom/movable/screen()
	pressure.icon = ui_style
	pressure.icon_state = "pressure0"
	pressure.name = "pressure"
	pressure.screen_loc = ui_pressure
	hud_elements |= pressure

	//Body temp warning
	bodytemp = new /atom/movable/screen()
	bodytemp.icon = ui_style
	bodytemp.icon_state = "temp0"
	bodytemp.name = "body temperature"
	bodytemp.screen_loc = ui_temp
	hud_elements |= bodytemp

	//Nutrition status
	nutrition_icon = new /atom/movable/screen()
	nutrition_icon.icon = ui_style
	nutrition_icon.icon_state = "nutrition0"
	nutrition_icon.name = "nutrition"
	nutrition_icon.screen_loc = ui_nutrition
	hud_elements |= nutrition_icon

	pain = new /atom/movable/screen( null )

	zone_sel = new /atom/movable/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.cut_overlays()
	zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[zone_sel.selecting]"))
	hud_elements |= zone_sel

	//Hand things
	if(get_nominal_hand_count() > 0)
		//Drop button
		using = new /atom/movable/screen()
		using.name = "drop"
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		hud.hotkeybuttons += using

		//Throw button
		throw_icon = new /atom/movable/screen/hud/throwmode(null, hud)
		hud.hotkeybuttons += throw_icon
		hud_elements |= throw_icon

	extra_huds(hud,ui_style,hud_elements)

	client.screen = list()

	client.screen += hud_elements
	client.screen += adding + hotkeybuttons
	client.mob.reload_rendering()

	return
