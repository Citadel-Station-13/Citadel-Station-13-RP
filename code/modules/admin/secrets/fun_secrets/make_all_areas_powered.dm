/datum/admin_secret_item/fun_secret/make_GLOB.sortedAreas_powered
	name = "Make All Areas Powered"

/datum/admin_secret_item/fun_secret/make_GLOB.sortedAreas_powered/execute(var/mob/user)
	. = ..()
	if(.)
		power_restore()
