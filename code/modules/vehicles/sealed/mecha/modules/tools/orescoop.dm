
/obj/item/vehicle_module/lazy/legacy/tool/orescoop/micro
	w_class = WEIGHT_CLASS_BULKY
	name = "Mounted ore box"
	desc = "A mounted ore scoop and hopper, for gathering ores."
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "microscoop"
	equip_cooldown = 5
	energy_drain = 0
	module_class = VEHICLE_MODULE_CLASS_MICRO
	var/orecapacity = 500

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/micro/action(atom/target)
	if(!action_checks(target))
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='info'>[chassis] sweeps around with its ore scoop.</span>")
	occupant_message("<span class='info'>You sweep around the area with the scoop.</span>")
	var/T = chassis.loc
	//var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			for(var/obj/item/stack/ore/ore in range(chassis,1))
				if(get_dir(chassis,ore)&chassis.dir)
					if (contents.len >= orecapacity)
						occupant_message("<span class='warning'>The ore compartment is full.</span>")
						return 1
					else
						ore.forceMove(src)
	return 1

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/micro/Topic(href,href_list)
	..()
	if (href_list["empty_box"])
		if(contents.len < 1)
			occupant_message("The ore compartment is empty.")
			return
		for (var/obj/item/stack/ore/O in contents)
			contents -= O
			O.loc = chassis.loc
		occupant_message("Ore compartment emptied.")

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/micro/get_equip_info()
	return "[..()] <br /><a href='?src=\ref[src];empty_box=1'>Empty ore compartment</a>"

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/verb/empty_box() //so you can still get the ore out if someone detaches it from the mech
	set name = "Empty Ore compartment"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human)) //Only living, intelligent creatures with hands can empty ore boxes.
		to_chat(usr, "<span class='warning'>You are physically incapable of emptying the ore box.</span>")
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr, "You cannot reach the ore box.")
		return

	add_fingerprint(usr)

	if(contents.len < 1)
		to_chat(usr, "<span class='warning'>The ore box is empty</span>")
		return

	for (var/obj/item/stack/ore/O in contents)
		contents -= O
		O.loc = src.loc
	to_chat(usr, "<span class='info'>You empty the ore box</span>")
