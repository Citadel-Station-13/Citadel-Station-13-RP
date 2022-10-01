/obj/item/bot_assembly
	icon = 'icons/obj/bots/aibots.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 3
	throw_speed = 2
	throw_range = 5
	var/created_name
	var/build_step = ASSEMBLY_FIRST_STEP
	var/robot_arm = /obj/item/robot_parts/l_arm
	var/skin = null //Same as medibot, set to tox or ointment for the respective kits.

/obj/item/bot_assembly/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/pen))
		rename_bot()
		return

/obj/item/bot_assembly/proc/rename_bot()
	var/t = sanitizeSafe(input(usr, "Enter new robot name", name, created_name), MAX_NAME_LEN)
	if(!t)
		return
	if(!in_range(src, usr) && loc != usr)
		return
	created_name = t

/obj/item/bot_assembly/proc/can_finish_build(obj/item/I, mob/user)
	if(contents.len >= 1)
		to_chat(user, SPAN_WARNING("You need to empty [src] out first."))
		return FALSE
	return TRUE

/obj/item/bot_assembly/proc/is_valid_arm(obj/item/I, mob/user)
	if(istype(I, /obj/item/robot_parts/l_arm) || istype(I, /obj/item/robot_parts/r_arm) || (istype(I, /obj/item/organ/external/arm) && (I.name == "robotic right arm") || (I.name == "robotic left arm")))
		return TRUE
	return FALSE
