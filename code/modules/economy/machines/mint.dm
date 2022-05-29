/**********************Mint**************************/


/obj/machinery/mineral/mint
	name = "Coin press"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/amt_supermatter = 0
	var/amt_bananium = 0
	var/amt_mhydrogen = 0
	var/amt_durasteel = 0
	var/amt_platinum = 0
	var/amt_diamond = 0
	var/amt_uranium = 0
	var/amt_phoron = 0
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_copper = 0
	var/amt_iron = 0
	var/newCoins = 0   //how many coins the machine made in it's last load
	var/processing = 0
	var/chosen = MAT_STEEL //which material will be used to make coins
	var/coinsToProduce = 10

/obj/machinery/mineral/mint/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/mint/LateInitialize()
	for(var/dir in GLOB.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break
	for(var/dir in GLOB.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break
	START_PROCESSING(SSobj, src)

/obj/machinery/mineral/mint/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/machinery/mineral/mint/process(delta_time)
	if (input)
		var/obj/item/stack/O
		O = locate(/obj/item/stack, input.loc)
		if(O)
			var/processed = 1
			switch(O.get_material_name())
				if("supermatter")
					amt_supermatter += 100 * O.get_amount()
				if("bananium")
					amt_bananium += 100 * O.get_amount()
				if("mhydrogen")
					amt_mhydrogen += 100 * O.get_amount()
				if("durasteel")
					amt_durasteel += 100 * O.get_amount()
				if("platinum")
					amt_platinum += 100 * O.get_amount()
				if("diamond")
					amt_diamond += 100 * O.get_amount()
				if("uranium")
					amt_uranium += 100 * O.get_amount()
				if("phoron")
					amt_phoron += 100 * O.get_amount()
				if("gold")
					amt_gold += 100 * O.get_amount()
				if("silver")
					amt_silver += 100 * O.get_amount()
				if("copper")
					amt_copper += 100 * O.get_amount()
				if("iron")
					amt_iron += 100 * O.get_amount()
				else
					processed = 0
			if(processed)
				qdel(O)

/obj/machinery/mineral/mint/attack_hand(user as mob)

	var/dat = "<b>Coin Press</b><br>"

	if (!input)
		dat += text("input connection status: ")
		dat += text("<b><font color='red'>NOT CONNECTED</font></b><br>")
	if (!output)
		dat += text("<br>output connection status: ")
		dat += text("<b><font color='red'>NOT CONNECTED</font></b><br>")

	dat += text("<br><font color='#c70000'><b>Supermatter inserted: </b>[amt_supermatter]</font> ")
	if (chosen == "supermatter")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=supermatter'>Choose</A>")
	dat += text("<br><font color='#aaa81d'><b>Bananium inserted: </b>[amt_bananium]</font> ")
	if (chosen == "bananium")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=bananium'>Choose</A>")
	dat += text("<br><font color='#8d3d5f'><b>Metallic Hydrogen inserted: </b>[amt_mhydrogen]</font> ")
	if (chosen == "mhydrogen")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=mhydrogen'>Choose</A>")
	dat += text("<br><font color='#8888FF'><b>Durasteel inserted: </b>[amt_durasteel]</font> ")
	if (chosen == "durasteel")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=durasteel'>Choose</A>")
	dat += text("<br><font color='#375064'><b>Platinum inserted: </b>[amt_platinum]</font> ")
	if (chosen == "platinum")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=platinum'>Choose</A>")
	dat += text("<br><font color='#509edd'><b>Diamond inserted: </b>[amt_diamond]</font> ")
	if (chosen == "diamond")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=diamond'>Choose</A>")
	dat += text("<br><font color='#008800'><b>Uranium inserted: </b>[amt_uranium]</font> ")
	if (chosen == "uranium")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=uranium'>Choose</A>")
	dat += text("<br><font color='#FF8800'><b>Phoron inserted: </b>[amt_phoron]</font> ")
	if (chosen == "phoron")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=phoron'>Choose</A>")
	dat += text("<br><font color='#ffcc00'><b>Gold inserted: </b>[amt_gold]</font> ")
	if (chosen == "gold")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=gold'>Choose</A>")
	dat += text("<br><font color='#888888'><b>Silver inserted: </b>[amt_silver]</font> ")
	if (chosen == "silver")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=silver'>Choose</A>")
	dat += text("<br><font color='#a86e02'><b>Copper inserted: </b>[amt_copper]</font> ")
	if (chosen == "copper")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=copper'>Choose</A>")
	dat += text("<br><font color='#474747'><b>Iron inserted: </b>[amt_iron]</font> ")
	if (chosen == "iron")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=iron'>Choose</A>")

	dat += text("<br><br>Will produce [coinsToProduce] [chosen] coins if enough materials are available.<br>")
	//dat += text("The dial which controls the number of conins to produce seems to be stuck. A technician has already been dispatched to fix this.")
	dat += text("<A href='?src=\ref[src];chooseAmt=-10'>-10</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=-5'>-5</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=-1'>-1</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=1'>+1</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=5'>+5</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=10'>+10</A> ")

	dat += text("<br><br>In total this machine produced <font color='green'><b>[newCoins]</b></font> coins.")
	dat += text("<br><A href='?src=\ref[src];makeCoins=[1]'>Make coins</A>")
	user << browse("[dat]", "window=mint")

/obj/machinery/mineral/mint/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(processing==1)
		to_chat(usr, "<font color=#4F49AF>The machine is processing.</font>")
		return
	if(href_list["choose"])
		chosen = href_list["choose"]
	if(href_list["chooseAmt"])
		coinsToProduce = between(0, coinsToProduce + text2num(href_list["chooseAmt"]), 1000)
	if(href_list["makeCoins"])
		var/temp_coins = coinsToProduce
		if (src.output)
			processing = 1;
			icon_state = "coinpress1"
			var/obj/item/moneybag/M
			switch(chosen)
				if("supermatter")
					while(amt_supermatter > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/supermatter(M)
						amt_supermatter -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("bananium")
					while(amt_bananium > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/bananium(M)
						amt_bananium -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("mhydrogen")
					while(amt_mhydrogen > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/mhydrogen(M)
						amt_mhydrogen -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("durasteel")
					while(amt_durasteel > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/durasteel(M)
						amt_durasteel -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("platinum")
					while(amt_platinum > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/platinum(M)
						amt_platinum -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("diamond")
					while(amt_diamond > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/diamond(M)
						amt_diamond -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("uranium")
					while(amt_uranium > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/uranium(M)
						amt_uranium -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("phoron")
					while(amt_phoron > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/phoron(M)
						amt_phoron -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("gold")
					while(amt_gold > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/gold(M)
						amt_gold -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("silver")
					while(amt_silver > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/silver(M)
						amt_silver -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5);
				if("copper")
					while(amt_copper > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new /obj/item/coin/copper(M)
						amt_copper -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
				if("iron")
					while(amt_iron > 0 && coinsToProduce > 0)
						if (locate(/obj/item/moneybag,output.loc))
							M = locate(/obj/item/moneybag,output.loc)
						else
							M = new/obj/item/moneybag(output.loc)
						new/obj/item/coin/iron(M)
						amt_iron -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
			icon_state = "coinpress0"
			processing = 0;
			coinsToProduce = temp_coins
	src.updateUsrDialog()
	return

/**********************Coin Machine**************************/

/obj/machinery/coinbank
	name = "\improper Coin Bank"
	icon = 'icons/obj/vending.dmi'
	icon_state = "coinvend"
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_on = "coinvend"
	var/icon_off = "coinvent-off"
	var/icon_panel = "coinvent-panel"
	var/list/item_records = list()
	var/datum/stored_item/currently_vending = null	//What we're putting out of the machine.
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/wrenchable = TRUE
	var/datum/wires/coinbank/wires = null

/obj/machinery/coinbank/Initialize(mapload)
	. = ..()
	wires = new/datum/wires/coinbank(src)

/obj/machinery/coinbank/Destroy()
	qdel(wires)
	for(var/A in item_records)	//Get rid of item records.
		qdel(A)
	wires = null
	return ..()

/obj/machinery/coinbank/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/coin))
		return 1
	return 0

/obj/machinery/coinbank/process(delta_time)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/coinbank/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/coinbank/update_icon()
	if(machine_stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

/obj/machinery/coinbank/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.is_screwdriver())
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		playsound(src, O.usesound, 50, 1)
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		SSnanoui.update_uis(src)
		return

	if(wrenchable && default_unfasten_wrench(user, O, 20))
		return

	if(istype(O, /obj/item/multitool) || O.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return

	if(machine_stat & NOPOWER)
		to_chat(user, "<span class='notice'>\The [src] is unpowered and useless.</span>")
		return

	if(accept_check(O))
		user.remove_from_mob(O)
		stock(O)
		user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")


	else if(istype(O, /obj/item/storage/bag))
		var/obj/item/storage/bag/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				P.remove_from_storage(G) //fixes ui bug - Pull Request 5515
				stock(G)
				plants_loaded = 1
		if(plants_loaded)
			user.visible_message("<span class='notice'>[user] loads \the [src] with \the [P].</span>", "<span class='notice'>You load \the [src] with \the [P].</span>")
			if(P.contents.len > 0)
				to_chat(user, "<span class='notice'>Some items are refused.</span>")

	else if(istype(O, /obj/item/gripper)) // Grippers. ~Mechoid.
		var/obj/item/gripper/B = O	//B, for Borg.
		if(!B.wrapped)
			to_chat(user, "\The [B] is not holding anything.")
			return
		else
			var/B_held = B.wrapped
			to_chat(user, "You use \the [B] to put \the [B_held] into \the [src] slot.")
		return

	else
		to_chat(user, "<span class='notice'>\The [O] doesn't fit into the [src] slot.</span>")
		return 1

/obj/machinery/coinbank/proc/stock(obj/item/O)
	var/hasRecord = FALSE	//Check to see if this passes or not.
	for(var/datum/stored_item/I in item_records)
		if((O.type == I.item_path) && (O.name == I.item_name))
			I.add_product(O)
			hasRecord = TRUE
			break
	if(!hasRecord)
		var/datum/stored_item/item = new/datum/stored_item(src, O.type, O.name)
		item.add_product(O)
		item_records.Add(item)
	SSnanoui.update_uis(src)

/obj/machinery/coinbank/proc/vend(datum/stored_item/I)
	I.get_product(get_turf(src))
	SSnanoui.update_uis(src)

/obj/machinery/coinbank/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/coinbank/attack_hand(mob/user as mob)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	nano_ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/coinbank/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory

	var/list/items[0]
	for (var/i=1 to length(item_records))
		var/datum/stored_item/I = item_records[i]
		var/count = I.get_amount()
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(I.item_name)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/coinbank/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if(href_list["vend"])
		var/index = text2num(href_list["vend"])
		var/amount = text2num(href_list["amount"])
		var/datum/stored_item/I = item_records[index]
		var/count = I.get_amount()

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > 0)
			if((count - amount) < 0)
				amount = count
			for(var/i = 1 to amount)
				vend(I)

		return 1
	return 0

/obj/machinery/coinbank/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_item/I in item_records)
		throw_item = I.get_product(get_turf(src))
		if (!throw_item)
			continue
		break

	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	return 1
