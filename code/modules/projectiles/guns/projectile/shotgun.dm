/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Uses 12g rounds."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	force = 10
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	projectile_type = /obj/item/projectile/bullet/shotgun
	handle_casings = HOLD_CASINGS
	one_handed_penalty = 15
	var/recentpump = 0 // to prevent spammage
	var/action_sound = 'sound/weapons/shotgunpump.ogg'
	load_sound = 'sound/weapons/guns/interaction/shotgun_insert.ogg'
	var/animated_pump = 0 //This is for cyling animations.
	var/empty_sprite = 0 //This is just a dirty var so it doesn't fudge up.

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, action_sound, 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	if(animated_pump)//This affects all bolt action and shotguns.
		flick("[icon_state]-cycling", src)//This plays any pumping

	update_icon()

/obj/item/gun/projectile/shotgun/pump/update_icon_state()
	. = ..()
	if(!empty_sprite)//Just a dirty check
		return
	if((loaded.len) || (chambered))
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]-empty"

/obj/item/gun/projectile/shotgun/pump/slug
	ammo_type = /obj/item/ammo_casing/a12g

/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. Uses 12g rounds."
	icon_state = "shotgun_c"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/a12g
	load_method = SINGLE_CASING|SPEEDLOADER

/obj/item/gun/projectile/shotgun/pump/combat/warden
	name = "warden's shotgun"
	desc = "A heavily modified Hephaestus Industries KS-40. This version bears multiple after-market mods, including a laser sight to help compensate for its shortened stock. 'Property of the Warden' has been etched into the side of the reciever. Uses 12g rounds."
	icon_state = "shotgun_w"
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_BACK
	w_class = ITEMSIZE_NORMAL
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/gun/projectile/shotgun/pump/combat/warden/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the Warden."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Warden")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Lock and load.")
		return 1

/obj/item/gun/projectile/shotgun/pump/combat/warden/verb/reskin_gun()
	set name = "Resprite gun"
	set category = "Object"
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["KS-40 CQC"] = "shotgun_w"
	options["NT Limted Run CQ-6"] = "shotgun_w_corp"
	options["WT Sabot Stinger"] = "shotgun_w_sting"
	options["Donksoft Prank Kit"] = "shotgun_w_donk"
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		item_state = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Lock and load.")
		update_icon()
		return 1

//Don't you wish you had bigger arms?
/obj/item/gun/projectile/shotgun/pump/combat/grit
	name = "Grit"
	desc = "This exotic ten gauge shotgun sports a custom paint job and a cylinder choke. At close ranges, it packs quite the punch."
	icon_state = "grit"
	item_state = "grit"
	caliber = "10g"
	ammo_type = /obj/item/ammo_casing/a10g/pellet/grit
	fire_sound = 'sound/weapons/gunshot/musket.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	one_handed_penalty = 5
	recoil = 10
	accuracy = 40

/*
//This is being stubborn. Might need more input. / In fact, I'm gonna save this work for some larger kind of "Recoil Size Check" system later.
/obj/item/gun/projectile/shotgun/pump/combat/grit/Fire(atom/target, mob/living/user)
	. = ..()
	if(user.mob_size < MOB_MEDIUM)
		var/mob/living/L = target
		var/throwdir = get_dir(user,L)
		var/destination = turn(throwdir, 180)
		user.forceMove(destination)
		user.emote("flip")
*/

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A truely classic weapon. No need to change what works. Uses 12g rounds."
	icon_state = "shotgun_d"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	force = 10
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/a12g/beanbag


	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", one_handed_penalty = 15, burst=1),
		list(mode_name="fire both barrels at once", one_handed_penalty = 35, burst=2),
		)

/obj/item/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/gun/projectile/shotgun/doublebarrel/holy
	ammo_type = /obj/item/ammo_casing/a12g/silver
	desc = "Alright you primitive screw heads, listen up. See this? This... is my BOOMSTICK."
	holy = TRUE

/obj/item/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flare shells. Uses 12g rounds."
	ammo_type = /obj/item/ammo_casing/a12g/flare

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			var/burstsetting = burst
			burst = 2
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			Fire_userless(user)
			burst = burstsetting
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = ITEMSIZE_NORMAL
			force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!" // I'm not gonna add "Uses 12g rounds." to this one. I'll just let this reference go undisturbed.
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3
	accuracy = 40
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	w_class = ITEMSIZE_NORMAL
	force = 5
	one_handed_penalty = 5

/obj/item/gun/projectile/shotgun/doublebarrel/sawn/alt
	icon_state = "shotpistol"
	accuracy = 40

/obj/item/gun/projectile/shotgun/doublebarrel/sawn/alt/holy // A Special Skin for the sawn off,makes it look like the sawn off from Blood.
	ammo_type = /obj/item/ammo_casing/a12g/silver
	holy = TRUE

/obj/item/gun/projectile/shotgun/doublebarrel/quad
	name = "quad-barreled shotgun"
	desc = "A shotgun pattern designed to make the most out of the limited machining capability of the frontier. 4 Whole barrels of death, loads using 12 gauge rounds."
	icon_state = "shotgun_q"
	item_state = "qshotgun"
	recoil = 2
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	force = 5
	accuracy = 40
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/a12g/pellet

	burst_delay = 0

	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		)

/obj/item/gun/projectile/shotgun/doublebarrel/sawn/super
	name = "super shotgun"
	desc = "Rip and tear, until it is done."
	icon_state = "supershotgun"
	item_state = "supershotgun"
	caliber = "10g"
	recoil = 0
	accuracy = 80
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/a10g/silver
	w_class = ITEMSIZE_NORMAL
	safety_state = GUN_SAFETY_OFF
	force = 15

//Flaregun Code that may work?
/obj/item/gun/projectile/shotgun/flare
	name = "Emergency Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'Warning: Possession is prohibited outside of emergency situations'."
	icon_state = "flareg"
	item_state = "flareg"
	load_method = SINGLE_CASING
	handle_casings = CYCLE_CASINGS
	max_shells = 1
	w_class = ITEMSIZE_SMALL
	force = 5
	slot_flags = SLOT_BELT
	caliber = "12g"
	accuracy = -15 //Its a flaregun and you expected accuracy?
	ammo_type = /obj/item/ammo_casing/a12g/flare
	projectile_type = /obj/item/projectile/energy/flash
	one_handed_penalty = 0

/obj/item/gun/projectile/shotgun/flare/paramed
	name = "Paramedic Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'For use by emergency medical services only.'"
	icon_state = "flareg-para"


/obj/item/gun/projectile/shotgun/flare/explo
	name = "Exploration Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'For use on extraplanetary excursions only.'"
	icon_state = "flareg-explo"

/obj/item/gun/projectile/shotgun/flare/holy
	name = "Brass Flare Gun"
	desc = "A Brass Flare Gun far more exspensuve and well made then the plastic ones mass produced for signalling. It fires using an odd clockwork mechanism. Loads using 12g"
	icon_state = "flareg-holy"
	accuracy = 50 //Strong Gun Better Accuracy
	holy = TRUE

/obj/item/gun/projectile/shotgun/doublebarrel/axe
	name = "Shot Axe"
	desc = " A single barrel shotgun with a long curved stock and an axe head wrapped around the end of the barrel. More axe than shotgun, the blade has been treated with an odd smelling incense. Loads using 12g shells."
	icon_state = "axeshotgun"
	item_state = "axeshotgun"
	load_method = SINGLE_CASING
	handle_casings = CYCLE_CASINGS
	ammo_type = /obj/item/ammo_casing/a12g/silver
	max_shells = 1
	w_class = ITEMSIZE_LARGE
	force = 25
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_OCCULT = 1)
	sharp = 1
	edge = 1
	holy = TRUE

/obj/item/gun/projectile/shotgun/underslung
	name = "underslung shotgun"
	desc = "A compact shotgun designed to be mounted underneath a proper weapon, this secondary unit usually has a limited capacity."
	icon_state = null
	item_state = null
	load_method = SINGLE_CASING
	handle_casings = CYCLE_CASINGS
	max_shells = 1
	w_class = ITEMSIZE_TINY
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g
	one_handed_penalty = 0
	safety_state = GUN_SAFETY_OFF

//Foam Shotguns
/obj/item/gun/projectile/shotgun/pump/foam
	name = "toy shotgun"
	desc = "A relatively faithful recreation of a pump action shotgun, this one only accepts foam darts."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_shotgun"
	max_shells = 8
	force = 5
	caliber = "foamdart"
	ammo_type = /obj/item/ammo_casing/foam
	projectile_type = /obj/item/projectile/bullet/reusable/foam
	one_handed_penalty = 5
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/shotgun/pump/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0
	return

/obj/item/gun/projectile/shotgun/pump/foam/pump(mob/M as mob)
	playsound(M, action_sound, 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	if(animated_pump)//This affects all bolt action and shotguns.
		flick("[icon_state]-cycling", src)//This plays any pumping

	update_icon()
/obj/item/gun/projectile/shotgun/pump/foam/blue
	icon_state = "toy_shotgun_blue"
