//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("mob-show-mind-panel", "Open Mind")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(href_list["mob-show-mind-panel"])
		if(!mind)
			to_chat(usr, SPAN_WARNING("[src] has no mind."))
		else
			mind.ui_interact(usr, admin_inspect = TRUE)
