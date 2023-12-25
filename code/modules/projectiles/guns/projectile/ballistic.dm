/**
 * Projectile guns that use ammo casings / magazines.
 */
/obj/item/gun/projectile/ballistic
	//* chamber
	/// if in internal ammo mode, cycle forwards on fire, regardless of casing mode
	var/cycle_on_fire = TRUE
	/// drop spent casings?
	var/eject_on_fire = TRUE
	/// rack / charge chamber on fire
	var/rack_on_fire = TRUE
	/// automatically rack on magazine insert, which transfers a round to chamber
	var/rack_on_magazine = FALSE
	/// default manual racking allowed
	var/rack_allowed = TRUE
	/// do we need racking at all? if not, we directly draw from magazine.
	var/chamber_charging_system = TRUE
	/// chambered casing
	var/obj/item/ammo_casing/chambered
	/// chamber racking sound
	var/chamber_charging_sound
	#warn find a sound
	/// compatible calibers - either an enum or a list
	/// this controls what magazines we can load, as well as what bullets we can hold
	/// if unset, we use caliber_bounds system!
	var/list/regex_this_caliber
	/// determines what can fit in this gun
	var/caliber_bound_diameter_low = 0
	/// determines what can fit in this gun
	var/caliber_bound_diameter_high = INFINITY
	/// determines what can fit in this gun
	var/caliber_bound_length_low = 0
	/// determines what can fit in this gun
	var/caliber_bound_length_high = INFINITY
	/// ammo load sound
	var/casing_load_sound = 'sound/weapons/guns/interaction/bullet_insert.ogg'
	#warn find a sound

	//* static config; do not change at runtime without using helpers.
	/// do we use magazines? this **CANNOT** be changed at runtime without a proc
	/// because behavior and initializations depend on this!
	/// speedloaders cannot be used with a gun that uses magazines
	var/use_magazines = FALSE

	//* dynamic config; can be changed at runtime freely
	/// allow speedloaders?
	/// speedloaders can only be used with guns that don't use magazines
	var/speedloader_allowed = TRUE
	/// speedloaders load 1 at a time?
	var/speedloader_serial = TRUE
	/// speedloader delay
	var/speedloader_delay = 0.5 SECONDS
	/// speedloader types allowed; if null, we only care aobut caliber
	var/speedloader_type

	//* for guns that use magazines
	/// magazine type allowed ; must match the magazine's. if null, we only use caliber.
	/// this can be a list, or a single datapoint.
	/// if list, we check for type to be inside the list.
	var/list/magazine_type
	/// magazine type to preload with
	var/magazine_preload
	/// stored magazine
	var/obj/item/ammo_magazine/magazine
	/// magazine auto ejects on empty
	//  todo: legacy
	var/magazine_auto_eject = FALSE
	/// sound to play on magazine auto eject
	var/magazine_auto_eject_sound
	/// magazine load sound
	var/magazine_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	/// magazine unload sound
	var/magazine_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'
	/// allow magazine removal.
	var/magazine_removable = TRUE
	/// speed reload time (drop magazine)
	var/reload_time_drop = 1 SECONDS
	/// tactical reload time (replace magazine)
	var/reload_time_replace = 2 SECONDS

	//* for guns that don't use magazines
	/// internal ammo holder size. 0 = single action, put in chamber, cock, and fire
	var/internal_ammo_capacity = 0
	/// internal ammo acts like a revolver; this means that the list will have nulls in it and be rotated
	/// rather than have nulls dropped
	var/internal_ammo_revolver = FALSE
	/// for revolver mode: list position. this means we don't need to constantly shift the list.
	var/internal_ammo_position
	/// internal ammo list
	var/list/internal_ammo_held
	/// starts loaded with ammo type
	var/internal_ammo_preload
	/// starts loaded with amount; defaults to max
	var/internal_ammo_amount

	//* Rendering
	/// rendering system for magazine
	/// in overlay mode, we add "[base_icon_state]-empty" as a priority overlay if we're empty.
	/// in state mode, "-empty" is automatically inserted after base_icon_state if we're empty, after bolt state (if applicable).
	/// in state mode, we will override all other states.
	var/render_magazine_system = GUN_RENDERING_DISABLED
	/// use -ext if we have an extended magazine in
	var/render_magazine_extended = FALSE
	/// magazine rendering system is used for inhands
	/// this will result in the effective item state for onmob being modified,
	/// completely ignores render_magazine_system; this only uses states!
	var/render_magazine_inhand = TRUE
	#warn hook above using render_append_state and priority overlays, and overriding build worn icon etc etc
	/// rendering system for bolt
	/// in overlay mode, we add "[base_icon_state]-open" as a priority overlay if we're open.
	/// in state mode, "-open" is automatically inserted after base_icon_state if we're open, before any other state.
	/// in state mode, we will override all other states.
	var/render_magazine_system = GUN_RENDERING_DISABLED
	/// magazine rendering system is used for inhands
	/// this will result in the effective item state for onmob being modified,
	/// completely ignores render_magazine_system; this only uses states!
	var/render_magazine_inhand = TRUE
	#warn hook above using render_append_state and priority overlays, and overriding build worn icon etc etc

/obj/item/gun/projectile/ballistic/Initialize(mapload)
	. = ..()
	init_ammo()

/obj/item/gun/projectile/ballistic/proc/init_ammo()
	#warn impl

/obj/item/gun/projectile/ballistic/consume_next_projectile()
	#warn impl

/obj/item/gun/projectile/ballistic/percent_ammo()
	#warn impl

/obj/item/gun/projectile/ballistic/examine(mob/user, dist)
	. = ..()
	#warn impl

/obj/item/gun/projectile/ballistic/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	. = ..()
	#warn impl

/obj/item/gun/projectile/ballistic/proc/handle_magazine_load(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor)
	WRAP_MOB_TO_ACTOR_EVENT_ARGS(actor)
	#warn impl

/obj/item/gun/projectile/ballistic/proc/handle_casing_load(obj/item/ammo_casing/casing, datum/event_args/actor/actor)
	WRAP_MOB_TO_ACTOR_EVENT_ARGS(actor)
	#warn impl

/**
 * returns string reason why we can't load something, or null if we can
 */
/obj/item/gun/projectile/ballistic/proc/why_cant_load_magazine(obj/item/ammo_magazine/magazine)

/**
 * returns string reason why we can't load something, or null if we can
 */
/obj/item/gun/projectile/ballistic/proc/why_cant_load_casing(obj/item/ammo_casing/casing)

/obj/item/gun/projectile/ballistic/post_fire(atom/target, atom/movable/user, turf/where, angle, reflex, iteration)
	. = ..()
	process_chamber()

/**
 * process chamber post fire
 */
/obj/item/gun/projectile/ballistic/proc/process_chamber()
	if(cycle_on_fire)
		#warn impl

	if(isnull(chambered))
		return

	chambered.expend()

	if(chambered.casing_flags & CASING_DELETE)
		QDEL_NULL(chambered)
	else if(eject_on_fire)
		// todo: this is bad code
		chambered.forceMove(loc.drop_location())
		// todo: variable sounds?
		playsound(src, "casing", 50, TRUE)

	if(rack_on_fire)
		rack_chamber(TRUE)

/**
 * rack chamber
 */
/obj/item/gun/projectile/ballistic/proc/rack_chamber(silent)
	#warn impl

/**
 * has round in chambered
 */
/obj/item/gun/projectile/ballistic/proc/has_chambered()
	return !isnull(chambered)

/**
 * get round chambered
 */
/obj/item/gun/projectile/ballistic/proc/peek_chambered()
	return chambered

#warn below

/obj/item/gun/projectile/ballistic/Initialize(mapload, starts_loaded = TRUE)
	. = ..()
	if(starts_loaded)
		if(ispath(ammo_type) && (load_method & (SINGLE_CASING|SPEEDLOADER)))
			for(var/i in 1 to max_shells)
				loaded += new ammo_type(src)
		if(ispath(magazine_type) && (load_method & MAGAZINE))
			ammo_magazine = new magazine_type(src)
	update_icon()

/obj/item/gun/ballistic/update_icon_state()
	. = ..()
	var/silenced_state = silenced ? silenced_icon : initial(icon_state)
	var/magazine_state = ammo_magazine ? "" : "-empty"
	if(magazine_type)
		icon_state = "[silenced_state][magazine_state]"

/obj/item/gun/projectile/ballistic/consume_next_projectile()
	//get the next casing
	if(loaded.len)
		chambered = loaded[1] //load next casing.
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(ammo_magazine && ammo_magazine.stored_ammo.len)
		chambered = ammo_magazine.stored_ammo[ammo_magazine.stored_ammo.len]
		if(handle_casings != HOLD_CASINGS)
			ammo_magazine.stored_ammo -= chambered

	if (chambered)
		return chambered.get_projectile()
	return null

//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/ballistic/proc/load_ammo(obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || caliber != AM.caliber || allowed_magazines && !is_type_in_list(A, allowed_magazines))
			to_chat(user, SPAN_WARNING("[AM] won't load into [src]!"))
			return
		switch(AM.mag_type)
			if(MAGAZINE)
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
					playsound(loc, magazine_insert_sound, 75, 1)
					update_icon()
					AM.update_icon()
				if(!user.attempt_insert_item_for_installation(AM, src))
					return
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
				playsound(src.loc, magazine_insert_sound, 50, 1)
			if(SPEEDLOADER)
				if(loaded.len >= max_shells)
					to_chat(user, "<span class='warning'>[src] is full!</span>")
					return
				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(loaded.len >= max_shells)
						break
					if(C.caliber == caliber)
						C.loc = src
						loaded += C
						AM.stored_ammo -= C //should probably go inside an ammo_magazine proc, but I guess less proc calls this way...
						count++
				if(count)
					user.visible_message("[user] reloads [src].", "<span class='notice'>You load [count] round\s into [src].</span>")
					playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1) //Kind of the opposite of empty but the "click" sound fits a speedloader nicely.
		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
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
			if(caliber != ammo.caliber)
				continue

			load_ammo(ammo, user)

			if(loaded.len >= max_shells)
				to_chat(user, "<span class='warning'>[src] is full.</span>")
				break
			sleep(1 SECOND)

	update_icon()

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/ballistic/proc/unload_ammo(mob/user, var/allow_dump=1)
	if(ammo_magazine)
		user.put_in_hands_or_drop(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src].</span>")
		playsound(src.loc, magazine_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
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
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
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
			w_class = ITEMSIZE_NORMAL
			update_icon()
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(A, /obj/item/tool/wrench))
			if(silenced)
				var/obj/item/silencer/S = new (get_turf(user))
				to_chat(user, "<span class='notice'>You unscrew [S]] from [src].</span>")
				user.put_in_hands(S)
				silenced = FALSE
				w_class = ITEMSIZE_SMALL
				update_icon()

/obj/item/gun/projectile/ballistic/attack_self(mob/user)
	if(firemodes.len > 1)
		switch_firemodes(user)
	else if(ammo_magazine)
		ammo_magazine.forceMove(user.drop_location())
		user.visible_message("[user] dumps [ammo_magazine] from [src] onto the floor.", SPAN_NOTICE("You dump [ammo_magazine] from [src] onto the floor."))
		playsound(src, magazine_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
	else
		unload_ammo(user)
	update_icon()

/obj/item/gun/projectile/ballistic/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src)
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/gun/projectile/ballistic/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	..()
	if(auto_eject && ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
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
	return

/obj/item/gun/projectile/ballistic/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += ammo_magazine.stored_ammo.len
	if(chambered)
		bullets += 1
	return bullets
