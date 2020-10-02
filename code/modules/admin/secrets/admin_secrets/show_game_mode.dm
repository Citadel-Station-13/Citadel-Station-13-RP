/datum/admin_secret_item/admin_secret/show_game_mode
	name = "Show Game Mode"

/datum/admin_secret_item/admin_secret/show_game_mode/can_execute(var/mob/user)
	if(!SSticker)
		return FALSE
	return ..()

/datum/admin_secret_item/admin_secret/show_game_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	if (SSticker.mode) alert("The game mode is [SSticker.mode.name]")
	else alert("For some reason there's a SSticker, but not a game mode")
