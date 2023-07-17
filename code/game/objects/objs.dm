/obj

	layer = OBJ_LAYER
	plane = OBJ_PLANE
	pass_flags_self = ATOM_PASS_OVERHEAD_THROW
	animate_movement = SLIDE_STEPS
	rad_flags = NONE
	atom_colouration_system = TRUE

	/// object flags, see __DEFINES/_flags/obj_flags.dm
	var/obj_flags = CAN_BE_HIT
	/// ONLY FOR MAPPING: Sets flags from a string list, handled in Initialize. Usage: set_obj_flags = "EMAGGED;!CAN_BE_HIT" to set EMAGGED and clear CAN_BE_HIT.
	var/set_obj_flags

	//? Access - see [modules/jobs/access.dm]
	/// If set, all of these accesses are needed to access this object.
	var/list/req_access
	/// If set, at least one of these accesses are needed to access this object.
	var/list/req_one_access

	//? Economy
	/// economic category for objects
	var/economic_category_obj = ECONOMIC_CATEGORY_OBJ_DEFAULT

	//? Materials
	/// static materials in us
	/// material id = amount
	var/list/materials
	/// material parts - lazy list; lets us track what we're made of.
	/// key = cost in cm3
	var/list/material_parts
	/// material parts on spawn
	/// key = material id
	var/list/material_defaults

	//? Sounds
	/// volume when breaking out using resist process
	var/breakout_sound = 'sound/effects/grillehit.ogg'
	/// volume when breaking out using resist process
	var/breakout_volume = 100

	//? misc / legacy
	/// Set when a player renames a renamable object.
	var/renamed_by_player = FALSE
	var/w_class // Size of the object.
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	var/sharp = 0		// whether this object cuts
	var/edge = 0		// whether this object is more likely to dismember
	var/pry = 0			//Used in attackby() to open doors
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = "brute"
	// todo: /obj/item level, /obj/projectile level, how to deal with armor?
	var/armor_penetration = 0
	var/show_messages
	var/preserve_item = 0 //whether this object is preserved when its owner goes into cryo-storage, gateway, etc
	var/can_speak = 0 //For MMIs and admin trickery. If an object has a brainmob in its contents, set this to 1 to allow it to speak.

	var/show_examine = TRUE	// Does this pop up on a mob when the mob is examined?
	var/register_as_dangerous_object = FALSE // Should this tell its turf that it is dangerous automatically?

/obj/Initialize(mapload)
	if(register_as_dangerous_object)
		register_dangerous_to_step()
	. = ..()
	if(!isnull(materials))
		materials = typelist(NAMEOF(src, materials), materials)
	if(!isnull(material_parts))
		material_parts = typelist(NAMEOF(src, material_parts), material_parts)
	if(!isnull(material_defaults))
		material_defaults = typelist(NAMEOF(src, material_defaults), material_defaults)
		init_materials()
	if (set_obj_flags)
		var/flagslist = splittext(set_obj_flags,";")
		var/list/string_to_objflag = GLOB.bitfields["obj_flags"]
		for (var/flag in flagslist)
			if(flag[1] == "!")
				flag = copytext(flag, length(flag[1]) + 1) // Get all but the initial !
				obj_flags &= ~string_to_objflag[flag]
			else
				obj_flags |= string_to_objflag[flag]

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(register_as_dangerous_object)
		unregister_dangerous_to_step()
	SStgui.close_uis(src)
	SSnanoui.close_uis(src)
	return ..()

/obj/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(register_as_dangerous_object)
		var/turf/old_turf = get_turf(old_loc)
		var/turf/new_turf = get_turf(src)

		if(old_turf != new_turf)
			old_turf.unregister_dangerous_object(src)
			new_turf.register_dangerous_object(src)

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for MUTATION_TELEKINESIS users

		if (istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(H.get_held_item_of_type(/obj/item/tk_grab))
				if(!(H in nearby))
					if(H.client && H.machine==src)
						is_in_use = 1
						src.attack_hand(H)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	nano_ui_interact(user)
	..()

/mob/proc/unset_machine()
	machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(h)
	return

/obj/proc/hides_under_flooring()
	return 0

	/**
 * This proc is used for telling whether something can pass by this object in a given direction, for use by the pathfinding system.
 *
 * Trying to generate one long path across the station will call this proc on every single object on every single tile that we're seeing if we can move through, likely
 * multiple times per tile since we're likely checking if we can access said tile from multiple directions, so keep these as lightweight as possible.
 *
 * Arguments:
 * * ID- An ID card representing what access we have (and thus if we can open things like airlocks or windows to pass through them). The ID card's physical location does not matter, just the reference
 * * to_dir- What direction we're trying to move in, relevant for things like directional windows that only block movement in certain directions
 * * caller- The movable we're checking pass flags for, if we're making any such checks
 **/
/obj/proc/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	if(ismovable(caller))
		var/atom/movable/AM = caller
		if(AM.pass_flags & pass_flags_self)
			return TRUE
	. = !density

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/hear_signlang(mob/M as mob, text, verb, datum/language/speaking) // Saycode gets worse every day.
	return FALSE

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

// Used to mark a turf as containing objects that are dangerous to step onto.
/obj/proc/register_dangerous_to_step()
	var/turf/T = get_turf(src)
	if(T)
		T.register_dangerous_object(src)

/obj/proc/unregister_dangerous_to_step()
	var/turf/T = get_turf(src)
	if(T)
		T.unregister_dangerous_object(src)

// Test for if stepping on a tile containing this obj is safe to do, used for things like landmines and cliffs.
/obj/proc/is_safe_to_step(mob/living/L)
	return TRUE

/obj/examine(mob/user, dist)
	. = ..()
	if(materials)
		if(!materials.len)
			return
		var/materials_list
		var/i = 1
		while(i<materials.len)
			materials_list += lowertext(materials[i])
			materials_list += ", "
			i++
		materials_list += materials[i]
		. += "<u>It is made out of [materials_list]</u>."
	return

/obj/proc/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	return

/obj/attack_hand(mob/user, list/params, datum/event_args/clickchain/e_args)
	if(Adjacent(user))
		add_fingerprint(user)
	..()

//? Resists

/**
 * called when something tries to resist out from inside us.
 *
 * @return TRUE if something was done to start to resist / as a resist actino, FALSE if something trivial was done / nothing was done.
 */
/obj/proc/contents_resist(mob/escapee)
	SHOULD_NOT_SLEEP(TRUE)
	return FALSE

/**
 * Invoke asynchronously from contents_resist.
 *
 * @return TRUE / FALSE based on if they started an action.
 */
/obj/proc/contents_resist_sequence(mob/escapee, time = 2 MINUTES, interval = 5 SECONDS)
	set waitfor = FALSE
	if(INTERACTING_WITH_FOR(escapee, src, INTERACTING_FOR_RESIST))
		return FALSE
	. = TRUE
	_contents_resist_sequence(arglist(args))

/obj/proc/_contents_resist_sequence(mob/escapee, time, interval)
	START_INTERACTING_WITH(escapee, src, INTERACTING_FOR_RESIST)
	if(!contents_resist_step(escapee, 0))
		return FALSE
	. = TRUE
	// todo: mobility flags
	var/extra_time = MODULUS(time, interval)
	var/i
	for(i in 1 to round(time / interval))
		if(!do_after(escapee, interval, mobility_flags = MOBILITY_CAN_RESIST))
			return FALSE
		if(escapee.loc != src)
			return FALSE
		if(!contents_resist_step(escapee, i))
			return FALSE
		if(breakout_sound)
			playsound(src, breakout_sound, breakout_volume, 1)
	if(!do_after(escapee, extra_time, mobility_flags = MOBILITY_CAN_RESIST))
		return FALSE
	if(!contents_resist_step(escapee, i + 1, TRUE))
		return FALSE
	STOP_INTERACTING_WITH(escapee, src, INTERACTING_FOR_RESIST)
	if(.)
		contents_resist_finish(escapee)

/**
 * called on interval step of contents_request_sequence
 * use this to cancel and open if we're already open / whatever.
 *
 * @return TRUE / FALSE to keep resisting or not
 */
/obj/proc/contents_resist_step(mob/escapee, iteration, finishing)
	contents_resist_shake()
	return TRUE

/**
 * Called when contents_resist_sequence finishes successfully.
 */
/obj/proc/contents_resist_finish(mob/escapee)
	return

/**
 * called to shake during contents resist
 */
/obj/proc/contents_resist_shake()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), 8*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

//? materials

/obj/get_materials()
	. = materials.Copy()

/**
 * initialize materials
 */
/obj/proc/init_materials()
	if(!isnull(material_defaults))
		set_material_parts(material_defaults)
		for(var/key in material_defaults)
			var/mat = material_defaults[key]
			var/amt = material_parts[key]
			materials[mat] += amt

/**
 * sets our material parts to a list by key / value
 * this does not update [materials], you have to do that manually
 * this is usually done in init using init_materials
 */
/obj/proc/set_material_parts(list/parts)
	return
