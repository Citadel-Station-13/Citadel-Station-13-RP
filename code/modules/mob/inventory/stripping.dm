#warn impl oh god oh fuck

/mob/proc/request_strip_menu(mob/user, ignore_adjacency = FALSE, ignore_incapacitation = FALSE)
	if(!ignore_incapacitation && user.incapacitated())
		return FALSE
	if(!ignore_adjacency && !user.Adjacent(src))
		return FALSE

/mob/proc/open_strip_menu(mob/user)
	var/datum/browser/B = new(user, "strip_window_[REF(src)]", "[name] (stripping)", 340, 540)
	B.set_content(render_strip_menu(user).Join(""))
	B.open()

/mob/proc/render_strip_menu(mob/user)
	RETURN_TYPE(/list)
	. = list()



/mob/proc/handle_strip_topic(mob/user, list/href_list)
