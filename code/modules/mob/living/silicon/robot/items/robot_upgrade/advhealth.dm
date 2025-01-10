/obj/item/robot_upgrade/advhealth
	name = "advanced health analyzer module"
	desc = "An upgrade to improve a station-bound synthetic's health analyzer."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/robot_upgrade/advhealth/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	var/obj/item/healthanalyzer/advanced/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/healthanalyzer/advanced(R.module)
		return TRUE
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE
