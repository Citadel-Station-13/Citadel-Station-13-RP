/datum/admin_secret_item/admin_secret/show_nuke_codes
	name = "Show Nuclear Codes"

/datum/admin_secret_item/admin_secret/show_nuke_codes/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = "<B>All codes for all nuclear devices:</B><HR>"

	for(var/obj/machinery/nuclearbomb/bomb in world)
		dat += "[bomb] at ([bomb.x], [bomb.y], [bomb.z]): [bomb.r_code]<BR>"

	user << browse(HTML_SKELETON(dat), "window=nukecodes;size=400x400")
