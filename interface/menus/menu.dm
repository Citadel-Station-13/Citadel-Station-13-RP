/datum/byond_menu
	var/category_type

/datum/byond_menu/New()
	build()

/datum/byond_menu/proc/build()
	if(type == /datum/byond_menu)
		CRASH("tried to build abstract root of menu types")

#warn oh god
