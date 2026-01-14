
// todo: /ore_box & /ore_box/with_scoop
/obj/item/vehicle_module/lazy/legacy/tool/orescoop
	w_class = WEIGHT_CLASS_BULKY
	name = "Mounted ore box"
	desc = "A mounted ore scoop and hopper, for gathering ores."
	icon_state = "microscoop"
	equip_cooldown = 5
	energy_drain = 0
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

	var/orecapacity = 50

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/on_attack_self(datum/event_args/actor/e_args)
	if(length(contents))
		dump()
		e_args.chat_feedback(
			SPAN_NOTICE("You dump out the contents of [src]."),
			target = src,
		)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/proc/dump(atom/where = drop_location())
	. = 0
	for(var/obj/item/stack/ore/ore in contents)
		. += ore.amount
		ore.forceMove(where)

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/render_ui()
	..()
	l_ui_html("Stored", "~[length(contents)] stacks")
	l_ui_button("dump", "Dump", "Empty Box Contents", confirm = TRUE)

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/on_l_ui_button(datum/event_args/actor/actor, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("dump")
			var/amt_dumped = dump(vehicle?.drop_location())
			vehicle_log_for_admins(actor, "ore-dump", list("amount" = amt_dumped))

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/action(atom/target)
	if(!action_checks(target))
		return
	// TODO: logging
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='info'>[chassis] sweeps around with its ore scoop.</span>")
	occupant_message("<span class='info'>You sweep around the area with the scoop.</span>")
	var/T = chassis.loc
	//var/C = target.loc	//why are these backwards? we may never know -Pete
	if(vehicle_do_after(null, 1 SECONDS, target))
		for(var/obj/item/stack/ore/ore in range(chassis,1))
			if(get_dir(chassis,ore)&chassis.dir)
				if (contents.len >= orecapacity)
					occupant_message("<span class='warning'>The ore compartment is full.</span>")
					return 1
				else
					ore.forceMove(src)
	return 1
