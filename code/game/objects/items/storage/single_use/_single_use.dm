
/obj/item/storage/single_use
	var/opened = FALSE
	use_sound = ""
	tear_sound = "rip"
	var/opening_text_self = ""
	var/opening_text_others = ""

/obj/item/storage/single_use/open(mob/user)
	if(!opened)
		playsound(src.loc, src.tear_sound, 50, 0, -5)
		user.visible_message(SPAN_NOTICE(opening_text_others),SPAN_NOTICE(opening_text_self))
		opened = 1
		update_icon()
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 0, -5)
	if (isrobot(user) && user.hud_used)
		var/mob/living/silicon/robot/robot = user
		if(robot.shown_robot_modules) //The robot's inventory is open, need to close it first.
			robot.hud_used.toggle_show_robot_modules()
	return ..(user, TRUE)

/obj/item/storage/single_use/attack_self(mob/user)
	open(user)

/obj/item/storage/single_use/update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()
