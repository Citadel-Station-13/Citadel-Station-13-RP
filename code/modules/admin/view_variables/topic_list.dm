/client/proc/vv_do_list(list/target, href, href_list, hrsc)
//LISTS - CAN NOT DO VV_DO_TOPIC BECAUSE LISTS AREN'T DATUMS :(
	if(href_list["listedit"] && href_list["index"])
		var/index = text2num(href_list["index"])
		if (!index)
			return

		var/list/L = locate(href_list["listedit"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		mod_list(L, null, "list", "contents", index, autodetect_class = TRUE)

	else if(href_list["listchange"] && href_list["index"])
		var/index = text2num(href_list["index"])
		if (!index)
			return

		var/list/L = locate(href_list["listchange"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		mod_list(L, null, "list", "contents", index, autodetect_class = FALSE)

	else if(href_list["listremove"] && href_list["index"])
		var/index = text2num(href_list["index"])
		if (!index)
			return

		var/list/L = locate(href_list["listremove"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		var/variable = L[index]
		var/prompt = alert("Do you want to remove item number [index] from list?", "Confirm", "Yes", "No")
		if (prompt != "Yes")
			return
		L.Cut(index, index+1)
		log_world("### ListVarEdit by [src]: /list's contents: REMOVED=[html_encode("[variable]")]")
		log_admin("[key_name(src)] modified list's contents: REMOVED=[variable]")
		message_admins("[key_name_admin(src)] modified list's contents: REMOVED=[variable]")

	else if(href_list["listadd"])
		var/list/L = locate(href_list["listadd"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		mod_list_add(L, null, "list", "contents")

	else if(href_list["listdupes"])
		var/list/L = locate(href_list["listdupes"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		uniqueList_inplace(L)
		log_world("### ListVarEdit by [src]: /list contents: CLEAR DUPES")
		log_admin("[key_name(src)] modified list's contents: CLEAR DUPES")
		message_admins("[key_name_admin(src)] modified list's contents: CLEAR DUPES")

	else if(href_list["listnulls"])
		var/list/L = locate(href_list["listnulls"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		listclearnulls(L)
		log_world("### ListVarEdit by [src]: /list contents: CLEAR NULLS")
		log_admin("[key_name(src)] modified list's contents: CLEAR NULLS")
		message_admins("[key_name_admin(src)] modified list's contents: CLEAR NULLS")

	else if(href_list["listlen"])
		var/list/L = locate(href_list["listlen"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return
		var/value = vv_get_value(VV_NUM)
		if (value["class"] != VV_NUM)
			return

		L.len = value["value"]
		log_world("### ListVarEdit by [src]: /list len: [L.len]")
		log_admin("[key_name(src)] modified list's len: [L.len]")
		message_admins("[key_name_admin(src)] modified list's len: [L.len]")

	else if(href_list["listshuffle"])
		var/list/L = locate(href_list["listshuffle"])
		if (!istype(L))
			to_chat(usr, "This can only be used on instances of type /list")
			return

		shuffle_inplace(L)
		log_world("### ListVarEdit by [src]: /list contents: SHUFFLE")
		log_admin("[key_name(src)] modified list's contents: SHUFFLE")
		message_admins("[key_name_admin(src)] modified list's contents: SHUFFLE")
//LISTS END
