/obj/item/robot_upgrade/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/robot_upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	var/obj/item/tank/jetpack/carbondioxide/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/tank/jetpack/carbondioxide(R.module)
		for(var/obj/item/tank/jetpack/carbondioxide in R.module.modules)
			R.internals = src
		return TRUE
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE
