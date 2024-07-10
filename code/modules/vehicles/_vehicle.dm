/**
 * generic, multiseat-capable vehicles system
 *
 * ! Port of old vehicles underway. Maintain typepath if possible.
 */
/obj/vehicle
	name = "generic vehicle"
	desc = "Yell at coderbus."
	icon = 'icons/obj/vehicles/_vehicles.dmi'
	icon_state = "oops"
	// integrity_max = 300
	// armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 0, BOMB = 30, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)
	density = TRUE
	anchored = FALSE
	buckle_flags = BUCKLING_PASS_PROJECTILES_UPWARDS
	COOLDOWN_DECLARE(cooldown_vehicle_move)
	var/list/mob/occupants				//mob = bitflags of their control level.
	var/max_occupants = 1
	var/max_drivers = 1
	var/movedelay = 2
	var/lastmove = 0
	var/key_type
	var/obj/item/key/inserted_key
	var/key_type_exact = TRUE		//can subtypes work
	var/canmove = TRUE
	var/emulate_door_bumps = TRUE	//when bumping a door try to make occupants bump them to open them.
	var/default_driver_move = TRUE	//handle driver movement instead of letting something else do it like riding datums.
	var/enclosed = FALSE	// is the rider protected from bullets? assume no
	var/list/autogrant_actions_passenger	//plain list of typepaths
	var/list/autogrant_actions_controller	//assoc list "[bitflag]" = list(typepaths)
	var/list/mob/occupant_actions			//assoc list mob = list(type = action datum assigned to mob)
	var/obj/vehicle/trailer				//what trailer is hitched to this vehicle
	var/obj/vehicle/trailer_type		//what trailer is allowed to hitch to this vehicle
	var/is_tugged = FALSE				//is this vehicle attached to another
	var/mouse_pointer //do we have a special mouse
	var/mechanical = TRUE			//if true the vehicle will not initialize a cell power system
	var/obj/item/cell/cell_type 	//default cell to spawn inside
	var/power_move_cost = 0		//how much power it costs to move in cell units
	//*var/obj_cell_slot 				//defined at mapload if mechanical is false. Use to access cell subsystem
	var/maint_panel_open = FALSE	//is the maintenance panel open?

	//Defines what buttons are in the alt-click radial menu.
	var/static/list/radial_menu = list(
		"Close" = image(icon = 'icons/mob/radial.dmi', icon_state = "red_x"),
		"Remove Cell" = image(icon = 'icons/obj/power.dmi', icon_state = "cell"),
		"Remove Key" = image(icon = 'icons/obj/vehicles/keys.dmi', icon_state = "train_keys")
	)


/obj/vehicle/Initialize(mapload)
	. = ..()
	occupants = list()
	autogrant_actions_passenger = list()
	autogrant_actions_controller = list()
	occupant_actions = list()
	generate_actions()
	if(!mechanical)
		var/datum/object_system/cell_slot/cell_slot = init_cell_slot(cell_type) //Enables the generic cell system
		cell_slot.receive_emp = TRUE
		cell_slot.receive_inducer = TRUE
		cell_slot.remove_yank_offhand = TRUE
		cell_slot.remove_yank_context = TRUE
		cell_slot.remove_yank_inhand = TRUE

/obj/vehicle/examine(mob/user, dist)
	. = ..()
	//You can't see inside a closed vehicle dummy!
	if(enclosed && is_occupant(user))
		if(key_type)
			if(!inserted_key)
				. += "<span class='notice'>Put a key inside it by clicking it with the key.</span>"
			else
				. += "<span class='notice'>There is a key in the ignition!.</span>"
		if(!mechanical)
			if(obj_cell_slot.has_cell())
				. += "<br><span class='notice'>Its charge meter reads: [obj_cell_slot.percent()]%.</span>"
	//Range check to make people interact with the world
	if(!enclosed && dist < 3)
		if(key_type)
			if(!inserted_key)
				. += "<span class='notice'>Put a key inside it by clicking it with the key.</span>"
			else
				. += "<span class='notice'>There is a key in the ignition!.</span>"
		if(!mechanical)
			if(obj_cell_slot.has_cell())
				. += "<br><span class='notice'>Its charge meter reads: [obj_cell_slot.percent()]%.</span>"


	if(maint_panel_open)
		. += "<br><span class='notice'>Its maintenance panel is open!</span>"
	. += "<br><span class='notice'>Alt-click on \the [src] to open the menu!</span>"
	/*
	if(resistance_flags & ON_FIRE)
		. += "<span class='warning'>It's on fire!</span>"
	var/healthpercent = obj_integrity/integrity_max * 100
	switch(healthpercent)
		if(50 to 99)
			. += "It looks slightly damaged."
		if(25 to 50)
			. += "It appears heavily damaged."
		if(0 to 25)
			. += "<span class='warning'>It's falling apart!</span>"
	*/

/**Check if the mob is adjacent, living, capable of advanced tool use, and not an AI*/
/obj/vehicle/proc/can_use_check(mob/user)
	if (!isliving(user) || isAI(user))
		return FALSE

	if (!user.IsAdvancedToolUser())
		to_chat(user, "You lack the dexterity to do that!")
		return FALSE

	if (user.stat || user.restrained() || user.incapacitated())
		return FALSE

	if (!Adjacent(user) && !issilicon(user))
		to_chat(user, "You can't reach [src] from here.")
		return FALSE

	return TRUE

/**Defines what the radial wheel buttons do.*/
/obj/vehicle/proc/choose_action()
	set src in view()
	set name = "Choose Action"
	set category = "Object"

	if(!can_use_check(usr))
		return

	var/choice = show_radial_menu(usr, src, radial_menu, require_near = !issilicon(usr), tooltips = TRUE)
	if(!choice)
		return
	switch(choice)
		if("Close")
			return
		if("Remove Cell")
			if(mechanical)
				return
			if(obj_cell_slot.interaction_active())
				if(obj_cell_slot.mob_yank_cell(usr))
					to_chat(usr, "<span class='notice'>You pry out the cell!</span>")
				else
					to_chat(usr, "<span class='notice'>There is no cell to remove!</span>")
			else
				to_chat(usr, "<span class='notice'>The cell is inaccessible!</span>")
			return
		if("Remove Key")
			remove_key(usr)
			return

/obj/vehicle/AltClick(mob/user)
	choose_action()
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/vehicle/proc/is_key(obj/item/I)
	return I? (key_type_exact? (I.type == key_type) : istype(I, key_type)) : FALSE

/obj/vehicle/proc/return_occupants()
	return occupants

/obj/vehicle/proc/occupant_amount()
	return length(occupants)

/obj/vehicle/proc/return_amount_of_controllers_with_flag(flag)
	. = 0
	for(var/i in occupants)
		if(occupants[i] & flag)
			.++

/obj/vehicle/proc/return_controllers_with_flag(flag)
	RETURN_TYPE(/list/mob)
	. = list()
	for(var/i in occupants)
		if(occupants[i] & flag)
			. += i

/obj/vehicle/proc/return_drivers()
	return return_controllers_with_flag(VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/driver_amount()
	return return_amount_of_controllers_with_flag(VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/is_driver(mob/M)
	return is_occupant(M) && occupants[M] & VEHICLE_CONTROL_DRIVE

/obj/vehicle/proc/is_occupant(mob/M)
	return !isnull(occupants[M])

/obj/vehicle/proc/add_occupant(mob/M, control_flags)
	if(!istype(M) || occupants[M])
		return FALSE
	occupants[M] = NONE
	add_control_flags(M, control_flags)
	after_add_occupant(M)
	grant_passenger_actions(M)
	return TRUE

/obj/vehicle/proc/after_add_occupant(mob/M)
	auto_assign_occupant_flags(M)

/obj/vehicle/proc/auto_assign_occupant_flags(mob/M) //override for each type that needs it. Default is assign driver if drivers is not at max.
	if(driver_amount() < max_drivers)
		add_control_flags(M, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/remove_occupant(mob/M)
	if(!istype(M))
		return FALSE
	remove_control_flags(M, ALL)
	remove_passenger_actions(M)
	occupants -= M
	cleanup_actions_for_mob(M)
	after_remove_occupant(M)
	return TRUE

/obj/vehicle/proc/after_remove_occupant(mob/M)

/obj/vehicle/relaymove(mob/user, direction)
	if(is_driver(user))
		return driver_move(user, direction)
	return FALSE

/obj/vehicle/proc/driver_move(mob/user, direction)
	if(key_type && !is_key(inserted_key))
		to_chat(user, "<span class='warning'>[src] has no key inserted!</span>")
		return FALSE
	if(!default_driver_move)
		return
	vehicle_move(direction)


/obj/vehicle/proc/vehicle_move(direction)
	if(!COOLDOWN_FINISHED(src, cooldown_vehicle_move))
		return FALSE
	COOLDOWN_START(src, cooldown_vehicle_move, movedelay)
	if(trailer)
		var/dir_to_move = get_dir(trailer.loc, loc)
		var/did_move = step(src, direction)
		if(did_move)
			step(trailer, dir_to_move)
		return did_move
	else
		after_move(direction)
		return step(src, direction)

/obj/vehicle/proc/after_move(direction)
	return

/obj/vehicle/proc/add_control_flags(mob/controller, flags)
	if(!istype(controller) || !flags)
		return FALSE
	occupants[controller] |= flags
	for(var/i in GLOB.bitflags)
		if(flags & i)
			grant_controller_actions_by_flag(controller, i)
	return TRUE

/obj/vehicle/proc/remove_control_flags(mob/controller, flags)
	if(!istype(controller) || !flags)
		return FALSE
	occupants[controller] &= ~flags
	for(var/i in GLOB.bitflags)
		if(flags & i)
			remove_controller_actions_by_flag(controller, i)
	return TRUE

/obj/vehicle/Bump(atom/movable/M)
	. = ..()
	if(emulate_door_bumps)
		if(istype(M, /obj/machinery/door))
			for(var/m in occupants)
				M.Bumped(m)

/obj/vehicle/Move(newloc, new_dir)

	//if(new_dir & (new_dir-1)) //Dark magic sigil which determines diagonal movement
		//Cool code that slows down diagonal movement to match horizontal/vertical movement.
	if(!TryUsePower())
		return
	var/old_loc = src.loc
	. = ..()
	if(trailer && .)
		var/dir_to_move = get_dir(trailer.loc, old_loc)
		step(trailer, dir_to_move)

/**
 * Checks if the vehicle has enough power to move and consumes it if it does.
 * Returns TRUE on success.
 */
/obj/vehicle/proc/TryUsePower()
	if(mechanical)
		return TRUE
	else if(obj_cell_slot.checked_use(power_move_cost))
		return TRUE
	return FALSE

/**Key removal proc to override for different effects*/
/obj/vehicle/proc/remove_key(mob/user)
	if(inserted_key && user.Adjacent(src) && !user.incapacitated())
		if(!is_occupant(user))
			to_chat(user, "<span class='notice'>You must be riding the [src] to remove [src]'s key!</span>")
			return
		to_chat(user, "<span class='notice'>You remove \the [inserted_key] from \the [src].</span>")
		user.put_in_hands_or_drop(inserted_key)
		inserted_key = null

/obj/vehicle/attackby(obj/item/I as obj, mob/user as mob)
	//Flipflop maint panel status if screwed.
	if(istype(I, /obj/item/tool/screwdriver) && !mechanical)
		maint_panel_open = !maint_panel_open
		to_chat(user, "<span class='warning'>You [maint_panel_open ? "open" : "close"] the maintenance panel!</span>")
		return
	if(key_type && !is_key(inserted_key) && is_key(I))
		if(user.transfer_item_to_loc(I, src))
			to_chat(user, "<span class='notice'>You insert \the [I] into \the [src].</span>")
			if(inserted_key)	//just in case there's an invalid key
				inserted_key.forceMove(drop_location())
			inserted_key = I
		else
			to_chat(user, "<span class='notice'>[I] seems to be stuck to your hand!</span>")
		return
	return ..()

/obj/vehicle/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return maint_panel_open && ..()

//Take DroppedOn atoms and determine if they are a trailer to be attached, or pass on for passenger procs.
/obj/vehicle/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(!istype(dropping) || !isliving(user) || !proximity || get_dist(dropping.loc, loc) != 1)
		return ..()
	//Trailer hitch check
	if(istype(dropping, /obj/vehicle/trailer))
		if(attach_to(dropping, user))
			return CLICKCHAIN_DO_NOT_PROPAGATE

	return ..()

/**
 * Attempts to attach a trailer to the vehicle. Returns true if it does something else it returns false.
 * Assumes proximity checks have already been made.
 */
/obj/vehicle/proc/attach_to(obj/vehicle/trailer/dropping, mob/user)
	//If its not our allowed trailer, leave this function NOW.
	if (dropping.type != trailer_type)
		return FALSE
	//Is this already THE trailer? Let it go.
	if (dropping == trailer)
		trailer = null
		dropping.is_tugged = FALSE
		dropping.anchored = FALSE
		to_chat(user, "<span class='warning'>You unhitch the [src]!</span>")
		return TRUE
	//If there is not already a trailer, and the trailer isn't getting pulled already. Tug it.
	if (trailer == null && dropping.is_tugged == FALSE)
		trailer = dropping
		dropping.is_tugged = TRUE
		dropping.anchored = TRUE
		to_chat(user, "<span class='notice'>You hitch the [src]!</span>")
		return TRUE
	//If we are already tugging a trailer, we can't hitch another.
	if (trailer != null)
		to_chat(user, "<span class='warning'>Another trailer is already hitched here!</span>")
		return TRUE
	//If the trailer is already hitched to something else, we can't unhitch it.
	if (dropping.is_tugged != FALSE)
		to_chat(user, "<span class='warning'>The [src] is already hitched to another vehicle!</span>")
		return TRUE
	return FALSE

//Build load() proc here

//Skeleton key
/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key."
	icon = 'icons/obj/vehicles/keys.dmi'
	icon_state = "keys"
	w_class = WEIGHT_CLASS_TINY
