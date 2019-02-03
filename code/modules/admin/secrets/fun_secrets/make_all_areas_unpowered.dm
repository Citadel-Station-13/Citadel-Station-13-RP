/datum/admin_secret_item/fun_secret/make_GLOB.sortedAreas_unpowered
	name = "Make All Areas Unpowered"

/datum/admin_secret_item/fun_secret/make_GLOB.sortedAreas_unpowered/execute(var/mob/user)
	. = ..()
	if(.)
		power_failure()
