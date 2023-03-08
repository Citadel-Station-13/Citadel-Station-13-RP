/**
 * The base type for nearly all physical objects in SS13

 * Lots and lots of functionality lives here, although in general we are striving to move
 * as much as possible to the components/elements system
 */
/atom
	layer = TURF_LAYER

	//? Core
	/// Atom flags.
	var/atom_flags = NONE

	//? Interaction
	/// Intearaction flags.
	var/interaction_flags_atom = NONE

	//? Physics
	/// pass_flags that we are. If any of this matches a pass_flag on a moving thing, by default, we let them through.
	var/pass_flags_self = NONE

	//? Unsorted / Legacy
	var/level = 2
	/// Used for changing icon states for different base sprites.
	var/base_icon_state
	/// Holder for the last time we have been bumped.
	var/last_bumped = 0
	/// The higher the germ level, the more germ on the atom.
	var/germ_level = GERM_LEVEL_AMBIENT
	/// The 'action' the atom takes to speak.
	var/atom_say_verb = "says"
	/// What icon the atom uses for speechbubbles.
	var/bubble_icon = "normal"

	//? Economy
	/// intrinsic worth without accounting containing reagents / materials - applies in static and dynamic mode.
	var/worth_intrinsic = 0
	/// static worth of contents - only read if getting a static worth from typepath.
	var/worth_containing = 0
	/// static worth of raw materials - only read if getting a static worth from typepath.
	var/worth_materials = 0
	/// intrinsic worth default markup when buying as factor (2 for 2x)
	var/worth_buy_factor = WORTH_BUY_FACTOR_DEFAULT
	/// intrinsic elasticity as factor, 2 = 2x easy to inflate market
	var/worth_elasticity = WORTH_ELASTICITY_DEFAULT
	/**
	 * * DANGER * - do not touch this variable unless you know what you are doing.
	 *
	 * This signifies that procs have a non-negligible randomization on a *freshly-spawned* instance of this object.
	 * This is not the case for most closets / lockers / crates / storage that spawn with items.
	 * In those cases, use the other variables to control its static worth.
	 *
	 * This means that things like cargo should avoid "intuiting" the value of this object
	 * through initial()'s alone.
	 */
	var/worth_dynamic = FALSE

	//? Colors
	/**
	 * used to store the different colors on an atom
	 *
	 * its inherent color, the colored paint applied on it, special color effect etc...
	 */
	var/list/atom_colours

	//? Health
	// todo: every usage of these vars need to be parsed because shitcode still exists that
	// todo: was just monkey patched over by making it not compile error for redefining this..
	/// max health
	var/max_integrity
	/// health
	var/integrity
	/// what integrity we call break at.
	var/failure_integrity = 0
	/// do we use the atom damage system?
	var/use_integrity = FALSE
	// todo: use integrity & procs on turf and obj level
	// todo: armor system, how?

	//? HUDs
	/// This atom's HUD (med/sec, etc) images. Associative list.
	var/list/image/hud_list = null
	/// HUD images that this atom can provide.
	var/list/hud_possible

	//? Icon Smoothing
	/// Icon-smoothing behavior.
	var/smoothing_flags = NONE
	/// What directions this is currently smoothing with. IMPORTANT: This uses the smoothing direction flags as defined in icon_smoothing.dm, instead of the BYOND flags.
	var/smoothing_junction = null //This starts as null for us to know when it's first set, but after that it will hold a 8-bit mask ranging from 0 to 255.
	/// Smoothing variable
	var/top_left_corner
	/// Smoothing variable
	var/top_right_corner
	/// Smoothing variable
	var/bottom_left_corner
	/// Smoothing variable
	var/bottom_right_corner
	/**
	 * What smoothing groups does this atom belongs to, to match canSmoothWith.
	 * If null, nobody can smooth with it.
	 *! Must be sorted.
	 */
	var/list/smoothing_groups = null
	/**
	 * List of smoothing groups this atom can smooth with.
	 * If this is null and atom is smooth, it smooths only with itself.
	 *! Must be sorted.
	 */
	var/list/canSmoothWith = null

	//? Chemistry
	// todo: properly finalize the semantics of this variable and what it's for.
	var/datum/reagents/reagents = null

	//? Detective Work
	// todo: rework a lot of this, especially flurescent
	/// Used for the duplicate data points kept in the scanners.
	var/list/original_atom
	/// List of all fingerprints on the atom.
	var/list/fingerprints
	/// Same as fingerprints, but only can be seen via VV.
	var/list/fingerprintshidden
	/// Last fingerprints to touch this atom.
	var/fingerprintslast = null
	/// Status flag for if this atom has blood on it.
	var/was_bloodied
	/// Holder for the dna the blood on this atom.
	var/list/blood_DNA
	/// The color of the blood on this atom.
	var/blood_color
	/// Shows up under a UV light.
	var/fluorescent

	//? Radiation
	/// radiation flags
	var/rad_flags = RAD_NO_CONTAMINATE	// overridden to NONe in /obj and /mob base
	/// radiation insulation - does *not* affect rad_act!
	var/rad_insulation = RAD_INSULATION_NONE
	/// contamination insulation; null defaults to rad_insulation
	var/rad_stickiness

	//? Overlays
	/// vis overlays managed by SSvis_overlays to automaticaly turn them like other overlays.
	var/list/managed_vis_overlays
	/// overlays managed by [update_overlays][/atom/proc/update_overlays] to prevent removing overlays that weren't added by the same proc. Single items are stored on their own, not in a list.
	var/list/managed_overlays

	//? Layers
	/// Base layer - defaults to layer.
	var/base_layer
	/// Relative layer - position this atom should be in within things of the same base layer. defaults to 0.
	var/relative_layer = 0

	//? Pixel Offsets
	/// Default pixel x shifting for the atom's icon.
	var/base_pixel_x = 0
	/// Default pixel y shifting for the atom's icon.
	var/base_pixel_y = 0
	/// expected icon width; centering offsets will be calculated from this and our base pixel x.
	var/icon_dimension_x = 32
	/// expected icon height; centering offsets will be calculated from this and our base pixel y.
	var/icon_dimension_y = 32

	//? Filters
	/// For handling persistent filters
	var/list/filter_data

	//? Misc
	/// What mobs are interacting with us right now, associated directly to concurrent interactions. (use defines)
	var/list/interacting_mobs
	/// The orbiter comopnent if we're being orbited.
	var/datum/component/orbiter/orbiters

/**
 * Called when an atom is created in byond (built in engine proc)
 *
 * Not a lot happens here in SS13 code, as we offload most of the work to the
 * [Intialization][/atom/proc/Initialize] proc, mostly we run the preloader
 * if the preloader is being used and then call [InitAtom][/datum/controller/subsystem/atoms/proc/InitAtom] of which the ultimate
 * result is that the Intialize proc is called.
 *
 * We also generate a tag here if the DF_USE_TAG flag is set on the atom
 */
/atom/New(loc, ...)
	//atom creation method that preloads variables at creation
	if(GLOB.use_preloader && (src.type == GLOB._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		world.preloader_load(src)

	if(datum_flags & DF_USE_TAG)
		GenerateTag()

	var/do_initialize = SSatoms.initialized
	if(do_initialize != INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return

/**
 * The primary method that objects are setup in SS13 with
 *
 * we don't use New as we have better control over when this is called and we can choose
 * to delay calls or hook other logic in and so forth
 *
 * During roundstart map parsing, atoms are queued for intialization in the base atom/New(),
 * After the map has loaded, then Initalize is called on all atoms one by one. NB: this
 * is also true for loading map templates as well, so they don't Initalize until all objects
 * in the map file are parsed and present in the world
 *
 * If you're creating an object at any point after SSInit has run then this proc will be
 * immediately be called from New.
 *
 * mapload: This parameter is true if the atom being loaded is either being intialized during
 * the Atom subsystem intialization, or if the atom is being loaded from the map template.
 * If the item is being created at runtime any time after the Atom subsystem is intialized then
 * it's false.
 *
 * The mapload argument occupies the same position as loc when Initialize() is called by New().
 * loc will no longer be needed after it passed New(), and thus it is being overwritten
 * with mapload at the end of atom/New() before this proc (atom/Initialize()) is called.
 *
 * You must always call the parent of this proc, otherwise failures will occur as the item
 * will not be seen as initalized (this can lead to all sorts of strange behaviour, like
 * the item being completely unclickable)
 *
 * !Note: Ignore the note below until the first two lines of the proc are uncommented. -Zandario
 * You must not sleep in this proc, or any subprocs
 *
 * Any parameters from new are passed through (excluding loc), naturally if you're loading from a map
 * there are no other arguments
 *
 * Must return an [initialization hint][INITIALIZE_HINT_NORMAL] or a runtime will occur.
 *
 * !Note: the following functions don't call the base for optimization and must copypasta handling:
 * * [/turf/proc/Initialize]
 */
/atom/proc/Initialize(mapload, ...)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(atom_flags & ATOM_INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_INITIALIZED

	if (is_datum_abstract())
		log_debug("Abstract atom [type] created!")
		return INITIALIZE_HINT_QDEL

	if(loc)
		SEND_SIGNAL(loc, COMSIG_ATOM_INITIALIZED_ON, src) /// Sends a signal that the new atom `src`, has been created at `loc`

	//atom color stuff
	if(color)
		add_atom_colour(color, FIXED_COLOUR_PRIORITY)

	if(light_power && light_range)
		update_light()

	SETUP_SMOOTHING()

	if(opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guranteed to be on afterwards anyways.

	return INITIALIZE_HINT_NORMAL

/**
 * Late Intialization, for code that should run after all atoms have run Intialization
 *
 * To have your LateIntialize proc be called, your atoms [Initalization][/atom/proc/Initialize]
 *  proc must return the hint
 * [INITIALIZE_HINT_LATELOAD] otherwise you will never be called.
 *
 * useful for doing things like finding other machines on GLOB.machines because you can guarantee
 * that all atoms will actually exist in the "WORLD" at this time and that all their Intialization
 * code has been run
 */
/atom/proc/LateInitialize()
	set waitfor = FALSE

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
/atom/Destroy(force)
	if(alternate_appearances)
		for(var/current_alternate_appearance in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/selected_alternate_appearance = alternate_appearances[current_alternate_appearance]
			selected_alternate_appearance.remove_from_hud(src)

	if(reagents)
		QDEL_NULL(reagents)

	orbiters = null // The component is attached to us normaly and will be deleted elsewhere

	LAZYCLEARLIST(overlays)
	LAZYNULL(managed_overlays)

	if(light)
		QDEL_NULL(light)

	if(smoothing_flags & SMOOTH_QUEUED)
		SSicon_smooth.remove_from_queues(src)

	return ..()

/atom/proc/reveal_blood()
	return

/// Return flags that should be added to the viewer's sight var.
// Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 0
	return -1

/atom/proc/Bumped(atom/movable/bumped_atom)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_ATOM_BUMPED, bumped_atom)

/// Convenience proc to see if a container is open for chemistry handling.
/atom/proc/is_open_container()
	return atom_flags & OPENCONTAINER

///Is this atom within 1 tile of another atom
/atom/proc/HasProximity(atom/movable/proximity_check_mob as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	// todo: SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_EMP_ACT, severity)


/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

// Called when a blob expands onto the tile the atom occupies.
/atom/proc/blob_act()
	return

///Return true if we're inside the passed in atom
/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return TRUE
	else if(src in container)
		return TRUE
	return FALSE

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
	. = "\a <b>[src]</b>"
	var/list/override = list(gender == PLURAL ? "some" : "a", " ", "[name]")

	var/should_override = FALSE

	if(SEND_SIGNAL(src, COMSIG_ATOM_GET_EXAMINE_NAME, user, override) & COMPONENT_EXNAME_CHANGED)
		should_override = TRUE


	if(blood_DNA && !istype(src, /obj/effect/decal))
		override[EXAMINE_POSITION_BEFORE] = " blood-stained "
		should_override = TRUE

	if(should_override)
		. = override.Join("")

/// Generate the full examine string of this atom (including icon for goonchat)
/atom/proc/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(src, user)] [thats? "That's ":""][get_examine_name(user)]"

/**
 * Returns an extended list of examine strings for any contained ID cards.
 *
 * Arguments:
 * * user - The user who is doing the examining.
 */
/atom/proc/get_id_examine_strings(mob/user)
	. = list()
	return

/// Used to insert text after the name but before the description in examine()
/atom/proc/get_name_chaser(mob/user, list/name_chaser = list())
	return name_chaser

/**
 * Called when a mob examines (shift click or verb) this atom
 *
 * Default behaviour is to get the name and icon of the object and it's reagents where
 * the [TRANSPARENT] flag is set on the reagents holder
 *
 * Produces a signal [COMSIG_PARENT_EXAMINE]
 */
/atom/proc/examine(mob/user)
	var/examine_string = get_examine_string(user, thats = TRUE)
	if(examine_string)
		. = list("[examine_string].")
	else
		. = list()

	. += get_name_chaser(user)
	if(desc)
		. += "<hr>[desc]"
/*
	if(custom_materials)
		var/list/materials_list = list()
		for(var/datum/material/current_material as anything in custom_materials)
			materials_list += "[current_material.name]"
		. += "<u>It is made out of [english_list(materials_list)]</u>."
*/
	if(reagents)
		if(reagents.reagents_holder_flags & TRANSPARENT)
			. += "It contains:"
			if(length(reagents.reagent_list))
				if(user.can_see_reagents()) //Show each individual reagent
					for(var/datum/reagent/current_reagent as anything in reagents.reagent_list)
						. += "&bull; [round(current_reagent.volume, 0.01)] units of [current_reagent.name]"
				else //Otherwise, just show the total volume
					var/total_volume = 0
					for(var/datum/reagent/current_reagent as anything in reagents.reagent_list)
						total_volume += current_reagent.volume
					. += "[total_volume] units of various reagents"
			else
				. += "Nothing."
		else if(reagents.reagents_holder_flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				. += SPAN_NOTICE("It has [reagents.total_volume] unit\s left.")
			else
				. += SPAN_DANGER("It's empty.")

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/**
 * Called when a mob examines (shift click or verb) this atom twice (or more) within EXAMINE_MORE_WINDOW (default 1 second)
 *
 * This is where you can put extra information on something that may be superfluous or not important in critical gameplay
 * moments, while allowing people to manually double-examine to take a closer look
 *
 * Produces a signal [COMSIG_PARENT_EXAMINE_MORE]
 */
/atom/proc/examine_more(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE_MORE, user, .)


// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

/atom/proc/relaymove_from_contents(mob/user, direction)
	return relaymove(user, direction)

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

/**
 * React to being hit by an explosion
 *
 * Should be called through the [EX_ACT] wrapper macro.
 * The wrapper takes care of the [COMSIG_ATOM_EX_ACT] signal.
 * as well as calling [/atom/proc/contents_explosion].
 */
/atom/proc/legacy_ex_act(severity, target)
	set waitfor = FALSE

/**
 * todo: implement on most atoms/generic damage system
 * todo: replace legacy_ex_act entirely with this
 *
 * React to being hit by an explosive shockwave
 *
 * ? Tip for overrides: . = ..() when you want signal to be sent, mdify power before if you need to; to ignore parent
 * ? block power, just `return power` in your proc after . = ..().
 *
 * @params
 * - power - power our turf was hit with
 * - direction - DIR_BIT bits; can bwe null if it wasn't a wave explosion!!
 * - explosion - explosion automata datum; can be null
 *
 * @return power after falloff (e.g. hit with 30 power, return 20 to apply 10 falloff)
 */
/atom/proc/ex_act(power, dir, datum/automata/wave/explosion/E)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, power, dir, E)
	return power

// todo: this really needs to be refactored
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
	if(istype(tool) && (tool.atom_flags & NOPRINT))
		return
	if (ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if (MUTATION_NOPRINTS in M.mutations)
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


/// Returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)

	if(atom_flags & NOBLOODY)
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
		var/obj/effect/debris/cleanable/vomit/this = new /obj/effect/debris/cleanable/vomit(src)
		this.virus2 = virus_copylist(M.virus2)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

/atom/proc/clean_blood()
	if(atom_flags & ATOM_ABSTRACT)
		return
	fluorescent = 0
	src.germ_level = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0

/// Show a message to all mobs and objects in sight of this atom
/// Use for objects performing visible actions
/// message is output to anyone who can see, e.g. "The [src] does something!"
/// blind_message (optional) is what blind people will hear e.g. "You hear something!"
// todo: refactor
/atom/proc/visible_message(message, self_message, blind_message, range = world.view)
	var/list/see
	if(isbelly(loc))
		var/obj/belly/B = loc
		see = B.effective_emote_hearers()
	else
		see = get_hearers_in_view(range, src)
	for(var/atom/movable/AM as anything in see)
		if(ismob(AM))
			var/mob/M = AM
			if(self_message && (M == src))
				M.show_message(self_message, 1, blind_message, 2)
			else if((M.see_invisible >= invisibility) && MOB_CAN_SEE_PLANE(M, plane))
				M.show_message(message, 1, blind_message, 2)
			else if(blind_message)
				M.show_message(blind_message, 2)
		else
			AM.show_message(message, 1, blind_message, 2)

// todo: refactor
/atom/movable/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/// Show a message to all mobs and objects in earshot of this atom
/// Use for objects performing audible actions
/// message is the message output to anyone who can hear.
/// deaf_message (optional) is what deaf people will see.
/// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance, datum/language/lang)

	var/range = hearing_distance || world.view
	var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)

	var/list/hearing_mobs = hear["mobs"]
	var/list/hearing_objs = hear["objs"]
	var/list/heard_to_floating_message = list()
	for(var/obj in hearing_objs)
		var/obj/O = obj
		O.show_message(message, 2, deaf_message, 1)

	var/no_runechat = FALSE
	for(var/mob in hearing_mobs)
		var/mob/M = mob
		var/msg = message
		if(lang && !(lang.name in M.languages))
			msg = lang.scramble(msg)
		M.show_message(msg, 2, deaf_message, 1)
		heard_to_floating_message += M
	if(!no_runechat)
		INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, (message ? message : deaf_message), null, FALSE, heard_to_floating_message, 30)

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

/// Where atoms should drop if taken from this atom.
/atom/proc/drop_location()
	var/atom/location = loc
	if(!location)
		return null
	return location.AllowDrop() ? location : location.drop_location()

/atom/proc/AllowDrop()
	return FALSE

/atom/proc/get_nametag_name(mob/user)
	return name

/atom/proc/get_nametag_desc(mob/user)
	return "" //Desc itself is often too long to use

/atom/proc/GenerateTag()
	return

//? Radiation

/**
 * called when we're hit by a radiation wave
 */
/atom/proc/rad_act(strength, datum/radiation_wave/wave)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_RAD_ACT, strength)

/**
 * called when we're hit by z radiation
 */
/atom/proc/z_rad_act(strength)
	SHOULD_CALL_PARENT(TRUE)
	rad_act(strength)

/atom/proc/add_rad_block_contents(source)
	ADD_TRAIT(src, TRAIT_ATOM_RAD_BLOCK_CONTENTS, source)
	rad_flags |= RAD_BLOCK_CONTENTS

/atom/proc/remove_rad_block_contents(source)
	REMOVE_TRAIT(src, TRAIT_ATOM_RAD_BLOCK_CONTENTS, source)
	if(!HAS_TRAIT(src, TRAIT_ATOM_RAD_BLOCK_CONTENTS))
		rad_flags &= ~RAD_BLOCK_CONTENTS

/atom/proc/clean_radiation(str, mul, cheap)
	var/datum/component/radioactive/RA = GetComponent(/datum/component/radioactive)
	RA?.clean(str, mul)

//? Atom Colour Priority System
/**
 * A System that gives finer control over which atom colour to colour the atom with.
 * The "highest priority" one is always displayed as opposed to the default of
 * "whichever was set last is displayed"
 */

/// Adds an instance of colour_type to the atom's atom_colours list
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

/// Removes an instance of colour_type from the atom's atom_colours list
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

/// Resets the atom's color to null, and then sets it to the highest priority colour available
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

/**
 * Returns true if this atom has gravity for the passed in turf
 *
 * Gravity situations:
 * * No gravity if you're not in a turf
 * * No gravity if this atom is in is a space turf
 * * Gravity if the area it's in always has gravity
 * * Gravity if there's a gravity generator on the z level
 * * Gravity if the Z level has an SSMappingTrait for ZTRAIT_GRAVITY
 * * otherwise no gravity
 */
/atom/proc/has_gravity(turf/T = get_turf(src))
	if(!T)
		return FALSE

	return T.has_gravity()

/atom/proc/is_incorporeal()
	return FALSE

/atom/proc/CheckParts(list/parts_list)
	for(var/A in parts_list)
		if(istype(A, /datum/reagent))
			if(!reagents)
				reagents = new()
			reagents.reagent_list.Add(A)
			reagents.conditional_update()
		else if(ismovable(A))
			var/atom/movable/M = A
			M.forceMove(src)

/atom/proc/is_drainable()
	return reagents && (reagents.reagents_holder_flags & DRAINABLE)


/atom/proc/get_cell()
	return

//? Filters

/atom/proc/add_filter(name, priority, list/params, update = TRUE)
	LAZYINITLIST(filter_data)
	var/list/copied_parameters = params.Copy()
	copied_parameters["priority"] = priority
	filter_data[name] = copied_parameters
	if(update)
		update_filters()

/atom/proc/update_filters()
	filters = null
	filter_data = tim_sort(filter_data, /proc/cmp_filter_data_priority, TRUE)
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

/atom/proc/get_filter(name)
	if(filter_data && filter_data[name])
		return filters[filter_data.Find(name)]

/atom/proc/remove_filter(name_or_names, update = TRUE)
	if(!filter_data)
		return

	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(filter_data[name])
			filter_data -= name
	if(update)
		update_filters()

/atom/proc/clear_filters()
	filter_data = null
	filters = null

//? Layers

/// Sets the new base layer we should be on.
/atom/proc/set_base_layer(new_layer)
	ASSERT(isnum(new_layer))
	base_layer = new_layer
	// rel layer being null is fine
	layer = base_layer + 0.001 * relative_layer

/// Set the relative layer within our layer we should be on.
/atom/proc/set_relative_layer(new_layer)
	ASSERT(isnum(new_layer))
	if(isnull(base_layer))
		base_layer = layer
	relative_layer = new_layer
	// base layer being null isn't
	layer = base_layer + 0.001 * relative_layer

/atom/proc/hud_layerise()
	plane = PLANE_PLAYER_HUD_ITEMS
	set_base_layer(LAYER_HUD_ITEM)
	// appearance_flags |= NO_CLIENT_COLOR

/atom/proc/hud_unlayerise()
	plane = initial(plane)
	set_base_layer(initial(layer))
	// appearance_flags &= ~(NO_CLIENT_COLOR)

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	set_base_layer(initial(layer))

//? Pixel Offsets

/atom/proc/set_pixel_x(val)
	pixel_x = val + get_managed_pixel_x()

/atom/proc/set_pixel_y(val)
	pixel_y = val + get_managed_pixel_y()

/atom/proc/reset_pixel_offsets()
	pixel_x = get_managed_pixel_x()
	pixel_y = get_managed_pixel_y()

/**
 * get our pixel_x to reset to
 */
/atom/proc/get_managed_pixel_x()
	return get_standard_pixel_x_offset()

/**
 * get our pixel_y to reset to
 */
/atom/proc/get_managed_pixel_y()
	return get_standard_pixel_y_offset()

/**
 * get the pixel_x needed to center our sprite visually with our current bounds
 */
/atom/proc/get_standard_pixel_x_offset()
	return base_pixel_x

/**
 * get the pixel_y needed to center our sprite visually with our current bounds
 */
/atom/proc/get_standard_pixel_y_offset()
	return base_pixel_y

/**
 * get the pixel_x needed to adjust an atom on our turf **to the position of our visual center**
 *
 * e.g. even if we are a 3x3 sprite with -32 x/y offsets, this would be 0
 * if we were, for some reason, a 4x4 with -32 x/y, this would probably be 16/16 x/y.
 */
/atom/proc/get_centering_pixel_x_offset(dir, atom/aligning)
	return base_pixel_x + (icon_dimension_x - WORLD_ICON_SIZE) / 2

/**
 * get the pixel_y needed to adjust an atom on our turf **to the position of our visual center**
 *
 * e.g. even if we are a 3x3 sprite with -32 x/y offsets, this would be 0
 * if we were, for some reason, a 4x4 with -32 x/y, this would probably be 16/16 x/y.
 */
/atom/proc/get_centering_pixel_y_offset(dir, atom/aligning)
	return base_pixel_y + (icon_dimension_y - WORLD_ICON_SIZE) / 2

/// Setter for the `base_pixel_x` variable to append behavior related to its changing.
/atom/proc/set_base_pixel_x(new_value)
	if(base_pixel_x == new_value)
		return
	. = base_pixel_x
	base_pixel_x = new_value

	pixel_x = pixel_x + base_pixel_x - .

/// Setter for the `base_pixel_y` variable to append behavior related to its changing.
/atom/proc/set_base_pixel_y(new_value)
	if(base_pixel_y == new_value)
		return
	. = base_pixel_y
	base_pixel_y = new_value

	pixel_y = pixel_y + base_pixel_y - .

/// forcefully center us
/atom/proc/auto_pixel_offset_to_center()
	set_base_pixel_y(get_centering_pixel_y_offset())
	set_base_pixel_x(get_centering_pixel_x_offset())
