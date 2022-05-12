/datum/hud/proc/larva_hud()

	src.adding = list()
	src.other = list()

	var/atom/movable/screen/using

	using = new /atom/movable/screen()
	using.name = "mov_intent"
	using.setDir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_acti
	using.layer = HUD_LAYER
	src.adding += using
	move_intent = using

	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = 'icons/mob/screen1_alien.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_alien_health

	mymob.fire = new /atom/movable/screen()
	mymob.fire.icon = 'icons/mob/screen1_alien.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire

	mymob.client.screen = list()
	mymob.client.screen += list( mymob.healths, mymob.fire) //, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen += src.adding + src.other

	mymob.reload_rendering()
