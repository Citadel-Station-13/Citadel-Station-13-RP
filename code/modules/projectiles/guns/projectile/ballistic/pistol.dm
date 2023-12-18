





/obj/item/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "silencer"
	w_class = ITEMSIZE_SMALL

/obj/item/gun/projectile/ballistic/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3 //Improvised weapons = poor ergonomics
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	safety_state = GUN_NO_SAFETY
	max_shells = 1 //literally just a barrel
	unstable = 1

	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/a357              = ".357",
		/obj/item/ammo_casing/a9mm		        = "9mm",
		/obj/item/ammo_casing/a45				= ".45",
		/obj/item/ammo_casing/a10mm             = "10mm",
		/obj/item/ammo_casing/a12g              = "12g",
		/obj/item/ammo_casing/a12g              = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/beanbag      = "12g",
		/obj/item/ammo_casing/a12g/stunshell    = "12g",
		/obj/item/ammo_casing/a12g/flare        = "12g",
		/obj/item/ammo_casing/a762              = "7.62mm",
		/obj/item/ammo_casing/a556              = "5.56mm"
		)

/obj/item/gun/projectile/ballistic/pirate/Initialize(mapload)
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	return ..()

/obj/item/gun/ballistic/pirate/consume_next_projectile(mob/user as mob)
	. = ..()
	if(.)
		if(unstable)
			if(prob(10))
				to_chat(user, "<span class='danger'>The barrel bursts open as the gun backfires!</span>")
				name = "destroyed zip gun"
				desc = "The barrel has burst. It seems inoperable."
				icon_state = "[initial(icon_state)]-destroyed"
				destroyed = 1
				spawn(1 SECOND)
					explosion(get_turf(src), -1, 0, 2, 3)

		if(destroyed)
			to_chat(user, "<span class='notice'>The [src] is broken!</span>")
			handle_click_empty()
			return

/obj/item/gun/ballistic/pirate/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	. = ..()
	if(destroyed)
		to_chat(user, "<span class='notice'>\The [src] is completely inoperable!</span>")
		handle_click_empty()

/obj/item/gun/ballistic/pirate/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && destroyed)
		to_chat(user, "<span class='danger'>\The [src]'s chamber is too warped to extract the casing!</span>")
		return
	else
		return ..()

/obj/item/gun/projectile/ballistic/derringer
	name = "derringer"
	desc = "It's not size of your gun that matters, just the size of your load. Uses .357 rounds." //OHHH MYYY~
	icon_state = "derringer"
	item_state = "concealed"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 2
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/projectile/bullet/pistol/strong

/obj/item/gun/projectile/ballistic/luger
	name = "\improper P08 Luger"
	desc = "Not some cheap scheisse Martian knockoff! This Luger is an authentic reproduction by RauMauser. Accuracy, easy handling, and its signature appearance make it popular among historic gun collectors. Uses 9mm rounds."
	icon_state = "p08"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/gun/projectile/ballistic/luger/brown
	icon_state = "p08b"

/obj/item/gun/projectile/ballistic/p92x
	name = "9mm pistol"
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. Uses 9mm rounds."
	icon_state = "p92x"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm) // Can accept illegal large capacity magazines, or compact magazines.

/obj/item/gun/projectile/ballistic/p92x/sec
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. This one is a less-lethal variant that only accepts 9mm rubber or flash magazines."
	magazine_type = /obj/item/ammo_magazine/m9mm/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/flash)

//Ported this over from the _vr before deletion. Commenting them out because I'm not sure we want these in.
/*
/obj/item/gun/projectile/ballistic/p92x/large/licensed
	icon_state = "p92x-brown"
	magazine_type = /obj/item/ammo_magazine/m9mm/large/licensed // Spawns with big magazines that are legal.

/obj/item/gun/projectile/ballistic/p92x/large/licensed/hp
	magazine_type = /obj/item/ammo_magazine/m9mm/large/licensed/hp // Spawns with legal hollow-point mag
*/

/obj/item/gun/projectile/ballistic/p92x/brown
	icon_state = "p92x-brown"

/obj/item/gun/projectile/ballistic/p92x/large
	magazine_type = /obj/item/ammo_magazine/m9mm/large // Spawns with illegal magazines.

/obj/item/gun/projectile/ballistic/r9
	name = "C96-Red 9"
	desc = "A variation on the Mauser C-96, remade for a modern day. A Glithari Exports product, for gun collectors and private militaries alike. Uses 9mm stripper clips."
	icon_state = "r9"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL =1) //VERY OLD
	caliber = "9mm"
	load_method = SPEEDLOADER
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/a9mm

/obj/item/gun/projectile/ballistic/r9/holy
	name = "Blessed Red 9"
	desc = "Ah, the choice of an avid gun collector! It's a nice gun, stranger."
	ammo_type = /obj/item/ammo_casing/a9mm/silver


//Hey did you ever see Kingsman? Well, you know this gun then.
/obj/item/gun/projectile/ballistic/konigin
	name = "Konigin-63 compact"
	desc = "A compact pistol with an underslung single-round shotgun barrel. Uses 9mm."
	description_fluff = "Originally produced in 2463 by GMC, the Konigin is considered to be the direct ancestor to the P3 Whisper. Considerably more expensive to manufacture and maintain, the Konigin saw limited use outside of Syndicate special operations cells. By the time GMC ended production of the Konigin-63, the weapon had undergone significant design changes - most notably the installment of a single capacity underbarrel shotgun. This rare design is certainly inspired, and has become something of a collector's item post-war."
	icon_state = "konigin"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "9mm"
	suppressible = TRUE
	silenced_icon = "konigin_silencer"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact/double
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/gun/projectile/ballistic/konigin
	firemodes = list(
		list(mode_name="pistol",       burst=1,    fire_delay=0,    move_delay=null, use_shotgun=null, burst_accuracy=null, dispersion=null),
		list(mode_name="shotgun",  burst=null, fire_delay=null, move_delay=null, use_shotgun=1,    burst_accuracy=null, dispersion=null)
		)

	var/use_shotgun = 0
	var/obj/item/gun/projectile/ballistic/shotgun/underslung/shotgun

/obj/item/gun/projectile/ballistic/konigin/Initialize(mapload)
	. = ..()
	shotgun = new(src)

/obj/item/gun/projectile/ballistic/konigin/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/a12g)))
		shotgun.load_ammo(I, user)
	else
		..()

/obj/item/gun/projectile/ballistic/konigin/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && use_shotgun)
		shotgun.unload_ammo(user)
	else
		..()

/obj/item/gun/projectile/ballistic/konigin/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_shotgun)
		shotgun.Fire(target, user, params, pointblank, reflex)
	else
		..()
