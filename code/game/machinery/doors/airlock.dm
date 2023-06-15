/**
 * Redone a lot of airlock things:
 *
 * Specific department maintenance doors
 * Named doors properly according to type
 * Gave them default access levels with the access constants
 * Improper'd all of the names in the new()
 */

var/global/list/airlock_icon_cache = list()

GLOBAL_REAL_VAR(airlock_typecache) = typecacheof(list(
	/obj/structure/window/reinforced/tinted/full,
	/obj/structure/window/reinforced/full,
	/obj/structure/window/phoronreinforced/full,
	/obj/structure/window/phoronbasic/full,
	/obj/structure/window/basic/full,
	/obj/structure/window/reinforced/polarized/full,
	/obj/structure/wall_frame
	))

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

#define AIRLOCK_PAINTABLE 1
#define AIRLOCK_STRIPABLE 2
#define AIRLOCK_DETAILABLE 4
#define AIRLOCK_WINDOW_PAINTABLE 8

/obj/machinery/door/airlock
	name = "Airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	power_channel = ENVIRON
	rad_flags = RAD_BLOCK_CONTENTS
	rad_insulation = RAD_INSULATION_MEDIUM

	explosion_resistance = 10
	autoclose = 1
	normalspeed = 1

	/**
	 * If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	 * If 1, AI control is disabled until the AI hacks back in and disables the lock.
	 * If 2, the AI has bypassed the lock.
	 */
	var/aiControlDisabled = 0
	/// If 1, this door can't be hacked by the AI.
	var/hackProof = 0
	/// World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/electrified_until = 0
	/// World time when main power is restored.
	var/main_power_lost_until = 0
	/// World time when backup power is restored.
	var/backup_power_lost_until = -1
	/// If 1, will not beep on failed closing attempt. Resets when door closes.
	var/has_beeped = 0
	var/spawnPowerRestoreRunning = 0
	var/welded = null
	var/locked = 0
	/// Bolt lights show by default.
	var/lights = 1
	var/aiDisabledIdScanner = 0
	var/aiHacking = 0
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = 0
	var/safe = 1
	var/obj/item/airlock_electronics/electronics = null
	/// Prevents multiple shocks from happening.
	var/hasShocked = 0
	var/secured_wires = 0
	var/datum/wires/airlock/wires = null

	var/open_sound_powered = 'sound/machines/door/covert1o.ogg'
	var/open_sound_unpowered = 'sound/machines/airlockforced.ogg'
	var/close_sound_powered = 'sound/machines/door/covert1c.ogg'
	var/denied_sound = 'sound/machines/deniedbeep.ogg'
	var/bolt_up_sound = 'sound/machines/boltsup.ogg'
	var/bolt_down_sound = 'sound/machines/boltsdown.ogg'

	var/paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE|AIRLOCK_WINDOW_PAINTABLE
	var/door_color = null
	var/stripe_color = null
	var/symbol_color = null
	var/window_color = GLASS_COLOR
	var/window_material = /datum/material/glass

	var/fill_file = 'icons/obj/doors/station/fill_steel.dmi'
	var/color_file = 'icons/obj/doors/station/color.dmi'
	var/color_fill_file = 'icons/obj/doors/station/fill_color.dmi'
	var/stripe_file = 'icons/obj/doors/station/stripe.dmi'
	var/stripe_fill_file = 'icons/obj/doors/station/fill_stripe.dmi'
	var/glass_file = 'icons/obj/doors/station/fill_glass.dmi'
	var/bolts_file = 'icons/obj/doors/station/lights_bolts.dmi'
	var/deny_file = 'icons/obj/doors/station/lights_deny.dmi'
	var/lights_file = 'icons/obj/doors/station/lights_green.dmi'
	var/panel_file = 'icons/obj/doors/station/panel.dmi'
	var/sparks_damaged_file = 'icons/obj/doors/station/sparks_damaged.dmi'
	var/sparks_broken_file = 'icons/obj/doors/station/sparks_broken.dmi'
	var/welded_file = 'icons/obj/doors/station/welded.dmi'
	var/emag_file = 'icons/obj/doors/station/emag.dmi'
	var/airlock_type = "Standard"
	var/state = AIRLOCK_CLOSED
	var/speaker = TRUE

	/// Bandaid around a problem.
	var/last_spark = 0

	smoothing_flags = SMOOTH_CUSTOM
	smoothing_groups = (SMOOTH_GROUP_AIRLOCK)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_GRILLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS )

/obj/machinery/door/airlock/proc/set_airlock_overlays(state)
	var/icon/color_overlay
	var/icon/filling_overlay
	var/icon/stripe_overlay
	var/icon/stripe_filling_overlay
	var/icon/lights_overlay
	var/icon/panel_overlay
	var/icon/weld_overlay
	var/icon/damage_overlay
	var/icon/sparks_overlay
	var/icon/brace_overlay

	set_light(0)

	if(door_color && !(door_color == "none"))
		var/ikey = "[airlock_type]-[door_color]-color"
		color_overlay = airlock_icon_cache["[ikey]"]
		if(!color_overlay)
			color_overlay = new(color_file)
			color_overlay.Blend(door_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = color_overlay
	if(glass)
		if (window_color && window_color != "none")
			var/ikey = "[airlock_type]-[window_color]-windowcolor"
			filling_overlay = airlock_icon_cache["[ikey]"]
			if (!filling_overlay)
				filling_overlay = new(glass_file)
				filling_overlay.Blend(window_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = glass_file
	else
		if(door_color && !(door_color == "none"))
			var/ikey = "[airlock_type]-[door_color]-fillcolor"
			filling_overlay = airlock_icon_cache["[ikey]"]
			if(!filling_overlay)
				filling_overlay = new(color_fill_file)
				filling_overlay.Blend(door_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = fill_file
	if(stripe_color && !(stripe_color == "none"))
		var/ikey = "[airlock_type]-[stripe_color]-stripe"
		stripe_overlay = airlock_icon_cache["[ikey]"]
		if(!stripe_overlay)
			stripe_overlay = new(stripe_file)
			stripe_overlay.Blend(stripe_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = stripe_overlay
		if(!glass)
			var/ikey2 = "[airlock_type]-[stripe_color]-fillstripe"
			stripe_filling_overlay = airlock_icon_cache["[ikey2]"]
			if(!stripe_filling_overlay)
				stripe_filling_overlay = new(stripe_fill_file)
				stripe_filling_overlay.Blend(stripe_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey2]"] = stripe_filling_overlay

	if(arePowerSystemsOn())
		switch(state)
			if(AIRLOCK_CLOSED)
				if(lights && locked)
					lights_overlay = bolts_file
					set_light(1, 2, l_color = COLOR_RED_LIGHT)

			if(AIRLOCK_DENY)
				if(lights)
					lights_overlay = deny_file
					set_light(1, 2, l_color = COLOR_RED_LIGHT)

			if(AIRLOCK_EMAG)
				sparks_overlay = emag_file

			if(AIRLOCK_CLOSING)
				if(lights)
					lights_overlay = lights_file
					set_light(1, 2, l_color = COLOR_LIME)

			if(AIRLOCK_OPENING)
				if(lights)
					lights_overlay = lights_file
					set_light(1, 2, l_color = COLOR_LIME)

		if(machine_stat & BROKEN)
			damage_overlay = sparks_broken_file
		else if(health < maxhealth * 3/4)
			damage_overlay = sparks_damaged_file

	if(welded)
		weld_overlay = welded_file

	if(panel_open)
		panel_overlay = panel_file

	overlays.Cut()

	overlays += color_overlay
	overlays += filling_overlay
	overlays += stripe_overlay
	overlays += stripe_filling_overlay
	overlays += panel_overlay
	overlays += weld_overlay
	overlays += brace_overlay
	overlays += lights_overlay
	overlays += sparks_overlay
	overlays += damage_overlay

/obj/machinery/door/airlock/attack_generic(var/mob/living/user, var/damage)
	if(machine_stat & (BROKEN|NOPOWER))
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			if(src.locked || src.welded)
				visible_message("<span class='danger'>\The [user] begins breaking into \the [src] internals!</span>")
				user.set_AI_busy(TRUE) // If the mob doesn't have an AI attached, this won't do anything.
				if(do_after(user,10 SECONDS,src))
					src.locked = 0
					src.welded = 0
					update_icon()
					open(1)
					if(prob(25))
						src.shock(user, 100)
				user.set_AI_busy(FALSE)
			else if(src.density)
				visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
				open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
		return
	..()

/obj/machinery/door/airlock/attack_alien(var/mob/user) //Familiar, right? Doors. -Mechoid
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			if(src.locked || src.welded)
				visible_message("<span class='green'>\The [user] begins digging into \the [src] internals!</span>")
				src.do_animate("deny")
				if(do_after(user,5 SECONDS,src))
					visible_message("<span class='danger'>\The [user] forces \the [src] open, sparks flying from its electronics!</span>")
					src.do_animate("spark")
					playsound(src.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
					src.locked = 0
					src.welded = 0
					update_icon()
					open(1)
					src.emag_act()
			else if(src.density)
				visible_message("<span class='green'>\The [user] begins forcing \the [src] open!</span>")
				if(do_after(user, 5 SECONDS,src))
					playsound(src.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
					visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
					open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			src.do_animate("deny")
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
			return
	..()

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return get_material_by_name(mineral)
	return get_material_by_name(MAT_STEEL)

/obj/machinery/door/airlock/process(delta_time)
	// Deliberate no call to parent.
	if(main_power_lost_until > 0 && world.time >= main_power_lost_until)
		regainMainPower()

	if(backup_power_lost_until > 0 && world.time >= backup_power_lost_until)
		regainBackupPower()

	else if(electrified_until > 0 && world.time >= electrified_until)
		electrify(0)

	if (..() == PROCESS_KILL && !(main_power_lost_until > 0 || backup_power_lost_until > 0 || electrified_until > 0))
		. = PROCESS_KILL

/obj/machinery/door/airlock/uranium/process(delta_time)
	if(world.time > last_event+20)
		if(prob(50))
			radiation_pulse(src, rad_power)
		last_event = world.time
	..()

/obj/machinery/door/airlock/phoron
	name = "Phoron Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/Doorphoron.dmi'
	mineral = "phoron"

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas(/datum/gas/phoron, 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/



/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return
			else /*if(src.justzap)*/
				return
		else if(user.hallucination > 50 && prob(10) && src.operating == 0)
			to_chat(user, "<span class='danger'>You feel a powerful shock course through your body!</span>")
			user.halloss += 10
			user.afflict_stun(5 SECONDS)
			return
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.aiControlDisabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.aiControlDisabled==1) && (!hackProof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if(machine_stat & (NOPOWER|BROKEN))
		return 0
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(wires.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(machine_stat & (NOPOWER|BROKEN))
		return 1
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return 1
	return 0

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return wires.is_cut(WIRE_MAIN_POWER1) || wires.is_cut(WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return wires.is_cut(WIRE_BACKUP_POWER1) || wires.is_cut(WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + SecondsToTicks(10)

	if(main_power_lost_until > 0 || backup_power_lost_until > 0)
		START_MACHINE_PROCESSING(src)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	if(backup_power_lost_until > 0)
		START_MACHINE_PROCESSING(src)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

	update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0

	update_icon()

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(wires.is_cut(WIRE_ELECTRIFY) && arePowerSystemsOn())
		message = "The electrification wire is cut - Door permanently electrified."
		src.electrified_until = -1
	else if(duration && !arePowerSystemsOn())
		message = "The door is unpowered - Cannot electrify the door."
		src.electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		src.electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			shockedby += "\[[time_stamp()]\] - [usr](ckey:[usr.ckey])"
			add_attack_logs(usr,name,"Electrified a door")
		else
			shockedby += "\[[time_stamp()]\] - EMP)"
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		src.electrified_until = duration == -1 ? -1 : world.time + SecondsToTicks(duration)

	if(electrified_until > 0)
		START_MACHINE_PROCESSING(src)

	if(feedback && message)
		to_chat(usr,message)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(wires.is_cut(WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 0
		message = "IdScan feature has been enabled."
	else if(!activate && !src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 1
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr,message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (wires.is_cut(WIRE_SAFETY))
		message = "The safety wire is cut - Cannot enable safeties."
	else if (!activate && src.safe)
		safe = 0
	else if (activate && !src.safe)
		safe = 1

	if(feedback && message)
		to_chat(usr,message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0


/obj/machinery/door/airlock/update_icon(var/doorstate)
	for (var/cardinal in GLOB.cardinal) //No list copy please good sir
		var/turf/step_turf = get_step(src, cardinal)
		for(var/atom/thing as anything in step_turf)
			if(thing.type in airlock_typecache)
				switch(cardinal)
					if(EAST)
						setDir(SOUTH)
					if(WEST)
						setDir(SOUTH)
					if(NORTH)
						setDir(WEST)
					if(SOUTH)
						setDir(WEST)
		if (step_turf.density == TRUE)
			switch(cardinal)
				if(EAST)
					setDir(SOUTH)
				if(WEST)
					setDir(SOUTH)
				if(NORTH)
					setDir(WEST)
				if(SOUTH)
					setDir(WEST)
	switch(doorstate)
		if(AIRLOCK_OPEN)
			icon_state = "open"
		if(AIRLOCK_CLOSED)
			icon_state = "closed"
		if(AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG, AIRLOCK_DENY)
			icon_state = ""

	set_airlock_overlays(state)

	return

/obj/machinery/door/airlock/custom_smooth()
	return //we only custom smooth because we don't need to do anything else.

/obj/machinery/door/airlock/do_animate(animation)
	if(overlays)
		overlays.Cut()

	switch(animation)
		if("opening")
			set_airlock_overlays(AIRLOCK_OPENING)
			flick("opening", src)//[stat ? "_stat":]
			update_icon(AIRLOCK_OPEN)
		if("closing")
			set_airlock_overlays(AIRLOCK_CLOSING)
			flick("closing", src)
			update_icon(AIRLOCK_CLOSED)
		if("deny")
			set_airlock_overlays(AIRLOCK_DENY)
			if(density && arePowerSystemsOn())
				flick("deny", src)
				if(speaker)
					playsound(loc, denied_sound, 50, 0)
			update_icon(AIRLOCK_CLOSED)
		if("emag")
			set_airlock_overlays(AIRLOCK_EMAG)
			if(density && arePowerSystemsOn())
				flick("deny", src)
		else
			update_icon()
	return

/obj/machinery/door/airlock/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/door/airlock/attack_ghost(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/door/airlock/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiAirlock", name)
		ui.open()
	return TRUE

/obj/machinery/door/airlock/ui_data(mob/user)
	var/list/data = list()

	var/list/power = list()
	power["main"] = main_power_lost_until > 0 ? 0 : 2
	power["main_timeleft"] = round(main_power_lost_until > 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until, 1)
	power["backup"] = backup_power_lost_until > 0 ? 0 : 2
	power["backup_timeleft"] = round(backup_power_lost_until > 0 ? max(backup_power_lost_until - world.time, 0) / 10 : backup_power_lost_until, 1)
	data["power"] = power

	data["shock"] = (electrified_until == 0) ? 2 : 0
	data["shock_timeleft"] = round(electrified_until > 0 ? max(electrified_until - world.time, 	0) / 10 : electrified_until, 1)
	data["id_scanner"] = !aiDisabledIdScanner
	data["locked"] = locked // bolted
	data["lights"] = lights // bolt lights
	data["safe"] = safe // safeties
	data["speed"] = normalspeed // safe speed
	data["welded"] = welded // welded
	data["opened"] = !density // opened

	var/list/wire = list()
	wire["main_1"] = !wires.is_cut(WIRE_MAIN_POWER1)
	wire["main_2"] = !wires.is_cut(WIRE_MAIN_POWER2)
	wire["backup_1"] = !wires.is_cut(WIRE_BACKUP_POWER1)
	wire["backup_2"] = !wires.is_cut(WIRE_BACKUP_POWER2)
	wire["shock"] = !wires.is_cut(WIRE_ELECTRIFY)
	wire["id_scanner"] = !wires.is_cut(WIRE_IDSCAN)
	wire["bolts"] = !wires.is_cut(WIRE_DOOR_BOLTS)
	wire["lights"] = !wires.is_cut(WIRE_BOLT_LIGHT)
	wire["safe"] = !wires.is_cut(WIRE_SAFETY)
	wire["timing"] = !wires.is_cut(WIRE_SPEED)

	data["wires"] = wire
	return data

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(src.aiHacking==0)
		src.aiHacking=1
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			src.aiControlDisabled = 2
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			src.aiHacking = 0
			if (user)
				src.attack_ai(user)

/obj/machinery/door/airlock/Bumped(atom/movable/mover, turf/target)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if(world.time > last_spark + 2 SECONDS)
				if (i.matter && (MAT_STEEL in i.matter) && i.matter[MAT_STEEL] > 0)
					var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
					s.set_up(5, 1, src)
					s.start()
					last_spark = world.time
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user, list/params)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			src.attack_alien(user)
			return

	if(src.p_open)
		user.set_machine(src)
		wires.Interact(user)
	else
		..(user)
	return

/obj/machinery/door/airlock/ui_act(action, params)
	if(..())
		return TRUE
	if(!user_allowed(usr))
		return TRUE

	switch(action)
		if("disrupt-main")
			if(!main_power_lost_until)
				loseMainPower()
				update_icon()
			else
				to_chat(usr, SPAN_WARNING("Main power is already offline."))
			. = TRUE
		if("disrupt-backup")
			if(!backup_power_lost_until)
				loseBackupPower()
				update_icon()
			else
				to_chat(usr, SPAN_WARNING("Backup power is already offline."))
			. = TRUE
		if("shock-restore")
			electrify(0, 1)
			. = TRUE
		if("shock-temp")
			electrify(30, 1)
			. = TRUE
		if("shock-perm")
			electrify(-1, 1)
			. = TRUE
		if("idscan-toggle")
			set_idscan(aiDisabledIdScanner, 1)
			. = TRUE
		// if("emergency-toggle")
		// 	toggle_emergency(usr)
		// 	. = TRUE
		if("bolt-toggle")
			toggle_bolt(usr)
			. = TRUE
		if("light-toggle")
			if(wires.is_cut(WIRE_BOLT_LIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
				return
			lights = !lights
			update_icon()
			. = TRUE
		if("safe-toggle")
			set_safeties(!safe, 1)
			. = TRUE
		if("speed-toggle")
			if(wires.is_cut(WIRE_SPEED))
				to_chat(usr, "The timing wire is cut - Cannot alter timing.")
				return
			normalspeed = !normalspeed
			. = TRUE
		if("open-close")
			user_toggle_open(usr)
			. = TRUE

	update_icon()
	return TRUE

/obj/machinery/door/airlock/proc/user_allowed(mob/user)
	var/allowed = (issilicon(user) && canAIControl(user))
	if(!allowed && isobserver(user))
		var/mob/observer/dead/D = user
		if(D.can_admin_interact())
			allowed = TRUE
	return allowed

/obj/machinery/door/airlock/proc/toggle_bolt(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_DOOR_BOLTS))
		to_chat(user, SPAN_WARNING("The door bolt drop wire is cut - you can't toggle the door bolts."))
		return
	if(locked)
		if(!arePowerSystemsOn())
			to_chat(user, SPAN_WARNING("The door has no power - you can't raise the door bolts."))
		else
			unlock()
			to_chat(user, SPAN_NOTICE("The door bolts have been raised."))
			// log_combat(user, src, "unbolted")
	else
		lock()
		to_chat(user, SPAN_WARNING("The door bolts have been dropped."))
		// log_combat(user, src, "bolted")

/obj/machinery/door/airlock/proc/user_toggle_open(mob/user)
	if(!user_allowed(user))
		return
	if(welded)
		to_chat(user, SPAN_WARNING("The airlock has been welded shut!"))
	else if(locked)
		to_chat(user, SPAN_WARNING("The door bolts are down!"))
	else if(!density)
		close()
	else
		open()

/obj/machinery/door/airlock/proc/can_remove_electronics()
	return src.p_open && (operating < 0 || (!operating && welded && !src.arePowerSystemsOn() && density && (!src.locked || (machine_stat & BROKEN))))

/obj/machinery/door/airlock/attackby(obj/item/C, mob/user as mob)
	//TO_WORLD("airlock attackby src [src] obj [C] mob [user]")
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	if(istype(C, /obj/item/barrier_tape_roll))
		return

	if (attempt_vr(src,"attackby_vr",list(C, user))) return
	if(istype(C, /mob/living))
		..()
		return
	if(!repairing && istype(C, /obj/item/weldingtool) && !( src.operating > 0 ) && src.density)
		var/obj/item/weldingtool/W = C
		if(W.remove_fuel(0,user))
			if(!src.welded)
				src.welded = 1
			else
				src.welded = null
			playsound(src.loc, C.tool_sound, 75, 1)
			src.update_icon()
			return
		else
			return
	else if(C.is_screwdriver())
		if (src.p_open)
			if (machine_stat & BROKEN)
				to_chat(usr, "<span class='warning'>The panel is broken and cannot be closed.</span>")
			else
				src.p_open = 0
				playsound(src, C.tool_sound, 50, 1)
		else
			src.p_open = 1
			playsound(src, C.tool_sound, 50, 1)
		src.update_icon()
	else if(C.is_wirecutter())
		return src.attack_hand(user)
	else if(istype(C, /obj/item/multitool))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
	else if(!repairing && C.is_crowbar())
		if(can_remove_electronics())
			playsound(src, C.tool_sound, 75, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user,40 * C.tool_speed))
				to_chat(user, "<span class='notice'>You removed the airlock electronics!</span>")

				var/obj/structure/door_assembly/da = new assembly_type(src.loc)
				if (istype(da, /obj/structure/door_assembly/multi_tile))
					da.setDir(src.dir)

				da.anchored = 1
				if(mineral)
					da.glass = mineral
				//else if(glass)
				else if(glass && !da.glass)
					da.glass = 1
				da.state = 1
				da.created_name = src.name
				da.update_state()

				if(operating == -1 || (machine_stat & BROKEN))
					new /obj/item/circuitboard/broken(src.loc)
					operating = 0
				else
					if (!electronics) create_electronics()

					electronics.loc = src.loc
					electronics = null

				qdel(src)
				return
		else if(arePowerSystemsOn())
			to_chat(user, "<span class='notice'>The airlock's motors resist your efforts to force it.</span>")
		else if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else
			if(density)
				spawn(0)	open(1)
			else
				spawn(0)	close(1)

	// Check if we're using a crowbar or armblade, and if the airlock's unpowered for whatever reason (off, broken, etc).
	else if(istype(C, /obj/item))
		var/obj/item/W = C
		if((W.pry == 1) && !arePowerSystemsOn())
			if(locked)
				to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
			else if( !welded && !operating )
				if(istype(C, /obj/item/material/twohanded/fireaxe)) // If this is a fireaxe, make sure it's held in two hands.
					var/obj/item/material/twohanded/fireaxe/F = C
					if(!F.wielded)
						to_chat(user, "<span class='warning'>You need to be wielding \the [F] to do that.</span>")
						return
				// At this point, it's an armblade or a fireaxe that passed the wielded test, let's try to open it.
				if(density)
					spawn(0)
						open(1)
				else
					spawn(0)
						close(1)
		else
			..()
	else
		..()
	return

/obj/machinery/door/airlock/phoron/attackby(C as obj, mob/user as mob)
	if(C)
		ignite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken()
	src.p_open = 1
	machine_stat |= BROKEN
	if (secured_wires)
		lock()
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name]'s control panel bursts open, sparks spewing out!")

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()

	update_icon()
	return

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))
		return 0
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	if(arePowerSystemsOn())
		playsound(src.loc, open_sound_powered, 50, 1)
	else
		playsound(src.loc, open_sound_unpowered, 75, 1)

	if(src.closeOther != null && istype(src.closeOther, /obj/machinery/door/airlock/) && !src.closeOther.density)
		src.closeOther.close()
	return ..()

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return FALSE

	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(!has_beeped)
						playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
						has_beeped = 1
					close_door_at = world.time + 6
					return

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(DOOR_CRUSH_DAMAGE))
				take_damage(DOOR_CRUSH_DAMAGE)

	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	has_beeped = 0
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound_powered, 50, 1)
	else
		playsound(src.loc, open_sound_unpowered, 75, 1)
	for(var/turf/turf in locs)
		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(killthis)
			LEGACY_EX_ACT(killthis, 2, null)//Smashin windows
	return ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(!forced)
		if(!arePowerSystemsOn() || wires.is_cut(WIRE_OPEN_DOOR))
			return 0

	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return 0

	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || wires.is_cut(WIRE_OPEN_DOOR))
			return	0

	return ..()

/obj/machinery/door/airlock/toggle_open(forced)
	. = ..()


/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return 0

/obj/machinery/mech_sensor/blocks_airlock()
	return 0

/mob/living/blocks_airlock()
	return 1

/atom/movable/proc/airlock_crush(var/crush_damage)
	return 0

/obj/machinery/portable_atmospherics/canister/airlock_crush(var/crush_damage)
	. = ..()
	health -= crush_damage
	healthcheck()

/obj/effect/energy_field/airlock_crush(var/crush_damage)
	adjust_strength(crush_damage)

/obj/structure/closet/airlock_crush(var/crush_damage)
	..()
	damage(crush_damage)
	for(var/atom/movable/AM in src)
		AM.airlock_crush()
	return 1

/mob/living/airlock_crush(var/crush_damage)
	. = ..()
	adjustBruteLoss(crush_damage)
	set_stunned(20 * 5)
	set_paralyzed(20 * 5)
	var/turf/T = get_turf(src)
	T.add_blood(src)

/mob/living/carbon/airlock_crush(var/crush_damage)
	. = ..()
	if(can_feel_pain())
		emote("scream")

/mob/living/silicon/robot/airlock_crush(var/crush_damage)
	adjustBruteLoss(crush_damage)
	return 0

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return 0

	if (operating && !forced) return 0

	src.locked = 1
	playsound(src, bolt_down_sound, 30, 0, 3)
	for(var/mob/M in range(1,src))
		M.show_message("You hear a click from the bottom of the door.", 2)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!src.locked)
		return

	if (!forced)
		if(operating || !src.arePowerSystemsOn() || wires.is_cut(WIRE_DOOR_BOLTS)) return

	src.locked = 0
	playsound(src, bolt_up_sound, 30, 0, 3)
	for(var/mob/M in range(1,src))
		M.show_message("You hear a click from the bottom of the door.", 2)
	update_icon()
	return 1

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	return ..(M)

// Airlock is passable if it is open (!density), bot has access, and is not bolted shut or powered off)
/obj/machinery/door/airlock/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	return ..() || (check_access(ID) && !locked && inoperable())

/obj/machinery/door/airlock/Initialize(mapload, obj/structure/door_assembly/assembly)
	//if assembly is given, create the new door from the assembly
	if (assembly && istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.loc = src

		//update the door's access to match the electronics'
		secured_wires = electronics.secure
		req_one_access = electronics.conf_req_one_access?.Copy()
		req_access = electronics.conf_req_access?.Copy()

		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		setDir(assembly.dir)

	//wires
	var/turf/T = get_turf(loc)
	if(T && (T.z in (LEGACY_MAP_DATUM).admin_levels))
		secured_wires = 1
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

	if(src.closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in GLOB.machines)
			if(A.closeOtherId == src.closeOtherId && A != src)
				src.closeOther = A
				break
	name = "\improper [name]"
	update_icon(AIRLOCK_CLOSED)
	. = ..()

/obj/machinery/door/airlock/Destroy()
	qdel(wires)
	wires = null
	return ..()

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/airlock_electronics/secure( src.loc )
	else
		src.electronics = new/obj/item/airlock_electronics( src.loc )

	//update the electronics to match the door's access
	if(!src.req_access)
		src.check_access()
	electronics.conf_req_access = req_access.Copy()
	electronics.conf_req_one_access = req_one_access.Copy()

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(40/severity))
		var/duration = world.time + SecondsToTicks(30 / severity)
		if(duration > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	..()
	if(machine_stat & NOPOWER)
		// If we lost power, disable electrification
		// Keeping door lights on, runs on internal battery or something.
		electrified_until = 0
	update_icon()

/obj/machinery/door/airlock/proc/prison_open()
	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return


/obj/machinery/door/airlock/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			// Old RCD code made it cost 10 units to decon an airlock.
			// Now the new one costs ten "sheets".
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 10
			)
	return FALSE

/obj/machinery/door/airlock/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
	return FALSE

/obj/machinery/door/airlock/glass_external/public
	req_one_access = list()
