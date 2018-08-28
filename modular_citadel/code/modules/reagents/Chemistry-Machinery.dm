/obj/machinery/chem_master/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	data["tab"] = tab
	data["condi"] = condi

	if(loaded_pill_bottle)
		data["pillBottle"] = list("total" = loaded_pill_bottle.contents.len, "max" = loaded_pill_bottle.max_storage_space)
	else
		data["pillBottle"] = null

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		var/ui_reagent_beaker_list[0]
		for(var/datum/reagent/G in R.reagent_list)
			ui_reagent_beaker_list[++ui_reagent_beaker_list.len] = list("name" = G.name, "volume" = G.volume, "description" = G.description, "id" = G.id)

		data["beaker"] = list("total_volume" = R.total_volume, "reagent_list" = ui_reagent_beaker_list)
	else
		data["beaker"] = null

	if(reagents.total_volume)
		var/ui_reagent_list[0]
		for(var/datum/reagent/N in reagents.reagent_list)
			ui_reagent_list[++ui_reagent_list.len] = list("name" = N.name, "volume" = N.volume, "description" = N.description, "id" = N.id)

		data["reagents"] = list("total_volume" = reagents.total_volume, "reagent_list" = ui_reagent_list)
	else
		data["reagents"] = null

	data["mode"] = mode

	if(analyze_data)
		data["analyzeData"] = list("name" = analyze_data["name"], "desc" = analyze_data["desc"], "blood_type" = analyze_data["blood_type"], "blood_DNA" = analyze_data["blood_DNA"])
	else
		data["analyzeData"] = null

	data["pillSprite"] = pillsprite
	data["bottleSprite"] = bottlesprite

	var/P[29] //how many pill sprites there are. Sprites are taken from chemical.dmi and can be found in nano/images/pill.png
	for(var/i = 1 to P.len)
		P[i] = i
	data["pillSpritesAmount"] = P

	data["bottleSpritesAmount"] = list(1, 2, 3, 4) //how many bottle sprites there are. Sprites are taken from chemical.dmi and can be found in nano/images/pill.png

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "chem_master.tmpl", src.name, 575, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)



/obj/machinery/chem_master/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER)) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	src.add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["tab_select"])
		tab = href_list["tab_select"]

	if (href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.loc = src.loc
			loaded_pill_bottle = null

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		if (tab == "analyze")
			analyze_data["name"] = href_list["name"]
			analyze_data["desc"] = href_list["desc"]
			if(!condi)
				if(href_list["name"] == "Blood")
					var/datum/reagent/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list["name"])
							G = F
							break
					analyze_data["name"] = G.name
					analyze_data["blood_type"] = G.data["blood_type"]
					analyze_data["blood_DNA"] = G.data["blood_DNA"]

		else if (href_list["add"])

			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				R.trans_id_to(src, id, amount)

		else if (href_list["addcustom"])

			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if (href_list["remove"])

			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
				else
					reagents.remove_reagent(id, amount)


		else if (href_list["removecustom"])

			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["eject"])
			if(beaker)
				beaker:loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"
		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if (href_list["createpill_multiple"])
				count = input("Select the number of pills to make.", "Max [max_pill_count]", pillamount) as null|num
				if(!count) //Covers 0 and cancel
					return
				count = Clamp(count, 1, max_pill_count)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			var/amount_per_pill = reagents.total_volume/count
			if (amount_per_pill > 60) amount_per_pill = 60

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill] units)") as null|text, MAX_NAME_LEN)
			if(!name) //Blank name (sanitized to nothing, or left empty) or cancel
				return

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count--)
				var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				//This line of code is so clunky. Need advice on improving it: going if(pillsprite >= 21) does not work as pillsprite is a text string.
				if(P.icon_state == "pill21" || P.icon_state == "pill22" || P.icon_state == "pill23" || P.icon_state == "pill24" || P.icon_state == "pill25" || P.icon_state == "pill26" || P.icon_state == "pill27" || P.icon_state == "pill28" || P.icon_state == "pill29")
					P.icon = 'modular_citadel/icons/obj/chemical.dmi'
					P.color = reagents.get_color()
				reagents.trans_to_obj(P,amount_per_pill)
				if(src.loaded_pill_bottle)
					if(loaded_pill_bottle.contents.len < loaded_pill_bottle.max_storage_space)
						P.loc = loaded_pill_bottle

		else if (href_list["createbottle"])
			if(!condi)
				var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()), MAX_NAME_LEN)
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "bottle-"+bottlesprite
				reagents.trans_to_obj(P,60)
				P.update_icon()
			else
				var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
				reagents.trans_to_obj(P,50)

		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	nanomanager.update_uis(src)




