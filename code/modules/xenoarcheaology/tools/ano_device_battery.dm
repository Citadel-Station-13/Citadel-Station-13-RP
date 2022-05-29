/obj/item/anobattery
	name = "Anomaly power battery"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anobattery0"
	var/datum/artifact_effect/battery_effect
	var/capacity = 300
	var/stored_charge = 0
	var/effect_id = ""

/obj/item/anobattery/Initialize(mapload)
	. = ..()
	battery_effect = new

/obj/item/anobattery/proc/UpdateSprite()
	var/p = (stored_charge/capacity)*100
	p = min(p, 100)
	icon_state = "anobattery[round(p,25)]"

/obj/item/anobattery/proc/use_power(var/amount)
	stored_charge = max(0, stored_charge - amount)

/obj/item/anodevice
	name = "Anomaly power utilizer"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anodev"
	var/activated = 0
	var/duration = 0
	var/interval = 0
	var/time_end = 0
	var/last_activation = 0
	var/last_process = 0
	var/obj/item/anobattery/inserted_battery
	var/turf/archived_loc
	var/energy_consumed_on_touch = 100

/obj/item/anodevice/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/anodevice/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/anobattery))
		if(!inserted_battery)
			to_chat(user, "<font color=#4F49AF>You insert the battery.</font>")
			user.drop_item()
			I.loc = src
			inserted_battery = I
			UpdateSprite()
	else
		return ..()

/obj/item/anodevice/attack_self(var/mob/user as mob)
	return ui_interact(user)

/obj/item/anodevice/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/anodevice/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchHandheldPowerUtilizer", name)
		ui.open()

/obj/item/anodevice/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["inserted_battery"] = inserted_battery
	data["anomaly"] = null
	data["charge"] = null
	data["capacity"] = null
	data["timeleft"] = null
	data["activated"] = null
	data["duration"] = null
	data["interval"] = null
	if(inserted_battery)
		data["anomaly"] = inserted_battery?.battery_effect?.artifact_id
		data["charge"] = inserted_battery.stored_charge
		data["capacity"] = inserted_battery.capacity
		data["timeleft"] = round(max((time_end - last_process) / 10, 0))
		data["activated"] = activated
		data["duration"] = duration / 10
		data["interval"] = interval / 10

	return data

/obj/item/anodevice/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("changeduration")
			duration = clamp(text2num(params["duration"]), 0, 300)
			if(activated)
				time_end = world.time + duration
			return TRUE
		if("changeinterval")
			interval = clamp(text2num(params["interval"]), 0, 100)
			return TRUE
		if("startup")
			if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0))
				activated = TRUE
				visible_message(SPAN_BLUE("[icon2html(src, world)] [src] whirrs."), SPAN_BLUE("[icon2html(src, world)]You hear something whirr."))
				if(!inserted_battery.battery_effect.activated)
					inserted_battery.battery_effect.ToggleActivate(1)
				time_end = world.time + duration
				last_process = world.time
			else
				to_chat(usr, SPAN_WARNING("[src] is unable to start due to no anomolous power source inserted/remaining."))
			return TRUE
		if("shutdown")
			activated = FALSE
			return TRUE
		if("ejectbattery")
			if(inserted_battery)
				inserted_battery.forceMove(get_turf(src))
				inserted_battery = null
				UpdateSprite()
			shutdown_emission()
			return TRUE

/obj/item/anodevice/process(delta_time)
	if(activated)
		if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0) )
			//make sure the effect is active
			if(!inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate(1)

			//update the effect loc
			var/turf/T = get_turf(src)
			if(T != archived_loc)
				archived_loc = T
				inserted_battery.battery_effect.UpdateMove()

			//if someone is holding the device, do the effect on them
			var/mob/holder
			if(ismob(loc))
				holder = loc

			//handle charge
			if(world.time - last_activation > interval)
				if(inserted_battery.battery_effect.effect == EFFECT_TOUCH)
					if(interval > 0)
						//apply the touch effect to the holder
						if(holder)
							to_chat(holder, "the [icon2html(thing = src, target = holder)] [src] held by [holder] shudders in your grasp.")
						else
							loc.visible_message("the [icon2html(thing = src, target = world)] [src] shudders.")
						inserted_battery.battery_effect.DoEffectTouch(holder)

						//consume power
						inserted_battery.use_power(energy_consumed_on_touch)
					else
						//consume power equal to time passed
						inserted_battery.use_power(world.time - last_process)

				else if(inserted_battery.battery_effect.effect == EFFECT_PULSE)
					inserted_battery.battery_effect.chargelevel = inserted_battery.battery_effect.chargelevelmax

					//consume power relative to the time the artifact takes to charge and the effect range
					inserted_battery.use_power(inserted_battery.battery_effect.effectrange * inserted_battery.battery_effect.effectrange * inserted_battery.battery_effect.chargelevelmax)

				else
					//consume power equal to time passed
					inserted_battery.use_power(world.time - last_process)

				last_activation = world.time

			//process the effect
			inserted_battery.battery_effect.process()

			//work out if we need to shutdown
			if(inserted_battery.stored_charge <= 0)
				loc.visible_message("<font color=#4F49AF>[icon2html(thing = src, target = world)] [src] buzzes.</font>", "<font color=#4F49AF>[icon2html(thing = src, target = world)] You hear something buzz.</font>")
				shutdown_emission()
			else if(world.time > time_end)
				loc.visible_message("<font color=#4F49AF>[icon2html(thing = src, target = world)] [src] chimes.</font>", "<font color=#4F49AF>[icon2html(thing = src, target = world)] You hear something chime.</font>")
				shutdown_emission()
		else
			visible_message("<font color=#4F49AF>[icon2html(thing = src, target = world)] [src] buzzes.</font>", "<font color=#4F49AF>[icon2html(thing = src, target = world)] You hear something buzz.</font>")
			shutdown_emission()
		last_process = world.time

/obj/item/anodevice/proc/shutdown_emission()
	if(activated)
		activated = FALSE
		if(inserted_battery?.battery_effect?.activated)
			inserted_battery.battery_effect.ToggleActivate(1)

/obj/item/anodevice/proc/UpdateSprite()
	if(!inserted_battery)
		icon_state = "anodev"
		return
	var/p = (inserted_battery.stored_charge/inserted_battery.capacity)*100
	p = min(p, 100)
	icon_state = "anodev[round(p,25)]"

/obj/item/anodevice/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/anodevice/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if (!istype(M))
		return

	if(activated && inserted_battery?.battery_effect?.effect == EFFECT_TOUCH && !isnull(inserted_battery))
		inserted_battery?.battery_effect?.DoEffectTouch(M)
		inserted_battery.use_power(energy_consumed_on_touch)
		user.visible_message("<font color=#4F49AF>[user] taps [M] with [src], and it shudders on contact.</font>")
	else
		user.visible_message("<font color=#4F49AF>[user] taps [M] with [src], but nothing happens.</font>")

	//admin logging
	user.lastattacked = M
	M.lastattacker = user

	if(inserted_battery?.battery_effect)
		add_attack_logs(user,M,"Anobattery tap ([inserted_battery?.battery_effect?.name])")
