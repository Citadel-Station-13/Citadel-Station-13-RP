// todo: /obj/machinery/turret_frame
/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density = TRUE

	/// The type we intend to build.
	var/target_type = /obj/machinery/porta_turret
	/// The current step in the building process.
	var/build_step = 0
	/// The name applied to the product turret.
	var/finish_name="turret"
	/// The gun type installed.
	var/installation = null
	/// The gun charge of the gun type installed.
	var/gun_charge = 0

/obj/machinery/porta_turret_construct/attackby(obj/item/I, mob/user)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(I.is_wrench() && !anchored)
				playsound(loc, I.tool_sound, 100, 1)
				to_chat(user, "<span class='notice'>You secure the external bolts.</span>")
				anchored = TRUE
				build_step = 1
				return

			else if(I.is_crowbar() && !anchored)
				playsound(loc, I.tool_sound, 75, 1)
				to_chat(user, "<span class='notice'>You dismantle the turret construction.</span>")
				new /obj/item/stack/material/steel(loc, 5)
				qdel(src)
				return

		if(1)
			if(I.is_material_stack_of(/datum/prototype/material/steel))
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal armor to the interior frame.</span>")
					build_step = 2
					icon_state = "turret_frame2"
				else
					to_chat(user, "<span class='warning'>You need two sheets of metal to continue construction.</span>")
				return

			else if(I.is_wrench())
				playsound(loc, I.tool_sound, 75, 1)
				to_chat(user, "<span class='notice'>You unfasten the external bolts.</span>")
				anchored = FALSE
				build_step = 0
				return

		if(2)
			if(I.is_wrench())
				playsound(loc, I.tool_sound, 100, 1)
				to_chat(user, "<span class='notice'>You bolt the metal armor into place.</span>")
				build_step = 3
				return

			else if(istype(I, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = I
				if(!WT.isOn())
					return
				if(WT.get_fuel() < 5) //uses up 5 fuel.
					to_chat(user, "<span class='notice'>You need more fuel to complete this task.</span>")
					return

				playsound(loc, I.tool_sound, 50, 1)
				if(do_after(user, 20 * I.tool_speed))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					to_chat(user, "You remove the turret's interior metal armor.")
					new /obj/item/stack/material/steel(loc, 2)
					return

		if(3)
			if(istype(I, /obj/item/gun/projectile/energy)) //the gun installation part
				if(!user.attempt_insert_item_for_installation(I, src))
					return
				var/obj/item/gun/projectile/energy/E = I //typecasts the item to an energy gun
				installation = I.type //installation becomes I.type
				gun_charge = E.obj_cell_slot.cell.charge //the gun's charge is stored in gun_charge
				to_chat(user, "<span class='notice'>You add [I] to the turret.</span>")
				target_type = /obj/machinery/porta_turret

				build_step = 4
				qdel(I) //delete the gun :(
				return

			else if(I.is_wrench())
				playsound(loc, I.tool_sound, 100, 1)
				to_chat(user, "<span class='notice'>You remove the turret's metal armor bolts.</span>")
				build_step = 2
				return

		if(4)
			if(isprox(I))
				if(!user.attempt_consume_item_for_construction(I))
					return
				build_step = 5
				to_chat(user, "<span class='notice'>You add the prox sensor to the turret.</span>")
				return

			//attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)

		if(5)
			if(I.is_screwdriver())
				playsound(loc, I.tool_sound, 100, 1)
				build_step = 6
				to_chat(user, "<span class='notice'>You close the internal access hatch.</span>")
				return

			//attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)

		if(6)
			if(I.is_material_stack_of(/datum/prototype/material/steel))
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal armor to the exterior frame.</span>")
					build_step = 7
				else
					to_chat(user, "<span class='warning'>You need two sheets of metal to continue construction.</span>")
				return

			else if(I.is_screwdriver())
				playsound(loc, I.tool_sound, 100, 1)
				build_step = 5
				to_chat(user, "<span class='notice'>You open the internal access hatch.</span>")
				return

		if(7)
			if(istype(I, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = I
				if(!WT.isOn()) return
				if(WT.get_fuel() < 5)
					to_chat(user, "<span class='notice'>You need more fuel to complete this task.</span>")

				playsound(loc, WT.tool_sound, 50, 1)
				if(do_after(user, 30 * WT.tool_speed))
					if(!src || !WT.remove_fuel(5, user))
						return
					build_step = 8
					to_chat(user, "<span class='notice'>You weld the turret's armor down.</span>")

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new target_type(loc)
					Turret.name = finish_name
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.enabled = 0
					Turret.setup()

					qdel(src) // qdel

			else if(I.is_crowbar())
				playsound(loc, I.tool_sound, 75, 1)
				to_chat(user, "<span class='notice'>You pry off the turret's exterior armor.</span>")
				new /obj/item/stack/material/steel(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/pen))	//you can rename turrets like bots!
		var/t = sanitizeSafe(input(user, "Enter new turret name", name, finish_name) as text, MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		finish_name = t
		return

	..()

/obj/machinery/porta_turret_construct/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3

			var/obj/item/gun/projectile/energy/Gun = new installation(loc)
			Gun.obj_cell_slot.cell.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			to_chat(user, "<span class='notice'>You remove [Gun] from the turret frame.</span>")

		if(5)
			to_chat(user, "<span class='notice'>You remove the prox sensor from the turret frame.</span>")
			new /obj/item/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return
