//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/game_preference_entry/toggle/parallax
	name = "Parallax Enabled"
	description = "Render space via parallax. This should be kept on."
	key = "enable_parallax"
	category = GAME_PREFERENCE_CATEGORY_GRAPHICS
	subcategory = "Parallax"
	default_value = TRUE

/datum/game_preference_entry/toggle/parallax/on_set(client/user, value, first_init)
	. = ..()
	user.parallax_holder?.reset()

/datum/game_preference_entry/toggle/ambient_occlusion
	name = "Fake Ambient Occlusion"
	description = "Fake, filter ambient occlusion. This should be kept off."
	key = "fake_ambient_occlusion"
	category = GAME_PREFERENCE_CATEGORY_GRAPHICS
	subcategory = "Rendering"
	default_value = FALSE

/datum/game_preference_entry/toggle/ambient_occlusion/on_set(client/user, value, first_init)
	. = ..()
	user.using_perspective?.planes?.sync_owner(user)

/datum/game_preference_entry/number/fps
	name = "FPS"
	description = "Client rendering FPS. It is recommended to set this to a multiple of the server's tickrate. 0 to sync with server."
	key = "client_fps"
	category = GAME_PREFERENCE_CATEGORY_GRAPHICS
	subcategory = "Rendering"
	default_value = 0
	min_value = 0
	max_value = 180
	round_to_nearest = 1
	legacy_savefile_key = "client_fps"

/datum/game_preference_entry/number/fps/on_set(client/user, value, first_init)
	. = ..()
	user.fps = value
