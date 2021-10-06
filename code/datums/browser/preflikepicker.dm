/datum/browser/modal/preflikepicker
	var/settings = list()
	var/icon/preview_icon = null
	var/datum/callback/preview_update

/datum/browser/modal/preflikepicker/New(User,Message,Title,Button1="Ok",Button2,Button3,StealFocus = 1, Timeout = FALSE,list/settings,inputtype="checkbox", width = 600, height, slidecolor)
	if (!User)
		return
	src.settings = settings

	..(User, ckey("[User]-[Message]-[Title]-[world.time]-[rand(1,10000)]"), Title, width, height, src, StealFocus, Timeout)
	set_content(ShowChoices(User))

/datum/browser/modal/preflikepicker/proc/ShowChoices(mob/user)
	if (settings["preview_callback"])
		var/datum/callback/callback = settings["preview_callback"]
		preview_icon = callback.Invoke(settings)
		if (preview_icon)
			user << browse_rsc(preview_icon, "previewicon.png")
	var/dat = ""

	for (var/name in settings["mainsettings"])
		var/setting = settings["mainsettings"][name]
		if (setting["type"] == "datum")
			if (setting["subtypesonly"])
				dat += "<b>[setting["desc"]]:</b> <a href='?src=[REF(src)];setting=[name];task=input;subtypesonly=1;type=datum;path=[setting["path"]]'>[setting["value"]]</a><BR>"
			else
				dat += "<b>[setting["desc"]]:</b> <a href='?src=[REF(src)];setting=[name];task=input;type=datum;path=[setting["path"]]'>[setting["value"]]</a><BR>"
		else
			dat += "<b>[setting["desc"]]:</b> <a href='?src=[REF(src)];setting=[name];task=input;type=[setting["type"]]'>[setting["value"]]</a><BR>"

	if (preview_icon)
		dat += "<td valign='center'>"

		dat += "<div class='statusDisplay'><center><img src=previewicon.png width=[preview_icon.Width()] height=[preview_icon.Height()]></center></div>"

		dat += "</td>"

	dat += "</tr></table>"

	dat += "<hr><center><a href='?src=[REF(src)];button=1'>Ok</a> "

	dat += "</center>"

	return dat

/datum/browser/modal/preflikepicker/Topic(href,href_list)
	if (href_list["close"] || !user || !user.client)
		opentime = 0
		return
	if (href_list["task"] == "input")
		var/setting = href_list["setting"]
		switch (href_list["type"])
			if ("datum")
				var/oldval = settings["mainsettings"][setting]["value"]
				if (href_list["subtypesonly"])
					settings["mainsettings"][setting]["value"] = pick_closest_path(null, make_types_fancy(subtypesof(text2path(href_list["path"]))))
				else
					settings["mainsettings"][setting]["value"] = pick_closest_path(null, make_types_fancy(typesof(text2path(href_list["path"]))))
				if (isnull(settings["mainsettings"][setting]["value"]))
					settings["mainsettings"][setting]["value"] = oldval
			if ("string")
				settings["mainsettings"][setting]["value"] = stripped_input(user, "Enter new value for [settings["mainsettings"][setting]["desc"]]", "Enter new value for [settings["mainsettings"][setting]["desc"]]", settings["mainsettings"][setting]["value"])
			if ("number")
				settings["mainsettings"][setting]["value"] = input(user, "Enter new value for [settings["mainsettings"][setting]["desc"]]", "Enter new value for [settings["mainsettings"][setting]["desc"]]") as num
			if ("color")
				settings["mainsettings"][setting]["value"] = input(user, "Enter new value for [settings["mainsettings"][setting]["desc"]]", "Enter new value for [settings["mainsettings"][setting]["desc"]]", settings["mainsettings"][setting]["value"]) as color
			if ("boolean")
				settings["mainsettings"][setting]["value"] = input(user, "[settings["mainsettings"][setting]["desc"]]?") in list("Yes","No")
			if ("ckey")
				settings["mainsettings"][setting]["value"] = input(user, "[settings["mainsettings"][setting]["desc"]]?") in list("none") + GLOB.directory
		if (settings["mainsettings"][setting]["callback"])
			var/datum/callback/callback = settings["mainsettings"][setting]["callback"]
			settings = callback.Invoke(settings)
	if (href_list["button"])
		var/button = text2num(href_list["button"])
		if (button <= 3 && button >= 1)
			selectedbutton = button
	if (selectedbutton != 1)
		set_content(ShowChoices(user))
		open()
		return
	for (var/item in href_list)
		switch(item)
			if ("close", "button", "src")
				continue
	opentime = 0
	close()

/proc/presentpreflikepicker(mob/User,Message, Title, Button1="Ok", Button2, Button3, StealFocus = 1,Timeout = 6000,list/settings, width, height, slidecolor)
	if (!istype(User))
		if (istype(User, /client/))
			var/client/C = User
			User = C.mob
		else
			return
	var/datum/browser/modal/preflikepicker/A = new(User, Message, Title, Button1, Button2, Button3, StealFocus,Timeout, settings, width, height, slidecolor)
	A.open()
	A.wait()
	if (A.selectedbutton)
		return list("button" = A.selectedbutton, "settings" = A.settings)
