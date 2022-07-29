/obj/machinery/oxygen_pump
	name = "emergency oxygen pump"
	icon = 'icons/obj/walllocker.dmi'
	desc = "A wall mounted oxygen pump with a retractable mask that you can pull over your face in case of emergencies."
	icon_state = "oxygen_tank"

	anchored = TRUE

	var/obj/item/tank/tank
	var/mob/living/carbon/breather
	var/obj/item/clothing/mask/breath/contained

	var/spawn_type = /obj/item/tank/emergency/oxygen/engi
	var/mask_type = /obj/item/clothing/mask/breath/emergency
	var/icon_state_open = "oxygen_tank_open"
	var/icon_state_closed = "oxygen_tank"

	power_channel = ENVIRON
	idle_power_usage = 10
	active_power_usage = 120 // No idea what the realistic amount would be.

/obj/machinery/oxygen_pump/Initialize(mapload)
	. = ..()
	tank = new spawn_type (src)
	contained = new mask_type (src)

/obj/machinery/oxygen_pump/Destroy()
	if(breather)
		breather.internal = null
		if(breather.internals)
			breather.internals.icon_state = "internal0"
		visible_message(SPAN_NOTICE("\The [contained] rapidly retracts just before \the [src] is destroyed!"))
		breather = null

	if(tank)
		QDEL_NULL(tank)
	if(contained)
		QDEL_NULL(contained)
	return ..()

/obj/machinery/oxygen_pump/OnMouseDropLegacy(mob/living/carbon/human/target, src_location, over_location)
	..()
	if(istype(target) && CanMouseDrop(target))
		if(!can_apply_to_target(target, usr)) // There is no point in attempting to apply a mask if it's impossible.
			return
		usr.visible_message("\The [usr] begins placing \the [contained] onto [target].")
		if(!do_mob(usr, target, 25) || !can_apply_to_target(target, usr))
			return
		// place mask and add fingerprints
		usr.visible_message("\The [usr] has placed \the [contained] on [target]'s mouth.")
		attach_mask(target)
		src.add_fingerprint(usr)

/obj/machinery/oxygen_pump/attack_hand(mob/user)
	if((machine_stat & MAINT) && tank)
		user.visible_message( \
			SPAN_NOTICE("\The [user] removes \the [tank] from \the [src]."), \
			SPAN_NOTICE("You remove \the [tank] from \the [src]."))
		user.put_in_hands(tank)
		src.add_fingerprint(user)
		tank.add_fingerprint(user)
		tank = null
		return
	if (!tank)
		to_chat(user, SPAN_WARNING("There is no tank in \the [src]!"))
		return
	if(breather)
		if(tank)
			tank.forceMove(src)
		contained.forceMove(src)
		visible_message(SPAN_NOTICE("\The [user] makes \the [contained] rapidly retract back into \the [src]!"))
		if(breather.internals)
			breather.internals.icon_state = "internal0"
		breather = null
		update_use_power(USE_POWER_IDLE)

/obj/machinery/oxygen_pump/attack_ai(mob/user)
	nano_ui_interact(user)

/obj/machinery/oxygen_pump/proc/attach_mask(mob/living/carbon/C)
	if(C && istype(C))
		if(!C.equip_to_slot_if_possible(contained, SLOT_ID_MASK, INV_OP_FLUFFLESS | INV_OP_SUPPRESS_WARNING))
			return
		if(tank)
			tank.forceMove(C)
		breather = C
		if(!breather.internal && tank)
			breather.internal = tank
			if(breather.internals)
				breather.internals.icon_state = "internal1"
		update_use_power(USE_POWER_ACTIVE)

/obj/machinery/oxygen_pump/proc/can_apply_to_target(mob/living/carbon/human/target, mob/user)
	if(!user)
		user = target
	// Check target validity
	if(!target.organs_by_name[BP_HEAD])
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a head."))
		return
	if(!target.check_has_mouth())
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a mouth."))
		return
	if(target.wear_mask && target != breather)
		to_chat(user, SPAN_WARNING("\The [target] is already wearing a mask."))
		return
	if(target.head && (target.head.body_parts_covered & FACE))
		to_chat(user, SPAN_WARNING("Remove their [target.head] first."))
		return
	if(!tank)
		to_chat(user, SPAN_WARNING("There is no tank in \the [src]."))
		return
	if(machine_stat & MAINT)
		to_chat(user, SPAN_WARNING("Please close the maintenance hatch first."))
		return
	if(!Adjacent(target))
		to_chat(user, SPAN_WARNING("Please stay close to \the [src]."))
		return
	//when there is a breather:
	if(breather && target != breather)
		to_chat(user, SPAN_WARNING("\The pump is already in use."))
		return
	//Checking if breather is still valid
	if(target == breather && target.wear_mask != contained)
		to_chat(user, SPAN_WARNING("\The [target] is not using the supplied [contained]."))
		return
	return 1

/obj/machinery/oxygen_pump/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		machine_stat ^= MAINT
		user.visible_message( \
			SPAN_NOTICE("\The [user] [(machine_stat & MAINT) ? "opens" : "closes"] \the [src]."), \
			SPAN_NOTICE("You [(machine_stat & MAINT) ? "open" : "close"] \the [src]."))

		icon_state = (machine_stat & MAINT) ? icon_state_open : icon_state_closed
		//TO-DO: Open icon
	if(istype(W, /obj/item/tank) && (machine_stat & MAINT))
		if(tank)
			to_chat(user, SPAN_WARNING("\The [src] already has a tank installed!"))
		else
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			tank = W
			user.visible_message( \
				SPAN_NOTICE("\The [user] installs \the [tank] into \the [src]."), \
				SPAN_NOTICE("You install \the [tank] into \the [src]."))
			src.add_fingerprint(user)
	if(istype(W, /obj/item/tank) && !machine_stat)
		to_chat(user, SPAN_WARNING("Please open the maintenance hatch first."))

/obj/machinery/oxygen_pump/examine(mob/user)
	. = ..()
	if(tank)
		. += SPAN_NOTICE("The meter shows [round(tank.air_contents.return_pressure())] kPa.")
	else
		. += SPAN_WARNING("It is missing a tank!")


/obj/machinery/oxygen_pump/process(delta_time)
	if(breather)
		if(!can_apply_to_target(breather))
			if(tank)
				tank.forceMove(src)
			contained.forceMove(src)
			src.visible_message(SPAN_NOTICE("\The [contained] rapidly retracts back into \the [src]!"))
			breather = null
			update_use_power(USE_POWER_IDLE)
		else if(!breather.internal && tank)
			breather.internal = tank
			if(breather.internals)
				breather.internals.icon_state = "internal0"

//Create rightclick to view tank settings
/obj/machinery/oxygen_pump/verb/settings()
	set src in oview(1)
	set category = "Object"
	set name = "Show Tank Settings"
	nano_ui_interact(usr)

//GUI Tank Setup
/obj/machinery/oxygen_pump/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/data[0]
	if(!tank)
		to_chat(usr, "<span class='warning'>It is missing a tank!</span>")
		data["tankPressure"] = 0
		data["releasePressure"] = 0
		data["defaultReleasePressure"] = 0
		data["maxReleasePressure"] = 0
		data["maskConnected"] = 0
		data["tankInstalled"] = 0
	// this is the data which will be sent to the ui
	if(tank)
		data["tankPressure"] = round(tank.air_contents.return_pressure() ? tank.air_contents.return_pressure() : 0)
		data["releasePressure"] = round(tank.distribute_pressure ? tank.distribute_pressure : 0)
		data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)
		data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)
		data["maskConnected"] = 0
		data["tankInstalled"] = 1

	if(!breather)
		data["maskConnected"] = 0
	if(breather)
		data["maskConnected"] = 1


	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "Oxygen_pump.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/oxygen_pump/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			tank.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
		else if (href_list["dist_p"] == "max")
			tank.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			tank.distribute_pressure += cp
		tank.distribute_pressure = min(max(round(tank.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
		return 1

/obj/machinery/oxygen_pump/anesthetic
	name = "anesthetic pump"
	spawn_type = /obj/item/tank/anesthetic
	icon_state = "anesthetic_tank"
	icon_state_closed = "anesthetic_tank"
	icon_state_open = "anesthetic_tank_open"
	mask_type = /obj/item/clothing/mask/breath/anesthetic

/obj/machinery/oxygen_pump/mobile
	name = "portable oxygen pump"
	icon = 'icons/obj/atmos.dmi'
	desc = "A portable oxygen pump with a retractable mask that you can pull over your face in case of emergencies."
	icon_state = "medpump"
	icon_state_open = "medpump_open"
	icon_state_closed = "medpump"

	anchored = FALSE
	density = TRUE

	mask_type = /obj/item/clothing/mask/gas/clear

	var/last_area = null

/obj/machinery/oxygen_pump/mobile/process(delta_time)
	..()

	var/turf/T = get_turf(src)

	if(!last_area && T)
		last_area = T.loc

	if(last_area != T.loc)
		power_change()
		last_area = T.loc

/obj/machinery/oxygen_pump/mobile/anesthetic
	name = "portable anesthetic pump"
	spawn_type = /obj/item/tank/anesthetic
	icon_state = "medpump_n2o"
	icon_state_closed = "medpump_n2o"
	icon_state_open = "medpump_n2o_open"
	mask_type = /obj/item/clothing/mask/breath/anesthetic

/obj/machinery/oxygen_pump/mobile/stabilizer
	name = "portable patient stabilizer"
	desc = "A portable oxygen pump with a retractable mask used for stabilizing patients in the field."

/obj/machinery/oxygen_pump/mobile/stabilizer/process(delta_time)
	if(breather)
		if(!can_apply_to_target(breather))
			if(tank)
				tank.forceMove(src)
			contained.forceMove(src)
			src.visible_message(SPAN_NOTICE("\The [contained] rapidly retracts back into \the [src]!"))
			breather = null
			update_use_power(USE_POWER_IDLE)
		else if(!breather.internal && tank)
			breather.internal = tank
			if(breather.internals)
				breather.internals.icon_state = "internal0"

		if(breather)	// Safety.
			if(ishuman(breather))
				var/mob/living/carbon/human/H = breather

				if(H.stat == DEAD)
					H.add_modifier(/datum/modifier/bloodpump_corpse, 6 SECONDS)

				else
					H.add_modifier(/datum/modifier/bloodpump, 6 SECONDS)

	var/turf/T = get_turf(src)

	if(!last_area && T)
		last_area = T.loc

	if(last_area != T.loc)
		power_change()
		last_area = T.loc
