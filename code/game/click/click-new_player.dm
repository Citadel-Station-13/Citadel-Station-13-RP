//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/new_player/click_on(atom/target, location, control, raw_params)
	SHOULD_NOT_OVERRIDE(FALSE)
	/**
	* New players shouldn't click on anything at all.
	*/
	return TRUE
