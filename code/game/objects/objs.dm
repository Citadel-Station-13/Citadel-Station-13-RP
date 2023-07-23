/obj
	layer = OBJ_LAYER
	plane = OBJ_PLANE
	pass_flags_self = ATOM_PASS_OVERHEAD_THROW
	animate_movement = SLIDE_STEPS
	rad_flags = NONE
	atom_colouration_system = TRUE

	//? Flags
	/// object flags, see __DEFINES/_flags/obj_flags.dm
	var/obj_flags = OBJ_MELEE_TARGETABLE | OBJ_RANGE_TARGETABLE
	/// ONLY FOR MAPPING: Sets flags from a string list, handled in Initialize. Usage: set_obj_flags = "OBJ_EMAGGED;!CAN_BE_HIT" to set OBJ_EMAGGED and clear CAN_BE_HIT.
	var/set_obj_flags

	//? Access - see [modules/jobs/access.dm]
	/// If set, all of these accesses are needed to access this object.
	var/list/req_access
	/// If set, at least one of these accesses are needed to access this object.
	var/list/req_one_access

	//? Climbing
	/// people can climb onto us
	var/climb_allowed = FALSE
	/// people are allowed to knock climbers off of us
	var/climb_knockable = TRUE
	/// list of people currently climbing on us
	/// currently, only /mob/living is allowed to climb
	var/list/mob/living/climbing
	/// nominal climb delay before modifiers
	var/climb_delay = 3.5 SECONDS

	//? Depth
	/// logical depth in pixels. people can freely run from high to low objects without being blocked.
	///
	/// negative values are ignored as turfs are assumed to be depth 0
	/// unless we change that in the future
	var/depth_level = 28
	/// contributes to depth when we're on a turf
	var/depth_projected = FALSE

	//? Economy
	/// economic category for objects
	var/economic_category_obj = ECONOMIC_CATEGORY_OBJ_DEFAULT

	//? Integrity
	integrity = 200
	integrity_max = 200
	integrity_failure = 50
	/// Standard integrity examine
	var/integrity_examine = TRUE

	//? Materials
	/// Material amounts in us
	/// For sheets, this represents the per-sheet amount.
	/// material id = amount
	/// * This may be a typelist, use is_typelist to check.
	/// * Always use get_base_materials to get this list unless you know what you're doing.
	/// * This may use typepath keys at compile time, but is immediately converted to material IDs on boot.
	/// * This does not include material parts.
	var/list/materials_base
	/// material parts - lets us track what we're made of
	/// this is either a lazy list of material keys to IDs,
	/// or a single material id
	/// or null for defaults.
	/// ! This must be set for anything using the materials system.
	/// ! This is what determines how many, and if something uses the material parts system.
	/// * This may be a typelist, use is_typelist to check.
	/// * Use [MATERIAL_DEFAULT_DISABLED] if something doesn't use material parts system.
	/// * Use [MATERIAL_DEFAULT_NONE] if something uses material parts system, but has only one material with default of null.
	/// * This may use typepath keys at compile time, but is immediately converted to material instances on boot.
	/// * Always use [get_material_parts] to get this list unless you know what you're doing.
	/// * This var should never be changed from a list to a normal value or vice versa at runtime,
	///   as we use this to detect which material update proc to call!
	var/list/material_parts = MATERIAL_DEFAULT_DISABLED
	/// material costs - lets us track the costs of what we're made of.
	/// this is either a lazy list of ordered costs in cm3,
	/// or a single number.
	/// * This may be a typelist, use is_typelist to check.
	/// * Always use [get_material_part_costs] to get this list unless you know what you're doing.
	/// * This may use typepath keys at compile time, but is immediately converted to material IDs on boot.
	/// * This list has the same ordering as [material_parts].
	var/list/material_costs
	/// make the actual materials multiplied by this amount. used by lathes to prevent duping with efficiency upgrades.
	var/material_multiplier = 1

	//? Sounds
	/// volume when breaking out using resist process
	var/breakout_sound = 'sound/effects/grillehit.ogg'
	/// volume when breaking out using resist process
	var/breakout_volume = 100

	//? misc / legacy
	/// Set when a player renames a renamable object.
	var/renamed_by_player = FALSE
	var/w_class // Size of the object.
	//! LEGACY: DO NOT USE
	var/sharp = 0		// whether this object cuts
	//! LEGACY: DO NOT USE
	var/edge = 0		// whether this object is more likely to dismember
	//! LEGACY: DO NOT USE
	var/pry = 0			//Used in attackby() to open doors
	//! LEGACY: DO NOT USE
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
	// cache base materials if it's not modified
	if(!isnull(materials_base) && !(obj_flags & OBJ_MATERIALS_MODIFIED))
		if(has_typelist(materials_base))
			materials = get_typelist(materials)
		else
			// preprocess
			materials = SSmaterials.preprocess_kv_keys_to_ids(materials)
			materials = typelist(NAMEOF(src, materials), materials)
	// cache material costs if it's not modified
	if(!islist(material_costs) && !(obj_flags & OBJ_MATERIAL_COSTS_MODIFIED))
		if(has_typelist(material_costs))
			material_costs = get_typelist(material_costs)
		else
			material_costs = typelist(NAMEOF(src, material_costs), material_costs)
	// initialize material parts system
	if(material_parts != MATERIAL_DEFAULT_DISABLED)
		// process material parts only if it wasn't set already
		// this allows children of /obj to modify their material parts prior to init.
		if(islist(material_parts) && !(obj_flags & OBJ_MATERIAL_PARTS_MODIFIED))
			if(has_typelist(material_parts))
				material_parts = get_typelist(material_parts)
			else
				// preprocess
				material_parts = SSmaterials.preprocess_kv_values_to_ids(material_parts)
				material_parts = typelist(NAMEOF(src, material_parts), material_parts)
		// init material parts only if it wasn't initialized already
		if(!(obj_flags & OBJ_MATERIAL_INITIALIZED))
			init_material_parts()
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

//? Climbing

/obj/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(drag_drop_climb_interaction(user, dropping))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/proc/drag_drop_climb_interaction(mob/user, atom/dropping)
	if(!climb_allowed)
		return FALSE
	if(user != dropping)
		return FALSE
	// todo: better hinting to user for this
	if(buckle_allowed && user.a_intent != INTENT_GRAB)
		return FALSE
	if(!user.Adjacent(src))
		return FALSE
	. = TRUE
	INVOKE_ASYNC(src, PROC_REF(attempt_climb_on), user)

/obj/proc/attempt_climb_on(mob/living/climber, delay_mod = 1)
	if(!istype(climber))
		return FALSE
	if(!allow_climb_on(climber))
		climber.action_feedback(SPAN_WARNING("You can't climb onto [src]!"), src)
		return FALSE
	if(INTERACTING_WITH_FOR(climber, src, INTERACTING_FOR_CLIMB))
		return FALSE
	climber.visible_action_feedback(SPAN_WARNING("[climber] starts climbing onto \the [src]!"), src, MESSAGE_RANGE_COMBAT_LOUD)
	START_INTERACTING_WITH(climber, src, INTERACTING_FOR_CLIMB)
	LAZYDISTINCTADD(climbing, climber)
	. = do_after(climber, climb_delay * delay_mod, src, mobility_flags = MOBILITY_CAN_MOVE | MOBILITY_CAN_STAND | MOBILITY_IS_STANDING)
	if(!INTERACTING_WITH_FOR(climber, src, INTERACTING_FOR_CLIMB))
		. = FALSE
	LAZYREMOVE(climbing, climber)
	STOP_INTERACTING_WITH(climber, src, INTERACTING_FOR_CLIMB)
	if(!allow_climb_on(climber))
		climber.action_feedback(SPAN_WARNING("You couldn't climb onto [src]!"), src)
		return FALSE
	do_climb_on(climber)

/obj/proc/allow_climb_on(mob/living/climber)
	if(!istype(climber))
		return FALSE
	if(!climb_allowed)
		return FALSE
	if(!climber.Adjacent(src))
		return FALSE
	return TRUE

/obj/proc/do_climb_on(mob/living/climber)
	climber.visible_message(SPAN_WARNING("[climber] climbs onto \the [src]!"))
	// all this effort just to avoid a splurtstation railing spare ID speedrun incident
	var/old_depth = climber.depth_current
	if(climber.depth_current < depth_level)
		// basically, we don't force move them, we just elevate them to our level
		// if something else blocks them, L + ratio + get parried
		climber.change_depth(depth_level)
	if(!step_towards(climber, do_climb_target(climber)))
		climber.change_depth(old_depth)

/obj/proc/do_climb_target(mob/living/climber)
	return get_turf(src)

/obj/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	if(length(climbing) && user.a_intent == INTENT_HARM)
		user.visible_message(SPAN_WARNING("[user] slams against \the [src]!"))
		user.do_attack_animation(src)
		shake_climbers()
		return TRUE

/obj/proc/shake_climbers()
	for(var/mob/living/climber as anything in climbing)
		climber.afflict_knockdown(1 SECONDS)
		climber.visible_message(SPAN_WARNING("[climber] is toppled off of \the [src]!"))
		STOP_INTERACTING_WITH(climber, src, INTERACTING_FOR_CLIMB)
	climbing = null

	// disabled old, but fun code that knocks people on their ass if something is shaken without climbers
	// being ontop of it
	// consider re-enabling this sometime.
	/*
	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.afflict_paralyze(20 * 3)
		to_chat(M, "<span class='danger'>You topple as \the [src] moves under you!</span>")

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting

			switch(pick(list("ankle","wrist","head","knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick(BP_L_FOOT, BP_R_FOOT))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
				if("wrist")
					affecting = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if("head")
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, "<span class='danger'>You land heavily on your [affecting.name]!</span>")
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.update_health()
	*/

//? Examine

/obj/examine(mob/user, dist)
	. = ..()
	if(integrity_examine)
		. += examine_integrity(user)
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

/obj/examine_integrity(mob/user)
	. = list()
	if(integrity == integrity_max)
		. += SPAN_NOTICE("It looks fully intact.")
	else
		var/perc = percent_integrity()
		if(perc > 0.75)
			. += SPAN_NOTICE("It looks a bit dented.")
		else if(perc > 0.5)
			. += SPAN_WARNING("It looks damaged.")
		else if(perc > 0.25)
			. += SPAN_RED("It looks severely damaged.")
		else
			. += SPAN_BOLDWARNING("It's falling apart!")

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
