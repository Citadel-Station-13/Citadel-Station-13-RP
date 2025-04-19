/obj/item/gun/projectile/ballistic/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Uses 12g rounds."
	icon_state = "shotgun"
	item_state = "shotgun"
	internal_magazine_size = 4
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	slot_flags = SLOT_BACK
	caliber = /datum/ammo_caliber/a12g
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	internal_magazine = TRUE
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/beanbag
	chamber_cycle_after_fire = FALSE

	one_handed_penalty = 15
	chamber_manual_cycle_sound = 'sound/weapons/shotgunpump.ogg'
	single_load_sound = 'sound/weapons/guns/interaction/shotgun_insert.ogg'
	var/empty_sprite = 0 //This is just a dirty var so it doesn't fudge up.

/obj/item/gun/projectile/ballistic/shotgun/pump/update_icon_state()
	. = ..()
	if(!(item_renderer || mob_renderer) && render_use_legacy_by_default)
		if(!empty_sprite)//Just a dirty check
			return
		if(get_ammo_remaining())
			icon_state = "[icon_state]"
		else
			icon_state = "[icon_state]-empty"

/obj/item/gun/projectile/ballistic/shotgun/pump/slug
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g

/obj/item/gun/projectile/ballistic/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. Uses 12g rounds."
	icon_state = "shotgun_c"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	worth_intrinsic = 500
	internal_magazine_size = 7
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g

/obj/item/gun/projectile/ballistic/shotgun/pump/combat/warden
	name = "warden's shotgun"
	desc = "A heavily modified Hephaestus Industries KS-40. This version bears multiple after-market mods, including a laser sight to help compensate for its shortened stock. 'Property of the Warden' has been etched into the side of the reciever. Uses 12g rounds."
	icon_state = "shotgun_w"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/beanbag

/obj/item/gun/projectile/ballistic/shotgun/pump/combat/warden/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
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

/obj/item/gun/projectile/ballistic/shotgun/pump/combat/warden/verb/reskin_gun()
	set name = "Resprite gun"
	set category = VERB_CATEGORY_OBJECT
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
/obj/item/gun/projectile/ballistic/shotgun/pump/combat/grit
	name = "Grit"
	desc = "This exotic ten gauge shotgun sports a custom paint job and a cylinder choke. At close ranges, it packs quite the punch."
	icon_state = "grit"
	item_state = "grit"
	caliber = /datum/ammo_caliber/a10g
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a10g/pellet/grit
	fire_sound = 'sound/weapons/gunshot/musket.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	one_handed_penalty = 5
	recoil = 10
	accuracy = 40

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A truely classic weapon. No need to change what works. Uses 12g rounds."
	icon_state = "shotgun_d"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	internal_magazine_size = 2
	internal_magazine = TRUE
	internal_magazine_revolver_mode = TRUE
	chamber_simulation = FALSE
	internal_magazine_revolver_spinnable = FALSE
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	slot_flags = SLOT_BACK
	caliber = /datum/ammo_caliber/a12g
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/beanbag

	firemodes = list(
		list(mode_name="fire one barrel at a time", one_handed_penalty = 15, burst=1),
		list(mode_name="fire both barrels at once", one_handed_penalty = 35, burst=2),
	)

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/pellet
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/pellet

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/holy
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/silver
	desc = "Alright you primitive screw heads, listen up. See this? This... is my BOOMSTICK."

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flare shells. Uses 12g rounds."
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/flare

//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/transforming/energy) || istype(A, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(get_ammo_remaining())
			// todo: what happens if it's inside a container?
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			start_firing_cycle_async(src, rand(0, 360), firemode = firemodes[2])
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			set_weight_class(WEIGHT_CLASS_NORMAL)
			damage_force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!" // I'm not gonna add "Uses 12g rounds." to this one. I'll just let this reference go undisturbed.
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3
	accuracy = 40
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/pellet
	w_class = WEIGHT_CLASS_NORMAL
	damage_force = 5
	one_handed_penalty = 5

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn/alt
	icon_state = "shotpistol"
	accuracy = 40

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn/alt/holy // A Special Skin for the sawn off,makes it look like the sawn off from Blood.
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/silver

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/quad
	name = "quad-barreled shotgun"
	desc = "A shotgun pattern designed to make the most out of the limited machining capability of the frontier. 4 Whole barrels of death, loads using 12 gauge rounds."
	icon_state = "shotgun_q"
	item_state = "qshotgun"
	recoil = 2
	internal_magazine_size = 4
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 5
	accuracy = 40
	slot_flags = SLOT_BACK
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/pellet
	caliber = /datum/ammo_caliber/a12g
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)

	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
	)

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn/super
	name = "super shotgun"
	desc = "Rip and tear, until it is done."
	icon_state = "supershotgun"
	item_state = "supershotgun"
	caliber = /datum/ammo_caliber/a10g
	recoil = 0
	accuracy = 80
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a10g/silver
	w_class = WEIGHT_CLASS_NORMAL
	safety_state = GUN_SAFETY_OFF
	damage_force = 15

//Flaregun Code that may work?
/obj/item/gun/projectile/ballistic/shotgun/flare
	name = "Emergency Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'Warning: Possession is prohibited outside of emergency situations'."
	icon_state = "flareg"
	item_state = "flareg"
	chamber_simulation = TRUE
	chamber_preload_ammo = /obj/item/ammo_casing/a12g/flare
	chamber_cycle_after_fire = FALSE
	chamber_manual_cycle = FALSE
	internal_magazine = TRUE
	internal_magazine_size = 0
	w_class = WEIGHT_CLASS_SMALL
	damage_force = 5
	slot_flags = SLOT_BELT
	caliber = /datum/ammo_caliber/a12g
	accuracy = -15 //Its a flaregun and you expected accuracy?

	one_handed_penalty = 0
	worth_intrinsic = 150

/obj/item/gun/projectile/ballistic/shotgun/flare/paramed
	name = "Paramedic Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'For use by emergency medical services only.'"
	icon_state = "flareg-para"

/obj/item/gun/projectile/ballistic/shotgun/flare/explo
	name = "Exploration Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'For use on extraplanetary excursions only.'"
	icon_state = "flareg-explo"

/obj/item/gun/projectile/ballistic/shotgun/flare/holy
	name = "Brass Flare Gun"
	desc = "A Brass Flare Gun far more exspensuve and well made then the plastic ones mass produced for signalling. It fires using an odd clockwork mechanism. Loads using 12g"
	icon_state = "flareg-holy"
	accuracy = 50 //Strong Gun Better Accuracy

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/axe
	name = "Shot Axe"
	desc = " A single barrel shotgun with a long curved stock and an axe head wrapped around the end of the barrel. More axe than shotgun, the blade has been treated with an odd smelling incense. Loads using 12g shells."
	icon_state = "axeshotgun"
	item_state = "axeshotgun"
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/silver
	internal_magazine_revolver_mode = TRUE
	internal_magazine_size = 1
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 25
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_OCCULT = 1)
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE

/obj/item/gun/projectile/ballistic/shotgun/underslung
	name = "underslung shotgun"
	desc = "A compact shotgun designed to be mounted underneath a proper weapon, this secondary unit usually has a limited capacity."
	icon_state = null
	item_state = null
	internal_magazine_size = 1
	w_class = WEIGHT_CLASS_TINY
	caliber = /datum/ammo_caliber/a12g
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g
	one_handed_penalty = 0
	safety_state = GUN_SAFETY_OFF

//Foam Shotguns
/obj/item/gun/projectile/ballistic/shotgun/pump/foam
	name = "toy shotgun"
	desc = "A relatively faithful recreation of a pump action shotgun, this one only accepts foam darts."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_shotgun"
	internal_magazine_size = 8
	damage_force = 5
	caliber = /datum/ammo_caliber/foam
	internal_magazine_preload_ammo = /obj/item/ammo_casing/foam

	one_handed_penalty = 5
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/ballistic/shotgun/pump/foam/blue
	icon_state = "toy_shotgun_blue"
