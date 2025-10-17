/obj/item/vehicle_chassis/fighter/baron
	name = "\improper Baron Chassis"
	icon_state = "baron_chassis"

	origin_tech = list(TECH_MATERIAL = 2)

/obj/item/vehicle_chassis/fighter/baron/New()
	..()
	construct = new /datum/construction/mecha/fighter/baron_chassis(src)


/obj/item/vehicle_part/fighter/baron_core
	name="\improper Baron Core"
	icon_state = "baron_core"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 4)

/obj/item/vehicle_part/fighter/baron_cockpit
	name="\improper Baron Cockpit"
	icon_state = "baron_cockpit"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 4)

/obj/item/vehicle_part/fighter/baron_left_wing
	name="\improper Baron Left Wing"
	icon_state = "baron_l_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_part/fighter/baron_right_wing
	name="\improper Baron Right Wing"
	icon_state = "baron_r_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_part/fighter/baron_main_engine
	name="\improper Baron Main Engine"
	icon_state = "baron_m_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_part/fighter/baron_left_engine
	name="\improper Baron Left Engine"
	icon_state = "baron_l_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_part/fighter/baron_right_engine
	name="\improper Baron Right Engine"
	icon_state = "baron_r_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/datum/construction/mecha/fighter/baron_chassis
	result = "/obj/vehicle/sealed/mecha/combat/fighter/baron"
	steps = list(list("key"=/obj/item/vehicle_part/fighter/baron_core),//1
					 list("key"=/obj/item/vehicle_part/fighter/baron_cockpit),//2
					 list("key"=/obj/item/vehicle_part/fighter/baron_main_engine),//3
					 list("key"=/obj/item/vehicle_part/fighter/baron_left_engine),//4
					 list("key"=/obj/item/vehicle_part/fighter/baron_right_engine),//5
					 list("key"=/obj/item/vehicle_part/fighter/baron_left_wing),//6
					 list("key"=/obj/item/vehicle_part/fighter/baron_right_wing)//final
					)

/datum/construction/mecha/fighter/baron_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/fighter/baron_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/fighter/baron_chassis/spawn_result()
	var/obj/item/vehicle_chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/fighter/baron(const_holder)
	const_holder.icon = 'icons/mecha/fighters_construction64x64.dmi'
	const_holder.icon_state = "baron0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/fighter/baron
	result = "/obj/vehicle/sealed/mecha/combat/fighter/baron"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=IS_WRENCH,
							"desc"="External armor is bolted into place."),
					//2
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is installed."),
					//3
					list("key"=/obj/item/stack/material/plasteel,
							"backkey"=/obj/item/weldingtool,
							"desc"="The internal armor is welded into place."),
					//4
					list("key"=/obj/item/weldingtool,
							"backkey"=IS_WRENCH,
							"desc"="The internal armor is bolted into place."),
					//5
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="The internal armor is installed."),
					//6
					list("key"=/obj/item/stack/material/steel,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The manual flight control instruments are secured."),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The manual flight control instruments are installed."),
					//8
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/cockpitboard,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The advanced capacitor is secured."),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The advanced capacitor is installed."),
					//10
					list("key"=/obj/item/stock_parts/capacitor/adv,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The targeting module is secured."),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The targeting module is installed."),
					//12
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The flight control module is secured."),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The flight control module is installed."),
					//14
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/flight,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The central control module is secured."),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The central control module is installed."),
					//16
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The internal wiring is adjusted."),
					//17
					list("key"=/obj/item/tool/wirecutters,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The internal wiring is added."),
					//18
					list("key"=/obj/item/stack/cable_coil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The hydraulic landing gear are deployed."),
					//19
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_WRENCH,
							"desc"="The hydraulic landing gear are attached."),
					//20
					list("key"=IS_WRENCH,
							"desc"="The hydraulic landing gear are detached.")
					)

/datum/construction/reversible/mecha/fighter/baron/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/fighter/baron/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(20)
			user.visible_message("[user] attaches [holder]'s hydraulic landing gear.", "You attach [holder]'s hydraulic landing gear.")
			holder.icon_state = "baron1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] deploys [holder]'s hydraulic landing gear.", "You deploy [holder]'s hydraulic landing gear.")
				holder.icon_state = "baron2"
			else
				user.visible_message("[user] removes [holder]'s hydraulic landing gear.", "You remove [holder]'s hydraulic landing gear.")
				holder.icon_state = "baron0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the internal wiring to [holder].", "You add the internal wiring to [holder].")
				holder.icon_state = "baron3"
			else
				user.visible_message("[user] retracts [holder]'s hydraulic landing gear.", "You retract [holder]'s hydraulic landing gear.")
				holder.icon_state = "baron1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the internal wiring of [holder].", "You adjust the internal wiring of [holder].")
				holder.icon_state = "baron4"
			else
				user.visible_message("[user] removes the internal wiring from [holder].", "You remove the internal wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "baron2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central control module into [holder].")
				qdel(I)
				holder.icon_state = "baron5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "baron3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the central control module.", "You secure the central control module.")
				holder.icon_state = "baron6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central control module from [holder].")
				new /obj/item/circuitboard/mecha/fighter/baron/main(get_turf(holder))
				holder.icon_state = "baron4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the flight control module into [holder].", "You install the flight control module into [holder].")
				qdel(I)
				holder.icon_state = "baron7"
			else
				user.visible_message("[user] unfastens the central control module.", "You unfasten the central control module.")
				holder.icon_state = "baron5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the flight control module.", "You secure the flight control module.")
				holder.icon_state = "baron8"
			else
				user.visible_message("[user] removes the flight control module from [holder].", "You remove the flight control module from [holder].")
				new /obj/item/circuitboard/mecha/fighter/baron/flight(get_turf(holder))
				holder.icon_state = "baron6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the targeting control module into [holder].", "You install the targeting control module into [holder].")
				qdel(I)
				holder.icon_state = "baron9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "baron7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the targeting control module.", "You secure the targeting control module.")
				holder.icon_state = "baron10"
			else
				user.visible_message("[user] removes the targeting control module from [holder].", "You remove the targeting control module from [holder].")
				new /obj/item/circuitboard/mecha/fighter/baron/targeting(get_turf(holder))
				holder.icon_state = "baron8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the advanced capacitor into [holder].", "You install the advanced capacitor into [holder].")
				qdel(I)
				holder.icon_state = "baron11"
			else
				user.visible_message("[user] unfastens the targeting control module.", "You unfasten the targeting control module.")
				holder.icon_state = "baron9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
				holder.icon_state = "baron12"
			else
				user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "baron10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the manual flight controls to [holder].", "You install the manual flight controls to [holder].")
				qdel(I)
				holder.icon_state = "baron13"
			else
				user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
				holder.icon_state = "baron11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the manual flight controls.", "You secure the manual flight controls.")
				holder.icon_state = "baron14"
			else
				user.visible_message("[user] removes the manual flight controls from [holder].", "You remove the manual flight controls from [holder].")
				new /obj/item/circuitboard/mecha/fighter/baron/cockpitboard(get_turf(holder))
				holder.icon_state = "baron12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs the internal armor layer to [holder].", "You install the internal armor layer to [holder].")
				holder.icon_state = "baron19"
			else
				user.visible_message("[user] unfastens the manual flight controls.", "You unfasten the manual flight controls.")
				holder.icon_state = "baron13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] bolts the internal armor layer.", "You bolt the internal armor layer.")
				holder.icon_state = "baron20"
			else
				user.visible_message("[user] pries the internal armor layer from [holder].", "You pry the internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "baron14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds the internal armor layer into place on [holder].", "You weld the internal armor layer into place on [holder].")
				holder.icon_state = "baron21"
			else
				user.visible_message("[user] unbolt the internal armor layer.", "You unbolt the internal armor layer.")
				holder.icon_state = "baron19"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the external reinforced armor layer to [holder].", "You install the external reinforced armor layer to [holder].")
				holder.icon_state = "baron22"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "baron20"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] bolts external armor layer.", "You bolt external reinforced armor layer.")
				holder.icon_state = "baron23"
			else
				user.visible_message("[user] pries the external armor layer from [holder].", "You pry external armor layer from [holder].")
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "baron21"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the external armor layer to [holder].", "You weld the external armor layer to [holder].")
			else
				user.visible_message("[user] unbolts the external armor layer.", "You unbolt the external armor layer.")
				holder.icon_state = "baron22"
	return 1

/datum/construction/reversible/mecha/fighter/baron/spawn_result()
	..()
	feedback_inc("mecha_fighter_baron_created",1)
	return
