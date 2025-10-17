/obj/item/vehicle_chassis/phazon
	name = "Phazon Chassis"
	origin_tech = list(TECH_MATERIAL = 7)

/obj/item/vehicle_chassis/phazon/New()
	..()
	construct = new /datum/construction/mecha/phazon_chassis(src)

/obj/item/vehicle_part/phazon_torso
	name="Phazon Torso"
	icon_state = "phazon_harness"
	//construction_time = 300
	//construction_cost = list(MAT_STEEL=35000,"glass"=10000,"phoron"=20000)
	origin_tech = list(TECH_DATA = 5, TECH_MATERIAL = 7, TECH_BLUESPACE = 6, TECH_POWER = 6)

/obj/item/vehicle_part/phazon_head
	name="Phazon Head"
	icon_state = "phazon_head"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=15000,"glass"=5000,"phoron"=10000)
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 5, TECH_MAGNET = 6)

/obj/item/vehicle_part/phazon_left_arm
	name="Phazon Left Arm"
	icon_state = "phazon_l_arm"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/vehicle_part/phazon_right_arm
	name="Phazon Right Arm"
	icon_state = "phazon_r_arm"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/vehicle_part/phazon_left_leg
	name="Phazon Left Leg"
	icon_state = "phazon_l_leg"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3)

/obj/item/vehicle_part/phazon_right_leg
	name="Phazon Right Leg"
	icon_state = "phazon_r_leg"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3)

/datum/construction/mecha/phazon_chassis
	result = "/obj/vehicle/sealed/mecha/combat/phazon"
	steps = list(list("key"=/obj/item/vehicle_part/phazon_torso),//1
					 list("key"=/obj/item/vehicle_part/phazon_left_arm),//2
					 list("key"=/obj/item/vehicle_part/phazon_right_arm),//3
					 list("key"=/obj/item/vehicle_part/phazon_left_leg),//4
					 list("key"=/obj/item/vehicle_part/phazon_right_leg),//5
					 list("key"=/obj/item/vehicle_part/phazon_head)
					)

/datum/construction/mecha/phazon_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/phazon_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/phazon_chassis/spawn_result()
	var/obj/item/vehicle_chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/phazon(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "phazon0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/phazon
	result = "/obj/vehicle/sealed/mecha/combat/phazon"
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
							"desc"="Hand teleporter is secured"),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Hand teleporter is installed"),
					//8
					list("key"=/obj/item/hand_tele,
							"backkey"=IS_SCREWDRIVER,
							"desc"="SMES coil is secured"),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="SMES coil is installed"),
					//10
					list("key"=/obj/item/smes_coil/super_capacity,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Targeting module is secured"),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Targeting module is installed"),
					//12
					list("key"=/obj/item/circuitboard/mecha/phazon/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Peripherals control module is secured"),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Peripherals control module is installed"),
					//14
					list("key"=/obj/item/circuitboard/mecha/phazon/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Central control module is secured"),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Central control module is installed"),
					//16
					list("key"=/obj/item/circuitboard/mecha/phazon/main,
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

/datum/construction/reversible/mecha/phazon/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/phazon/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(20)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "phazon1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "phazon2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "phazon0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "phazon3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "phazon1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "phazon4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "phazon2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "phazon5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "phazon3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "phazon6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/circuitboard/mecha/phazon/main(get_turf(holder))
				holder.icon_state = "phazon4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "phazon7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "phazon5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "phazon8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/circuitboard/mecha/phazon/peripherals(get_turf(holder))
				holder.icon_state = "phazon6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "phazon9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "phazon7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "phazon10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/circuitboard/mecha/phazon/targeting(get_turf(holder))
				holder.icon_state = "phazon8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the SMES coil to [holder].", "You install the SMES coil to [holder].")
				qdel(I)
				holder.icon_state = "phazon11"
			else
				user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
				holder.icon_state = "phazon9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the SMES coil.", "You secure the SMES coil.")
				holder.icon_state = "phazon12"
			else
				user.visible_message("[user] removes the SMES coil from [holder].", "You remove the SMES coil from [holder].")
				new /obj/item/smes_coil/super_capacity(get_turf(holder))
				holder.icon_state = "phazon10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the hand teleporter to [holder].", "You install the hand teleporter to [holder].")
				qdel(I)
				holder.icon_state = "phazon13"
			else
				user.visible_message("[user] unfastens the SMES coil.", "You unfasten the SMES coil.")
				holder.icon_state = "phazon11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the hand teleporter.", "You secure the hand teleporter.")
				holder.icon_state = "phazon14"
			else
				user.visible_message("[user] removes the hand teleporter from [holder].", "You remove the hand teleporter from [holder].")
				new /obj/item/hand_tele(get_turf(holder))
				holder.icon_state = "phazon12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs the internal armor layer to [holder].", "You install the internal armor layer to [holder].")
				holder.icon_state = "phazon19"
			else
				user.visible_message("[user] unfastens the hand teleporter.", "You unfasten the hand teleporter.")
				holder.icon_state = "phazon13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures the internal armor layer.", "You secure the internal armor layer.")
				holder.icon_state = "phazon20"
			else
				user.visible_message("[user] pries the internal armor layer from [holder].", "You pry the internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "phazon14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds the internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "phazon21"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "phazon19"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the external reinforced armor layer to [holder].", "You install the external reinforced armor layer to [holder].")
				holder.icon_state = "phazon22"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "phazon20"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "phazon23"
			else
				user.visible_message("[user] pries the external armor layer from [holder].", "You pry external armor layer from [holder].")
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "phazon21"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the external armor layer to [holder].", "You weld the external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "phazon22"
	return 1

/datum/construction/reversible/mecha/phazon/spawn_result()
	..()
	feedback_inc("mecha_phazon_created",1)
	return
