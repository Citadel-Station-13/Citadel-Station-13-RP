/* Windoor (window door) assembly -Nodrak
 * Step 1: Create a windoor out of rglass
 * Step 2: Add r-glass to the assembly to make a secure windoor (Optional)
 * Step 3: Rotate or Flip the assembly to face and open the way you want
 * Step 4: Wrench the assembly in place
 * Step 5: Add cables to the assembly
 * Step 6: Set access for the door.
 * Step 7: Screwdriver the door to complete
 */


/obj/structure/windoor_assembly
	name = "windoor assembly"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "l_windoor_assembly01"
	anchored = FALSE
	density = FALSE
	pass_flags_self = ATOM_PASS_GLASS
	dir = NORTH
	w_class = ITEMSIZE_NORMAL

	var/obj/item/airlock_electronics/electronics = null
	var/created_name = null

	//Vars to help with the icon's name
	var/facing = "l"	//Does the windoor open to the left or right?
	var/secure = ""		//Whether or not this creates a secure windoor
	var/state = "01"	//How far the door assembly has progressed in terms of sprites
	var/step = null		//How far the door assembly has progressed in terms of steps

/obj/structure/windoor_assembly/secure
	name = "secure windoor assembly"
	secure = "secure_"
	icon_state = "l_secure_windoor_assembly01"

/obj/structure/windoor_assembly/Initialize(mapload, start_dir = NORTH, constructed = FALSE)
	. = ..()
	if(constructed)
		state = "01"
		anchored = 0
	switch(start_dir)
		if(NORTH, SOUTH, EAST, WEST)
			setDir(start_dir)
		else //If the user is facing northeast. northwest, southeast, southwest or north, default to north
			setDir(NORTH)
	update_state()

	update_nearby_tiles()

/obj/structure/windoor_assembly/Destroy()
	density = 0
	update_nearby_tiles()
	..()

/obj/structure/windoor_assembly/update_icon()
	icon_state = "[facing]_[secure]windoor_assembly[state]"

/obj/structure/windoor_assembly/CanAllowThrough(atom/movable/mover, turf/target)
	if(!(get_dir(loc, mover) & dir))
		// if it isn't our side we don't care
		return TRUE
	return ..()

/obj/structure/windoor_assembly/CheckExit(atom/movable/AM, atom/newLoc)
	if(!(get_dir(src, newLoc) & dir))
		// ditto
		return TRUE
	if(check_standard_flag_pass(AM))
		return TRUE
	return !density

/obj/structure/windoor_assembly/proc/rename_door(mob/living/user)
	var/t = sanitizeSafe(input(user, "Enter the name for the windoor.", src.name, src.created_name), MAX_NAME_LEN)
	if(!in_range(src, user) && src.loc != user)	return
	created_name = t
	update_state()

/obj/structure/windoor_assembly/attack_robot(mob/living/silicon/robot/user)
	if(Adjacent(user) && (user.module && (istype(user.module,/obj/item/robot_module/robot/engineering/general)) \
	|| istype(user.module,/obj/item/robot_module/drone))) //Only dron (and engiborg) needs this.
		rename_door(user)

/obj/structure/windoor_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen))
		rename_door(user)
		return

	switch(state)
		if("01")
			if(istype(W, /obj/item/weldingtool) && !anchored )
				var/obj/item/weldingtool/WT = W
				if (WT.remove_fuel(0,user))
					user.visible_message("[user] disassembles the windoor assembly.", "You start to disassemble the windoor assembly.")
					playsound(src.loc, WT.tool_sound, 50, 1)

					if(do_after(user, 40 * WT.tool_speed))
						if(!src || !WT.isOn()) return
						to_chat(user,"<span class='notice'>You disassembled the windoor assembly!</span>")
						if(secure)
							new /obj/item/stack/material/glass/reinforced(get_turf(src), 2)
						else
							new /obj/item/stack/material/glass(get_turf(src), 2)
						qdel(src)
				else
					to_chat(user,"<span class='notice'>You need more welding fuel to disassemble the windoor assembly.</span>")
					return

			//Wrenching an unsecure assembly anchors it in place. Step 4 complete
			if(W.is_wrench() && !anchored)
				playsound(src, W.tool_sound, 100, 1)
				user.visible_message("[user] secures the windoor assembly to the floor.", "You start to secure the windoor assembly to the floor.")

				if(do_after(user, 40 * W.tool_speed))
					if(!src) return
					to_chat(user,"<span class='notice'>You've secured the windoor assembly!</span>")
					src.anchored = 1
					step = 0

			//Unwrenching an unsecure assembly un-anchors it. Step 4 undone
			else if(W.is_wrench() && anchored)
				playsound(src, W.tool_sound, 100, 1)
				user.visible_message("[user] unsecures the windoor assembly to the floor.", "You start to unsecure the windoor assembly to the floor.")

				if(do_after(user, 40 * W.tool_speed))
					if(!src) return
					to_chat(user,"<span class='notice'>You've unsecured the windoor assembly!</span>")
					src.anchored = 0
					step = null

			//Adding cable to the assembly. Step 5 complete.
			else if(istype(W, /obj/item/stack/cable_coil) && anchored)
				user.visible_message("[user] wires the windoor assembly.", "You start to wire the windoor assembly.")

				var/obj/item/stack/cable_coil/CC = W
				if(do_after(user, 40))
					if (CC.use(1))
						to_chat(user,"<span class='notice'>You wire the windoor!</span>")
						src.state = "02"
						step = 1
			else
				..()

		if("02")

			//Removing wire from the assembly. Step 5 undone.
			if(W.is_wirecutter() && !src.electronics)
				playsound(src, W.tool_sound, 100, 1)
				user.visible_message("[user] cuts the wires from the airlock assembly.", "You start to cut the wires from airlock assembly.")

				if(do_after(user, 40 * W.tool_speed))
					if(!src) return

					to_chat(user,"<span class='notice'>You cut the windoor wires.!</span>")
					new/obj/item/stack/cable_coil(get_turf(user), 1)
					src.state = "01"
					step = 0

			//Adding airlock electronics for access. Step 6 complete.
			else if(istype(W, /obj/item/airlock_electronics))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message("[user] installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")

				if(do_after(user, 40))
					if(!src)
						return
					if(!user.attempt_insert_item_for_installation(W, src))
						return
					to_chat(user,"<span class='notice'>You've installed the airlock electronics!</span>")
					step = 2
					src.electronics = W
				else
					W.loc = src.loc

			//Screwdriver to remove airlock electronics. Step 6 undone.
			else if(W.is_screwdriver() && src.electronics)
				playsound(src, W.tool_sound, 100, 1)
				user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to uninstall electronics from the airlock assembly.")

				if(do_after(user, 40 * W.tool_speed))
					if(!src || !src.electronics) return
					to_chat(user,"<span class='notice'>You've removed the airlock electronics!</span>")
					step = 1
					var/obj/item/airlock_electronics/ae = electronics
					electronics = null
					ae.loc = src.loc

			//Crowbar to complete the assembly, Step 7 complete.
			else if(W.is_crowbar())
				if(!src.electronics)
					to_chat(usr,"<span class='warning'>The assembly is missing electronics.</span>")
					return
				if(src.electronics && istype(src.electronics, /obj/item/circuitboard/broken))
					to_chat(usr,"<span class='warning'>The assembly has broken airlock electronics.</span>")
					return
				user << browse(null, "window=windoor_access") //Not sure what this actually does... -Ner
				playsound(src, W.tool_sound, 100, 1)
				user.visible_message("[user] pries the windoor into the frame.", "You start prying the windoor into the frame.")

				if(do_after(user, 40 * W.tool_speed))

					if(!src) return

					density = 1 //Shouldn't matter but just incase
					to_chat(user,"<span class='notice'>You finish the windoor!</span>")

					var/obj/machinery/door/window/windoor
					if(secure)
						windoor = new /obj/machinery/door/window/brigdoor(loc)
						if(src.facing == "l")
							windoor.icon_state = "leftsecureopen"
							windoor.base_state = "leftsecure"
						else
							windoor.icon_state = "rightsecureopen"
							windoor.base_state = "rightsecure"
					else
						windoor = new /obj/machinery/door/window(loc)
						if(src.facing == "l")
							windoor.icon_state = "leftopen"
							windoor.base_state = "left"
						else
							windoor.icon_state = "rightopen"
							windoor.base_state = "right"
					windoor.setDir(src.dir)
					windoor.density = 0
					if(created_name)
						windoor.name = created_name
					spawn(0)
						windoor.close()
					windoor.req_access = electronics.conf_req_access?.Copy()
					windoor.req_one_access = electronics.conf_req_one_access?.Copy()
					windoor.electronics = electronics
					electronics.forceMove(windoor)
					qdel(src)
			else
				..()

	//Update to reflect changes(if applicable)
	update_state()

/obj/structure/windoor_assembly/proc/update_state()
	update_icon()
	name = ""
	switch(step)
		if (0)
			name = "anchored "
		if (1)
			name = "wired "
		if (2)
			name = "near finished "
	name += "[secure ? "secure " : ""]windoor assembly[created_name ? " ([created_name])" : ""]"

//Rotates the windoor assembly clockwise
/obj/structure/windoor_assembly/verb/rotate_clockwise()
	set name = "Rotate Windoor Assembly Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		to_chat(usr,"It is fastened to the floor; therefore, you can't rotate it!")
		return 0
	if(src.state != "01")
		update_nearby_tiles() //Compel updates before

	src.setDir(turn(src.dir, 270))

	if(src.state != "01")
		update_nearby_tiles()

	update_icon()
	return

//Flips the windoor assembly, determines whather the door opens to the left or the right
/obj/structure/windoor_assembly/verb/flip()
	set name = "Flip Windoor Assembly"
	set category = "Object"
	set src in oview(1)

	if(src.facing == "l")
		to_chat(usr,"The windoor will now slide to the right.")
		src.facing = "r"
	else
		src.facing = "l"
		to_chat(usr,"The windoor will now slide to the left.")

	update_icon()
	return
