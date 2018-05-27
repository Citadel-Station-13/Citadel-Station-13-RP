<<<<<<< HEAD
/datum/admin_secret_item/fun_secret/fix_all_lights
	name = "Fix All Lights"

/datum/admin_secret_item/fun_secret/fix_all_lights/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/obj/machinery/light/L in world)
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
>>>>>>> 4cddf6c... Merge pull request #3762 from VOREStation/aro-sync-05-25-2018
