


#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define EJECT_CASINGS	1 //drop spent casings on the ground after firing
#define CYCLE_CASINGS 	2 //experimental: cycle casings, like a revolver. Also works for multibarrelled guns

/obj/item/gun/projectile
	name = "gun"
	desc = "A gun that fires bullets."
	icon_state = "revolver"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = ITEMSIZE_NORMAL
	matter = list(DEFAULT_WALL_MATERIAL = 1000)
	recoil = 1
	projectile_type = /obj/item/projectile/bullet/pistol/strong	//Only used for Cham Guns

	var/caliber = ".357"		//determines which casings will fit
	var/handle_casings = EJECT_CASINGS	//determines how spent casings should be handled
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 3 = magazine
	var/obj/item/ammo_casing/chambered = null

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0			//the number of casings that will fit inside
	var/ammo_type = null		//the type of ammo that the gun comes preloaded with
	var/list/loaded = list()	//stored ammo

	//For MAGAZINE guns
	var/magazine_type = null	//the type of magazine that the gun comes preloaded with
	var/obj/item/ammo_magazine/ammo_magazine = null //stored magazine
	var/allowed_magazines		//determines list of which magazines will fit in the gun
	var/auto_eject = 0			//if the magazine should automatically eject itself when empty.
	var/auto_eject_sound = null
	//TODO generalize ammo icon states for guns
	//var/magazine_states = 0
	//var/list/icon_keys = list()		//keys
	//var/list/ammo_states = list()	//values

/obj/item/gun/projectile/New(loc, var/starts_loaded = 1)
	..()
	if(starts_loaded)
		if(ispath(ammo_type) && (load_method & (SINGLE_CASING|SPEEDLOADER)))
			for(var/i in 1 to max_shells)
				loaded += new ammo_type(src)
		if(ispath(magazine_type) && (load_method & MAGAZINE))
			ammo_magazine = new magazine_type(src)
			allowed_magazines += /obj/item/ammo_magazine/smart
	update_icon()

/obj/item/gun/projectile/consume_next_projectile()
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
		return chambered.BB
	return null

/obj/item/gun/projectile/handle_post_fire()
	..()
	if(chambered)
		chambered.expend()
		process_chambered()

/obj/item/gun/projectile/handle_click_empty()
	..()
	process_chambered()

/obj/item/gun/projectile/proc/process_chambered()
	if (!chambered) return

	// Aurora forensics port, gunpowder residue.
	if(chambered.leaves_residue)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			if(!H.gloves)
				H.gunshot_residue = chambered.caliber
			else
				var/obj/item/clothing/G = H.gloves
				G.gunshot_residue = chambered.caliber

	switch(handle_casings)
		if(EJECT_CASINGS) //eject casing onto ground.
			chambered.loc = get_turf(src)
			playsound(src.loc, "casing", 50, 1)
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(ammo_magazine)
				ammo_magazine.stored_ammo += chambered
			else
				loaded += chambered

	if(handle_casings != HOLD_CASINGS)
		chambered = null


//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/proc/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || caliber != AM.caliber || allowed_magazines && !is_type_in_list(A, allowed_magazines))
			user << "<span class='warning'>[AM] won't load into [src]!</span>"
			return
		switch(AM.mag_type)
			if(MAGAZINE)
				if(ammo_magazine)
					user << "<span class='warning'>[src] already has a magazine loaded.</span>" //already a magazine here
					return
				user.remove_from_mob(AM)
				AM.loc = src
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
				playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
			if(SPEEDLOADER)
				if(loaded.len >= max_shells)
					user << "<span class='warning'>[src] is full!</span>"
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
					playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
			return //incompatible
		if(loaded.len >= max_shells)
			user << "<span class='warning'>[src] is full.</span>"
			return

		user.remove_from_mob(C)
		C.loc = src
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)

	else if(istype(A, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/storage = A
		if(!(load_method & SINGLE_CASING))
			return //incompatible

		user << "<span class='notice'>You start loading \the [src].</span>"
		sleep(1 SECOND)
		for(var/obj/item/ammo_casing/ammo in storage.contents)
			if(caliber != ammo.caliber)
				continue

			load_ammo(ammo, user)

			if(loaded.len >= max_shells)
				user << "<span class='warning'>[src] is full.</span>"
				break
			sleep(1 SECOND)

	update_icon()

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/proc/unload_ammo(mob/user, var/allow_dump=1)
	if(ammo_magazine)
		user.put_in_hands(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
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
			user.put_in_hands(C)
			user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		user << "<span class='warning'>[src] is empty.</span>"
	update_icon()

/obj/item/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	load_ammo(A, user)

/obj/item/gun/projectile/attack_self(mob/user as mob)
	if(firemodes.len > 1)
		switch_firemodes(user)
	else
		unload_ammo(user)

/obj/item/gun/projectile/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/gun/projectile/afterattack(atom/A, mob/living/user)
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

/obj/item/gun/projectile/examine(mob/user)
	..(user)
	if(ammo_magazine)
		user << "It has \a [ammo_magazine] loaded."
	user << "Has [getAmmo()] round\s remaining."
	return

/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += ammo_magazine.stored_ammo.len
	if(chambered)
		bullets += 1
	return bullets

/* Unneeded -- so far.
//in case the weapon has firemodes and can't unload using attack_hand()
/obj/item/gun/projectile/verb/unload_gun()
	set name = "Unload Ammo"
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained()) return

	unload_ammo(usr)
*/









//////////////

//Ballistic guns! Magazines rather than energy
/obj/item/gun/ballistic
	name = "projectile gun"
	desc = "Now comes in flavors like GUN. Uses 10mm ammo, for some reason."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_NORMAL

	//Sound variables
	var/load_sound = "gun_insert_full_magazine"
	var/load_empty_sound = "gun_insert_empty_magazine"
	var/load_sound_volume = 40
	var/load_sound_vary = TRUE
	var/rack_sound = "gun_slide_lock"
	var/rack_sound_volume = 60
	var/rack_sound_vary = TRUE
	var/lock_back_sound = "sound/weapons/pistollock.ogg"
	var/lock_back_sound_volume = 60
	var/lock_back_sound_vary = TRUE
	var/eject_sound = "gun_remove_empty_magazine"
	var/eject_empty_sound = "gun_remove_full_magazine"
	var/eject_sound_volume = 40
	var/eject_sound_vary = TRUE
	var/bolt_drop_sound = 'sound/weapons/gun_chamber_round.ogg'
	var/bolt_drop_sound_volume = 60
	var/empty_alarm_sound = 'sound/weapons/smg_empty_alarm.ogg'
	var/empty_alarm_volume = 70
	var/empty_alarm_vary = TRUE
	var/alarmed = FALSE
	var/empty_alarm = FALSE //Whether the gun alarms when empty or not.

	//Bolts/firing vars

	//Four bolt types:
	//BOLT_TYPE_STANDARD: Gun has a bolt, it stays closed while not cycling. The gun must be racked to have a bullet chambered when a mag is inserted.
	//Example: c20, shotguns, m90
	//BOLT_TYPE_OPEN: Gun has a bolt, it is open when ready to fire. The gun can never have a chambered bullet with no magazine, but the bolt stays ready when a mag is removed.
	//Example: Some SMGs, the L6
	//BOLT_TYPE_NONE: Gun has no moving bolt mechanism, it cannot be racked. Also dumps the entire contents when emptied instead of a magazine.
	//Example: Break action shotguns, revolvers
	//BOLT_TYPE_LOCKING: Gun has a bolt, it locks back when empty. It can be released to chamber a round if a magazine is in.
	//Example: Pistols with a slide lock, some SMGs
	var/bolt_type = BOLT_TYPE_STANDARD
	var/bolt_locked = FALSE		//Used for locking bolt and open bolt guns. Set a bit differently for the two but prevents firing when true for both.
	var/bolt_wording = "bolt" //bolt, slide, etc.
	var/semi_auto = TRUE //Whether the gun has to be racked each shot or not.
	var/rack_delay = 5
	var/recent_rack = 0
	var/casing_ejector = TRUE //whether the gun ejects the chambered casing

	//Magazines and bullets
	var/spawnwithmagazine = TRUE
	var/obj/item/ammo_box/magazine/magazine
	var/internal_magazine = FALSE		//Whether the gun has an internal magazine or a detatchable one. Overridden by BOLT_TYPE_NO_BOLT.
	var/magazine_wording = "magazine"
	var/cartridge_wording = "bullet"
	var/tac_reloads = FALSE		//Snowflake mechanic no more.
	var/mag_type = /obj/item/ammo_box/magazine/m10mm		//Removes the need for max_ammo and caliber info.
	var/special_mags = FALSE //Whether the gun supports multiple special mag types

	//Sprite vars
	var/mag_display = FALSE //Whether the sprite has a visible magazine or not
	var/mag_display_ammo = FALSE //Whether the sprite has a visible ammo display or not
	var/empty_indicator = FALSE //Whether the sprite has an indicator for being empty or not.

/obj/item/gun/ballistic/Initialize()
	. = ..()
	if(spawn_with_magazine)
		if(!magazine)
			magazine = new mag_type(src)
	if(!magazine)
		bolt_locked = TRUE
	else
		update_icon()
	update_icon()

/obj/item/gun/ballistic/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(!semi_auto && from_firing)
		return
	var/obj/item/ammu_casing/AC = chambered
	if(istype(AC))
		if(casing_ejector || !from_firing)
			AC.forceMove(drop_location()) //Eject casing onto ground.
			AC.bounce_away(TRUE)
			chambered = null
		else if(empty_chamber)
			chambered = null
	if(chambered && (bolt_type == BOLT_TYPE_NO_BOLT))
		magazine.insert_last_casing(chambered)
	if (chamber_next_round && (magazine.ammo_left()))
		chamber_round()

/obj/item/gun/ballistic/proc/chamber_round()
	if(chambered || !magazine)
		return
	if(magazine.ammo_left())
		chambered = magazine.default_expend_casing()
		chambered.forceMove(src)

/obj/item/gun/ballistic/proc/rack(mob/user)
	if(bold_type == BOLT_TYPE_NONE)
		return
	if(bolt_type == BOLT_TYPE_OPEN)
		if(!bolt_locked)
			to_chat(user, "<span class='notice'>[src] is already ready to fire!</span>")
			return
		bolt_locked = FALSE
	to_chat(user, "<span class='noticed'>You rack the [bolt_wording] of [src].</span>")
	process_chamber(!chambered, FALSE)
	if((bolt_type == BOLT_TYPE_LOCKING) && !chambered)
		bolt_locked = TRUE
		playsound(src, lock_back_sound, lock_back_sound_volume, lock_back_sound_vary)
	else
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
	update_icon()

/obj/item/gun/ballistic/proc/drop_bolt(mob/user)
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	to_chat(user, "<span class='notice'>You drop the [bolt_wording] of [src].</span>")
	chamber_round()
	bolt_locked = FALSE
	update_icon()

/obj/item/gun/ballistic/can_shoot()
	return chambered

/obj/item/gun/ballistic/proc/prefire_empty_checks()
	if (!chambered && !get_ammo())
		if (bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
			bolt_locked = TRUE
			playsound(src, bolt_drop_sound, bolt_drop_sound_volume)
			update_icon()

/obj/item/gun/ballistic/proc/postfire_empty_checks()
	if (!chambered && !get_ammo())
		if (!alarmed && empty_alarm)
			playsound(src, empty_alarm_sound, empty_alarm_volume, empty_alarm_vary)
			alarmed = TRUE
			update_icon()
		if (bolt_type == BOLT_TYPE_LOCKING)
			bolt_locked = TRUE
			update_icon()

/obj/item/gun/ballistic/proc/insert_magazine(obj/item/ammo_box/magazine/M, mob/user, display_message = TRUE)
	if(user && !user.remove_from_mob(M))
		to_chat(user, "<span class='warning'>[M] seems to be stuck to your hand!</span>")
		return FALSE
	M.forceMove(src)
	if(magazine)
		magazine.forceMove(drop_location())
	magazine = M
	playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	if(bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
		chamber_round()
	update_icon()
	return TRUE

/obj/item/gun/ballistic/proc/eject_magazine(obj/item/ammo_box/magazine/tac_load, mob/user, display_message = TRUE)
	if(bolt_type == BOLT_TYPE_OPEN)
		chambered.forceMove(drop_location())
		chambered = null
	if (magazine.ammo_count())
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
	else
		playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	magazine.forceMove(drop_location())
	var/obj/item/ammo_box/magazine/old_mag = magazine
	magazine = null
	if(tac_load)
		insert_magazine(tac_load, user, FALSE)
		to_chat(user, "<span class='notice'>You perform a tactical reload on \the [src].")
	user.put_in_hands(old_mag)
	//besure to insert logic in here somewhere to drop the bullet chambered if bolt is open bolt!
	old_mag.update_icon()
	if (display_message)
		to_chat(user, "<span class='notice'>You pull the [magazine_wording] out of \the [src].</span>")
	update_icon()










/obj/item/gun/ballistic/attackby(obj/item/A, mob/user, params)
	..()
	if (.)
		return
	if (!internal_magazine && istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			insert_magazine(user, AM)
		else if (magazine)
			if(tac_reloads)
				eject_magazine(user, FALSE, AM)
			else
				to_chat(user, "<span class='notice'>There's already a [magazine_wording] in \the [src].</span>")
		return
	if (istype(A, /obj/item/ammo_casing) || istype(A, /obj/item/ammo_box))
		if (bolt_type == BOLT_TYPE_NO_BOLT || internal_magazine)
			if (chambered && !chambered.BB)
				chambered.forceMove(drop_location())
				chambered = null
			var/num_loaded = magazine.attackby(A, user, params, TRUE)
			if (num_loaded)
				to_chat(user, "<span class='notice'>You load [num_loaded] [cartridge_wording]\s into \the [src].</span>")
				playsound(src, load_sound, load_sound_volume, load_sound_vary)
				if (chambered == null && bolt_type == BOLT_TYPE_NO_BOLT)
					chamber_round()
				A.update_icon()
				update_icon()
			return
	if(istype(A, /obj/item/suppressor))
		var/obj/item/suppressor/S = A
		if(!can_suppress)
			to_chat(user, "<span class='warning'>You can't seem to figure out how to fit [S] on [src]!</span>")
			return
		if(!user.is_holding(src))
			to_chat(user, "<span class='notice'>You need be holding [src] to fit [S] to it!</span>")
			return
		if(suppressed)
			to_chat(user, "<span class='warning'>[src] already has a suppressor!</span>")
			return
		if(user.transferItemToLoc(A, src))
			to_chat(user, "<span class='notice'>You screw \the [S] onto \the [src].</span>")
			install_suppressor(A)
			return
	return FALSE

/obj/item/gun/ballistic/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if (sawn_off)
		bonus_spread += SAWN_OFF_ACC_PENALTY
	. = ..()

/obj/item/gun/ballistic/proc/install_suppressor(obj/item/suppressor/S)
	// this proc assumes that the suppressor is already inside src
	suppressed = S
	w_class += S.w_class //so pistols do not fit in pockets when suppressed
	update_icon()

/obj/item/gun/ballistic/AltClick(mob/user)
	if (unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		reskin_obj(user)
		return
	if(loc == user)
		if(suppressed && can_unsuppress)
			var/obj/item/suppressor/S = suppressed
			if(!user.is_holding(src))
				return ..()
			to_chat(user, "<span class='notice'>You unscrew \the [suppressed] from \the [src].</span>")
			user.put_in_hands(suppressed)
			w_class -= S.w_class
			suppressed = null
			update_icon()
			return


/obj/item/gun/ballistic/afterattack()
	prefire_empty_checks()
	. = ..() //The gun actually firing
	postfire_empty_checks()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/gun/ballistic/attack_hand(mob/user)
	if(!internal_magazine && loc == user && user.is_holding(src) && magazine)
		eject_magazine(user)
		return
	return ..()

/obj/item/gun/ballistic/attack_self(mob/living/user)
	if(!internal_magazine && magazine)
		if(!magazine.ammo_count())
			eject_magazine(user)
			return
	if(bolt_type == BOLT_TYPE_NO_BOLT)
		chambered = null
		var/num_unloaded = 0
		for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
			CB.forceMove(drop_location())
			CB.bounce_away(FALSE, NONE)
			num_unloaded++
		if (num_unloaded)
			to_chat(user, "<span class='notice'>You unload [num_unloaded] [cartridge_wording]\s from [src].</span>")
			playsound(user, eject_sound, eject_sound_volume, eject_sound_vary)
			update_icon()
		else
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return
	if(bolt_type == BOLT_TYPE_LOCKING && bolt_locked)
		drop_bolt(user)
		return
	if (recent_rack > world.time)
		return
	recent_rack = world.time + rack_delay
	rack(user)
	return


/obj/item/gun/ballistic/examine(mob/user)
	..()
	var/count_chambered = !((bolt_type == BOLT_TYPE_NO_BOLT) || (bolt_type == BOLT_TYPE_OPEN))
	to_chat(user, "It has [get_ammo(count_chambered)] round\s remaining.")
	if (!chambered)
		to_chat(user, "It does not seem to have a round chambered.")
	if (bolt_locked)
		to_chat(user, "The [bolt_wording] is locked back and needs to be released before firing.")
	if (suppressed)
		to_chat(user, "It has a suppressor attached that can be removed with <b>alt+click</b>.")

/obj/item/gun/ballistic/proc/get_ammo(countchambered = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets

/obj/item/gun/ballistic/proc/get_ammo_list(countchambered = TRUE, drop_all = FALSE)
	var/list/rounds = list()
	if(chambered && countchambered)
		rounds.Add(chambered)
		if(drop_all)
			chambered = null
	rounds.Add(magazine.ammo_list(drop_all))
	return rounds




/obj/item/gun/ballistic/proc/sawoff(mob/user)
	if(sawn_off)
		to_chat(user, "<span class='warning'>\The [src] is already shortened!</span>")
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("[user] begins to shorten \the [src].", "<span class='notice'>You begin to shorten \the [src]...</span>")

	//if there's any live ammo inside the gun, makes it go off
	if(blow_up(user))
		user.visible_message("<span class='danger'>\The [src] goes off!</span>", "<span class='danger'>\The [src] goes off in your face!</span>")
		return

	if(do_after(user, 30, target = src))
		if(sawn_off)
			return
		user.visible_message("[user] shortens \the [src]!", "<span class='notice'>You shorten \the [src].</span>")
		name = "sawn-off [src.name]"
		desc = sawn_desc
		w_class = WEIGHT_CLASS_NORMAL
		item_state = "gun"
		slot_flags &= ~ITEM_SLOT_BACK	//you can't sling it on your back
		slot_flags |= ITEM_SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
		recoil = SAWN_OFF_RECOIL
		sawn_off = TRUE
		update_icon()
		return TRUE

// Sawing guns related proc
/obj/item/gun/ballistic/proc/blow_up(mob/user)
	. = FALSE
	for(var/obj/item/ammo_casing/AC in magazine.stored_ammo)
		if(AC.BB)
			process_fire(user, user, FALSE)
			. = TRUE


/obj/item/gun/ballistic/update_icon()
	if (QDELETED(src))
		return
	..()
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][sawn_off ? "_sawn" : ""]"
	else
		icon_state = "[initial(icon_state)][sawn_off ? "_sawn" : ""]"
	cut_overlays()
	if (bolt_type == BOLT_TYPE_LOCKING)
		add_overlay("[icon_state]_bolt[bolt_locked ? "_locked" : ""]")
	if (bolt_type == BOLT_TYPE_OPEN && bolt_locked)
		add_overlay("[icon_state]_bolt")
	if (suppressed)
		add_overlay("[icon_state]_suppressor")
	if(!chambered && empty_indicator)
		add_overlay("[icon_state]_empty")
	if (magazine)
		if (special_mags)
			add_overlay("[icon_state]_mag_[initial(magazine.icon_state)]")
			if (!magazine.ammo_count())
				add_overlay("[icon_state]_mag_empty")
		else
			add_overlay("[icon_state]_mag")
			var/capacity_number = 0
			switch(get_ammo() / magazine.max_ammo)
				if(0.2 to 0.39)
					capacity_number = 20
				if(0.4 to 0.59)
					capacity_number = 40
				if(0.6 to 0.79)
					capacity_number = 60
				if(0.8 to 0.99)
					capacity_number = 80
				if(1.0)
					capacity_number = 100
			if (capacity_number)
				add_overlay("[icon_state]_mag_[capacity_number]")






/*
#define BRAINS_BLOWN_THROW_RANGE 3
#define BRAINS_BLOWN_THROW_SPEED 1
/obj/item/gun/ballistic/suicide_act(mob/user)
	var/obj/item/organ/brain/B = user.getorganslot(ORGAN_SLOT_BRAIN)
	if (B && chambered && chambered.BB && can_trigger_gun(user) && !chambered.BB.nodamage)
		user.visible_message("<span class='suicide'>[user] is putting the barrel of [src] in [user.p_their()] mouth.  It looks like [user.p_theyre()] trying to commit suicide!</span>")
		sleep(25)
		if(user.is_holding(src))
			var/turf/T = get_turf(user)
			process_fire(user, user, FALSE, null, BODY_ZONE_HEAD)
			user.visible_message("<span class='suicide'>[user] blows [user.p_their()] brain[user.p_s()] out with [src]!</span>")
			var/turf/target = get_ranged_target_turf(user, turn(user.dir, 180), BRAINS_BLOWN_THROW_RANGE)
			B.Remove(user)
			B.forceMove(T)
			var/datum/callback/gibspawner = CALLBACK(GLOBAL_PROC, /proc/spawn_atom_to_turf, /obj/effect/gibspawner/generic, B, 1, FALSE, user)
			B.throw_at(target, BRAINS_BLOWN_THROW_RANGE, BRAINS_BLOWN_THROW_SPEED, callback=gibspawner)
			return(BRUTELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to blow [user.p_their()] brain[user.p_s()] out with [src]! It looks like [user.p_theyre()] trying to commit suicide!</b></span>")
		playsound(src, dry_fire_sound, 30, TRUE)
		return (OXYLOSS)
#undef BRAINS_BLOWN_THROW_SPEED
#undef BRAINS_BLOWN_THROW_RANGE
*/
