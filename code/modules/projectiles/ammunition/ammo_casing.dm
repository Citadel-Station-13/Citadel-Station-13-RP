/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	slot_flags = SLOT_BELT | SLOT_EARS
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT | ITEM_ENCUMBERS_WHILE_HELD
	throw_force = 1
	w_class = WEIGHT_CLASS_TINY
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

	//* Casing *//
	/// casing flags - see __DEFINES/projectiles/ammo_casing.dm
	var/casing_flags = NONE
	/// what types of primer we react to
	var/casing_primer = CASING_PRIMER_CHEMICAL
	/// caliber - set to typepath of datum for compile checking
	///
	/// todo: rename to casing_caliber?
	///
	/// * may be typepath of caliber (recommended)
	/// * may be instance of caliber (not recommended, but allowable for special cases)
	/// * may NOT be string of caliber, currently
	var/casing_caliber
	/// Effective mass multiplier.
	///
	/// * This is used to calculate energy draw for magnetic weapons.
	/// * Set this as a multiple of a parent type's multiplier.
	var/casing_effective_mass_multiplier = 1

	//* Projectile *//
	/// projectile type
	var/projectile_type
	/// stored projectile - either null for un-init'd, FALSE for empty, or an instance
	VAR_PROTECTED/obj/projectile/projectile_stored
	/// passed to bullet in fire()
	var/list/projectile_effects_add

	//* Icon *//
	/// switch to "[initial(state)]-spent" after expenditure
	var/icon_spent = TRUE

	//! unsorted / legacy
	var/leaves_residue = 1
	var/fall_sounds = list('sound/weapons/guns/casingfall1.ogg','sound/weapons/guns/casingfall2.ogg','sound/weapons/guns/casingfall3.ogg')

/obj/item/ammo_casing/Initialize(mapload)
	. = ..()
	// let's like, not randomize icon state when we're not somewhere relevant, shall we?
	if(isturf(loc) || istype(loc, /obj/structure/closet))
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)

/obj/item/ammo_casing/Destroy()
	if(projectile_stored)
		QDEL_NULL(projectile_stored)
	return ..()

/obj/item/ammo_casing/get_intrinsic_worth(flags)
	return is_loaded()? ..() : 0

/obj/item/ammo_casing/screwdriver_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = TRUE
	if(projectile_stored == FALSE)
		e_args.chat_feedback(SPAN_WARNING("There is no bullet in [src] to inscribe."), src)
		return
	var/label_text = input(e_args.initiator, "Inscribe some text into [initial(projectile_stored.name)]", "Inscription", projectile_stored.name)
	if(!e_args.performer.Adjacent(src))
		return
	label_text = sanitize(label_text, MAX_NAME_LEN, extra = FALSE)
	get_projectile()
	if(!projectile_stored)
		CRASH("projectile stored isn't instanced when it shoudl be")
	if(!label_text)
		e_args.chat_feedback(SPAN_NOTICE("You scratch the inscription off of [initial(projectile_stored.name)]."), src)
		projectile_stored.name = initial(projectile_stored.name)
		return
	e_args.chat_feedback(SPAN_NOTICE("You inscribe [label_text] into \the [initial(projectile_stored.name)]."), src)
	projectile_stored.name = "[initial(projectile_stored.name)] (\"[label_text]\")"

/obj/item/ammo_casing/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images = list())
	. = list(
		TOOL_SCREWDRIVER = list(
			"etch"
		)
	)
	return merge_double_lazy_assoc_list(., ..())

/obj/item/ammo_casing/update_icon_state()
	. = ..()
	if(icon_spent && !is_loaded())
		icon_state = "[base_icon_state || initial(icon_state)]-spent"
	else
		icon_state = base_icon_state || icon_state

/obj/item/ammo_casing/examine(mob/user, dist)
	. = ..()
	if(!is_loaded())
		. += "This one is spent."

/obj/item/ammo_casing/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/mag = I
		mag.quick_gather(get_turf(src), user)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/ammo_casing/throw_land(atom/A, datum/thrownthing/TT)
	. = ..()
	play_drop_sound()

//* Caliber *//

/obj/item/ammo_casing/proc/get_caliber_string()
	return resolve_caliber(casing_caliber)?.caliber

/obj/item/ammo_casing/proc/get_caliber()
	RETURN_TYPE(/datum/ammo_caliber)
	return resolve_caliber(casing_caliber)

//* Firing *//

/**
 * Called as we're fired.
 *
 * @params
 * * priming_methods - the priming methods being used to fire us
 *
 * @return /obj/projectile to shoot, or a GUN_FIRED_* fail status
 */
/obj/item/ammo_casing/proc/process_fire(priming_methods)
	if(!(priming_methods & casing_primer))
		return GUN_FIRED_FAIL_INERT
	. = expend()
	if(!.)
		return GUN_FIRED_FAIL_EMPTY

/**
 * Uses the ammo casing, returning the projectile retrieved, updating icon, etc
 */
/obj/item/ammo_casing/proc/expend()
	if(isnull(projectile_stored))
		init_projectile()
	. = projectile_stored
	projectile_stored = FALSE
	if(isnull(.))
		return
	projectile_stored = FALSE
	setDir(pick(GLOB.cardinal)) //spin spent casings
	update_icon()

/**
 * Play sound when dropped
 */
/obj/item/ammo_casing/proc/play_drop_sound()
	playsound(src, pick(fall_sounds), 50, TRUE)

//* Getters *//

/**
 * sees if we're currently loaded
 */
/obj/item/ammo_casing/proc/is_loaded()
	return projectile_stored != FALSE

/**
 * grab projectile, initializing it if needed
 */
/obj/item/ammo_casing/proc/get_projectile()
	switch(projectile_stored)
		if(null)
			return init_projectile()
		if(FALSE)
			return null
	return projectile_stored

//* Projectile *//

/**
 * makes a new projectile
 */
/obj/item/ammo_casing/proc/init_projectile()
	if(istype(projectile_stored))
		CRASH("double init?")
	projectile_stored = new projectile_type(src)
	projectile_stored.add_projectile_effects(projectile_effects_add)
	return projectile_stored

//* Render *//

/**
 * makes us look messier, basically
 */
/obj/item/ammo_casing/proc/randomize_offsets_after_eject()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

//* Generic - Spent Subtype *//

/obj/item/ammo_casing/spent
	icon_state = /obj/item/ammo_casing::icon_state + "-spent"
	projectile_stored = FALSE
