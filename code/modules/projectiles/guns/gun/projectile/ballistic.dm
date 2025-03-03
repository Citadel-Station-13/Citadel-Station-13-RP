/**
 * Ballistic Guns
 *
 * These are guns that fire primarily ammo casings.
 *
 * They have simulation / support for both direct-load / internal magazines, as well as
 * attached / inserted external magazines.
 */
/obj/item/gun/projectile/ballistic
	desc = "A gun that fires bullets."
	description_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  To reload, click the weapon in your hand to unload (if needed), then add the appropriate ammo.  The description \
	will tell you what caliber you need."
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "revolver"
	w_class = WEIGHT_CLASS_NORMAL
	materials_base = list(MAT_STEEL = 1000)
	recoil = 0

	//* Actions *//

	/// If we're an internal mag gun, this is our chamber spin action.
	/// * Lazy-init'd
	var/datum/action/item_action/gun_spin_chamber/chamber_spin_action

	//* Ammunition *//

	/// Inserted magazine
	/// * Ignored if [internal_magazine] is enabled.
	var/obj/item/ammo_magazine/magazine
	/// magazine types allowed for insertion
	/// * You probably want [magazine_class]. This lets you override normal behavior
	///   for what magazines receive the function calls for loading as magazines, and is
	///   for advanced uses only.
	var/magazine_type = MAGAZINE_TYPE_NORMAL
	/// magazine classes allowed for insertion
	var/magazine_class = MAGAZINE_CLASSES_DEFAULT_FIT
	/// Magazine restrict; restricts inserted magazines to those that
	/// match this.
	///
	/// How this is checked:
	/// * [magazine_class] is applied first, and will reject the magazine if it doesn't match.
	/// * If this is a path, that path and its subtypes are allowed.
	///
	//  todo: are multi-restrictions necessary? a single type-and-subtypes seems to work fine for now.
	var/magazine_restrict
	/// Magazine insert sound
	var/magazine_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	/// Magazine removal sound
	var/magazine_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'
	/// Preloads us with a magazine type.
	/// * Ignored if [internal_magazine] is enabled.
	var/magazine_preload
	/// Automatically eject magazine once empty
	/// * Ignored if [internal_magazine] is enabled.
	var/magazine_auto_eject = FALSE
	/// Magazine auto-eject sound
	/// * Played additionally to [magazine_remove_sound]
	var/magazine_auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	/// Magazine insertion delay
	/// * Added to the magazine's inherent delay.
	//  todo: impl
	var/magazine_delay = 0
	/// Magazine removal delay
	/// * Defaults to [magazine_delay], overrides it if non-null
	/// * Added to the magazine's inherent delay.
	//  todo: impl
	var/magazine_remove_delay

	/// Allow speedloaders
	/// * [internal_magazine] is required to use speedloaders.
	var/speedloader_allowed = TRUE
	/// Speedloader restrict; restricts speedloader usage to speedloader magazines
	/// that match this.
	///
	/// How this is checked:
	/// * If this is a path, that path and its subtypes are allowed.
	///
	//  todo: are multi-restrictions necessary? a single type-and-subtypes seems to work fine for now.
	var/speedloader_restrict
	/// Delay for speedloader refills
	var/speedloader_delay
	/// Speedloader sound
	var/speedloader_sound = 'sound/weapons/guns/interaction/bullet_insert.ogg'

	/// Allow single loading without a speedloader, whether by hand or via clip magazines.
	/// * This loads to internal magazine.
	/// * If no internal magazine is provided, this loads to chambered.
	var/single_load_allowed = TRUE
	/// Single load sound
	var/single_load_sound = 'sound/weapons/guns/interaction/bullet_insert.ogg'
	/// Delay for single loading
	/// * If this is 0 and so is a clip's, clips act like speedloaders.
	var/single_load_delay = 0

	//* Ammunition - Internal *//

	/// If set, we use an internal magazine.
	/// * Changing this post-Initialize() is considered undefined behavior.
	/// * Only internal magazine guns work with speedloaders.
	//  todo: evaluate if internal magazines should just be a special magazine object
	//        as the current way of doing it leads to a lot of unnecessary logic
	var/internal_magazine = FALSE
	/// Sets our internal magazine size.
	/// * Changing this post-Initialize() is considered undefined behavior.
	var/internal_magazine_size = 0
	/// Internal magazine list
	/// * This is an indexed list. Non-revolverlikes will trim the list as
	///   needed, while revolverlikes will keep the list size static.
	/// * This is separate from [magazine] on purpose.
	/// * The top round is the bottom of the list, ergo last element.
	///   This makes insertion and removal very fast.
	var/list/obj/item/ammo_casing/internal_magazine_vec
	/// Preloads internal magazine with this ammo type
	var/internal_magazine_preload_ammo
	/// The internal magazine should act like a looping list
	/// rather than being a stack.
	/// * Changing this post-Initialize() is considered undefined behavior.
	/// * Basically, makes this act like a revolver. Round ejection still works.
	var/internal_magazine_revolver_mode = FALSE
	/// The current position in [internal_magazine_vec] we are at.
	/// * This position in the list will be put into chambered and nulled out, as it's technically
	///   the chambered round.
	/// * This is to avoid duplicate references, as those are pretty much asking for trouble.
	/// * This is only used if [internal_magazine_revolver_mode] is enabled.
	/// * This normally goes **forwards**. This means that it goes from say,
	///   1 to 10, then wraps back to 1.
	var/internal_magazine_revolver_offset

	//* Bolt *//

	#warn implement this
	/// Perform simplified bolt simulation on the gun.
	/// * [chamber_simulation] is required for this to do anything.
	///
	/// Bolt simulated guns do the following:
	/// * The bolt must be closed to fire.
	/// * The bolt will close when cycling (charging) the chamber, whether
	///   manually or automatically.
	/// * The bolt will open after firing.
	/// * By default, chambered round cannot be accessed while the bolt is closed
	/// * By default, internal magazine cannot be accessed while the bolt is closed
	/// * By default, external magazine cannot be inserted or removed while the bolt is closed
	/// * By default, the 'cycle chamber' interaction will instead close or open
	///   the bolt. If the bolt is being closed, it will also cycle the chamber.
	/// * Enable bolt-state rendering if [render_bolt_overlay] is on.
	var/bolt_simulation = FALSE
	/// Is the bolt closed right now?
	/// * No effect without [bolt_simulation]
	var/bolt_closed = TRUE
	/// Sound to manipulate the bolt.
	/// * Played in lieu of chambering sound if that exists and this is a manual bolt
	///   manipulation.
	var/bolt_open_sound = 'sound/weapons/guns/interaction/rifle_boltback.ogg'
	/// Sound to manipulate the bolt.
	/// * Played in lieu of chambering sound if that exists and this is a manual bolt
	///   manipulation.
	var/bolt_close_sound = 'sound/weapons/guns/interaction/rifle_boltforward.ogg'

	//* Chamber *//

	/// If this is off, we draw casings from the magazine directly,
	/// and do not allow charging the chamber.
	var/chamber_simulation = TRUE
	/// Chambered round
	/// * This is considered an internal variable; use getters / setters to manipulate it.
	/// How this works:
	/// * This is filled on cycle if it's an external magazine and chamber is separated from magazine.
	/// * Ditto for internal magazine, if chamber is separated.
	/// * If [chamber_simulation] is off, this variable will never be filled.
	///   get_chambered(), eject_chamber(), etc, will all return the first in magazine.
	/// * If [internal_magazine] and [internal_magazine_revolver_mode] are both on, this variable will never be filled.
	///   get_chambered(), eject_chamber(), etc, will all return the current revolver offset.
	/// Caveats
	/// * Internally, if this variable is filled, it'll be returned.
	///   Even if it should be using something else. This is so things don't runtime when there's
	///   invalid behavior, instead just acting weirdly. You can technically use this to
	///   make custom behaviors, but it's not recommended.
	VAR_PROTECTED/obj/item/ammo_casing/chamber
	/// Cycle the chamber on a successful live fire.
	var/chamber_cycle_after_fire = TRUE
	/// Cycle the chamber on an unsuccessful inert fire.
	var/chamber_cycle_after_inert = FALSE
	/// chamber manual cycle sound
	/// * not played on an automatic cycle (from live / inert fire)
	var/chamber_manual_cycle_sound = /datum/soundbyte/guns/ballistic/rack_chamber/generic_1
	/// Spin the internal magazine after a live-fire.
	/// * Only has an effect on revolver-like internal magazines.
	/// * Cycling the chamber will eject the round. Turn off 'cycle after fire' if you don't want this.
	var/chamber_spin_after_fire = TRUE
	/// Spin the internal magazine after an inert-fire.
	/// * Only has an effect on revolver-like internal magazines.
	/// * Cycling the chamber will eject the round. Turn off 'cycle after inert' if you don't want this.
	var/chamber_spin_after_inert = TRUE

	//* Configuration *//
	/// If set, accepts ammo and magazines of this caliber.
	var/caliber

	//* Interaction *//
	/// Show caliber on examine.
	var/interact_show_caliber_on_examine = TRUE
	/// Allow tactical / combat / whatever reloading
	var/interact_allow_tactical_reload = TRUE
	/// Speed (drop mag) reload speed
	var/interact_speed_reload_delay = 0.5 SECONDS
	/// Tactical (swap mag) reload speed
	var/interact_tactical_reload_delay = 1 SECONDS
	/// Allow spinning the chamber if we're a revolver-like
	var/interact_allow_chamber_spin = TRUE

	//* Rendering *//
	/// Render an overlay when magazine is in.
	///
	/// todo: mob renderer integration
	///
	/// * This uses MAGAZINE_CLASS_* defines
	/// * We'll look for a matching class that we support to render
	/// * If we can't find one, we'll use any class that we have on ourselves
	/// * This is separate from normal item rendering. This adds an overlay directly. See MAGAZINE_CLASS_* enums.
	var/render_magazine_overlay = NONE
	/// Render the chamber state.
	///
	/// todo: mob renderer integration
	/// todo: this is not supported yet
	///
	/// * uses BALLISTIC_RENDER_BOLT_* enums
	var/render_bolt_overlay = BALLISTIC_RENDER_BOLT_NEVER
	/// Render the state of a gun that's 'break action'
	///
	/// todo: mob renderer integration
	/// todo: this is not supported yet
	///
	/// * uses BALLISTIC_RENDER_BREAK_* enums
	/// * This is also used for LMGs, and any other gun requiring this stuff.
	var/render_break_overlay = BALLISTIC_RENDER_BREAK_NEVER

/obj/item/gun/projectile/ballistic/Initialize(mapload)
	. = ..()
	update_icon()

	if(internal_magazine)
		// fast insert, does not call the insert proc for casings or anything hooked to it
		internal_magazine_vec = list()
		if(internal_magazine_preload_ammo)
			for(var/i in 1 to internal_magazine_size)
				internal_magazine_vec += new internal_magazine_preload_ammo(src)
		if(internal_magazine_revolver_mode)
			// ensure it's the right size, even if we didn't fill it the full way
			internal_magazine_vec.len = internal_magazine_size
			internal_magazine_revolver_offset = 1
		else
			// chamber the gun
			load_chamber()
	else
		if(magazine_preload)
			// fast insert, does not call the insert proc or anything hooked to it
			magazine = new magazine_preload
			// chamber the gun
			load_chamber()

/obj/item/gun/projectile/ballistic/update_icon_state()
	. = ..()
	if((item_renderer || mob_renderer) || !render_use_legacy_by_default)
		return // using new system
	var/silenced_state = silenced ? silenced_icon : initial(icon_state)
	var/magazine_state = magazine ? "" : "-empty"
	if(magazine)
		icon_state = "[silenced_state][magazine_state]"

/obj/item/gun/projectile/ballistic/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/ammo_magazine))
		return user_clickchain_apply_magazine(using, e_args, e_args)
	else if(istype(using, /obj/item/ammo_casing))
		return user_clickchain_apply_casing(using, e_args, e_args)

/obj/item/gun/projectile/ballistic/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
	if(e_args.performer.is_holding_inactive(src))
		if(user_clickchain_unload(e_args, e_args) & CLICKCHAIN_FLAGS_INTERACT_ABORT)
			return TRUE

/obj/item/gun/projectile/ballistic/consume_next_projectile(datum/gun_firing_cycle/cycle)
	var/obj/item/ammo_casing/priming = ready_chambered()
	return priming ? prime_casing(cycle, priming, CASING_PRIMER_CHEMICAL) : GUN_FIRED_FAIL_EMPTY

/obj/item/gun/projectile/ballistic/post_fire(datum/gun_firing_cycle/cycle)
	. = ..()
	switch(cycle.last_firing_result)
		if(GUN_FIRED_SUCCESS)
			legacy_emit_chambered_residue()
			if(magazine_auto_eject && !magazine.get_amount_remaining())
				remove_magazine(null, null, TRUE)
			if(chamber_cycle_after_fire)
				cycle_chamber(FALSE, TRUE)
			if(chamber_spin_after_fire && internal_magazine_revolver_mode && internal_magazine)
				unsafe_spin_chamber_to_next()
		if(GUN_FIRED_FAIL_INERT)
			if(chamber_cycle_after_inert)
				cycle_chamber(FALSE, TRUE)
			if(chamber_spin_after_inert && internal_magazine_revolver_mode && internal_magazine)
				unsafe_spin_chamber_to_next()
		if(GUN_FIRED_FAIL_EMPTY)
			if(chamber_cycle_after_inert)
				cycle_chamber(FALSE, TRUE)
			if(chamber_spin_after_inert && internal_magazine_revolver_mode && internal_magazine)
				unsafe_spin_chamber_to_next()

/obj/item/gun/projectile/ballistic/examine(mob/user, dist)
	. = ..()
	if(interact_show_caliber_on_examine)
		var/datum/ammo_caliber/our_caliber = resolve_caliber(caliber)
		if(our_caliber)
			. += "It uses [our_caliber.caliber][our_caliber.name ? " ([our_caliber.name])" : ""] caliber ammunition."
	if(magazine)
		. += "It has \a [magazine] loaded."
	. += "Has [get_ammo_remaining()] round\s remaining."

//* Actions *//

/obj/item/gun/projectile/ballistic/register_item_actions(mob/user)
	. = ..()
	if(internal_magazine && internal_magazine_revolver_mode)
		if(!chamber_spin_action)
			chamber_spin_action = new(src)
		chamber_spin_action.grant(user.inventory.actions)

/obj/item/gun/projectile/ballistic/unregister_item_actions(mob/user)
	. = ..()
	chamber_spin_action?.revoke(user.inventory.actions)

//* Ammo *//

/obj/item/gun/projectile/ballistic/get_ammo_ratio(rounded)
	if(internal_magazine)
		var/remaining
		if(internal_magazine_revolver_mode)
			for(var/i in 1 to length(internal_magazine_revolver_mode))
				if(internal_magazine_vec[i])
					remaining += 1
		else
			remaining = length(internal_magazine_vec)
		return min(1, remaining / internal_magazine_size)
	else
		if(!magazine)
			return 0
		return min(1, magazine.get_amount_remaining() / magazine.ammo_max)

/obj/item/gun/projectile/ballistic/get_ammo_remaining()
	if(internal_magazine)
		if(internal_magazine_revolver_mode)
			for(var/i in 1 to length(internal_magazine_revolver_mode))
				if(internal_magazine_vec[i])
					. += 1
		else
			. = length(internal_magazine_vec)
	else
		. = magazine?.get_amount_remaining()
	if(chamber)
		. += 1

/**
 * Accepts:
 *
 * * Text caliber string
 * * Caliber path
 * * Caliber instance
 *
 * @params
 * * caliberlike - caliber to test
 * * for_magazine - are we testing for a magazine insertion?
 *
 * @return TRUE / FALSE
 */
/obj/item/gun/projectile/ballistic/proc/accepts_caliber(datum/ammo_caliber/caliberlike, for_magazine)
	if(!caliber)
		return TRUE
	var/datum/ammo_caliber/ours = resolve_caliber(caliber)
	var/datum/ammo_caliber/theirs = resolve_caliber(caliberlike)
	return ours.equivalent(theirs)

/**
 * Can accept an ammo casing
 */
/obj/item/gun/projectile/ballistic/proc/accepts_casing(obj/item/ammo_casing/casing)
	if(!accepts_caliber(casing.caliber))
		return FALSE
	return TRUE

/obj/item/gun/projectile/ballistic/proc/accepts_magazine(obj/item/ammo_magazine/magazine)
	if(!(magazine_class & magazine.magazine_class))
		return FALSE
	if(!(magazine_type & magazine.magazine_type))
		return FALSE
	if(!accepts_caliber(magazine.ammo_caliber, TRUE))
		return FALSE
	return magazine_restrict ? check_magazine_restrict(magazine_restrict, null, magazine.type) : TRUE

/obj/item/gun/projectile/ballistic/proc/accepts_speedloader(obj/item/ammo_magazine/magazine)
	return speedloader_restrict ? check_magazine_restrict(speedloader_restrict, null, magazine.type) : TRUE

/**
 * Can accept a specific 'restrict' value
 *
 * @params
 * * requested - our side; what we accept
 * * provided - magazine side; what they give
 * * provided_path - magazine path
 */
/obj/item/gun/projectile/ballistic/proc/check_magazine_restrict(requested, provided, provided_path)
	// 0. if no magazine restrict is set, accept.
	if(isnull(requested))
		return TRUE
	// 1. if they are the type of 'magazine_restrict' or a related variable, accept.
	if(ispath(provided_path, requested))
		return TRUE
	return FALSE

/**
 * Load casing.
 *
 * * Has no sanity checks. Run [accepts_casing()] yourself.
 * * This also means this'll let you insert into chamber even with a magazine
 *   inserted or with an internal magazine, if the chamber is empty.
 * * Inserts into first open position after currently chambered if it's a revolver-like structure,
 *   unless doing `reverse_order`, in which case this is reversed to be first position behind current going
 *   backwards.
 * * Inserts into bottom of internal magazine if it's not a revolver-like structure, then chambered.
 *   If `reverse_order` is on, insert into chambered, then to top of magazine instead.
 *
 * @return TRUE / FALSE success / fail
 */
/obj/item/gun/projectile/ballistic/proc/insert_casing(obj/item/ammo_casing/casing, silent, reverse_order)
	if(internal_magazine)
		// insert into internal magazine
		if(internal_magazine_revolver_mode)
			var/success
			if(reverse_order)
				for(var/i in internal_magazine_revolver_offset to length(internal_magazine_vec))
					if(!internal_magazine_vec[i])
						success = TRUE
						internal_magazine_vec[i] = casing
						casing.forceMove(src)
						break
				if(!success)
					for(var/i in 1 to internal_magazine_revolver_mode - 1)
						if(!internal_magazine_vec[i])
							success = TRUE
							internal_magazine_vec[i] = casing
							casing.forceMove(src)
							break
			else
				for(var/i in internal_magazine_revolver_offset - 1 to 1 step -1)
					if(!internal_magazine_vec[i])
						success = TRUE
						internal_magazine_vec[i] = casing
						casing.forceMove(src)
						break
				if(!success)
					for(var/i in length(internal_magazine_vec) to internal_magazine_revolver_offset step -1)
						if(!internal_magazine_vec[i])
							success = TRUE
							internal_magazine_vec[i] = casing
							casing.forceMove(src)
							break
		else
			if(reverse_order)
				if(!chamber)
					chamber = casing
					casing.forceMove(src)
				else if(length(internal_magazine_vec) < internal_magazine_size)
					internal_magazine_vec += casing
					casing.forceMove(src)
			else if(length(internal_magazine_vec) < internal_magazine_size)
				internal_magazine_vec.Insert(1, casing)
				casing.forceMove(src)
	else
		// insert into chamber
		if(!chamber)
			. = TRUE
			casing.forceMove(src)
			chamber = casing
	if(. && !silent)
		playsound(src, single_load_sound, 50, TRUE)

/**
 * Load from a speedloader.
 *
 * * Has no sanity checks. Run [accepts_casing()] yourself.
 * * Doesn't check delay. That's your job.
 *
 * @return amount loaded
 */
/obj/item/gun/projectile/ballistic/proc/insert_speedloader(obj/item/ammo_magazine/speedloader, silent, reverse_order)
	// only works with internal magazines
	if(!internal_magazine)
		return 0
	if(internal_magazine_revolver_mode)
	else
		var/wanted = max(0, internal_magazine_size - length(internal_magazine_vec))
	#warn impl

/**
 * Load magazine
 *
 * * Has no sanity checks. Run [accepts_magazine()] yourself.
 *
 * @return TRUE / FALSE success / fail
 */
/obj/item/gun/projectile/ballistic/proc/insert_magazine(obj/item/ammo_magazine/magazine, silent)
	if(!magazine || src.magazine)
		return FALSE
	if(!silent)
		playsound(src, magazine_insert_sound, 75, TRUE)
	magazine.forceMove(src)
	src.magazine = magazine
	return TRUE

/**
 * Eject inserted magazine
 *
 * * This can make a sound if it's not using silent param.
 *
 * @return removed magazine
 */
/obj/item/gun/projectile/ballistic/proc/remove_magazine(atom/new_loc, silent, auto_eject) as /obj/item/ammo_magazine
	RETURN_TYPE(/obj/item/ammo_magazine)
	if(!magazine)
		return
	if(!silent)
		if(auto_eject)
			playsound(src, magazine_auto_eject_sound, 75, TRUE)
		else
			playsound(src, magazine_remove_sound, 75, TRUE)
	. = magazine
	if(new_loc)
		magazine.forceMove(new_loc)
	else
		magazine.moveToNullspace()
	magazine = null

/**
 * Eject **a** casing.
 *
 * * This can make a sound if it's not using silent param.
 * * For guns with external magazines, this removes chambered and only chambered.
 * * For guns with internal magazines, see params
 *
 * @params
 * * new_loc - where to put the casing
 * * silent - don't make a noise
 * * reverse_order - remove from chambered, then top of magazine first,
 *                          rather than bottom to top then chambered.
 *                          for revolvers, this will go from the current bullet forwards,
 *                          rather than the position before the current bullet backwards.
 */
/obj/item/gun/projectile/ballistic/proc/remove_casing(atom/new_loc, silent, reverse_order) as /obj/item/ammo_casing
	RETURN_TYPE(/obj/item/ammo_casing)
	var/obj/item/ammo_casing/ejecting

	// internal: eject from bottom to top of mag then chambered,
	//           or the other way around depending on vars
	if(internal_magazine)
		#warn impl these
		if(internal_magazine_revolver_mode)
			if(reverse_order)
				for(var/i in internal_magazine_revolver_offset to length(internal_magazine_vec))
					ejecting = internal_magazine_vec[i]
					if(ejecting)
						break
				if(!ejecting)
					for(var/i in 1 to internal_magazine_revolver_offset - 1)
						ejecting = internal_magazine_vec[i]
						if(ejecting)
							break
			else
				for(var/i in internal_magazine_revolver_offset - 1 to 1 step -1)
					ejecting = internal_magazine_vec[i]
					if(ejecting)
						break
				if(!ejecting)
					for(var/i in length(internal_magazine_vec) to internal_magazine_revolver_offset step -1)
						ejecting = internal_magazine_vec[i]
						if(ejecting)
							break
		else
			if(reverse_order)
				if(chamber)
					ejecting = chamber
					chamber = null
				else if(length(internal_magazine_vec))
					ejecting = internal_magazine_vec[length(internal_magazine_vec)]
					--internal_magazine_vec.len
			else
				if(length(internal_magazine_vec))
					ejecting = internal_magazine_vec[1]
					internal_magazine_vec.Cut(1, 2)
				else if(chamber)
					ejecting = chamber
					chamber = null

	// external: eject chamber only
	else if(chamber)
		ejecting = eject_chamber(TRUE, FALSE, null)

	if(!ejecting)
		return
	if(!silent)
		playsound(src, single_load_sound, 50, TRUE)
	. = ejecting
	if(new_loc)
		ejecting.forceMove(new_loc)
	else if(ejecting.loc)
		ejecting.moveToNullspace()

// todo: impl for advanced revolver shenanigans
/obj/item/gun/projectile/ballistic/proc/remove_casing_from_revolver_index(atom/new_loc, silent, force_index)
	if(!internal_magazine || !internal_magazine_revolver_mode)
		CRASH("attempted to call 'remove_casing_from_revolver_index' on a non-internal-revolver-like gun.")
	CRASH("unimplemented proc")

//* Chamber *//

/**
 * A wrapper to get_chambered() used when priming the chambered casing.
 *
 * @return the casing that's in our chamber (or considered to be as such)
 */
/obj/item/gun/projectile/ballistic/proc/ready_chambered() as /obj/item/ammo_casing
	RETURN_TYPE(/obj/item/ammo_casing)
	return get_chambered()

/**
 * Get currently chambered projectile
 */
/obj/item/gun/projectile/ballistic/proc/get_chambered() as /obj/item/ammo_casing
	RETURN_TYPE(/obj/item/ammo_casing)
	. = chamber
	if(.)
		return
	if(internal_magazine_revolver_mode && internal_magazine)
		return internal_magazine_vec[internal_magazine_revolver_offset]
	if(!chamber_simulation)
		if(internal_magazine)
			return internal_magazine[length(internal_magazine)]
		else
			return magazine?.peek()

/**
 * Cycles the chamber
 */
/obj/item/gun/projectile/ballistic/proc/cycle_chamber(silent, from_fire)
	eject_chamber(silent, from_fire, drop_location())
	load_chamber()
	if(!silent)
		if(!from_fire)
			playsound(src, chamber_manual_cycle_sound, 75, TRUE)

/**
 * Loads the chamber from magazine immediately, if it is separated
 * from the magazine.
 */
/obj/item/gun/projectile/ballistic/proc/load_chamber()
	if(chamber)
		return FALSE
	if(internal_magazine_revolver_mode && internal_magazine)
		return FALSE
	if(!chamber_simulation)
		return FALSE
	if(internal_magazine)
		if(length(internal_magazine_vec))
			chamber = internal_magazine_vec[length(internal_magazine_vec)]
			--internal_magazine_vec.len
			return TRUE
		else
			return FALSE
	else
		chamber = magazine?.pop()
		return chamber ? TRUE : FALSE

/**
 * Ejects a chambered casing
 *
 * @return casing, or null if it was deleted
 */
/obj/item/gun/projectile/ballistic/proc/eject_chamber(silent, from_fire, atom/move_to) as /obj/item/ammo_casing
	RETURN_TYPE(/obj/item/ammo_casing)

	if(chamber.casing_flags & CASING_DELETE)
		qdel(chamber)
		return
	if(move_to)
		chamber.forceMove(move_to)
	chamber.randomize_offsets_after_eject()
	. = chamber
	chamber = null
	// todo: soundbyte this
	if(!silent)
		playsound(src, "casing", 50, TRUE)
	#warn impl and handle internal / revolver / non-separated mags

/**
 * Primes the casing being fired, and expends it.
 *
 * Either will return an /obj/projectile,
 * or return a GUN_FIRED_* define that is not SUCCESS.
 */
/obj/item/gun/projectile/ballistic/proc/prime_casing(datum/gun_firing_cycle/cycle, obj/item/ammo_casing/casing, casing_primer)
	return casing.process_fire(casing_primer)

/**
 * Switches to a certain index in our internal magazine
 * * Crashes if we don't use a revolver-like internal magazine.
 */
/obj/item/gun/projectile/ballistic/proc/unsafe_spin_chamber_to_index(index)
	if(!internal_magazine || !internal_magazine_revolver_mode)
		CRASH("attempted to swap chamber index on a gun that doesn't use an internal revolver-like datastructure")
	internal_magazine_revolver_offset = clamp(index, 1, length(internal_magazine_vec))

/**
 * Switches to a random index in our internal magazine.
 * * Crashes if we don't use a revolver-like internal magazine.
 */
/obj/item/gun/projectile/ballistic/proc/unsafe_spin_chamber_to_random()
	unsafe_spin_chamber_to_index(rand(1, length(internal_magazine_vec)))

/**
 * Switches to the next index in our internal magazine.
 * * Crashes if we don't use a revolver-like internal magazine.
 */
/obj/item/gun/projectile/ballistic/proc/unsafe_spin_chamber_to_next()
	var/next_index = internal_magazine_revolver_offset >= length(internal_magazine_vec) ? 1 : internal_magazine_revolver_offset + 1
	unsafe_spin_chamber_to_index(next_index)

//* Rendering *//

/**
 * Returns an overlay for a magazine. This can be a string, or anything else that goes into our 'overlays' list.
 */
/obj/item/gun/projectile/ballistic/proc/get_magazine_overlay_for(obj/item/ammo_magazine/magazine)
	var/effective_magazine_class = magazine.magazine_class
	if(!(effective_magazine_class & render_magazine_overlay))
		if(render_magazine_overlay & MAGAZINE_CLASS_GENERIC)
			effective_magazine_class = MAGAZINE_CLASS_GENERIC
		else
			return
	return global.magazine_class_bit_to_state[log(2, magazine.magazine_class) + 1]

/obj/item/gun/projectile/ballistic/update_icon()
	// todo: shouldn't need this check, deal with legacy
	if(!item_renderer && !mob_renderer && render_use_legacy_by_default)
		return ..()
	. = ..()
	// todo: render_break_overlay
	// todo: base state handling? what if we want to change base state on parent handling?
	if(render_bolt_overlay)
		switch(render_bolt_overlay)
			if(BALLISTIC_RENDER_BOLT_BOTH)
				if(bolt_closed)
					add_overlay("[base_icon_state]-bolt-close")
				else
					add_overlay("[base_icon_state]-bolt-open")
			if(BALLISTIC_RENDER_BOLT_CLOSE)
				if(bolt_closed)
					add_overlay("[base_icon_state]-bolt")
			if(BALLISTIC_RENDER_BOLT_OPEN)
				if(!bolt_closed)
					add_overlay("[base_icon_state]-bolt")
	if(render_magazine_overlay)
		if(magazine)
			var/overlay = get_magazine_overlay_for(magazine)
			if(overlay)
				add_overlay(overlay)

//* Action Datums *//

/datum/action/item_action/gun_spin_chamber
	name = "Spin Chamber"
	desc = "Spin the chmaber."
	target_type = /obj/item/gun/projectile/ballistic
	check_mobility_flags = MOBILITY_CAN_USE

/datum/action/item_action/gun_spin_chamber/pre_render_hook()
	. = ..()
	var/image/item_overlay = button_additional_overlay
	var/image/symbol_overlay = image('icons/screen/actions/generic-overlays.dmi', "swap")
	symbol_overlay.color = "#ff1100"
	item_overlay.add_overlay(symbol_overlay)

/datum/action/item_action/gun_spin_chamber/invoke_target(obj/item/gun/projectile/ballistic/target, datum/event_args/actor/actor)
	. = ..()
	target.user_clickchain_spin_chamber(actor)
