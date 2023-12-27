/mob/living/silicon/robot/Life(seconds, times_fired)
	if((. = ..()))
		return

	//Status updates, death etc.
	clamp_values()
	handle_regular_UI_updates()

/mob/living/silicon/robot/PhysicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(client)
		update_items()
	if (src.stat != DEAD) //still using power
		use_power()
		process_killswitch()
		process_locks()
		process_queued_alarms()

/mob/living/silicon/robot/proc/clamp_values()
	var/datum/status_effect/effect
	effect = is_unconscious()
	if(effect?.time_left() > 20 SECONDS)
		effect.set_duration_from_now(20 SECONDS)

	set_sleeping(0)
	adjustBruteLoss(0)
	adjustToxLoss(0)
	adjustOxyLoss(0)
	adjustFireLoss(0)

/mob/living/silicon/robot/proc/use_power()
	// Debug only
	// to_chat(world, "DEBUG: life.dm line 35: cyborg use_power() called at tick [controller_iteration]")
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if ( cell && is_component_functioning("power cell") && src.cell.charge > 0 )
		if(src.module_state_1)
			cell_use_power(50) // 50W load for every enabled tool TODO: tool-specific loads
		if(src.module_state_2)
			cell_use_power(50)
		if(src.module_state_3)
			cell_use_power(50)

		if(lights_on)
			cell_use_power(30) 	// 30W light. Normal lights would use ~15W, but increased for balance reasons.

		src.has_power = 1
	else
		if (src.has_power)
			to_chat(src, "<font color='red'>You are now running on emergency backup power.</font>")
		src.has_power = 0
		if(lights_on) // Light is on but there is no power!
			lights_on = 0
			set_light(0)

/mob/living/silicon/robot/handle_regular_UI_updates()

	if(src.camera && !scrambledcodes)
		if(IS_DEAD(src) || wires.is_cut(WIRE_BORG_CAMERA))
			src.camera.set_status(0)
		else
			src.camera.set_status(1)

	update_health()
	update_stat()

	if(health < config_legacy.health_threshold_dead && src.stat != 2) //die only once
		death()

	AdjustConfused(-1)

	blinded = !!IS_DEAD(src)


	if (src.stuttering) src.stuttering--

	if (src.eye_blind || HAS_TRAIT(src, TRAIT_BLIND))
		src.AdjustBlinded(-1)
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf--
	if (src.ear_damage < 25)
		src.ear_damage -= 0.05
		src.ear_damage = max(src.ear_damage, 0)

	src.density = !( src.lying )

	if (src.sdisabilities & SDISABILITY_NERVOUS)
		src.blinded = 1
	if (src.sdisabilities & SDISABILITY_DEAF)
		src.ear_deaf = 1

	if (src.eye_blurry > 0)
		src.eye_blurry--
		src.eye_blurry = max(0, src.eye_blurry)

	if (src.druggy > 0)
		src.druggy--
		src.druggy = max(0, src.druggy)

	//update the state of modules and components here
	if (src.stat != 0)
		uneq_all()

	if(radio)
		if(!is_component_functioning("radio"))
			radio.on = 0
		else
			radio.on = 1

	if(is_component_functioning("camera"))
		src.blinded = 0
	else
		src.blinded = 1

	return 1

/mob/living/silicon/robot/handle_regular_hud_updates()
	. = ..()
	var/fullbright = FALSE

	if(stat == 2)
		AddSightSelf(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		RemoveSightSelf(SEE_BLACKNESS)
		SetSeeInvisibleSelf(SEE_INVISIBLE_LEVEL_TWO)
	if((MUTATION_XRAY in src.mutations) || (sight_mode & BORGXRAY))
		AddSightSelf(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		RemoveSightSelf(SEE_BLACKNESS)
		fullbright = TRUE
	if(sight_mode & BORGMESON)
		AddSightSelf(SEE_TURFS)
		RemoveSightSelf(SEE_BLACKNESS)
		fullbright = TRUE
	if(sight_mode & BORGMATERIAL)
		AddSightSelf(SEE_OBJS)
		RemoveSightSelf(SEE_BLACKNESS)
		fullbright = TRUE
	if(sight_mode & BORGTHERM)
		AddSightSelf(SEE_MOBS)
		RemoveSightSelf(SEE_BLACKNESS)
		fullbright = TRUE

	if(fullbright)
		// todo: legacy, remove
		self_perspective.legacy_force_set_hard_darkvision(0)
	else
		self_perspective.legacy_force_set_hard_darkvision(null)

	if (src.healths)
		if (src.stat != 2)
			if(istype(src,/mob/living/silicon/robot/drone))
				switch(health)
					if(35 to INFINITY)
						src.healths.icon_state = "health0"
					if(25 to 34)
						src.healths.icon_state = "health1"
					if(15 to 24)
						src.healths.icon_state = "health2"
					if(5 to 14)
						src.healths.icon_state = "health3"
					if(0 to 4)
						src.healths.icon_state = "health4"
					if(-35 to 0)
						src.healths.icon_state = "health5"
					else
						src.healths.icon_state = "health6"
			else
				switch(health)
					if(200 to INFINITY)
						src.healths.icon_state = "health0"
					if(150 to 200)
						src.healths.icon_state = "health1"
					if(100 to 150)
						src.healths.icon_state = "health2"
					if(50 to 100)
						src.healths.icon_state = "health3"
					if(0 to 50)
						src.healths.icon_state = "health4"
					else
						if(config_legacy.health_threshold_dead && config_legacy.health_threshold_dead >= health)
							healths.icon_state = "health5"
						else
							healths.icon_state = "health6"
		else
			src.healths.icon_state = "health7"

	if (src.syndicate) // WTF WHYYYY PAIN
		src.disconnect_from_ai()

	if (src.cells)
		if (src.cell)
			var/cellcharge = src.cell.charge/src.cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					src.cells.icon_state = "charge4"
				if(0.5 to 0.75)
					src.cells.icon_state = "charge3"
				if(0.25 to 0.5)
					src.cells.icon_state = "charge2"
				if(0 to 0.25)
					src.cells.icon_state = "charge1"
				else
					src.cells.icon_state = "charge0"
		else
			src.cells.icon_state = "charge-empty"


//Oxygen and fire does nothing yet!!
//	if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
//	if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"

	if(stat != 2)
		if(blinded)
			overlay_fullscreen("blind", /atom/movable/screen/fullscreen/scaled/blind)
		else
			clear_fullscreen("blind")
		if(disabilities & DISABILITY_NEARSIGHTED)
			overlay_fullscreen("impaired", /atom/movable/screen/fullscreen/scaled/impaired, 1)
		else
			clear_fullscreen("impaired")
		if(eye_blurry)
			overlay_fullscreen("blurry", /atom/movable/screen/fullscreen/tiled/blurry)
		else
			clear_fullscreen("blurry")
		if(druggy)
			overlay_fullscreen("high", /atom/movable/screen/fullscreen/tiled/high)
		else
			clear_fullscreen("high")

	if(IsRemoteViewing())
		if(!machine || machine.check_eye(src) < 0)
			reset_perspective()
	return 1

/mob/living/silicon/robot/proc/update_items()
	if (src.client)
		src.client.screen -= src.contents
		for(var/obj/I in src.contents)
			if(I && !(istype(I,/obj/item/cell) || istype(I,/obj/item/radio)  || istype(I,/obj/machinery/camera) || istype(I,/obj/item/mmi)))
				src.client.screen += I
	if(src.module_state_1)
		src.module_state_1:screen_loc = ui_inv1
	if(src.module_state_2)
		src.module_state_2:screen_loc = ui_inv2
	if(src.module_state_3)
		src.module_state_3:screen_loc = ui_inv3
	updateicon()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(src.client)
				to_chat(src, "<span class='danger'>Killswitch Activated</span>")
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(src.client)
				to_chat(src, "<span class='danger'>Weapon Lock Timed Out!</span>")
			weapon_lock = 0
			weaponlock_time = 120

// todo: better way
/mob/living/silicon/robot/update_mobility()
	. = ..()
	if(!is_component_functioning("actuator"))
		mobility_flags &= ~MOBILITY_CAN_MOVE
	if(lockdown)
		mobility_flags &= ~(MOBILITY_FLAGS_ANY_INTERACTION | MOBILITY_CAN_MOVE | MOBILITY_CAN_PULL | MOBILITY_CAN_RESIST)
	return mobility_flags

/mob/living/silicon/robot/update_fire()
	cut_overlay(image("icon"='icons/mob/OnFire.dmi', "icon_state" = get_fire_icon_state()))
	if(on_fire)
		add_overlay(image("icon"='icons/mob/OnFire.dmi', "icon_state" = get_fire_icon_state()))

/mob/living/silicon/robot/fire_act()
	if(!on_fire) //Silicons don't gain stacks from hotspots, but hotspots can ignite them
		IgniteMob()
