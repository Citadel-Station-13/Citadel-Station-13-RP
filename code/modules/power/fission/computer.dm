#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/fission_monitor
	name = T_BOARD("fission monitoring console")
	build_path = /obj/machinery/computer/fission_monitor

/obj/machinery/computer/fission_monitor
	name = "fission monitoring console"
	desc = "Used to monitor a linked fission core."
	icon_keyboard = "tech_key"
	icon_screen = "power_monitor"
	light_color = "#ffcc33"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/circuitboard/fission_monitor
	var/obj/machinery/power/fission/linked

/obj/machinery/computer/fission_monitor/New()
	..()

/obj/machinery/computer/fission_monitor/Destroy()
	linked = null
	..()

/obj/machinery/computer/fission_monitor/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		if (!isnull(M.connectable) && istype(M.connectable, /obj/machinery/power/fission))
			linked = M.connectable
			to_chat(user, "<span class='notice'>You link \the [M.connectable] to \the [src].</span>")
			M.connectable = null
		else
			to_chat(user, "<span class='notice'>There's nothing to link.</span>")
		return
	return ..()

/obj/machinery/computer/fission_monitor/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/fission_monitor/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/fission_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!src.powered())
		return

	var/data[0]

	if(isnull(linked) || !linked.anchored)
		data["not_connected"] = 1
	else
		data = linked.ui_data(TRUE)
		data["not_connected"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fission_monitor.tmpl", "Nuclear Fission Core", 500, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/fission_monitor/Topic(href,href_list)
	if(..())
		return 1
	if(isnull(linked) || !linked.powered())
		return 1

	if(href_list["rod_insertion"])
		var/obj/item/fuelrod/rod = locate(href_list["rod_insertion"])
		if(istype(rod) && rod.loc == linked)
			var/new_insersion = input(usr,"Enter new insertion (0-100)%","Insertion control",rod.insertion * 100) as num
			rod.insertion = between(0, new_insersion / 100, 1)

	if(href_list["cutoff_point"])
		var/new_cutoff = input(usr,"Enter new cutoff point in Kelvin","Cutoff point",linked.cutoff_temp) as num
		linked.cutoff_temp = between(0, new_cutoff, linked.max_temp)
		if (linked.cutoff_temp == 0)
			message_admins("[key_name(usr)] switched off auto shutdown on [linked]",0,1)
			log_game("[linked] auto shutdown was switched off by [key_name(usr)]")

	usr.set_machine(src)
	src.add_fingerprint(usr)
