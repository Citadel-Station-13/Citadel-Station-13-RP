/client/proc/vv_do_basic(datum/target, href, href_list, hsrc)
	if(href_list["varnameedit"] && href_list["datumedit"])
		if(!check_rights(R_VAREDIT))
			return

		var/datum/D = locate(href_list["datumedit"])
		if(!istype(D, /datum))
			to_chat(usr, "This can only be used on datums")
			return

		if (!modify_variables(D, href_list["varnameedit"], 1))
			return
		switch(href_list["varnameedit"])
			if("name")
				vv_update_display(D, "name", "[D]")
			if("dir")
				var/atom/A = D
				if(istype(A))
					vv_update_display(D, "dir", dir2text(A.dir) || A.dir)
			if("ckey")
				var/mob/living/L = D
				if(istype(L))
					vv_update_display(D, "ckey", L.ckey || "No ckey")
			if("real_name")
				var/mob/living/L = D
				if(istype(L))
					vv_update_display(D, "real_name", L.real_name || "No real name")

	else if(href_list["varnamechange"] && href_list["datumchange"])
		if(!check_rights(R_VAREDIT))
			return

		var/D = locate(href_list["datumchange"])
		if(!istype(D, /datum))
			to_chat(usr, "This can only be used on datums")
			return

		modify_variables(D, href_list["varnamechange"], 0)

	else if(href_list["varnamemass"] && href_list["datummass"])
		if(!check_rights(R_VAREDIT))
			return

		var/datum/D = locate(href_list["datummass"])
		if(!istype(D))
			to_chat(usr, "This can only be used on instances of type /datum")
			return

		cmd_mass_modify_object_variables(D, href_list["varnamemass"])

