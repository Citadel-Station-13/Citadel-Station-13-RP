/obj/item/gun/ballistic/revolver
	name = "revolver"
	desc = "The Lumoco Arms HE Colt is a choice revolver for when you absolutely, positively need to put a hole in the other guy. Uses .357 rounds."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = ".357"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

/obj/item/gun/ballistic/revolver/holy
	name = "blessed revolver"
	ammo_type = /obj/item/ammo_casing/a357/silver

/obj/item/gun/ballistic/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/ballistic/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/ballistic/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun/ballistic/revolver/mateba
	name = "mateba"
	desc = "This unique looking handgun is named after an Italian company famous for the manufacture of these revolvers, and pasta kneading machines. Uses .357 rounds." // Yes I'm serious. -Spades
	icon_state = "mateba"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

/obj/item/gun/ballistic/revolver/mateba/taj
	name = "Adhomai revolver"
	desc = "The Akhan and Khan Royal Service Revolver. Sophisticated but dated, this weapon is a metaphor for the New Kingdom of Adhomai itself."
	icon_state = "mateba-taj"

/obj/item/gun/ballistic/revolver/mateba/taj/knife
	name = "Adhomai knife revolver"
	desc = "An ornate knife revolver from an Adhomai gunsmith. Popular among Tajaran nobility just before the civil war and even to this day, many of these revolvers found their way into the market when they were taken as trophies by Grand People's Army soldiers and DPRA guerillas."
	icon_state = "knifegun"
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38
	force = 15
	sharp = 1
	edge = 1

/obj/item/gun/ballistic/revolver/detective
	name = "revolver"
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	icon_state = "detective"
	caliber = ".38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a38

/obj/item/gun/ballistic/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
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

/obj/item/gun/ballistic/revolver/detective45
	name = ".45 revolver"
	desc = "A fancy replica of an old revolver, modified for .45 rounds and a seven-shot cylinder."
	icon_state = "detective"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a45/rubber
	max_shells = 7


/obj/item/gun/ballistic/revolver/detective45/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
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

/obj/item/gun/ballistic/revolver/detective45/verb/reskin_gun()
	set name = "Resprite gun"
	set category = "Object"
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
/obj/item/gun/ballistic/revolver/deckard
	name = "\improper Deckard .38"
	desc = "A custom-built revolver, based off the semi-popular Detective Special model. Uses .38-Special rounds."
	icon_state = "deckard-empty"
	caliber = ".38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a38

/obj/item/gun/ballistic/revolver/deckard/emp
	ammo_type = /obj/item/ammo_casing/a38/emp


/obj/item/gun/ballistic/revolver/deckard/update_icon_state()
	. = ..()
	if(loaded.len)
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

/obj/item/gun/ballistic/revolver/deckard/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("deckard-reload",src)
	..()

/obj/item/gun/ballistic/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = "caps"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/cap
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/gun/ballistic/revolver/judge
	name = "\"The Judge\""
	desc = "A revolving hand-shotgun by Cybersun Industries that packs the power of a 12 guage in the palm of your hand (if you don't break your wrist). Uses 12g rounds."
	icon_state = "judge"
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	max_shells = 5
	recoil = 2 // ow my fucking hand
	accuracy = -15 // smooth bore + short barrel = shit accuracy
	ammo_type = /obj/item/ammo_casing/a12g
	projectile_type = /obj/item/projectile/bullet/shotgun
	// ToDo: Remove accuracy debuf in exchange for slightly injuring your hand every time you fire it.

/obj/item/gun/ballistic/revolver/lemat
	name = "LeMat Revolver"
	desc = "The LeMat revolver is a 9-shot revolver with a secondar barrel for firing shotgun shells. Cybersun Industries still produces this iconic revolver in limited numbers, deliberately inflating the value of these collectible reproduction pistols. Uses .38 rounds and 12g shotgun shells."
	icon_state = "lemat"
	item_state = "revolver"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 9
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38
	projectile_type = /obj/item/projectile/bullet/pistol
	var/secondary_max_shells = 1
	var/secondary_caliber = "12g"
	var/secondary_ammo_type = /obj/item/ammo_casing/a12g
	var/flipped_firing = 0
	var/list/secondary_loaded = list()
	var/list/tertiary_loaded = list()

/obj/item/gun/ballistic/revolver/lemat/Initialize(mapload)
	for(var/i in 1 to secondary_max_shells)
		secondary_loaded += new secondary_ammo_type(src)
	return ..()

/obj/item/gun/ballistic/revolver/lemat/verb/swap_firingmode()
	set name = "Swap Firing Mode"
	set category = "Object"
	set desc = "Click to swap from one method of firing to another."

	var/mob/living/carbon/human/M = usr
	if(!M.mind)
		return 0

	to_chat(M, "<span class='notice'>You change the firing mode on \the [src].</span>")
	if(!flipped_firing)
		if(max_shells && secondary_max_shells)
			max_shells = secondary_max_shells

		if(caliber && secondary_caliber)
			caliber = secondary_caliber

		if(ammo_type && secondary_ammo_type)
			ammo_type = secondary_ammo_type

		if(secondary_loaded)
			tertiary_loaded = loaded.Copy()
			loaded = secondary_loaded

		flipped_firing = 1

	else
		if(max_shells)
			max_shells = initial(max_shells)

		if(caliber && secondary_caliber)
			caliber = initial(caliber)

		if(ammo_type && secondary_ammo_type)
			ammo_type = initial(ammo_type)

		if(tertiary_loaded)
			secondary_loaded = loaded.Copy()
			loaded = tertiary_loaded

		flipped_firing = 0

/obj/item/gun/ballistic/revolver/lemat/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	if(!flipped_firing)
		loaded = shuffle(loaded)
		if(rand(1,max_shells) > loaded.len)
			chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/ballistic/revolver/lemat/examine(mob/user)
	. = ..()
	if(secondary_loaded)
		var/to_print
		for(var/round in secondary_loaded)
			to_print += round
		. += "\The [src] has a secondary barrel loaded with \a [to_print]"
	else
		. += "\The [src] has a secondary barrel that is empty."

/obj/item/gun/ballistic/revolver/lemat/holy
	name = "Blessed LeMat Revolver"
	ammo_type = /obj/item/ammo_casing/a38/silver
	secondary_ammo_type = /obj/item/ammo_casing/a12g/silver

//Ported from Bay
/obj/item/gun/ballistic/revolver/webley
	name = "service revolver"
	desc = "A rugged top break revolver based on the Webley Mk. VI model, with modern improvements. Uses .44 magnum rounds."
	icon_state = "webley2"
	item_state = "webley2"
	caliber = ".44"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/ballistic/revolver/webley/holy
	name = "blessed service revolver"
	ammo_type = /obj/item/ammo_casing/a44/silver

/obj/item/gun/ballistic/revolver/webley/auto
	name = "autorevolver"
	icon_state = "mosley"
	desc = "A shiny Mosley Autococker automatic revolver, with black accents. Marketed as the 'Revolver for the Modern Era'. Uses .44 magnum rounds."
	fire_delay = 5.7 //Autorevolver. Also synced with the animation
	fire_anim = "mosley_fire"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)

/obj/item/gun/ballistic/revolver/dirty_harry
	name = "Model 29 Revolver"
	desc = "A powerful hand cannon made famous by the legendary lawman that wielded it. Even to this day people follow in his legacy. 'Are you feeling lucky punk?'"
	icon_state = "dirty_harry"
	item_state = "revolver"
	caliber = ".44"
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/ballistic/revolver/dirty_harry/holy
	name = "Blessed Model 29"
	ammo_type = /obj/item/ammo_casing/a44/silver

//NT SpecOps Revolver
/obj/item/gun/ballistic/revolver/combat
	name = "NT-SO combat revolver"
	desc = "A semiautomatic revolver tooled for NanoTrasen special operations. Chambered in .44 Magnum, it serves as the perfect sidearm for any off the books endeavor."
	icon_state = "combatrevolver"
	caliber = ".44"
	fire_delay = 5.7
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/ballistic/revolver/combat/update_icon_state()
	. = ..()
	if(loaded.len)
		icon_state = "combatrevolver"
	else
		icon_state = "combatrevolver-e"
