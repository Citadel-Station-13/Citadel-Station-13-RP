//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? clickcatcher

/**
 * Makes a clickcatcher if necessary, and ensures it's fit to our size.
 */
/client/proc/update_clickcatcher()
	if(isnull(click_catcher))
		click_catcher = new
	screen |= click_catcher
	click_catcher.UpdateFill(current_viewport_width, current_viewport_height)

//? parallax

/client/proc/create_parallax()
	if(!isnull(parallax_holder))
		return
	parallax_holder = new(src)
