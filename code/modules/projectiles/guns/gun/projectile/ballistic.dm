/**
 * Ballistic Guns
 *
 * These are guns that fire primarily ammo casings.
 *
 * They have simulation / support for both direct-load / internal magazines, as well as
 * attached / inserted external magazines.
 */
/obj/item/gun/projectile/ballistic
	name = "gun"
	desc = "A gun that fires bullets."
	description_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  To reload, click the weapon in your hand to unload (if needed), then add the appropriate ammo.  The description \
	will tell you what caliber you need."
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "revolver"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = WEIGHT_CLASS_NORMAL
	materials_base = list(MAT_STEEL = 1000)
	recoil = 0
	projectile_type = /obj/projectile/bullet/pistol/strong	//Only used for chameleon guns

	//* Configuration *//

	/// If set, accepts ammo and magazines of this caliber.
	var/caliber = /datum/ammo_caliber/a357

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
	/// * uses BALLISTIC_RENDER_BOLT_* enms
	var/render_bolt_overlay = BALLISTIC_RENDER_BOLT_NEVER
	/// Render the state of a gun that's 'break action'
	///
	/// todo: mob renderer integration
	/// todo: this is not supported yet
	///
	/// * uses BALLISTIC_RENDER_BREAK_* enums
	/// * This is also used for LMGs, and any other gun requiring this stuff.
	var/render_break_overlay = BALLISTIC_RENDER_BREAK_NEVER

	//! LEGACY BELOW

	var/handle_casings = EJECT_CASINGS	//determines how spent casings should be handled
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 3 = magazine
	var/load_method_converted = TRUE

	// todo: rework mag handling, internal magazine?

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0			//the number of casings that will fit inside
	var/ammo_type = null		//the type of ammo that the gun comes preloaded with
	var/list/loaded = list()	//stored ammo
	var/load_sound = 'sound/weapons/guns/interaction/bullet_insert.ogg'

	//For MAGAZINE guns
	var/magazine_type = null	//the type of magazine that the gun comes preloaded with
	var/obj/item/ammo_magazine/ammo_magazine = null //stored magazine
	var/allowed_magazines		//determines list of which magazines will fit in the gun
	var/auto_eject = 0			//if the magazine should automatically eject itself when empty.
	var/auto_eject_sound = null
	var/mag_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'
	var/can_special_reload = TRUE //Whether or not we can perform tactical/speed reloads on this gun
	//TODO generalize ammo icon states for guns
	//var/magazine_states = 0
	//var/list/icon_keys = list()		//keys
	//var/list/ammo_states = list()	//values

/obj/item/gun/projectile/ballistic/Initialize(mapload, starts_loaded = TRUE)
	. = ..()
	if(starts_loaded)
		if(ispath(ammo_type) && (load_method & (SINGLE_CASING|SPEEDLOADER)))
			for(var/i in 1 to max_shells)
				loaded += new ammo_type(src)
		if(ispath(magazine_type) && (load_method & MAGAZINE))
			ammo_magazine = new magazine_type(src)
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
	var/magazine_state = ammo_magazine ? "" : "-empty"
	if(magazine_type)
		icon_state = "[silenced_state][magazine_state]"

/obj/item/gun/projectile/ballistic/consume_next_projectile(datum/gun_firing_cycle/cycle)
	//get the next casing
	if(!chambered)
		if(loaded.len)
			chambered = loaded[1] //load next casing.
			if(handle_casings != HOLD_CASINGS)
				loaded -= chambered
		else if(ammo_magazine && ammo_magazine.amount_remaining())
			chambered = ammo_magazine.pop(src)

	if(!chambered)
		return GUN_FIRED_FAIL_EMPTY

	return prime_casing(cycle, chambered, CASING_PRIMER_CHEMICAL)

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
			if(!H.gloves)
				H.gunshot_residue = chambered.get_caliber_string()
			else
				var/obj/item/clothing/G = H.gloves
				G.gunshot_residue = chambered.get_caliber_string()

	switch(handle_casings)
		if(EJECT_CASINGS) //eject casing onto ground.
			if(chambered.casing_flags & CASING_DELETE)
				qdel(chambered)
				return
			else
				chambered.forceMove(get_turf(src))
				chambered.randomize_offsets_after_eject()
				playsound(src.loc, "casing", 50, 1)
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(ammo_magazine)
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
			if(ammo_magazine)
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
	if(ammo_magazine)
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
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine

/obj/item/gun/projectile/ballistic/examine(mob/user, dist)
	. = ..()
	if(ammo_magazine)
		. += "It has \a [ammo_magazine] loaded."
	. += "Has [getAmmo()] round\s remaining."

/obj/item/gun/projectile/ballistic/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine)
		bullets += ammo_magazine.amount_remaining()
	if(chambered)
		bullets += 1
	return bullets

//* Ammo *//

/obj/item/gun/projectile/ballistic/get_ammo_ratio(rounded)
	if(!ammo_magazine)
		return 0
	return min(1, ammo_magazine.amount_remaining() / ammo_magazine.ammo_max)

/**
 * Can accept an ammo casing
 */
/obj/item/gun/projectile/ballistic/proc/accepts_casing(obj/item/ammo_casing/casing)
	if(!accepts_caliber(casing.caliber))
		return FALSE
	return TRUE

//* Caliber *//

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
		if(ammo_magazine)
			var/overlay = get_magazine_overlay_for(ammo_magazine)
			if(overlay)
				add_overlay(overlay)
