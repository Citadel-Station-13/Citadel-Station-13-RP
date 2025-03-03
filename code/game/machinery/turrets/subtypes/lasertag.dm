
/obj/machinery/porta_turret/lasertag
	name = "lasertag turret"
	turret_type = "normal"
	req_one_access = list()
	installation = /obj/item/gun/projectile/energy/lasertag/omni

	locked = FALSE
	enabled = FALSE
	anchored = FALSE
	//These two are used for lasertag
	check_synth	 = FALSE
	check_weapons = FALSE
	//These vars aren't used
	check_access = FALSE
	check_arrest = FALSE
	check_records = FALSE
	check_anomalies = FALSE
	check_all = FALSE
	check_down = FALSE

/obj/machinery/porta_turret/lasertag/assess_living(mob/living/L)
	if(!ishuman(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(get_dist(src, L) > 7)	//if it's too far away, why bother?
		return TURRET_NOT_TARGET

	if(L.lying)		//Don't need to stun-lock the players
		return TURRET_NOT_TARGET

	if(ishuman(L))
		var/mob/living/carbon/human/M = L
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag) && check_synth) // Checks if they are a red player
			return TURRET_PRIORITY_TARGET

		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag) && check_weapons) // Checks if they are a blue player
			return TURRET_PRIORITY_TARGET

/obj/machinery/porta_turret/lasertag/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled

	if(data["access"])
		var/settings[0]
		settings[++settings.len] = list("category" = "Target Red", "setting" = "check_synth", "value" = check_synth) // Could not get the UI to work with new vars specifically for lasertag turrets -Nalarac
		settings[++settings.len] = list("category" = "Target Blue", "setting" = "check_weapons", "value" = check_weapons) // So I'm using these variables since they don't do anything else in this case
		data["settings"] = settings

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/lasertag/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["command"] && href_list["value"])
		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value
		else if(href_list["command"] == "check_synth")
			check_synth = value
		else if(href_list["command"] == "check_weapons")
			check_weapons = value

		return 1

/obj/machinery/porta_turret/lasertag/red
	turret_type = "red"
	installation = /obj/item/gun/projectile/energy/lasertag/red
	check_weapons = TRUE // Used to target blue players

/obj/machinery/porta_turret/lasertag/blue
	turret_type = "blue"
	installation = /obj/item/gun/projectile/energy/lasertag/blue
	check_synth = TRUE // Used to target red players
