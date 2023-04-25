/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	slot_flags = SLOT_BELT | SLOT_EARS
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT
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
	VAR_PRIVATE/obj/projectile/stored

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
// todo: refactor for actual on-shot or whatever
/obj/item/ammo_casing/proc/expend()
	. = stored
	stored = FALSE
	setDir(pick(GLOB.cardinal)) //spin spent casings
	update_icon()

/obj/item/ammo_casing/screwdriver_act(obj/item/I, mob/user, flags, hint)
	. = TRUE
	if(!stored)
		user.action_feedback(SPAN_WARNING("There is no bullet in [src] to inscribe."), src)
		return
	var/label_text = input(user, "Inscribe some text into [initial(stored.name)]", "Inscription", stored.name)
	label_text = sanitize(label_text, MAX_NAME_LEN, extra = FALSE)
	if(!label_text)
		user.action_feedback(SPAN_NOTICE("You scratch the inscription off of [initial(stored.name)]."), src)
		stored.name = initial(stored.name)
		return
	user.action_feedback(SPAN_NOTICE("You inscribe [label_text] into \the [initial(stored.name)]."), src)
	stored.name = "[initial(stored.name)] (\"[label_text]\")"

/obj/item/ammo_casing/dynamic_tool_functions(obj/item/I, mob/user)
	. = list(
		TOOL_SCREWDRIVER = list(
			"etch"
		)
	)
	return merge_double_lazy_assoc_list(., ..())

/obj/item/ammo_casing/proc/newshot() //For energy weapons, syringe gun, shotgun shells and wands (!).
	if(stored)
		return
	init_projectile()

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
	return init_projectile()

/**
 * makes a new projectile
 */
/obj/item/ammo_casing/proc/init_projectile()
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

/obj/item/ammo_casing/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/mag = I
		mag.quick_gather(get_turf(src), user)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()
