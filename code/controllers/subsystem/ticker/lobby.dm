/datum/controller/subsystem/ticker/proc/build_lobby_screen(obj/effect/lobby_image/canvas)
	#warn impl

// todo: the image needs to be autocentered for widescreen/variable screens
#warn besure to check map for config + have fallback for no config image!
#warn fexists() directly

/*
/obj/effect/lobby_image/Initialize(mapload)
	icon = using_map_legacy().lobby_icon
	var/known_icon_states = icon_states(icon)
	for(var/lobby_screen in using_map_legacy().lobby_screens)
		if(!(lobby_screen in known_icon_states))
			log_world("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			using_map_legacy().lobby_screens -= lobby_screen

	if(using_map_legacy().lobby_screens.len)
		icon_state = pick(using_map_legacy().lobby_screens)
	else
		icon_state = known_icon_states[1]
	. = ..()
*/
