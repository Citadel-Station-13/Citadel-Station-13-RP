/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEMSIZE_SMALL //It should be tiny! -Agouri

	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

	var/list/conf_req_access
	var/list/conf_req_one_access
	var/secure =  FALSE //if set, then wires will be randomized and bolts will drop if the door is broken

/obj/item/airlock_electronics/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockElectronics")
		ui.open()

/obj/item/airlock_electronics/ui_static_data(mob/user)
	. = ..()
	.["access"] = SSjob.tgui_access_data()

/obj/item/airlock_electronics/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["req_access"] = conf_req_access || list()
	.["req_one_access"] = conf_req_one_access || list()

/obj/item/airlock_electronics/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("set")
			var/mode = params["mode"] == "all"
			var/access = text2num(params["id"])
			if(!access)
				return
			if(!mode)
				if(access in conf_req_one_access)
					LAZYREMOVE(conf_req_one_access, access)
				else
					LAZYOR(conf_req_one_access, access)
			else
				if(access in conf_req_access)
					LAZYREMOVE(conf_req_access, access)
				else
					LAZYOR(conf_req_access, access)
			return TRUE
		if("wipe")
			var/category = params["category"]
			if(!category)
				conf_req_access = null
				conf_req_one_access = null
			else
				var/list/access_ids = SSjob.access_ids_of_category(category)
				LAZYREMOVE(conf_req_one_access, access_ids)
				LAZYREMOVE(conf_req_access, access_ids)
			return TRUE

/obj/item/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = TRUE
