/**
 * The base type for nearly all physical objects in SS13

 * Lots and lots of functionality lives here, although in general we are striving to move
 * as much as possible to the components/elements system
 */
/atom
	SET_APPEARANCE_FLAGS(TILE_MOVER)
	layer = TURF_LAYER

	//* Core *//

	/// Atom flags.
	var/atom_flags = NONE
	/// Prototype ID; persistence uses this to know what atom to load, even if the path changes in a refactor.
	///
	/// * this is very much a 'set this on type and all subtypes or don't set it at all' situation.
	/// * should be `FormattedLikeThis`.
	var/prototype_id

	//? Interaction
	/// Intearaction flags.
	var/interaction_flags_atom = NONE

	//? Physics
	/// pass_flags that we are. If any of this matches a pass_flag on a moving thing, by default, we let them through.
	var/pass_flags_self = NONE

	//? Unsorted / Legacy
	/// Holder for the last time we have been bumped.
	var/last_bumped = 0
	/// The higher the germ level, the more germ on the atom.
	var/germ_level = GERM_LEVEL_AMBIENT
	/// The 'action' the atom takes to speak.
	var/atom_say_verb = "says"
	/// What icon the atom uses for speechbubbles.
	var/bubble_icon = "normal"

	//? Armor
	/// armor datum - holds armor values
	/// this is lazy initialized, only init'd when armor is fetched
	/// [armor_type] specifies the typepath to fetch if this is null during a fetch
	var/datum/armor/armor
	/// armor datum type
	/// this is the type to init if armor is unset when armor is fetched
	/// * anonymous typepaths are not allowed here
	var/armor_type = /datum/armor/none

	//? Context
	/// open context menus by mob
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/list/context_menus

	//? Integrity
	/// max health
	var/integrity_max
	/// health
	var/integrity
	/// what integrity we call break at.
	var/integrity_failure = 0
	/// do we use the atom damage system? having this off implicitly implies non-targetability for this entity,
	/// completely overriding any object flags at /obj levels for targeting.
	var/integrity_enabled = FALSE
	/// flags for resistances
	var/integrity_flags = NONE

	//* HUDs (Atom)
	/// atom hud typepath to image
	var/list/image/atom_huds

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
	// todo: should this variable even exist? most atoms don't need this, and we can easily have an APi
	//       to fetch a relevant holder upon being inspected by an analyzer.
	var/datum/reagent_holder/reagents = null

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

	//* Materials *//

	/// combined material trait flags
	/// this list is at /atom level but are only used/implemented on /obj generically; anything else, e.g. walls, should implement manually for efficiency.
	/// * this variable is a cache variable and is generated from the materials on an entity.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/material_trait_flags = NONE
	/// material traits on us, associated to metadata
	/// this list is at /atom level but are only used/implemented on /obj generically; anything else, e.g. walls, should implement manually for efficiency.
	/// * this variable is a cache variable and is generated from the materials on an entity.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/list/datum/prototype/material_trait/material_traits
	/// material trait metadata when [material_traits] is a single trait. null otherwise.
	/// * this variable is a cache variable and is generated from the materials on an entity.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/material_traits_data
	/// 'stacks' of ticking
	/// this synchronizes the system so removing one ticking material trait doesn't fully de-tick the entity
	/// * this variable is a cache variable and is generated from the materials on an entity.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/material_ticking_counter = 0
	/// material trait relative strength
	/// applies to all traits globally as opposed to just one material parts,
	/// because this is at /atom level.
	var/material_traits_multiplier = 1

	//? Radiation
	/// radiation flags
	var/rad_flags = RAD_NO_CONTAMINATE	// overridden to NONe in /obj and /mob base
	/// radiation insulation - does *not* affect rad_act!
	//  TODO: BUG: rad_insulation needs a `set_rad_insulation()` which updates turf!
	var/rad_insulation = RAD_INSULATION_NONE
	/// contamination insulation; null defaults to rad_insulation, this is a multiplier. *never* set higher than 1!!
	var/rad_stickiness = 1

	//* Rendering *//

	/// Used for changing icon states for different base sprites.
	///
	/// * Not used directly, but it's a frequent pattern to need to override this
	///   and we don't want to always force usage of initial(icon_state)
	var/base_icon_state

	//* Shieldcalls *//

	/// sorted priority list of datums for handling shieldcalls with
	/// we use this instead of signals so we can enforce priorities
	/// this is horrifying.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/list/datum/shieldcall/shieldcalls

	//? Overlays
	/// vis overlays managed by SSvis_overlays to automaticaly turn them like other overlays.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/list/managed_vis_overlays
	/// overlays managed by [update_overlays][/atom/proc/update_overlays] to prevent removing overlays that weren't added by the same proc. Single items are stored on their own, not in a list.
	/// * this variable is not visible and should not be edited in the map editor.
	var/tmp/list/managed_overlays

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
	var/icon_x_dimension = 32
	/// expected icon height; centering offsets will be calculated from this and our base pixel y.
	var/icon_y_dimension = 32

	//? Misc
	/// What mobs are interacting with us right now, associated directly to concurrent interactions. (use defines)
	var/list/interacting_mobs
	/// The orbiter comopnent if we're being orbited.
	var/datum/component/orbiter/orbiters

	//? Sounds
	/// Default sound played on impact when damaged by a weapon / projectile / whatnot. This is usually null for default.
	var/hit_sound_brute
	/// Default sound played on a burn type impact. This is usually null for default.
	var/hit_sound_burn

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
	for(var/hud_provider in atom_huds)
		remove_atom_hud_provider(src, hud_provider)

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

/// Convenience proc to see if a container is open for chemistry handling.
/atom/proc/is_open_container()
	return atom_flags & OPENCONTAINER

///Is this atom within 1 tile of another atom
/atom/proc/HasProximity(atom/movable/proximity_check_mob as mob|obj)
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

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

/atom/proc/relaymove_from_contents(mob/user, direction)
	return relaymove(user, direction)

///Setter for the `density` variable to append behavior related to its changing.
/atom/proc/set_density(new_value)
	SHOULD_CALL_PARENT(TRUE)
	if(density == new_value)
		return
	. = density
	density = new_value

// Called to set the atom's invisibility and usd to add behavior to invisibility changes.
/atom/proc/set_invisibility(var/new_invisibility)
	if(invisibility == new_invisibility)
		return FALSE
	invisibility = new_invisibility
	return TRUE

// todo: this really needs to be refactored
/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return -1


// Returns an assoc list of RCD information.
// Example would be: list(RCD_VALUE_MODE = RCD_DECONSTRUCT, RCD_VALUE_DELAY = 50, RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 4)
// This occurs before rcd_act() is called, and it won't be called if it returns FALSE.
/atom/proc/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/atom/proc/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return

/atom/proc/melt()
	return

/atom/proc/add_hiddenprint(mob/living/M)
	if (isnull(M))
		return
	if (isnull(M.key))
		return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna))
			return FALSE
		if (H.gloves)
			if (fingerprintslast != H.key)
				fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
				fingerprintslast = H.key
			return FALSE
		if (!(fingerprints))
			if (fingerprintslast != H.key)
				fingerprintshidden += "\[[time_stamp()]\] Real name: [H.real_name], Key: [H.key]"
				fingerprintslast = H.key
			return TRUE
	else
		if (fingerprintslast != M.key)
			fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
			fingerprintslast = M.key
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
	//! LEGACY
	if(isbelly(loc))
		var/obj/belly/B = loc
		see = B.effective_emote_hearers()
	else
		see = get_hearers_in_view(range, src)
	//! end
	for(var/atom/movable/AM as anything in see)
		if(ismob(AM))
			var/mob/M = AM
			if(self_message && (M == src))
				M.show_message(self_message, 1, blind_message, 2)
			else if((M.see_invisible >= invisibility) && M.can_see_plane(plane))
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
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance, datum/prototype/language/lang)

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
	if(!no_runechat && ismovable(src))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, animate_chat), (message ? message : deaf_message), null, FALSE, heard_to_floating_message, 30)

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

/**
 * generates our locate() tag
 *
 * why would we use tags?
 * i'm glad you asked!
 *
 * some atoms / datums have special needs of 'too critical to allow shared text refs to wreak havoc'
 * yes, usually, people need to be gc-aware and not allow text ref reuse to break things
 * unfortunately this is still going to be an issue for legacy code
 *
 * so we don't allow things like /mobs to ever share the same reference used for REF(),
 * because the chances of a collision is just too high
 *
 * not only that, this is currently the way things like mobs can generate things like their render source/target UIDs
 * in the future we'll need to change that to a better UID system for each system, but, for now, this is why.
 */
/atom/proc/generate_tag()
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

// todo: annihilate this in favor of ATOM_PASS_INCORPOREAL
/atom/proc/is_incorporeal()
	return FALSE

/atom/proc/CheckParts(list/parts_list)
	for(var/A in parts_list)
		// todo: i don't know why we do this in crafting but crafting needs fucking refactored lmao
		// if(istype(A, /datum/reagent))
		// 	if(!reagents)
		// 		reagents = new()
		// 	reagents.reagent_list.Add(A)
		// 	reagents.conditional_update()
		if(ismovable(A))
			var/atom/movable/M = A
			M.forceMove(src)

/atom/proc/is_drainable()
	return reagents && (reagents.reagents_holder_flags & DRAINABLE)


/atom/proc/get_cell(inducer)
	return

//* Color *//

/**
 * Managed color set procs for the atom's raw `color` variable. This used to be a full priority system,
 * but it was determined to be unnecessary.
 */

/**
 * getter for current color
 */
/atom/proc/get_atom_color()
	CRASH("base proc hit")

/**
 * copies from other
 */
/atom/proc/copy_atom_color(atom/other)
	CRASH("base proc hit")

/// Adds an instance of colour_type to the atom's atom_colors list
/atom/proc/add_atom_color(new_color)
	CRASH("base proc hit")

/// Removes an instance of colour_type from the atom's atom_colors list
/atom/proc/remove_atom_color(require_color)
	CRASH("base proc hit")

/// Resets the atom's color to null, and then sets it to the highest priority colour available
/atom/proc/update_atom_color()
	CRASH("base proc hit")

//* Deletions *//

// /**
//  * Called when something in our contents is being Destroy()'d, before they get moved.
//  */
// /atom/proc/handle_contents_del(atom/movable/deleting)
// 	return

//* Inventory *//

/atom/proc/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	return

/atom/proc/on_contents_weight_volume_change(obj/item/item, old_weight_volume, new_weight_volume)
	return

/atom/proc/on_contents_weight_change(obj/item/item, old_weight, new_weight)
	return

/**
 * called when an /obj/item Initialize()s in us.
 */
/atom/proc/on_contents_item_new(obj/item/item)
	return

//? Layers

/// Sets our plane
/atom/proc/set_plane(new_plane)
	ASSERT(isnum(new_plane))
	plane = new_plane

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

// todo: deprecate this
/atom/proc/hud_layerise()
	plane = HUD_ITEM_PLANE
	set_base_layer(HUD_LAYER_ITEM)
	// appearance_flags |= NO_CLIENT_COLOR

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	set_base_layer(initial(layer))

//* Persistence *//

/**
 * Triggered by SSpersistence to decay persisted atoms on load.
 *
 * @params
 * * rounds_since_saved - rounds since we were saved
 * * hours_since_saved - hours since we were saved
 */
/atom/proc/decay_persisted(rounds_since_saved, hours_since_saved)
	return

//? Pixel Offsets

// todo: figure out exactly what we're doing here because this is a dumpster fire; we need to well-define what each of htese is supposed to do.
// todo: at some point we need to optimize this entire chain of bullshit, proccalls are expensive yo

/atom/proc/set_pixel_x(val)
	pixel_x = val + get_managed_pixel_x()
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/atom/proc/set_pixel_y(val)
	pixel_y = val + get_managed_pixel_y()
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/atom/proc/set_pixel_offsets(x, y)
	pixel_x = x + get_managed_pixel_x()
	pixel_y = y + get_managed_pixel_y()
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/atom/proc/reset_pixel_offsets()
	pixel_x = get_managed_pixel_x()
	pixel_y = get_managed_pixel_y()
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

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
 * get the pixel_x needed to adjust ourselves to be centered on our turf. this is used for alignment with buckles and whatnot.
 *
 * e.g. even if we are a 3x3 sprite with -32 x/y offsets, this would be 0
 * if we were, for some reason, a 4x4 with -32 x/y, this would probably be 16/16 x/y.
 */
/atom/proc/get_centering_pixel_x_offset(dir)
	return base_pixel_x + (icon_x_dimension - WORLD_ICON_SIZE) / 2

/**
 * get the pixel_y needed to adjust ourselves to be centered on our turf. this is used for alignment with buckles and whatnot.
 *
 * e.g. even if we are a 3x3 sprite with -32 x/y offsets, this would be 0
 * if we were, for some reason, a 4x4 with -32 x/y, this would probably be 16/16 x/y.
 */
/atom/proc/get_centering_pixel_y_offset(dir)
	return base_pixel_y + (icon_y_dimension - WORLD_ICON_SIZE) / 2

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

/**
 * Get the left-to-right lower-left to top-right width of our icon in pixels.
 * * This is used to align some overlays like HUD overlays.
 */
/atom/proc/get_pixel_x_self_width()
	return icon_x_dimension

/**
 * Get the left-to-right lower-left to top-right width of our icon in pixels.
 * * This is used to align some overlays like HUD overlays.
 */
/atom/proc/get_pixel_y_self_width()
	return icon_y_dimension
