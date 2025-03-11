/obj/item/gun/projectile/ballistic/revolver
	name = "revolver"
	desc = "The Lumoco Arms HE Colt is a choice revolver for when you absolutely, positively need to put a hole in the other guy. Uses .357 rounds."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/a357
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	chamber_spin_after_fire = TRUE
	internal_magazine = TRUE
	internal_magazine_size = 6
	internal_magazine_revolver_mode = TRUE
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a357

	magazine_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'

/obj/item/gun/projectile/ballistic/revolver/holy
	name = "blessed revolver"
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a357/silver

/obj/item/gun/projectile/ballistic/revolver/mateba
	name = "mateba"
	desc = "This unique looking handgun is named after an Italian company famous for the manufacture of these revolvers, and pasta kneading machines. Uses .357 rounds." // Yes I'm serious. -Spades
	icon_state = "mateba"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

/obj/item/gun/projectile/ballistic/revolver/detective
	name = "revolver"
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	icon_state = "detective"
	caliber = /datum/ammo_caliber/a38
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a38

/obj/item/gun/projectile/ballistic/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/ballistic/revolver/detective45
	name = ".45 revolver"
	desc = "A fancy replica of an old revolver, modified for .45 rounds and a seven-shot cylinder."
	icon_state = "detective"
	caliber = /datum/ammo_caliber/a45
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	internal_magazine_size = 7
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a45/rubber

/obj/item/gun/projectile/ballistic/revolver/detective45/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Rename your gun. If you're the Detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/ballistic/revolver/detective45/verb/reskin_gun()
	set name = "Resprite gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["Colt Detective Special"] = "detective"
	options["Ruger GP100"] = "GP100"
	options["Colt Single Action Army"] = "detective_peacemaker"
	options["Colt Single Action Army, Dark"] = "detective_peacemaker_dark"
	options["H&K PT"] = "detective_panther"
	options["Vintage LeMat"] = "lemat_old"
	options["Webley MKVI "] = "webley"
	options["Lombardi Buzzard"] = "detective_buzzard"
	options["Constable Deluxe 2502"] = "detective_constable"
	options["Synth Tracker"] = "deckard-loaded"
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Say hello to your new friend.")
		return 1


// Blade Runner pistol.
/obj/item/gun/projectile/ballistic/revolver/deckard
	name = "\improper Deckard .38"
	desc = "A custom-built revolver, based off the semi-popular Detective Special model. Uses .38-Special rounds."
	icon_state = "deckard-empty"
	caliber = /datum/ammo_caliber/a38
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a38

/obj/item/gun/projectile/ballistic/revolver/deckard/emp
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a38/emp

/obj/item/gun/projectile/ballistic/revolver/deckard/update_icon_state()
	. = ..()
	if(get_ammo_remaining())
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

// /obj/item/gun/projectile/ballistic/revolver/deckard/load_ammo(var/obj/item/A, mob/user)
// 	if(istype(A, /obj/item/ammo_magazine))
// 		flick("deckard-reload",src)
// 	..()

/obj/item/gun/projectile/ballistic/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/cap_gun
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	internal_magazine_preload_ammo = /obj/item/ammo_casing/cap_gun
	internal_magazine_size = 7

/obj/item/gun/projectile/ballistic/revolver/judge
	name = "\"The Judge\""
	desc = "A revolving hand-shotgun by Cybersun Industries that packs the power of a 12 guage in the palm of your hand (if you don't break your wrist). Uses 12g rounds."
	icon_state = "judge"
	caliber = /datum/ammo_caliber/a12g
	internal_magazine_size = 2
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	recoil = 2 // ow my fucking hand
	accuracy = -15 // smooth bore + short barrel = shit accuracy

	// ToDo: Remove accuracy debuf in exchange for slightly injuring your hand every time you fire it.

// todo: secondary shotgun should be handled as an underbarrel attachment, CM style
/obj/item/gun/projectile/ballistic/revolver/lemat
	name = "LeMat Revolver"
	desc = {"
		A knockoff LeMat revolver that lacks a shotgun shell option.
		Legends say the remnants of Cybersun will return the real thing sooner or later.
	"}
	// desc = {"
	// 	The LeMat revolver is a 9-shot revolver with a secondary barrel for firing shotgun shells.
	// 	Cybersun Industries still produces this iconic revolver in limited numbers,
	// 	deliberately inflating the value of these collectible reproduction pistols.
	// 	Uses .38 rounds and 12g shotgun shells.
	// "}
	icon_state = "lemat"
	item_state = "revolver"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	internal_magazine_size = 9
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a38
	caliber = /datum/ammo_caliber/a38

// 	var/secondary_max_shells = 1
// 	var/secondary_caliber = /datum/ammo_caliber/a12g
// 	var/secondary_ammo_type = /obj/item/ammo_casing/a12g
// 	var/flipped_firing = 0
// 	var/list/secondary_loaded = list()
// 	var/list/tertiary_loaded = list()

// /obj/item/gun/projectile/ballistic/revolver/lemat/Initialize(mapload)
// 	for(var/i in 1 to secondary_max_shells)
// 		secondary_loaded += new secondary_ammo_type(src)
// 	return ..()

// /obj/item/gun/projectile/ballistic/revolver/lemat/verb/swap_firingmode()
// 	set name = "Swap Firing Mode"
// 	set category = VERB_CATEGORY_OBJECT
// 	set desc = "Click to swap from one method of firing to another."

// 	var/mob/living/carbon/human/M = usr
// 	if(!M.mind)
// 		return 0

// 	to_chat(M, "<span class='notice'>You change the firing mode on \the [src].</span>")
// 	if(!flipped_firing)
// 		if(max_shells && secondary_max_shells)
// 			max_shells = secondary_max_shells

// 		if(caliber && secondary_caliber)
// 			caliber = secondary_caliber

// 		if(ammo_type && secondary_ammo_type)
// 			ammo_type = secondary_ammo_type

// 		if(secondary_loaded)
// 			tertiary_loaded = loaded.Copy()
// 			loaded = secondary_loaded

// 		flipped_firing = 1

// 	else
// 		if(max_shells)
// 			max_shells = initial(max_shells)

// 		if(caliber && secondary_caliber)
// 			caliber = initial(caliber)

// 		if(ammo_type && secondary_ammo_type)
// 			ammo_type = initial(ammo_type)

// 		if(tertiary_loaded)
// 			secondary_loaded = loaded.Copy()
// 			loaded = tertiary_loaded

// 		flipped_firing = 0

// /obj/item/gun/projectile/ballistic/revolver/lemat/examine(mob/user, dist)
// 	. = ..()
// 	if(secondary_loaded)
// 		var/to_print
// 		for(var/round in secondary_loaded)
// 			to_print += round
// 		. += "\The [src] has a secondary barrel loaded with \a [to_print]"
// 	else
// 		. += "\The [src] has a secondary barrel that is empty."

/obj/item/gun/projectile/ballistic/revolver/lemat/holy
	name = "Blessed LeMat Revolver"
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a38/silver
	// secondary_ammo_type = /obj/item/ammo_casing/a12g/silver

//Ported from Bay
/obj/item/gun/projectile/ballistic/revolver/webley
	name = "service revolver"
	desc = "A rugged top break revolver based on the Webley Mk. VI model, with modern improvements. Uses .44 magnum rounds."
	icon_state = "webley2"
	item_state = "webley2"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = /datum/ammo_caliber/a44
	internal_magazine_size = 6
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/revolver/webley/holy
	name = "blessed service revolver"
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44/silver

/obj/item/gun/projectile/ballistic/revolver/webley/auto
	name = "autorevolver"
	icon_state = "mosley"
	desc = "A shiny Mosley Autococker automatic revolver, with black accents. Marketed as the 'Revolver for the Modern Era'. Uses .44 magnum rounds."
	firemodes = /datum/firemode{
		cycle_cooldown = 0.5 SECONDS;
	}
	// fire_anim = "mosley_fire"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)

/obj/item/gun/projectile/ballistic/revolver/dirty_harry
	name = "Model 29 Revolver"
	desc = "A powerful hand cannon made famous by the legendary lawman that wielded it. Even to this day people follow in his legacy. 'Are you feeling lucky punk?'"
	icon_state = "dirty_harry"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/a44
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	internal_magazine_size = 6
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/revolver/dirty_harry/holy
	name = "Blessed Model 29"
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44/silver

//NT SpecOps Revolver
/obj/item/gun/projectile/ballistic/revolver/combat
	name = "\improper Ogre combat revolver"
	desc = "The NT-R-7 'Ogre' combat revolver is tooled for Nanotrasen special operations. Chambered in .44 Magnum with an advanced high-speed firing mechanism, it serves as the perfect sidearm for any off the books endeavor."
	icon_state = "combatrevolver"
	caliber = /datum/ammo_caliber/a44
	firemodes = /datum/firemode{
		cycle_cooldown = 0.5 SECONDS;
	}
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/revolver/combat/update_icon_state()
	. = ..()
	if(get_ammo_remaining())
		icon_state = "combatrevolver"
	else
		icon_state = "combatrevolver-e"
