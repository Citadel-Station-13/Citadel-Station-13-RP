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

	/// casing flags - see __DEFINES/projectiles/ammo_casing.dm
	var/casing_flags = NONE

	var/leaves_residue = 1
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null	//The loaded bullet - make it so that the projectiles are created only when needed?
	var/fall_sounds = list('sound/weapons/guns/casingfall1.ogg','sound/weapons/guns/casingfall2.ogg','sound/weapons/guns/casingfall3.ogg')

/obj/item/ammo_casing/Initialize(mapload)
	. = ..()
	if(ispath(projectile_type))
		BB = new projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

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

/obj/item/ammo_casing/update_icon()
	if(!BB)
		icon_state = "[initial(icon_state)]-spent"

/obj/item/ammo_casing/examine(mob/user)
	. = ..()
	if (!BB)
		. += "This one is spent."

/obj/item/ammo_casing/proc/newshot() //For energy weapons, syringe gun, shotgun shells and wands (!).
	if(!BB)
		BB = new projectile_type(src, src)
