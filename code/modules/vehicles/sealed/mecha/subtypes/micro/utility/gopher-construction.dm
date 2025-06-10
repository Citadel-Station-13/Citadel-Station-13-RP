/obj/item/vehicle_chassis/micro/gopher
	name = "Gopher Chassis"
	icon_state = "gopher-chassis"

/obj/item/vehicle_chassis/micro/gopher/New()
	..()
	construct = new /datum/construction/mecha/gopher_chassis(src)

/obj/item/vehicle_part/micro/gopher_torso
	name="Gopher Torso"
	desc="A torso part of Gopher. Contains power unit, processing core and life support systems."
	icon_state = "gopher-torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/micro/gopher_left_arm
	name="Gopher Left Arm"
	desc="A Gopher left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "gopher-arm-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/micro/gopher_right_arm
	name="Gopher Right Arm"
	desc="A Gopher right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "gopher-arm-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/micro/gopher_left_leg
	name="Gopher Left Leg"
	desc="A Gopher left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "gopher-leg-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/micro/gopher_right_leg
	name="Gopher Right Leg"
	desc="A Gopher right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "gopher-leg-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/datum/construction/mecha/gopher_chassis
	steps = list(
		list("key"=/obj/item/vehicle_part/micro/gopher_torso),//1
		list("key"=/obj/item/vehicle_part/micro/gopher_left_arm),//2
		list("key"=/obj/item/vehicle_part/micro/gopher_right_arm),//3
		list("key"=/obj/item/vehicle_part/micro/gopher_left_leg),//4
		list("key"=/obj/item/vehicle_part/micro/gopher_right_leg),//5
	)

/datum/construction/mecha/gopher_chassis/custom_action(step, atom/used_atom, mob/user)
	user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
	holder.add_overlay("[used_atom.icon_state]+o")
	qdel(used_atom)
	return 1

/datum/construction/mecha/gopher_chassis/action(atom/used_atom,mob/user)
	return check_all_steps(used_atom,user)

/datum/construction/mecha/gopher_chassis/spawn_result()
	var/obj/item/vehicle_chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/gopher(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction_vr.dmi'
	const_holder.icon_state = "gopher0"
	const_holder.density = TRUE
	const_holder.cut_overlays()
	spawn()
		qdel(src)

/datum/construction/reversible/mecha/gopher
	result = "/obj/vehicle/sealed/mecha/micro/utility/gopher"
	steps = list(
		//1
		list("key"=/obj/item/weldingtool,
			"backkey"=IS_WRENCH,
			"desc"="External armor is wrenched."),
		//2
		list("key"=IS_WRENCH,
			"backkey"=IS_CROWBAR,
			"desc"="External armor is installed."),
		//3
		list("key"=/obj/item/stack/material/plasteel,
			"backkey"=/obj/item/weldingtool,
			"desc"="Internal armor is welded."),
		//4
		list("key"=/obj/item/weldingtool,
			"backkey"=IS_WRENCH,
			"desc"="Internal armor is wrenched"),
		//5
		list("key"=IS_WRENCH,
			"backkey"=IS_CROWBAR,
			"desc"="Internal armor is installed"),
		//6
		list("key"=/obj/item/stack/material/steel,
			"backkey"=IS_SCREWDRIVER,
			"desc"="Peripherals control module is secured"),
		//7
		list("key"=IS_SCREWDRIVER,
			"backkey"=IS_CROWBAR,
			"desc"="Peripherals control module is installed"),
		//8
		list("key"=/obj/item/circuitboard/mecha/gopher/peripherals,
			"backkey"=IS_SCREWDRIVER,
			"desc"="Central control module is secured"),
		//9
		list("key"=IS_SCREWDRIVER,
			"backkey"=IS_CROWBAR,
			"desc"="Central control module is installed"),
		//10
		list("key"=/obj/item/circuitboard/mecha/gopher/main,
			"backkey"=IS_SCREWDRIVER,
			"desc"="The wiring is adjusted"),
		//11
		list("key"=IS_WIRECUTTER,
			"backkey"=IS_SCREWDRIVER,
			"desc"="The wiring is added"),
		//12
		list("key"=/obj/item/stack/cable_coil,
			"backkey"=IS_SCREWDRIVER,
			"desc"="The hydraulic systems are active."),
		//13
		list("key"=IS_SCREWDRIVER,
			"backkey"=IS_WRENCH,
			"desc"="The hydraulic systems are connected."),
		//14
		list("key"=IS_WRENCH,
			"desc"="The hydraulic systems are disconnected."),
	)

/datum/construction/reversible/mecha/gopher/action(atom/used_atom,mob/user)
	return check_step(used_atom,user)

/datum/construction/reversible/mecha/gopher/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "gopher1"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "gopher2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "gopher0"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "gopher3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "gopher1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "gopher4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "gopher2"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(used_atom)
				holder.icon_state = "gopher5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "gopher3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "gopher6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/circuitboard/mecha/gopher/main(get_turf(holder))
				holder.icon_state = "gopher4"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(used_atom)
				holder.icon_state = "gopher7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "gopher5"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "gopher8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/circuitboard/mecha/gopher/peripherals(get_turf(holder))
				holder.icon_state = "gopher6"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "gopher9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "gopher7"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "gopher10"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 3
				holder.icon_state = "gopher8"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "gopher11"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "gopher9"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
				holder.icon_state = "gopher12"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "gopher10"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "gopher13"
			else
				user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 2
				holder.icon_state = "gopher11"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "gopher12"
	return 1

/datum/construction/reversible/mecha/gopher/spawn_result()
	..()
	feedback_inc("mecha_gopher_created",1)
	return
