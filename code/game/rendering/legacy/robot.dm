/datum/hud/proc/robot_hud(ui_style='icons/mob/screen1_robot.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255, var/mob/living/silicon/robot/target)

	if(ui_style == 'icons/mob/screen/minimalist.dmi')
		ui_style = 'icons/mob/screen1_robot_minimalist.dmi'
	else
		ui_style = 'icons/mob/screen1_robot.dmi'

	src.adding = list()
	src.other = list()

	var/atom/movable/screen/using

//Radio
	using = new /atom/movable/screen()
	using.name = "radio"
	using.setDir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	using.layer = HUD_LAYER_BASE
	src.adding += using

//Intent
	using = new /atom/movable/screen()
	using.name = "act_intent"
	using.setDir(SOUTHWEST)
	using.icon = ui_style
	using.alpha = ui_alpha
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	using.layer = HUD_LAYER_BASE
	src.adding += using
	action_intent = using

//Cell
	using = new /atom/movable/screen()
	using.icon = ui_style
	using.icon_state = "charge-empty"
	using.alpha = ui_alpha
	using.name = "cell"
	using.screen_loc = ui_toxin
	src.other += using
	target.cells = using

//Health
	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.alpha = ui_alpha
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_borg_health
	src.other += mymob.healths

//Installed Module
	mymob.hands = new /atom/movable/screen()
	mymob.hands.icon = ui_style
	mymob.hands.icon_state = "nomod"
	mymob.hands.alpha = ui_alpha
	mymob.hands.name = "module"
	mymob.hands.screen_loc = ui_borg_module
	src.other += mymob.hands

//Module Panel
	using = new /atom/movable/screen()
	using.name = "panel"
	using.icon = ui_style
	using.icon_state = "panel"
	using.alpha = ui_alpha
	using.screen_loc = ui_borg_panel
	using.layer = HUD_LAYER_BASE-0.01
	src.adding += using

//Store
	mymob.throw_icon = new /atom/movable/screen()
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.icon_state = "store"
	mymob.throw_icon.alpha = ui_alpha
	mymob.throw_icon.color = ui_color
	mymob.throw_icon.name = "store"
	mymob.throw_icon.screen_loc = ui_borg_store
	src.other += mymob.throw_icon

//Temp
	mymob.bodytemp = new /atom/movable/screen()
	mymob.bodytemp.icon_state = "temp0"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = ui_temp

	mymob.oxygen = new /atom/movable/screen()
	mymob.oxygen.icon = ui_style
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.alpha = ui_alpha
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen
	src.other += mymob.oxygen

	mymob.fire = new /atom/movable/screen()
	mymob.fire.icon = ui_style
	mymob.fire.icon_state = "fire0"
	mymob.fire.alpha = ui_alpha
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire
	src.other += mymob.fire

	mymob.pullin = new /atom/movable/screen()
	mymob.pullin.icon = ui_style
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.alpha = ui_alpha
	mymob.pullin.color = ui_color
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_borg_pull
	src.other += mymob.pullin

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.cut_overlays()
	mymob.zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.alpha = ui_alpha
	mymob.item_use_icon = new /atom/movable/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.alpha = ui_alpha
	mymob.gun_move_icon = new /atom/movable/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.alpha = ui_alpha
	mymob.radio_use_icon = new /atom/movable/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.alpha = ui_alpha

	mymob.client.screen = list()

	mymob.client.screen += list( mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.fire, mymob.hands, mymob.healths, using, mymob.pullin, mymob.gun_setting_icon)
	mymob.client.screen += src.adding + src.other

	mymob.reload_rendering()

/mob/living/silicon/robot/update_hud()
	if(modtype)
		hands.icon_state = lowertext(modtype)
	..()

//! ## VR FILE MERGE ## !//
/mob/living/silicon/robot/update_hud()
	if(modtype)
		hands.icon_state = lowertext(modtype)
	..()
