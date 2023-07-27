
/obj/item/storage/single_use
	var/opened = FALSE
	var/tear_sound = "rip"

/obj/item/storage/single_use/open(mob/user)
	if(!opened)
		playsound(src.loc, src.tear_sound, 50, FALSE, -5)
		user.visible_message(
			SPAN_NOTICE("\The [user] tears open [src], breaking the vacuum seal!"),
			SPAN_NOTICE("You tear open [src], breaking the vacuum seal!"),
			SPAN_HEAR("You hear something being torn open."),
		)
		opened = TRUE
		update_icon()
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, FALSE, -5)
	if (isrobot(user) && user.hud_used)
		var/mob/living/silicon/robot/robot = user
		if(robot.shown_robot_modules) //The robot's inventory is open, need to close it first.
			robot.hud_used.toggle_show_robot_modules()
	return ..(user, TRUE)

/obj/item/storage/single_use/attack_self(mob/user, datum/event_args/clickchain/e_args)
	. = ..()
	if(.)
		return
	open(user)

/obj/item/storage/single_use/update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()
