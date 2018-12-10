/obj/machinery/computer/telescience
	name = "telepad control console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	circuit = /obj/item/weapon/circuitboard/telesci_console
	var/sending = 1
	var/obj/machinery/telepad/telepad = null
	var/temp_msg = "Telescience control console initialized.<BR>Welcome."

 	// VARIABLES //
	var/teles_left	// How many teleports left until it becomes uncalibrated
	var/datum/projectile_data/last_tele_data = null
	var/z_co = 1
	var/power_off
	var/rotation_off
	var/last_target

 	var/rotation = 0
	var/angle = 45
	var/power = 5


 	// Based on the power used
	var/teleport_cooldown = 0 // every index requires a bluespace crystal
	var/list/power_options = list(5, 10, 20, 25, 30, 40, 50, 80, 100)
	var/teleporting = 0
	var/starting_crystals = 0
	var/max_crystals = 4
	var/list/crystals = list()
	var/obj/item/device/gps/inserted_gps

/obj/machinery/computer/telescience/New()
	..()
	recalibrate()

/obj/machinery/computer/telescience/Destroy()
	eject()
	if(inserted_gps)
		inserted_gps.forceMove(loc)
		inserted_gps = null
	return ..()

/obj/machinery/computer/telescience/examine(mob/user)
	..(user)
	to_chat(user, "There are [crystals ? crystals : "no"] bluespace crystal\s in the crystal slots.")

/obj/machinery/computer/telescience/initialize()
	..()

/obj/machinery/computer/telescience/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/ore/bluespace_crystal))
		var/obj/item/weapon/ore/bluespace_crystal/B = W
		if(crystals >= max_crystals)
			to_chat(user, "<span class='warning'>There are not enough crystal slots.</span>")
			return
		if(!user.drop_item())
			return
		crystals += W
		W.forceMove(src)
		user.visible_message("[user] inserts [W] into \the [src]'s crystal slot.", "<span class='notice'>You insert [W] into \the [src]'s crystal slot.</span>")
		updateDialog()
	else if(istype(W, /obj/item/device/gps))
		if(!inserted_gps)
			inserted_gps = W
			user.unEquip(W)
			W.loc = src
			user.visible_message("<span class='notice'>[user] inserts [W] into [src]'s GPS device slot.</span>")
			updateUsrDialog()
	else if(istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		if(M.connectable && istype(M.connectable, /obj/machinery/telepad))
			telepad = M.connectable
			M.connectable = null
			to_chat(user, "<span class = 'caution'>You upload the data from the [W.name]'s buffer.</span>")
			updateUsrDialog()
	else
		..()

/obj/machinery/computer/telescience/emag_act(user as mob)
	if(!emagged)
		to_chat(user, "<span class='notice'>You scramble the Telescience authentication key to an unknown signal. You should be able to teleport to more places now!</span>")
		emagged = 1
	else
		to_chat(user, "<span class='warning'>The machine seems unaffected by the card swipe...</span>")

/obj/machinery/computer/telescience/attack_ai(mob/user)
	src.attack_hand(user)

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/telescience/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/data[0]

	if(!telepad)
		in_use = 0     //Yeah so if you deconstruct teleporter while its in the process of shooting it wont disable the console
		data["noTelepad"] = 1
	else
		data["insertedGps"] = inserted_gps
		data["tempMsg"] = temp_msg
		data["rotation"] = rotation
		data["angle"] = angle
		data["power"] = power
		data["currentZ"] = z_co
 		data["powerOptions"] = new/list(power_options.len)

		for(var/i = 1; i <= power_options.len; i++)
			var/enabled = (crystals.len + telepad.efficiency >= i);
			data["powerOptions"][i] = list("power" = power_options[i], "enabled" = enabled)

 		data["sectorOptions"] = list()
		for(var/z in config.player_levels)
			data["sectorOptions"] += z

		if(last_tele_data)
			data["lastTeleData"] = list()
			data["lastTeleData"]["src_x"] = last_tele_data.src_x
			data["lastTeleData"]["src_y"] = last_tele_data.src_y
			data["lastTeleData"]["distance"] = last_tele_data.distance
			data["lastTeleData"]["time"] = last_tele_data.time
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "telescience_console_citadel.tmpl", src.name, 400, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)

/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
		s.set_up(5, 1, get_turf(telepad))
		s.start()
	else
		return

/obj/machinery/computer/telescience/proc/telefail()
	sparks()
	visible_message("<span class='warning'>The telepad weakly fizzles.</span>")
	return

/obj/machinery/computer/telescience/proc/doteleport(mob/user)

	if(teleport_cooldown > world.time)
		temp_msg = "Telepad is recharging power.<BR>Please wait [round((teleport_cooldown - world.time) / 10)] seconds."
		return

	if(teleporting)
		temp_msg = "Telepad is in use.<BR>Please wait."
		return

	if(telepad)

		var/truePower = Clamp(power + power_off, 1, 1000)
		var/trueRotation = rotation + rotation_off
		var/trueAngle = Clamp(angle, 1, 90)

		var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
		last_tele_data = proj_data

		var/trueX = Clamp(round(proj_data.dest_x, 1), 1, world.maxx)
		var/trueY = Clamp(round(proj_data.dest_y, 1), 1, world.maxy)
		var/spawn_time = round(proj_data.time) * 10

		var/turf/target = locate(trueX, trueY, z_co)
		last_target = target
		var/area/A = get_area(target)
		flick("pad-beam", telepad)

		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad.loc, 'sound/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = 1
			temp_msg = "Powering up bluespace crystals.<BR>Please wait."


		spawn(round(proj_data.time) * 10) // in seconds
			if(!telepad)
				return
			if(telepad.stat & NOPOWER)
				return
			teleporting = 0
			teleport_cooldown = world.time + (power * 2)
			teles_left -= 1

			// use a lot of power
			use_power(power * 10)

			var/datum/effect/effect/system/spark_spread/S = new /datum/effect/effect/system/spark_spread()
			S.set_up(5, 1, get_turf(telepad))
			S.start()

			temp_msg = "Teleport successful.<BR>"
			if(teles_left < 10)
				temp_msg += "<BR>Calibration required soon."
			else
				temp_msg += "Data printed below."

			var/sparks = get_turf(target)
			var/datum/effect/effect/system/spark_spread/Y = new /datum/effect/effect/system/spark_spread()
			Y.set_up(5, 1, sparks)
			Y.start()

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			var/log_msg = ""
			log_msg += ": [key_name(user)] has teleported "

			if(sending)
				source = dest
				dest = target

			flick("pad-beam", telepad)
			playsound(telepad.loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue

							log_msg += "[key_name(L)] (on a chair), "
						else
							continue
					else if(!isobserver(ROI))
						continue
				if(ismob(ROI))
					var/mob/T = ROI
					log_msg += "[key_name(T)], "
				else
					log_msg += "[ROI.name]"
					if (istype(ROI, /obj/structure/closet))
						var/obj/structure/closet/C = ROI
						log_msg += " ("
						for(var/atom/movable/Q as mob|obj in C)
							if(ismob(Q))
								log_msg += "[key_name(Q)], "
							else
								log_msg += "[Q.name], "
						if (dd_hassuffix(log_msg, "("))
							log_msg += "empty)"
						else
							log_msg += ")"
					log_msg += ", "
				do_teleport(ROI, dest)

			if (!dd_hassuffix(log_msg, ", "))
				log_msg += "nothing"
			log_msg += " [sending ? "to" : "from"] [trueX], [trueY], [z_co] ([A ? A.name : "null area"])"
			investigate_log(log_msg, "telesci")
			updateDialog()

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	if(rotation == null || angle == null || z_co == null)
		temp_msg = "ERROR!<BR>Set a angle, rotation and sector."
		return
	if(power <= 0)
		telefail()
		temp_msg = "ERROR!<BR>No power selected!"
		return
	if(angle < 1 || angle > 90)
		telefail()
		temp_msg = "ERROR!<BR>Elevation is less than 1 or greater than 90."
		return
	if(z_co == 2 || z_co < 1 || z_co > 6)
		if(z_co == 7 & emagged == 1)
		// This should be empty, allows for it to continue if the z-level is 7 and the machine is emagged.
		else
			telefail()
			temp_msg = "ERROR! Sector is less than 1, <BR>greater than [src.emagged ? "7" : "6"], or equal to 2."
			return


	var/truePower = Clamp(power + power_off, 1, 1000)
	var/trueRotation = rotation + rotation_off
	var/trueAngle = Clamp(angle, 1, 90)

	var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
	var/turf/target = locate(Clamp(round(proj_data.dest_x, 1), 1, world.maxx), Clamp(round(proj_data.dest_y, 1), 1, world.maxy), z_co)
	var/area/A = get_area(target)

	if(A.tele_proof == 1)
		telefail()
		temp_msg = "ERROR! Target destination unreachable due to interference."
		return

	if(teles_left > 0)
		if(!doteleport(user))
			telefail()
			temp_msg = "ERROR! Target destination unreachable due to interference."
			return
	else
		telefail()
		temp_msg = "ERROR!<BR>Calibration required."
		return
	return

/obj/machinery/computer/telescience/proc/eject()
	var/to_eject
	for(var/i in 1 to crystals)
		to_eject += 1
		crystals -= 1
	new /obj/item/weapon/ore/bluespace_crystal(drop_location(), to_eject)
	power = 0

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(!telepad)
		updateUsrDialog()
		return
	if(telepad.panel_open)
		temp_msg = "Telepad undergoing physical maintenance operations."

	if(href_list["setrotation"])
		var/new_rot = input("Please input desired bearing in degrees.", name, rotation) as num
		if(..()) // Check after we input a value, as they could've moved after they entered something
			return
		rotation = Clamp(new_rot, -900, 900)
		rotation = round(rotation, 0.01)

	if(href_list["setangle"])
		var/new_angle = input("Please input desired elevation in degrees.", name, angle) as num
		if(..())
			return
		angle = Clamp(round(new_angle, 0.1), 1, 9999)

	if(href_list["setpower"])
		var/index = href_list["setpower"]
		index = text2num(index)
		if(index != null && power_options[index])
			if(crystals + telepad.efficiency >= index)
				power = power_options[index]

	if(href_list["setz"])
		var/new_z = input("Please input desired sector.", name, z_co) as num
		if(..())
			return
		z_co = Clamp(round(new_z), 1, 10)

	if(href_list["ejectGPS"])
		if(inserted_gps)
			usr.put_in_hands(inserted_gps)
			inserted_gps = null

	if(href_list["setMemory"])
		if(last_target && inserted_gps)
//			inserted_gps.locked_location = last_target
			temp_msg = "ERROR!<BR>Function currently unavailable."
		else
			temp_msg = "ERROR!<BR>No data was stored."

	if(href_list["send"])
		sending = 1
		teleport(usr)

	if(href_list["receive"])
		sending = 0
		teleport(usr)

	if(href_list["recal"])
		recalibrate()
		sparks()
		temp_msg = "NOTICE:<BR>Calibration successful."

	if(href_list["eject"])
		eject()
		temp_msg = "NOTICE:<BR>Bluespace crystals ejected."

	updateUsrDialog()

/obj/machinery/computer/telescience/proc/recalibrate()
	teles_left = rand(30, 40)
	//angle_off = rand(-25, 25)
	power_off = rand(-4, 0)
	rotation_off = rand(-10, 10)