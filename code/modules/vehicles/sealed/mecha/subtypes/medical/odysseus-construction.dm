/obj/item/vehicle_chassis/odysseus
	name = "Odysseus Chassis"

/obj/item/vehicle_chassis/odysseus/New()
	..()
	construct = new /datum/construction/mecha/odysseus_chassis(src)

/obj/item/vehicle_part/odysseus_head
	name="Odysseus Head"
	icon_state = "odysseus_head"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 2)

/obj/item/vehicle_part/odysseus_torso
	name="Odysseus Torso"
	desc="A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/odysseus_left_arm
	name="Odysseus Left Arm"
	desc="An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/odysseus_right_arm
	name="Odysseus Right Arm"
	desc="An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/odysseus_left_leg
	name="Odysseus Left Leg"
	desc="An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/odysseus_right_leg
	name="Odysseus Right Leg"
	desc="A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/datum/construction/mecha/odysseus_chassis
	steps = list(list("key"=/obj/item/vehicle_part/odysseus_torso),//1
					 list("key"=/obj/item/vehicle_part/odysseus_head),//2
					 list("key"=/obj/item/vehicle_part/odysseus_left_arm),//3
					 list("key"=/obj/item/vehicle_part/odysseus_right_arm),//4
					 list("key"=/obj/item/vehicle_part/odysseus_left_leg),//5
					 list("key"=/obj/item/vehicle_part/odysseus_right_leg)//6
					)

/datum/construction/mecha/odysseus_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/odysseus_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/odysseus_chassis/spawn_result()
	var/obj/item/vehicle_chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/odysseus(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "odysseus0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/odysseus
	result = "/obj/vehicle/sealed/mecha/medical/odysseus"
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
					 list("key"=/obj/item/circuitboard/mecha/odysseus/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/circuitboard/mecha/odysseus/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=/obj/item/tool/wirecutters,
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
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/odysseus/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/odysseus/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "odysseus1"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "odysseus2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "odysseus0"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "odysseus3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "odysseus1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "odysseus4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "odysseus2"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "odysseus5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "odysseus3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "odysseus6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/circuitboard/mecha/odysseus/main(get_turf(holder))
				holder.icon_state = "odysseus4"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "odysseus7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "odysseus5"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "odysseus8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/circuitboard/mecha/odysseus/peripherals(get_turf(holder))
				holder.icon_state = "odysseus6"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "odysseus9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "odysseus7"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "odysseus10"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You pry internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "odysseus8"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "odysseus11"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "odysseus9"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs [I] layer to [holder].", "You install external reinforced armor layer to [holder].")
				holder.icon_state = "odysseus12"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "odysseus10"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "odysseus13"
			else
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				user.visible_message("[user] pries [MS] from [holder].", "You pry [MS] from [holder].")
				holder.icon_state = "odysseus11"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				holder.icon_state = "odysseus14"
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "odysseus12"
	return 1

/datum/construction/reversible/mecha/odysseus/spawn_result()
	..()
	feedback_inc("mecha_odysseus_created",1)
	return
