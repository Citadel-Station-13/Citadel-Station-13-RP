/obj/item/vehicle_chassis/honker
	name = "H.O.N.K. Chassis"

/obj/item/vehicle_chassis/honker/New()
	..()
	construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/vehicle_part/honker_torso
	name="H.O.N.K. Torso"
	desc="A H.O.N.K. torso. The lining requires a distressing amount of rubber."
	icon_state = "honker_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_head
	name="H.O.N.K. Head"
	desc="A H.O.N.K. head. Houses advanced slip prediction sensors and a squeezable nose."
	icon_state = "honker_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_left_arm
	name="H.O.N.K. Left Arm"
	desc="A H.O.N.K. left arm. Data and power sockets are compatible with the most hilarious tools and weapons."
	icon_state = "honker_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_right_arm
	name="H.O.N.K. Right Arm"
	desc="A H.O.N.K. right arm. Data and power sockets are compatible with the most hilarious tools and weapons."
	icon_state = "honker_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_left_leg
	name="H.O.N.K. Left Leg"
	icon_state = "honker_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_right_leg
	name="H.O.N.K. Right Leg"
	icon_state = "honker_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_armour
	name="H.O.N.K. Armour Plates"
	icon_state = "honker_armour"
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 5)

/datum/construction/mecha/honker_chassis
	steps = list(list("key"=/obj/item/vehicle_part/honker_torso),//1
					 list("key"=/obj/item/vehicle_part/honker_left_arm),//2
					 list("key"=/obj/item/vehicle_part/honker_right_arm),//3
					 list("key"=/obj/item/vehicle_part/honker_left_leg),//4
					 list("key"=/obj/item/vehicle_part/honker_right_leg),//5
					 list("key"=/obj/item/vehicle_part/honker_head)
					)

/datum/construction/mecha/honker_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/honker_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/honker_chassis/spawn_result()
	var/obj/item/vehicle_chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/honker(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "honker0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/honker
	result = "/obj/vehicle/sealed/mecha/combat/honker"
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
					 list("key"=/obj/item/vehicle_part/honker_armour,
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
					 		"desc"="Advanced capacitor is secured"),
					 //7
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced capacitor is installed"),
					 //8
					 list("key"=/obj/item/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/circuitboard/mecha/honker/targeting,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/circuitboard/mecha/honker/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/honker/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=/obj/item/tool/wirecutters,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //18
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //19
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //20
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/honker/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/honker/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(20)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "honker1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "honker2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "honker0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "honker3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "honker1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "honker4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "honker2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "honker5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "honker3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "honker6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/circuitboard/mecha/honker/main(get_turf(holder))
				holder.icon_state = "honker4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "honker7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "honker5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "honker8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/circuitboard/mecha/honker/peripherals(get_turf(holder))
				holder.icon_state = "honker6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "honker9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "honker7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "honker10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/circuitboard/mecha/honker/targeting(get_turf(holder))
				holder.icon_state = "honker8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
				qdel(I)
				holder.icon_state = "honker11"
			else
				user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
				holder.icon_state = "honker9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
				holder.icon_state = "honker12"
			else
				user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
				new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "honker10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced capacitor to [holder].", "You install advanced capacitor to [holder].")
				qdel(I)
				holder.icon_state = "honker13"
			else
				user.visible_message("[user] unfastens the advanced scanner module.", "You unfasten the advanced scanner module.")
				holder.icon_state = "honker11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
				holder.icon_state = "honker14"
			else
				user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "honker12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "honker15"
			else
				user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
				holder.icon_state = "honker13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "honker16"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You pry internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "honker14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "honker17"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "honker15"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs H.O.N.K. Armour Plates to [holder].", "You install H.O.N.K. Armour Plates to [holder].")
				qdel(I)
				holder.icon_state = "honker18"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "honker16"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures H.O.N.K. Armour Plates.", "You secure H.O.N.K. Armour Plates.")
				holder.icon_state = "honker19"
			else
				user.visible_message("[user] pries H.O.N.K. Armour Plates from [holder].", "You pry H.O.N.K. Armour Plates from [holder].")
				new /obj/item/vehicle_part/honker_armour(get_turf(holder))
				holder.icon_state = "honker17"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds H.O.N.K. Armour Plates to [holder].", "You weld H.O.N.K. Armour Plates to [holder].")
			else
				user.visible_message("[user] unfastens H.O.N.K. Armour Plates.", "You unfasten H.O.N.K. Armour Plates.")
				holder.icon_state = "honker18"
	return 1

/datum/construction/reversible/mecha/honker/spawn_result()
	..()
	feedback_inc("mecha_honker_created",1)
	return
