<<<<<<< HEAD
/datum/admin_secret_item/fun_secret/fix_all_lights
	name = "Fix All Lights"

/datum/admin_secret_item/fun_secret/fix_all_lights/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/obj/machinery/light/L in machines)
		L.fix()
=======
/datum/admin_secret_item/fun_secret/fix_all_lights
	name = "Fix All Lights"

/datum/admin_secret_item/fun_secret/fix_all_lights/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/obj/machinery/light/L in machines)
		L.fix()
>>>>>>> ad18753... Merge pull request #3813 from VOREStation/master
