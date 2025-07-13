/obj/item/vehicle_chassis/janus
	name = "Janus Chassis"
	origin_tech = list(TECH_MATERIAL = 7)

/obj/item/vehicle_chassis/janus/New()
	..()
	construct = new /datum/construction/mecha/janus_chassis(src)

/obj/item/vehicle_part/janus_torso
	name="Imperion Torso"
	icon_state = "janus_harness"
	origin_tech = list(TECH_DATA = 5, TECH_MATERIAL = 7, TECH_BLUESPACE = 2, TECH_POWER = 6, TECH_PRECURSOR = 2)

/obj/item/vehicle_part/janus_head
	name="Imperion Head"
	icon_state = "janus_head"
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 5, TECH_MAGNET = 6, TECH_PRECURSOR = 1)

/obj/item/vehicle_part/janus_left_arm
	name="Prototype Gygax Left Arm"
	icon_state = "janus_l_arm"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/vehicle_part/janus_right_arm
	name="Prototype Gygax Right Arm"
	icon_state = "janus_r_arm"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/vehicle_part/janus_left_leg
	name="Prototype Durand Left Leg"
	icon_state = "janus_l_leg"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3, TECH_ARCANE = 1)

/obj/item/vehicle_part/janus_right_leg
	name="Prototype Durand Right Leg"
	icon_state = "janus_r_leg"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3, TECH_ARCANE = 1)

/datum/construction/mecha/janus_chassis
	result = "/obj/vehicle/sealed/mecha/combat/phazon/janus"
	steps = list(list("key"=/obj/item/vehicle_part/janus_torso),//1
					 list("key"=/obj/item/vehicle_part/janus_left_arm),//2
					 list("key"=/obj/item/vehicle_part/janus_right_arm),//3
					 list("key"=/obj/item/vehicle_part/janus_left_leg),//4
					 list("key"=/obj/item/vehicle_part/janus_right_leg),//5
					 list("key"=/obj/item/vehicle_part/janus_head)
					)

/datum/construction/mecha/janus_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/janus_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/janus_chassis/spawn_result()
	var/obj/item/vehicle_chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/janus(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "janus0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/janus
	result = "/obj/vehicle/sealed/mecha/combat/phazon/janus"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is installed."),
					//2
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is attached."),
					//3
					list("key"=/obj/item/stack/material/morphium,
							"backkey"=/obj/item/weldingtool,
							"desc"="Internal armor is welded"),
					//4
					list("key"=/obj/item/weldingtool,
							"backkey"=IS_CROWBAR,
							"desc"="Internal armor is wrenched"),
					//5
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="Internal armor is attached."),
					//6
					list("key"=/obj/item/stack/material/durasteel,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Durand auxiliary board is secured."),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Durand auxiliary board is installed"),
					//8
					list("key"=/obj/item/circuitboard/mecha/durand/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Phase coil is secured"),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Phase coil is installed"),
					//10
					list("key"=/obj/item/prop/alien/phasecoil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Gygax balance system secured"),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Gygax balance system installed"),
					//12
					list("key"=/obj/item/circuitboard/mecha/gygax/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Targeting module is secured"),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Targeting module is installed"),
					//14
					list("key"=/obj/item/circuitboard/mecha/imperion/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Peripherals control module is secured"),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Peripherals control module is installed"),
					//16
					list("key"=/obj/item/circuitboard/mecha/imperion/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Central control module is secured"),
					//17
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Central control module is installed"),
					//18
					list("key"=/obj/item/circuitboard/mecha/imperion/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is adjusted"),
					//19
					list("key"=/obj/item/tool/wirecutters,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is added"),
					//20
					list("key"=/obj/item/stack/cable_coil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The hydraulic systems are active."),
					//21
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_WRENCH,
							"desc"="The hydraulic systems are connected."),
					//22
					list("key"=IS_WRENCH,
							"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/janus/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/janus/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(22)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "janus1"
		if(21)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "janus2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "janus0"
		if(20)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "janus3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "janus1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "janus4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "janus2"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "janus5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "janus3"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "janus6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/circuitboard/mecha/imperion/main(get_turf(holder))
				holder.icon_state = "janus4"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "janus7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "janus5"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "janus8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/circuitboard/mecha/imperion/peripherals(get_turf(holder))
				holder.icon_state = "janus6"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "janus9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "janus7"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "janus10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/circuitboard/mecha/imperion/targeting(get_turf(holder))
				holder.icon_state = "janus8"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the Gygax control module into [holder].", "You install the Gygax control module into [holder].")
				qdel(I)
				holder.icon_state = "janus11"
			else
				user.visible_message("[user] unfastens the Gygax control module.", "You unfasten the Gygax control module.")
				holder.icon_state = "janus9"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the Gygax control module.", "You secure the Gygax control module.")
				holder.icon_state = "janus12"
			else
				user.visible_message("[user] removes the Gygax control module from [holder].", "You remove the Gygax control module from [holder].")
				new /obj/item/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "janus10"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the phase coil into [holder].", "You install the phase coil into [holder].")
				qdel(I)
				holder.icon_state = "janus13"
			else
				user.visible_message("[user] unfastens the Gygax control module.", "You unfasten the Gygax control module.")
				holder.icon_state = "janus11"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the phase coil.", "You secure the phase coil.")
				holder.icon_state = "janus14"
			else
				user.visible_message("[user] removes the phase coil from [holder].", "You remove the phase coil from [holder].")
				new /obj/item/prop/alien/phasecoil(get_turf(holder))
				holder.icon_state = "janus12"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the Durand control module into [holder].", "You install the Durand control module into [holder].")
				qdel(I)
				holder.icon_state = "janus15"
			else
				user.visible_message("[user] unfastens the phase coil.", "You unfasten the phase coil.")
				holder.icon_state = "janus13"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the Durand control module.", "You secure the Durand control module.")
				holder.icon_state = "janus16"
			else
				user.visible_message("[user] removes the Durand control module from [holder].", "You remove the Durand control module from [holder].")
				new /obj/item/circuitboard/mecha/durand/peripherals(get_turf(holder))
				holder.icon_state = "janus14"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs the internal armor layer to [holder].", "You install the internal armor layer to [holder].")
				holder.icon_state = "janus17"
			else
				user.visible_message("[user] unfastens the Durand control module.", "You unfasten the Durand control module.")
				holder.icon_state = "janus15"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures the internal armor layer.", "You secure the internal armor layer.")
				holder.icon_state = "janus18"
			else
				user.visible_message("[user] pries the internal armor layer from [holder].", "You pry the internal armor layer from [holder].")
				var/obj/item/stack/material/durasteel/MS = new /obj/item/stack/material/durasteel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "janus16"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds the internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "janus19"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "janus17"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the external reinforced armor layer to [holder].", "You install the external reinforced armor layer to [holder].")
				holder.icon_state = "janus20"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "janus18"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "janus21"
			else
				user.visible_message("[user] pries the external armor layer from [holder].", "You pry external armor layer from [holder].")
				var/obj/item/stack/material/morphium/MS = new /obj/item/stack/material/morphium(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "janus19"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the external armor layer to [holder].", "You weld the external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "janus20"
	return 1

/datum/construction/reversible/mecha/janus/spawn_result()
	..()
	feedback_inc("mecha_janus_created",1)
	return
