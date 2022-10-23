/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEMSIZE_SMALL //It should be tiny! -Agouri

	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = null
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null

/obj/item/airlock_electronics/attack_self(mob/user)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	var/t1 = text("<B>Access control</B><br>\n")

	if (last_configurator)
		t1 += "Operator: [last_configurator]<br>"

	t1 += "Access requirement is set to "
	t1 += one_access ? "<a style='color: green' href='?src=\ref[src];one_access=1'>ONE</a><hr>" : "<a style='color: red' href='?src=\ref[src];one_access=1'>ALL</a><hr>"

	t1 += conf_access == null ? "<font color=red>All</font><br>" : "<a href='?src=\ref[src];access=all'>All</a><br>"

	t1 += "<br>"

	var/list/accesses = get_all_station_access()
	var/list/user_has = get_available_accesses(user)
	for (var/acc in accesses)
		var/aname = get_access_desc(acc)
		var/rendered_name = user_has.Find(acc)? "<b>[aname]</b>" : aname

		if (!conf_access || !conf_access.len || !(acc in conf_access))
			t1 += "<a href='?src=\ref[src];access=[acc]'>[rendered_name]</a><br>"
		else if(one_access)
			t1 += "<a style='color: green' href='?src=\ref[src];access=[acc]'>[rendered_name]</a><br>"
		else
			t1 += "<a style='color: red' href='?src=\ref[src];access=[acc]'>[rendered_name]</a><br>"

	t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)

	user << browse(t1, "window=airlock_electronics")
	onclose(user, "airlock")

/obj/item/airlock_electronics/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained() || (!ishuman(usr) && !istype(usr,/mob/living/silicon)))
		return

	if (href_list["close"])
		usr << browse(null, "window=airlock")
		return

	if (href_list["one_access"])
		one_access = !one_access

	if (href_list["access"])
		toggle_access(href_list["access"])

	attack_self(usr)

/obj/item/airlock_electronics/proc/toggle_access(var/acc)
	if (acc == "all")
		conf_access = null
	else
		var/req = text2num(acc)

		if (conf_access == null)
			conf_access = list()

		if (!(req in conf_access))
			conf_access += req
		else
			conf_access -= req
			if (!conf_access.len)
				conf_access = null

/obj/item/airlock_electronics/proc/get_available_accesses(var/mob/user)
	var/obj/item/card/id/id
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		id = H.get_idcard()
	else if(issilicon(user))
		var/mob/living/silicon/R = user
		id = R.idcard

	// Nothing
	if(!id || !id.access)
		return list()

	return id.access

/obj/item/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1
