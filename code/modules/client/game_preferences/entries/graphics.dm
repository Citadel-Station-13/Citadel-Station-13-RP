//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_entry/toggle/parallax
	name = "Parallax Enabled"
	description = "Render space via parallax. This should be kept on."
	key = "enable_parallax"
	category = "Graphics"
	subcategory = "Parallax"
	default_value = TRUE

/datum/game_preference_entry/toggle/parallax/on_set(client/user, value)
	. = ..()
	user.parallax_holder?.reset()

/datum/game_preference_entry/toggle/ambient_occlusion
	name = "Fake Ambient Occlusion"
	description = "Fake, filter ambient occlusion. This should be kept off."
	key = "fake_ambient_occlusion"
	category = "Graphics"
	subcategory = "Rendering"
	default_value = FALSE

/datum/game_preference_entry/toggle/ambient_occlusion/on_set(client/user, value)
	. = ..()
	user.using_perspective?.planes?.sync_owner(user)
