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
	projectile_type = /obj/projectile/bullet/pistol/strong	//Only used for chameleon guns

	//* Ammunition *//

	#warn hook everything

	/// Inserted magazine
	/// * Ignored if [internal_magazine] is enabled.
	var/obj/item/ammo_magazine/magazine
	/// magazine types allowed for insertion
	/// * This makes you able to let a gun use things like speedloaders
	///   as magazines directly.
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
	var/speedloader_sound

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
	var/internal_magazine = FALSE
	/// Sets our internal magazine size.
	/// * Changing this post-Initialize() is considered undefined behavior.
	var/internal_magazine_size = 0
	/// Internal magazine list
	/// * This is an indexed list. Non-revolverlikes will trim the list as
	///   needed, while revolverlikes will keep the list size static.
	/// * This is separate from [magazine] on purpose.
	var/list/obj/item/ammo_casing/internal_magazine_vec
	/// The current position in [internal_magazine_vec] we are at.
	/// * This position in the list will be put into chambered and nulled out, as it's technically
	///   the chambered round.
	/// * This is to avoid duplicate references, as those are pretty much asking for trouble.
	/// * This is only used if [internal_magazine_is_revolver] is enabled.
	var/internal_magazine_borrowed_offset
	/// Preloads internal magazine with this ammo type
	var/internal_magazine_preload_ammo
	/// The internal magazine should act like a looping list
	/// rather than being a stack.
	/// * Basically, makes this act like a revolver. Round ejection still works.
	/// * [internal_magazine_borrowed_offset] will be put into the chamber, and nulled.
	///   Anything reading internal_magazine_vec should know how to handle this.
	var/internal_magazine_is_revolver = FALSE

	//* Chamber *//
	/// Chambered round
	/// * This is considered an internal variable; use getters / setters to manipulate it.
	VAR_PROTECTED/obj/item/ammo_casing/chamber
	/// Eject rounds after firing
	var/chamber_eject_after_fire = TRUE
	/// Spin the internal magazine after firing
	/// * Has no effect if [internal_magazine_is_revolver] is off.
	var/chamber_spin_after_fire = TRUE
	/// A loaded magazine will leave a bullet in the chamber
	/// once removed.
	/// * If this is TRUE, the chamber **immediately** takes a bullet from the
	///   magazine once it's inserted.
	/// * If this is FALSE, the chamber does not take the bullet until it's being
	///   fired, and the chamber will never hold a bullet if a magazine isn't inserted.
	/// * This must be TRUE to allow manual loading without a magazine.
	var/chamber_magazine_separation = TRUE
	/// chamber will still clear a shot even if it doesn't fire
	/// * basically means a gun will automatically un-jam itself
	/// * you're a coward if you turn this on
	/// * this does not affect cycling chambers like revolvers! duh.
	var/chamber_eject_if_inert = FALSE

	//* Configuration *//
	/// If set, accepts ammo and magazines of this caliber.
	var/caliber

	//* Interaction *//
	/// Show caliber on examine.
	var/show_caliber_on_examine = TRUE

	//* Rendering *//
	/// Render an overlay when magazine is in.
	///
	/// todo: mob renderer integration
	///
	/// * This uses MAGAZINE_CLASS_* defines
	/// * We'll look for a matching class that we support to render
	/// * If we can't find one, we'll use any class that we have on ourselves
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



	if(load_method & SPEEDLOADER)
		load_method_converted |= MAGAZINE_TYPE_SPEEDLOADER | MAGAZINE_TYPE_CLIP
	else if(load_method & MAGAZINE)
		load_method_converted |= MAGAZINE_TYPE_NORMAL

/obj/item/gun/projectile/ballistic/update_icon_state()
	. = ..()
	if((item_renderer || mob_renderer) || !render_use_legacy_by_default)
		return // using new system
	var/silenced_state = silenced ? silenced_icon : initial(icon_state)
	var/magazine_state = magazine ? "" : "-empty"
	if(magazine)
		icon_state = "[silenced_state][magazine_state]"

/obj/item/gun/projectile/ballistic/consume_next_projectile(datum/gun_firing_cycle/cycle)
	#warn handle internal magazine and magazine chamber separation
	return chamber ? prime_casing(cycle, chamber, CASING_PRIMER_CHEMICAL) : GUN_FIRED_FAIL_EMPTY

/**
 * Primes the casing being fired, and expends it.
 *
 * Either will return an /obj/projectile,
 * or return a GUN_FIRED_* define that is not SUCCESS.
 */
/obj/item/gun/projectile/ballistic/proc/prime_casing(datum/gun_firing_cycle/cycle, obj/item/ammo_casing/casing, casing_primer)
	return casing.process_fire(casing_primer)

// todo: rework this
/obj/item/gun/projectile/ballistic/post_fire(datum/gun_firing_cycle/cycle)
	. = ..()
	switch(cycle.last_firing_result)
		// process chamber
		if(GUN_FIRED_FAIL_INERT, GUN_FIRED_SUCCESS, GUN_FIRED_FAIL_EMPTY)
			process_chambered()

// todo: refactor
/obj/item/gun/projectile/ballistic/proc/process_chambered()
	if (!chambered)
		return

	// Aurora forensics port, gunpowder residue.
	if(chambered.leaves_residue)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			if(!istype(H.gloves, /obj/item/clothing))
				H.gunshot_residue = chambered.get_caliber_string()
			else
				var/obj/item/clothing/G = H.gloves
				G.gunshot_residue = chambered.get_caliber_string()

	switch(handle_casings)
		if(EJECT_CASINGS) //eject casing onto ground.
			if(chambered.casing_flags & CASING_DELETE)
				qdel(chambered)
				chambered = null
				return
			else
				chambered.forceMove(get_turf(src))
				chambered.randomize_offsets_after_eject()
				playsound(src.loc, "casing", 50, 1)
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(magazine)
				CRASH("attempted to cycle casing with a mag in; guncode doesn't support this use case, this is for revolver-likes only currently!")
			loaded += chambered

	if(handle_casings != HOLD_CASINGS)
		chambered = null

///time it takes to tac reload a gun
#define TACTICAL_RELOAD_SPEED 1 SECOND
///time it takes to speed reload a gun
#define SPEED_RELOAD_SPEED    0.5 SECONDS
//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/ballistic/proc/load_ammo(obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method_converted & AM.magazine_type) || !accepts_caliber(AM.ammo_caliber) || allowed_magazines && !is_type_in_list(A, allowed_magazines))
			to_chat(user, SPAN_WARNING("[AM] won't load into [src]!"))
			return
		if(AM.magazine_type & MAGAZINE_TYPE_NORMAL)
			if(magazine)
				if(user.a_intent == INTENT_HELP || user.a_intent == INTENT_DISARM)
					to_chat(user, SPAN_WARNING("[src] already has a magazine loaded."))//already a magazine here
					return
				else
					if(user.a_intent == INTENT_GRAB) //Tactical reloading
						if(!can_special_reload)
							to_chat(user, SPAN_WARNING("You can't tactically reload this gun!"))
							return
						if(do_after(user, TACTICAL_RELOAD_SPEED, src))
							if(!user.attempt_insert_item_for_installation(AM, src))
								return
							ammo_magazine.update_icon()
							user.put_in_hands_or_drop(ammo_magazine)
							user.visible_message(SPAN_WARNING("\The [user] reloads \the [src] with \the [AM]!"),
													SPAN_WARNING("You tactically reload \the [src] with \the [AM]!"))
					else //Speed reloading
						if(!can_special_reload)
							to_chat(user, SPAN_WARNING("You can't speed reload this gun!"))
							return
						if(do_after(user, SPEED_RELOAD_SPEED, src))
							if(!user.attempt_insert_item_for_installation(AM, src))
								return
							ammo_magazine.update_icon()
							ammo_magazine.dropInto(user.loc)
							user.visible_message(SPAN_WARNING("\The [user] reloads \the [src] with \the [AM]!"),
													SPAN_WARNING("You speed reload \the [src] with \the [AM]!"))
				ammo_magazine = AM
				playsound(loc, mag_insert_sound, 75, 1)
				update_icon()
				AM.update_icon()
			if(!user.attempt_insert_item_for_installation(AM, src))
				return
			ammo_magazine = AM
			user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
			playsound(src.loc, mag_insert_sound, 50, 1)
		else if(AM.magazine_type & (MAGAZINE_TYPE_SPEEDLOADER | MAGAZINE_TYPE_CLIP))
			if(loaded.len >= max_shells)
				to_chat(user, "<span class='warning'>[src] is full!</span>")
				return
			var/count = 0
			while(length(loaded) < max_shells)
				var/obj/item/ammo_casing/inserting = AM.peek()
				if(!inserting)
					break
				if(!accepts_casing(inserting))
					break
				inserting = AM.pop(src)
				if(inserting.loc != src)
					inserting.forceMove(src)
				loaded += inserting
				count++
			if(count)
				user.visible_message("[user] reloads [src].", "<span class='notice'>You load [count] round\s into [src].</span>")
				playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1) //Kind of the opposite of empty but the "click" sound fits a speedloader nicely.
		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || !accepts_caliber(C.caliber))
			return //incompatible
		if(loaded.len >= max_shells)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		if(!user.attempt_insert_item_for_installation(C, src))
			return
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src].</span>")
		playsound(src.loc, load_sound, 50, 1)

	else if(istype(A, /obj/item/storage))
		var/obj/item/storage/storage = A
		if(!(load_method & SINGLE_CASING))
			return //incompatible

		to_chat(user, "<span class='notice'>You start loading \the [src].</span>")
		sleep(1 SECOND)
		for(var/obj/item/ammo_casing/ammo in storage.contents)
			if(!accepts_caliber(ammo.caliber))
				continue

			load_ammo(ammo, user)

			if(loaded.len >= max_shells)
				to_chat(user, "<span class='warning'>[src] is full.</span>")
				break
			sleep(1 SECOND)

	update_icon()

#undef TACTICAL_RELOAD_SPEED
#undef SPEED_RELOAD_SPEED

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/ballistic/proc/unload_ammo(mob/user, var/allow_dump=1)
	if(magazine)
		user.put_in_hands_or_drop(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src].</span>")
		playsound(src.loc, mag_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		. = TRUE
	else if(loaded.len)
		//presumably, if it can be speed-loaded, it can be speed-unloaded.
		if(allow_dump && (load_method & SPEEDLOADER))
			var/count = 0
			var/turf/T = get_turf(user)
			if(T)
				for(var/obj/item/ammo_casing/C in loaded)
					C.loc = T
					count++
				loaded.Cut()
			if(count)
				user.visible_message("[user] unloads [src].", "<span class='notice'>You unload [count] round\s from [src].</span>")
		else if(load_method & SINGLE_CASING)
			var/obj/item/ammo_casing/C = loaded[loaded.len]
			loaded.len--
			user.put_in_hands_or_drop(C)
			user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		. = TRUE
	if(.)
		update_icon()

/obj/item/gun/projectile/ballistic/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	load_ammo(A, user)

	if(suppressible)
		if(istype(A, /obj/item/silencer))
			if(!user.is_holding(src))	//if we're not in his hands
				to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.attempt_insert_item_for_installation(A, src))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			to_chat(user, "<span class='notice'>You screw [A] onto [src].</span>")
			silenced = TRUE
			set_weight_class(WEIGHT_CLASS_NORMAL)
			update_icon()
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(A, /obj/item/tool/wrench))
			if(silenced)
				var/obj/item/silencer/S = new (get_turf(user))
				to_chat(user, "<span class='notice'>You unscrew [S]] from [src].</span>")
				user.put_in_hands(S)
				silenced = FALSE
				set_weight_class(WEIGHT_CLASS_SMALL)
				update_icon()

/obj/item/gun/projectile/ballistic/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		if(unload_ammo(user, allow_dump=0))
		else
			return ..()
	else
		return ..()

/obj/item/gun/projectile/ballistic/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	..()
	if(auto_eject && ammo_magazine && !ammo_magazine.amount_remaining())
		ammo_magazine.loc = get_turf(src.loc)
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			"<span class='notice'>[ammo_magazine] falls out and clatters on the floor!</span>"
			)
		if(auto_eject_sound)
			playsound(user, auto_eject_sound, 40, 1)
		magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine

/obj/item/gun/projectile/ballistic/examine(mob/user, dist)
	. = ..()
	if(show_caliber_on_examine)
		#warn show_caliber_on_examine
	if(magazine)
		. += "It has \a [magazine] loaded."
	. += "Has [get_ammo_remaining()] round\s remaining."

//* Ammo *//

/obj/item/gun/projectile/ballistic/get_ammo_ratio(rounded)
	if(internal_magazine)
		var/remaining
		if(internal_magazine_is_revolver)
			for(var/i in 1 to length(internal_magazine_is_revolver))
				if(internal_magazine_vec[i])
					remaining += 1
		else
			remaining = length(internal_magazine_vec)
		return min(1, remaining / internal_magazine_size)
	else
		if(!magazine)
			return 0
		return min(1, magazine.amount_remaining() / magazine.ammo_max)

/obj/item/gun/projectile/ballistic/get_ammo_remaining()
	if(internal_magazine)
		if(internal_magazine_is_revolver)
			for(var/i in 1 to length(internal_magazine_is_revolver))
				if(internal_magazine_vec[i])
					. += 1
		else
			. = length(internal_magazine_vec)
	else
		. = magazine?.amount_remaining()
	if(chamber)
		. += 1

/**
 * Can accept an ammo casing
 */
/obj/item/gun/projectile/ballistic/proc/accepts_casing(obj/item/ammo_casing/casing)
	if(!accepts_caliber(casing.caliber))
		return FALSE
	return TRUE

/**
 * Accepts:
 *
 * * Text caliber string
 * * Caliber path
 * * Caliber instance
 *
 * @return TRUE / FALSE
 */
/obj/item/gun/projectile/ballistic/proc/accepts_caliber(datum/ammo_caliber/caliberlike)
	var/datum/ammo_caliber/ours = resolve_caliber(caliber)
	var/datum/ammo_caliber/theirs = resolve_caliber(caliberlike)
	return ours.equivalent(theirs)

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

/obj/item/gun/projectile/ballistic/proc/accepts_magazine(obj/item/ammo_magazine/magazine)
	return magazine_restrict ? check_magazine_restrict(magazine_restrict, null, magazine.type) : TRUE

/obj/item/gun/projectile/ballistic/proc/accepts_speedloader(obj/item/ammo_magazine/magazine)
	return speedloader_restrict ? check_magazine_restrict(speedloader_restrict, null, magazine.type) : TRUE

//* Chamber *//

/**
 * Get currently chambered projectile
 */
/obj/item/gun/projectile/ballistic/proc/get_chambered() as /obj/item/ammo_casing
	RETURN_TYPE(/obj/item/ammo_casing)
	return chamber

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
	// todo: render_bolt_overlay
	if(render_magazine_overlay)
		if(magazine)
			var/overlay = get_magazine_overlay_for(magazine)
			if(overlay)
				add_overlay(overlay)
