/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_keyboard = "tech_key"
	icon_screen = "shuttle"
	light_color = "#00ffff"
	var/auth_need = 3
	var/list/authorized = list(  )


/obj/machinery/computer/shuttle/attackby(obj/item/card/W, mob/user)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if((!( istype(W, /obj/item/card) ) || !( SSticker ) || SSemergencyshuttle.location() || !( user )))
		return
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(istype(W, /obj/item/pda))
			var/obj/item/pda/pda = W
			W = pda.id
		if(!W:access) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return

		var/list/cardaccess = W:access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return

		if(!(access_heads in W:access)) //doesn't have this access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return 0

		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		if(SSemergencyshuttle.location() && user.get_active_held_item() != W)
			return 0
		switch(choice)
			if("Authorize")
				src.authorized -= W:registered_name
				src.authorized += W:registered_name
				if (src.auth_need - src.authorized.len > 0)
					message_admins("[key_name_admin(user)] has authorized early shuttle launch")
					log_game("[user.ckey] has authorized early shuttle launch")
					to_chat(world, "<span class='notice'><b>Alert: [auth_need - authorized.len] authorizations needed until shuttle is launched early</b></span>")
				else
					message_admins("[key_name_admin(user)] has launched the shuttle")
					log_game("[user.ckey] has launched the shuttle early")
					to_chat(world, "<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
					SSemergencyshuttle.set_launch_countdown(10)
					//src.authorized = null
					qdel(src.authorized)
					src.authorized = list(  )

			if("Repeal")
				src.authorized -= W:registered_name
				to_chat(world, text("<span class='notice'><b>Alert: [] authorizations needed until shuttle is launched early</b></span>", src.auth_need - src.authorized.len))

			if("Abort")
				to_chat(world, "<span class='notice'><b>All authorizations to shortening time for shuttle launch have been revoked!</b></span>")
				src.authorized.len = 0
				src.authorized = list(  )

	else if (istype(W, /obj/item/card/emag) && !emagged)
		var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")

		if(!emagged && !SSemergencyshuttle.location() && user.get_active_held_item() == W)
			switch(choice)
				if("Launch")
					to_chat(world, "<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
					SSemergencyshuttle.set_launch_countdown(10)
					emagged = 1
				if("Cancel")
					return
	return
