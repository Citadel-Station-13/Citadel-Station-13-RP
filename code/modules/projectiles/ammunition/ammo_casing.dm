/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	slot_flags = SLOT_BELT | SLOT_EARS
	throw_force = 1
	w_class = ITEMSIZE_TINY
	preserve_item = 1
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

	//! Casing
	/// casing flags - see __DEFINES/projectiles/ammo_casing.dm
	var/casing_flags = NONE
	/// projectile type
	var/projectile_type
	/// stored projectile - either null for un-init'd, FALSE for empty, or an instance
	VAR_PRIVATE/obj/item/projectile/stored

	//! Icon
	/// switch to "[initial(state)]-spent" after expenditure
	var/icon_spent = TRUE

	//! unsorted / legacy
	var/leaves_residue = 1
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/fall_sounds = list('sound/weapons/guns/casingfall1.ogg','sound/weapons/guns/casingfall2.ogg','sound/weapons/guns/casingfall3.ogg')

/obj/item/ammo_casing/Initialize(mapload)
	. = ..()
	// let's like, not randomize icon state when we're not somewhere relevant, shall we?
	if(isturf(loc) || istype(loc, /obj/structure/closet))
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)

/obj/item/ammo_casing/Destroy()
	if(stored)
		QDEL_NULL(stored)
	return ..()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB = null
	setDir(pick(GLOB.cardinal)) //spin spent casings
	update_icon()

/obj/item/ammo_casing/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	. = ..()

	if(W.is_screwdriver())
		if(!BB)
			to_chat(user, "<font color=#4F49AF>There is no bullet in the casing to inscribe anything into.</font>")
			return

		var/tmp_label = ""
		var/label_text = sanitizeSafe(input(user, "Inscribe some text into \the [initial(BB.name)]","Inscription",tmp_label), MAX_NAME_LEN)
		if(length(label_text) > 20)
			to_chat(user, "<font color='red'>The inscription can be at most 20 characters long.</font>")
		else if(!label_text)
			to_chat(user, "<font color=#4F49AF>You scratch the inscription off of [initial(BB)].</font>")
			BB.name = initial(BB.name)
		else
			to_chat(user, "<font color=#4F49AF>You inscribe \"[label_text]\" into \the [initial(BB.name)].</font>")
			BB.name = "[initial(BB.name)] (\"[label_text]\")"


/obj/item/ammo_casing/proc/newshot() //For energy weapons, syringe gun, shotgun shells and wands (!).
	if(!BB)
		BB = new projectile_type(src, src)

/**
 * sees if we're currently loaded
 */
/obj/item/ammo_casing/proc/loaded()
	return stored != FALSE

/**
 * grab projectile
 */
/obj/item/ammo_casing/proc/get_projectile()
	switch(stored)
		if(null)
			return lazy_init_projectile()
		if(FALSE)
			return null
	return stored

/**
 * make projectile automatically but only if we're not expended
 */
/obj/item/ammo_casing/proc/lazy_init_projectile()
	if(stored == FALSE)
		return null
	if(istype(stored))
		CRASH("double init?")
	stored = new projectile_type
	return stored

/obj/item/ammo_casing/update_icon_state()
	. = ..()
	if(icon_spent && !loaded())
		icon_state = "[base_icon_state || initial(icon_state)]-spent"
	else
		icon_state = base_icon_state || icon_state

/obj/item/ammo_casing/examine(mob/user)
	. = ..()
	if(!loaded())
		. += "This one is spent."
