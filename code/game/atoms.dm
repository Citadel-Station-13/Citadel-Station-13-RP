/atom
	layer = TURF_LAYER //This was here when I got here. Why though?
	var/level = 2

	/// Atom flags
	var/flags = NONE
	///Intearaction flags
	var/interaction_flags_atom = NONE

	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = NONE
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = 1 //filter for actions - used by lighting overlays
	var/atom_say_verb = "says"
	var/bubble_icon = "normal" ///what icon the atom uses for speechbubbles
	var/fluorescent // Shows up under a UV light.

	var/list/atom_colours	 //used to store the different colors on an atom
							//its inherent color, the colored paint applied on it, special color effect etc...

/*		new overlay system
	/// a very temporary list of overlays to remove
	var/list/remove_overlays
	/// a very temporary list of overlays to add
	var/list/add_overlays
*/

	///vis overlays managed by SSvis_overlays to automaticaly turn them like other overlays
	var/list/managed_vis_overlays
	///overlays managed by [update_overlays][/atom/proc/update_overlays] to prevent removing overlays that weren't added by the same proc
	var/list/managed_overlays

	var/list/filter_data //For handling persistent filters

	/// The orbiter comopnent if we're being orbited.
	var/datum/component/orbiter/orbiters

	///Default pixel x shifting for the atom's icon.
	var/base_pixel_x = 0
	///Default pixel y shifting for the atom's icon.
	var/base_pixel_y = 0
	///Used for changing icon states for different base sprites.
	var/base_icon_state

	///Icon-smoothing behavior.
	var/smoothing_flags = NONE
	///What directions this is currently smoothing with. IMPORTANT: This uses the smoothing direction flags as defined in icon_smoothing.dm, instead of the BYOND flags.
	var/smoothing_junction = null //This starts as null for us to know when it's first set, but after that it will hold a 8-bit mask ranging from 0 to 255.
	///Smoothing variable
	var/top_left_corner
	///Smoothing variable
	var/top_right_corner
	///Smoothing variable
	var/bottom_left_corner
	///Smoothing variable
	var/bottom_right_corner
	///What smoothing groups does this atom belongs to, to match canSmoothWith. If null, nobody can smooth with it.
	var/list/smoothing_groups = null
	///List of smoothing groups this atom can smooth with. If this is null and atom is smooth, it smooths only with itself.
	var/list/canSmoothWith = null

	/// Chemistry.
	var/datum/reagents/reagents = null

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom

	// Overlays
	var/list/our_overlays	//our local copy of (non-priority) overlays without byond magic. Use procs in SSoverlays to manipulate
	var/list/priority_overlays	//overlays that should remain on top and not normally removed when using cut_overlay functions, like c4.

	/// base layer - defaults to layer
	var/base_layer
	/// relative layer - position this atom should be in within things of the same base layer. defaults to 0
	var/relative_layer = 0

/atom/New(loc, ...)
	// During dynamic mapload (reader.dm) this assigns the var overrides from the .dmm file
	// Native BYOND maploading sets those vars before invoking New(), by doing this FIRST we come as close to that behavior as we can.
	if(GLOB.use_preloader && (src.type == GLOB._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		world.preloader_load(src)

	if(datum_flags & DF_USE_TAG)
		GenerateTag()

	var/do_initialize = SSatoms.subsystem_initialized
	if(do_initialize != INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return
	// Don't call ..() unless /datum/New() ever exists

// Note: I removed "auto_init" feature (letting types disable auto-init) since it shouldn't be needed anymore.
// 	You can replicate the same by checking the value of the first parameter to initialize() ~Leshana

// Called after New if the map is being loaded, with mapload = TRUE
// Called from base of New if the map is not being loaded, with mapload = FALSE
// This base must be called or derivatives must set initialized to TRUE
// Must not sleep!
// Other parameters are passed from New (excluding loc), this does not happen if mapload is TRUE
// Must return an Initialize hint. Defined in code/__defines/subsystems.dm
/atom/proc/Initialize(mapload, ...)
	// SHOULD_NOT_SLEEP(TRUE)
	// SHOULD_CALL_PARENT(TRUE)
	if(flags & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags |= INITIALIZED

	//atom color stuff
	if(color)
		add_atom_colour(color, FIXED_COLOUR_PRIORITY)

	if(light_power && light_range)
		update_light()

	if (length(smoothing_groups))
		sortTim(smoothing_groups) //In case it's not properly ordered, let's avoid duplicate entries with the same values.
		SET_BITFLAG_LIST(smoothing_groups)
	if (length(canSmoothWith))
		sortTim(canSmoothWith)
		if(canSmoothWith[length(canSmoothWith)] > MAX_S_TURF) //If the last element is higher than the maximum turf-only value, then it must scan turf contents for smoothing targets.
			smoothing_flags |= SMOOTH_OBJ
		SET_BITFLAG_LIST(canSmoothWith)

	if(opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guranteed to be on afterwards anyways.

/*
	if (canSmoothWith)
		canSmoothWith = typelist("canSmoothWith", canSmoothWith)
*/

	ComponentInitialize()

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

// Put your AddComponent() calls here
/atom/proc/ComponentInitialize()
	return

/**
 * Top level of the destroy chain for most atoms
 *
 * Cleans up the following:
 * * Removes alternate apperances from huds that see them
 * * qdels the reagent holder from atoms if it exists
 * * clears the orbiters list
 * * clears overlays and priority overlays
 * * clears the light object
 */
/atom/Destroy()
/*
	if(alternate_appearances)
		for(var/K in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
			AA.remove_from_hud(src)
*/

	if(reagents)
		qdel(reagents)

	orbiters = null // The component is attached to us normaly and will be deleted elsewhere

	LAZYCLEARLIST(overlays)

/*
	for(var/i in targeted_by)
		var/mob/M = i
		LAZYREMOVE(M.do_afters, src)
	targeted_by = null
*/

	QDEL_NULL(light)

	return ..()

/atom/proc/reveal_blood()
	return

//return flags that should be added to the viewer's sight var.
//Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 0
	return -1

/atom/proc/Bumped(AM as mob|obj)
	set waitfor = FALSE

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

// If you want to use this, the atom must have the PROXMOVE flag, and the moving
// atom must also have the PROXMOVE flag currently to help with lag. ~ ComicIronic
/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return


/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

// Called when a blob expands onto the tile the atom occupies.
/atom/proc/blob_act()
	return

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

/atom/proc/get_examine_name(mob/user)
	. = "\a [src]"
	var/list/override = list(gender == PLURAL ? "some" : "a", " ", "[name]")

	var/should_override = FALSE

	if(SEND_SIGNAL(src, COMSIG_ATOM_GET_EXAMINE_NAME, user, override) & COMPONENT_EXNAME_CHANGED)
		should_override = TRUE


	if(blood_DNA && !istype(src, /obj/effect/decal))
		override[EXAMINE_POSITION_BEFORE] = " blood-stained "
		should_override = TRUE

	if(should_override)
		. = override.Join("")

///Generate the full examine string of this atom (including icon for goonchat)
/atom/proc/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(thing = src, target = user)] [thats? "That's ":""][get_examine_name(user)]"
// todo:
/atom/proc/examine(mob/user)
	. = list("[get_examine_string(user, TRUE)].")

	if(desc)
		. += desc

	if(reagents)
		if(is_open_container())
			. += "It contains:"
			if(length(reagents.reagent_list))
				if(user.can_see_reagents()) //Show each individual reagent
					for(var/datum/reagent/R in reagents.reagent_list)
						. += "[R.volume] units of [R.name]"
				else //Otherwise, just show the total volume
					var/total_volume = 0
					for(var/datum/reagent/R in reagents.reagent_list)
						total_volume += R.volume
					. += "[total_volume] units of various reagents"
			else
				. += "Nothing."


	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/**
 * Updates the appearence of the icon
 *
 * Mostly delegates to update_name, update_desc, and update_icon
 *
 * Arguments:
 * - updates: A set of bitflags dictating what should be updated. Defaults to [ALL]
 */
/atom/proc/update_appearance(updates=ALL)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	. = NONE
	updates &= ~SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_APPEARANCE, updates)
	if(updates & UPDATE_NAME)
		. |= update_name(updates)
	if(updates & UPDATE_DESC)
		. |= update_desc(updates)
	if(updates & UPDATE_ICON)
		. |= update_icon(updates)

/// Updates the name of the atom
/atom/proc/update_name(updates=ALL)
	// SHOULD_CALL_PARENT(TRUE)
	return SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_NAME, updates)

/// Updates the description of the atom
/atom/proc/update_desc(updates=ALL)
	// SHOULD_CALL_PARENT(TRUE)
	return SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_DESC, updates)

/// Updates the icon of the atom
/atom/proc/update_icon(updates=ALL)
	SIGNAL_HANDLER
	// SHOULD_CALL_PARENT(TRUE)

	. = NONE
	updates &= ~SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_ICON, updates)
	if(updates & UPDATE_ICON_STATE)
		update_icon_state()
		. |= UPDATE_ICON_STATE

	if(updates & UPDATE_OVERLAYS)
		if(LAZYLEN(managed_vis_overlays))
			SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)

		var/list/new_overlays = update_overlays(updates)
		if(managed_overlays)
			cut_overlay(managed_overlays)
			managed_overlays = null
		if(length(new_overlays))
			if (length(new_overlays) == 1)
				managed_overlays = new_overlays[1]
			else
				managed_overlays = new_overlays
			add_overlay(new_overlays)
		. |= UPDATE_OVERLAYS

	. |= SEND_SIGNAL(src, COMSIG_ATOM_UPDATED_ICON, updates, .)

/// Updates the icon state of the atom
/atom/proc/update_icon_state()
	SHOULD_CALL_PARENT(TRUE)
	return SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_ICON_STATE)

/// Updates the overlays of the atom
/atom/proc/update_overlays()
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_OVERLAYS, .)

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

// Called to set the atom's density and used to add behavior to density changes.
/atom/proc/set_density(var/new_density)
	if(density == new_density)
		return FALSE
	density = !!new_density // Sanitize to be strictly 0 or 1
	return TRUE

// Called to set the atom's invisibility and usd to add behavior to invisibility changes.
/atom/proc/set_invisibility(var/new_invisibility)
	if(invisibility == new_invisibility)
		return FALSE
	invisibility = new_invisibility
	return TRUE

/atom/proc/ex_act()
	return

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return -1

/atom/proc/fire_act()
	return


// Returns an assoc list of RCD information.
// Example would be: list(RCD_VALUE_MODE = RCD_DECONSTRUCT, RCD_VALUE_DELAY = 50, RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 4)
// This occurs before rcd_act() is called, and it won't be called if it returns FALSE.
/atom/proc/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/atom/proc/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return

/atom/proc/melt()
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	if (density)
		AM.throwing = 0
	return

/atom/proc/add_hiddenprint(mob/living/M as mob)
	if(isnull(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna))
			return 0
		if (H.gloves)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 0
		if (!( src.fingerprints ))
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 1
	else
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",M.real_name, M.key)
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/M, ignoregloves, obj/item/tool)
	if(isnull(M))
		return
	if(isAI(M))
		return
	if(!M || !M.key)
		return
	if(istype(tool) && (tool.flags & NOPRINT))
		return
	if (ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if (mFingerprints in M.mutations)
			if(fingerprintslast != M.key)
				fingerprintshidden += "[time_stamp()]: [key_name(M)] (No fingerprints mutation)"
				fingerprintslast = M.key
			return 0		//Now, lets get to the dirty work.
		//First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna) || !H.dna.uni_identity || (length(H.dna.uni_identity) != 32))
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				fingerprintshidden += "[time_stamp()]: [key_name(H)] (Wearing [H.gloves])"
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		//Deal with gloves the pass finger/palm prints.
		if(!ignoregloves)
			if(H.gloves && H.gloves != src)
				if(istype(H.gloves, /obj/item/clothing/gloves))
					var/obj/item/clothing/gloves/G = H.gloves
					if(!prob(G.fingerprint_chance))
						return 0

		//More adminstuffz
		if(fingerprintslast != H.key)
			fingerprintshidden += "[time_stamp()]: [key_name(H)]"
			fingerprintslast = H.key

		//Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		//Hash this shit.
		var/full_print = H.get_full_print()

		// Add the fingerprints
		//
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.

				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print 		// You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print     	//Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print		//Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print		//Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0,50)) 	// small chance you can smudge.
					else
						fingerprints[full_print] = full_print

		else
			fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.


		return 1
	else
		//Smudge up dem prints some
		if(fingerprintslast != M.key)
			fingerprintshidden += "[time_stamp()]: [key_name(M)]"
			fingerprintslast = M.key

	//Cleaning up shit.
	if(fingerprints && !fingerprints.len)
		qdel(fingerprints)
	return


/atom/proc/transfer_fingerprints_to(var/atom/A)

	if(!istype(A.fingerprints,/list))
		A.fingerprints = list()

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	//skytodo
	//A.fingerprints |= fingerprints            //detective
	//A.fingerprintshidden |= fingerprintshidden    //admin
	if(A.fingerprints && fingerprints)
		A.fingerprints |= fingerprints.Copy()            //detective
	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin	A.fingerprintslast = fingerprintslast


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)

	if(flags & NOBLOODY)
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = 1
	if(!blood_color)
		blood_color = "#A10808"
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		blood_color = M.species.get_blood_colour(M)
	. = 1
	return 1

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)
		this.virus2 = virus_copylist(M.virus2)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	src.germ_level = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1

/atom/proc/get_global_map_pos()
	if(!islist(global_map) || !length(global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global_map.len,cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	to_chat(world, "X = [cur_x]; Y = [cur_y]")
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return (pass_flags&passflag)

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0

// Show a message to all mobs and objects in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(message, self_message, blind_message, range = world.view)

	//VOREStation Edit
	var/list/see
	if(isbelly(loc))
		var/obj/belly/B = loc
		see = B.get_mobs_and_objs_in_belly()
	else
		see = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)
	//VOREStation Edit End

	var/list/seeing_mobs = see["mobs"]
	var/list/seeing_objs = see["objs"]

	for(var/obj in seeing_objs)
		var/obj/O = obj
		O.show_message(message, 1, blind_message, 2)
	for(var/mob in seeing_mobs)
		var/mob/M = mob
		if(self_message && (M == src))
			M.show_message( self_message, 1, blind_message, 2)
		else if((M.see_invisible >= invisibility) && MOB_CAN_SEE_PLANE(M, plane))
			M.show_message(message, 1, blind_message, 2)
		else if(blind_message)
			M.show_message(blind_message, 2)

// Show a message to all mobs and objects in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance)

	var/range = hearing_distance || world.view
	var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)

	var/list/hearing_mobs = hear["mobs"]
	var/list/hearing_objs = hear["objs"]

	for(var/obj in hearing_objs)
		var/obj/O = obj
		O.show_message(message, 2, deaf_message, 1)

	for(var/mob in hearing_mobs)
		var/mob/M = mob
		var/msg = message
		M.show_message(msg, 2, deaf_message, 1)

/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return moveToNullspace()

/atom/proc/onDropInto(var/atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.

/atom/proc/InsertedContents()
	return contents

/atom/proc/drop_location()
	var/atom/L = loc
	if(!L)
		return null
	return L.AllowDrop() ? L : L.drop_location()

/atom/proc/AllowDrop()
	return FALSE

/atom/proc/get_nametag_name(mob/user)
	return name

/atom/proc/get_nametag_desc(mob/user)
	return "" //Desc itself is often too long to use

/atom/proc/GenerateTag()
	return

/atom/proc/atom_say(message)
	if(!message)
		return
	var/list/speech_bubble_hearers = list()
	for(var/mob/M in get_hearers_in_view(7, src))
		M.show_message("<span class='game say'><span class='name'>[src]</span> [atom_say_verb], \"[message]\"</span>", 2, null, 1)
		if(M.client)
			speech_bubble_hearers += M.client

	if(length(speech_bubble_hearers))
		var/image/I = generate_speech_bubble(src, "[bubble_icon][say_test(message)]", FLY_LAYER)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, /.proc/flick_overlay, I, speech_bubble_hearers, 30)

/atom/proc/speech_bubble(bubble_state = "", bubble_loc = src, list/bubble_recipients = list())
	return

/*
	Atom Colour Priority System
	A System that gives finer control over which atom colour to colour the atom with.
	The "highest priority" one is always displayed as opposed to the default of
	"whichever was set last is displayed"
*/

/*
	Adds an instance of colour_type to the atom's atom_colours list
*/
/atom/proc/add_atom_colour(coloration, colour_priority)
	if(!atom_colours || !atom_colours.len)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(!coloration)
		return
	if(colour_priority > atom_colours.len)
		return
	atom_colours[colour_priority] = coloration
	update_atom_colour()

/*
	Removes an instance of colour_type from the atom's atom_colours list
*/
/atom/proc/remove_atom_colour(colour_priority, coloration)
	if(!atom_colours)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(colour_priority > atom_colours.len)
		return
	if(coloration && atom_colours[colour_priority] != coloration)
		return //if we don't have the expected color (for a specific priority) to remove, do nothing
	atom_colours[colour_priority] = null
	update_atom_colour()

/*
	Resets the atom's color to null, and then sets it to the highest priority
	colour available
*/
/atom/proc/update_atom_colour()
	if(!atom_colours)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	color = null
	for(var/C in atom_colours)
		if(islist(C))
			var/list/L = C
			if(L.len)
				color = L
				return
		else if(C)
			color = C
			return

///Setter for the `base_pixel_x` variable to append behavior related to its changing.
/atom/proc/set_base_pixel_x(new_value)
	if(base_pixel_x == new_value)
		return
	. = base_pixel_x
	base_pixel_x = new_value

	pixel_x = pixel_x + base_pixel_x - .


///Setter for the `base_pixel_y` variable to append behavior related to its changing.
/atom/proc/set_base_pixel_y(new_value)
	if(base_pixel_y == new_value)
		return
	. = base_pixel_y
	base_pixel_y = new_value

	pixel_y = pixel_y + base_pixel_y - .

/**
  * Returns true if this atom has gravity for the passed in turf
  *
  * Sends signals COMSIG_ATOM_HAS_GRAVITY and COMSIG_TURF_HAS_GRAVITY, both can force gravity with
  * the forced gravity var
  *
  * Gravity situations:
  * * No gravity if you're not in a turf
  * * No gravity if this atom is in is a space turf
  * * Gravity if the area it's in always has gravity
  * * Gravity if there's a gravity generator on the z level
  * * Gravity if the Z level has an SSMappingTrait for ZTRAIT_GRAVITY
  * * otherwise no gravity
  */
/atom/proc/has_gravity(turf/T)
	if(!T || !isturf(T))
		T = get_turf(src)

	if(!T)
		return 0

/*
	var/list/forced_gravity = list()
	SEND_SIGNAL(src, COMSIG_ATOM_HAS_GRAVITY, T, forced_gravity)
	if(!forced_gravity.len)
		SEND_SIGNAL(T, COMSIG_TURF_HAS_GRAVITY, src, forced_gravity)
	if(forced_gravity.len)
		var/max_grav
		for(var/i in forced_gravity)
			max_grav = max(max_grav, i)
		return max_grav
*/

	if(isspaceturf(T)) // Turf never has gravity
		return 0

	var/area/A = get_area(T)
	if(A.has_gravity) // Areas which always has gravity
		return A.has_gravity
/*
	else
		// There's a gravity generator on our z level
		if(GLOB.gravity_generators["[T.z]"])
			var/max_grav = 0
			for(var/obj/machinery/gravity_generator/main/G in GLOB.gravity_generators["[T.z]"])
				max_grav = max(G.setting,max_grav)
			return max_grav
*/
	return SSmapping.level_trait(T.z, ZTRAIT_GRAVITY)

/atom/proc/is_incorporeal()
	return FALSE

// Tool behavior procedure. Redirects to tool-specific procs by default.
// You can override it to catch all tool interactions, for use in complex deconstruction procs.
// Just don't forget to return ..() in the end.
/atom/proc/tool_act(mob/living/user, obj/item/I, tool_type)
	switch(tool_type)
		if(TOOL_CROWBAR)
			return crowbar_act(user, I)
		if(TOOL_MULTITOOL)
			return multitool_act(user, I)
		if(TOOL_SCREWDRIVER)
			return screwdriver_act(user, I)
		if(TOOL_WRENCH)
			return wrench_act(user, I)
		if(TOOL_WIRECUTTER)
			return wirecutter_act(user, I)
		if(TOOL_WELDER)
			return welder_act(user, I)
		if(TOOL_ANALYZER)
			return analyzer_act(user, I)

// Tool-specific behavior procs. To be overridden in subtypes.
/atom/proc/crowbar_act(mob/living/user, obj/item/I)
	return

/atom/proc/multitool_act(mob/living/user, obj/item/I)
	return

/atom/proc/multitool_check_buffer(user, obj/item/I, silent = FALSE)
	if(!I.tool_behaviour == TOOL_MULTITOOL)
		if(user && !silent)
			to_chat(user, "<span class='warning'>[I] has no data buffer!</span>")
		return FALSE
	return TRUE

/atom/proc/screwdriver_act(mob/living/user, obj/item/I)
	SEND_SIGNAL(src, COMSIG_ATOM_SCREWDRIVER_ACT, user, I)

/atom/proc/wrench_act(mob/living/user, obj/item/I)
	return

/atom/proc/wirecutter_act(mob/living/user, obj/item/I)
	return

/atom/proc/welder_act(mob/living/user, obj/item/I)
	return

/atom/proc/analyzer_act(mob/living/user, obj/item/I)
	return

/atom/proc/CheckParts(list/parts_list)
	for(var/A in parts_list)
		if(istype(A, /datum/reagent))
			if(!reagents)
				reagents = new()
			reagents.reagent_list.Add(A)
			reagents.conditional_update()
		else if(ismovable(A))
			var/atom/movable/M = A
			if(isliving(M.loc))
				var/mob/living/L = M.loc
				L.transferItemToLoc(M, src)
			else
				M.forceMove(src)

/atom/proc/is_drainable()
	return reagents && (reagents.reagents_holder_flags & DRAINABLE)

/atom/proc/add_filter(name,priority,list/params)
	LAZYINITLIST(filter_data)
	var/list/copied_parameters = params.Copy()
	copied_parameters["priority"] = priority
	filter_data[name] = copied_parameters
	update_filters()

/atom/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, /proc/cmp_filter_data_priority, TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))
	UNSETEMPTY(filter_data)

/atom/proc/transition_filter(name, time, list/new_params, easing, loop)
	var/filter = get_filter(name)
	if(!filter)
		return

	var/list/old_filter_data = filter_data[name]

	var/list/params = old_filter_data.Copy()
	for(var/thing in new_params)
		params[thing] = new_params[thing]

	animate(filter, new_params, time = time, easing = easing, loop = loop)
	for(var/param in params)
		filter_data[name][param] = params[param]

/atom/proc/change_filter_priority(name, new_priority)
	if(!filter_data || !filter_data[name])
		return

	filter_data[name]["priority"] = new_priority
	update_filters()

// /obj/item/update_filters()
// 	. = ..()
// 	update_action_buttons()

/atom/proc/get_filter(name)
	if(filter_data && filter_data[name])
		return filters[filter_data.Find(name)]

/atom/proc/remove_filter(name_or_names)
	if(!filter_data)
		return

	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(filter_data[name])
			filter_data -= name
	update_filters()

/atom/proc/clear_filters()
	filter_data = null
	filters = null

/**
 * set the new base layer we should be on
 */
/atom/proc/set_base_layer(new_layer)
	ASSERT(isnum(new_layer))
	base_layer = new_layer
	// rel layer being null is fine
	layer = base_layer + 0.000001 * relative_layer

/**
 * set the relative layer within our layer we should be on
 */
/atom/proc/set_relative_layer(new_layer)
	ASSERT(isnum(new_layer))
	if(isnull(base_layer))
		base_layer = layer
	relative_layer = new_layer
	// base layer being null isn't
	layer = base_layer + 0.000001 * relative_layer

/atom/proc/get_cell()
	return
