/obj/item/gun/projectile/colt
	var/unique_reskin
	name = ".45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	icon_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/gun/projectile/colt/update_icon_state()
	. = ..()
	if(ammo_magazine)
		if(unique_reskin)
			icon_state = unique_reskin
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin]-e"
		else
			icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/colt/detective
	desc = "A Martian recreation of an old pistol. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45/rubber

/obj/item/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're Security."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Detective" && job != "Security Officer" && job != "Warden" && job != "Head of Security")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/colt/detective/verb/reskin_gun()
	set name = "Resprite gun"
	set category = "Object"
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["NT Mk. 58"] = "secguncomp"
	options["NT Mk. 58 Custom"] = "secgundark"
	options["Colt M1911"] = "colt"
	options["USP"] = "usp"
	options["H&K VP"] = "VP78"
	options["P08 Luger"] = "p08"
	options["P08 Luger, Brown"] = "p08b"
	options["Glock 37"] = "enforcer_black"
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		unique_reskin = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/colt/taj
	name = "Adhomai Pistol"
	desc = "The Adar'Mazy pistol, produced by the Hadii-Wrack group. This pistol is the primary sidearm for low ranking officers and officals in the People's Republic of Adhomai."
	icon_state = "colt-taj"

/*//apart of reskins that have two sprites, touching may result in frustration and breaks
/obj/item/gun/projectile/colt/detective/attack_hand(var/mob/living/user)
	if(!unique_reskin && loc == user)
		reskin_gun(user)
		return
	..()
*/

/obj/item/gun/projectile/sec
	name = ".45 pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. Found pretty much everywhere humans are. This one is a less-lethal variant that only accepts .45 rubber or flash magazines."
	icon_state = "secguncomp"
	magazine_type = /obj/item/ammo_magazine/m45/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/flash, /obj/item/ammo_magazine/m45/practice)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/gun/projectile/sec/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "secguncomp"
	else
		icon_state = "secguncomp-e"

/obj/item/gun/projectile/sec/flash
	name = ".45 signal pistol"
	magazine_type = /obj/item/ammo_magazine/m45/flash

/obj/item/gun/projectile/sec/wood
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. This one has a sweet wooden grip and only accepts .45 rubber or flash magazines."
	name = "custom .45 pistol"
	icon_state = "secgundark"

/obj/item/gun/projectile/sec/wood/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "secgundark"
	else
		icon_state = "secgundark-e"

/obj/item/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = ITEMSIZE_NORMAL
	caliber = ".45"
	silenced = 1
	fire_delay = 1
	recoil = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/item/projectile/bullet/pistol/medium

/obj/item/gun/projectile/deagle
	name = "desert eagle"
	desc = "The perfect handgun for shooters with a need to hit targets through a wall and behind a fridge in your neighbor's house. Uses .44 rounds."
	icon_state = "deagle"
	item_state = "deagle"
	force = 14.0
	caliber = ".44"
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m44
	allowed_magazines = list(/obj/item/ammo_magazine/m44)

/obj/item/gun/projectile/deagle/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .44 rounds."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .44 rounds."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/projectile/deagle/taj
	name = "Adhomai Hand Cannon"
	desc = "The Nal'dor heavy pistol, a powerful Hadii-Wrack group handcannon that has gained an infamous reputation through its use by Commissars of the People's Republic of Adhomai."
	icon_state = "deagle-taj"

/obj/item/gun/projectile/gyropistol // Does this even appear anywhere outside of admin abuse?
	name = "gyrojet pistol"
	desc = "Speak softly, and carry a big gun. Fires rare .75 caliber self-propelled exploding bolts--because fuck you and everything around you."
	icon_state = "gyropistol"
	max_shells = 8
	caliber = ".75"
	fire_sound = 'sound/weapons/railgun.ogg'
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = "/obj/item/ammo_casing/a75"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m75
	allowed_magazines = list(/obj/item/ammo_magazine/m75)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/gyropistol/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/gun/projectile/pistol
	name = "compact pistol"
	desc = "The Lumoco Arms P3 Whisper. A compact, easily concealable gun, though it's only compatible with compact magazines. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/gun/projectile/pistol/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/pistol/flash
	name = "compact signal pistol"
	magazine_type = /obj/item/ammo_magazine/m9mm/compact/flash

/obj/item/gun/projectile/pistol/attack_hand(mob/living/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(!user.item_is_in_hands(src))
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = 0
			w_class = ITEMSIZE_SMALL
			update_icon()
			return
	..()

/obj/item/gun/projectile/pistol/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/silencer))
		if(!user.item_is_in_hands(src))	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		user.drop_item()
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = ITEMSIZE_NORMAL
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/gun/projectile/pistol/update_icon_state()
	. = ..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "silencer"
	w_class = ITEMSIZE_SMALL

/obj/item/gun/projectile/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3 //Improvised weapons = poor ergonomics
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	safety_state = GUN_NO_SAFETY
	max_shells = 1 //literally just a barrel

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
		/obj/item/ammo_casing/a545              = "5.45mm"
		)

/obj/item/gun/projectile/pirate/Initialize(mapload)
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	return ..()

/obj/item/gun/projectile/derringer
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
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/gun/projectile/luger
	name = "\improper P08 Luger"
	desc = "Not some cheap scheisse Martian knockoff! This Luger is an authentic reproduction by RauMauser. Accuracy, easy handling, and its signature appearance make it popular among historic gun collectors. Uses 9mm rounds."
	icon_state = "p08"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/gun/projectile/luger/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/luger/brown
	icon_state = "p08b"

/obj/item/gun/projectile/p92x
	name = "9mm pistol"
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. Uses 9mm rounds."
	icon_state = "p92x"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm) // Can accept illegal large capacity magazines, or compact magazines.

/obj/item/gun/projectile/p92x/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/p92x/sec
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. This one is a less-lethal variant that only accepts 9mm rubber or flash magazines."
	magazine_type = /obj/item/ammo_magazine/m9mm/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/flash)

//Ported this over from the _vr before deletion. Commenting them out because I'm not sure we want these in.
/*
/obj/item/gun/projectile/p92x/large/licensed
	icon_state = "p92x-brown"
	magazine_type = /obj/item/ammo_magazine/m9mm/large/licensed // Spawns with big magazines that are legal.

/obj/item/gun/projectile/p92x/large/licensed/hp
	magazine_type = /obj/item/ammo_magazine/m9mm/large/licensed/hp // Spawns with legal hollow-point mag
*/

/obj/item/gun/projectile/p92x/brown
	icon_state = "p92x-brown"

/obj/item/gun/projectile/p92x/large
	magazine_type = /obj/item/ammo_magazine/m9mm/large // Spawns with illegal magazines.

/obj/item/gun/projectile/r9
	name = "C96-Red 9"
	desc = "A variation on the Mauser C-96 - the first semi firearm ever to be widely adopted by a human military. This version is chambered for 9mm and reloads using stripper clips."
	icon_state = "r9"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL =1) //VERY OLD
	caliber = "9mm"
	load_method = SPEEDLOADER
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/a9mm

/obj/item/gun/projectile/r9/holy
	name = "Blessed Red 9"
	desc = "Ah, the choice of an avid gun collector! It's a nice gun, stranger."
	ammo_type = /obj/item/ammo_casing/a9mm/silver
	holy = TRUE

/obj/item/gun/projectile/clown_pistol
	name = "clown pistol"
	desc = "This curious weapon feeds from a compressed biomatter cartridge, and seems to fabricate its ammunition from that supply."
	icon_state = "clownpistol"
	item_state = "revolver"
	caliber = "organic"
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	magazine_type = /obj/item/ammo_magazine/mcompressedbio/compact
	allowed_magazines = list(/obj/item/ammo_magazine/mcompressedbio/compact)
	projectile_type = /obj/item/projectile/bullet/organic

/obj/item/gun/projectile/clown_pistol/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

//Exploration/Pathfinder Sidearms
/obj/item/gun/projectile/fnseven
	name = "NT-57 'LES'"
	desc = "The NT-57 'LES' (Light Expeditionary Sidearm) is a tried and tested pistol often issued to Pathfinders. Featuring a polymer frame, collapsible stock, and integrated optics, the LES is lightweight and reliably functions in nearly any hazardous environment, including vacuum."
	icon_state = "nt57"
	item_state = "pistol"
	caliber = "5.7x28mm"
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m57x28mm
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mm)
	projectile_type = /obj/item/projectile/bullet/pistol/lap
	one_handed_penalty = 30
	var/collapsible = 1
	var/extended = 0

/obj/item/gun/projectile/fnseven/update_icon_state()
	. = ..()
	if(!extended && ammo_magazine)
		icon_state = "nt57"
	else if(extended && ammo_magazine)
		icon_state = "nt57_extended"
	else if(extended && !ammo_magazine)
		icon_state = "nt57_extended-e"
	else
		icon_state = "nt57-e"

/obj/item/gun/projectile/fnseven/attack_self(mob/user, obj/item/gun/G)
	if(collapsible && !extended)
		to_chat(user, "<span class='notice'>You pull out the stock on the [src], steadying the weapon.</span>")
		w_class = ITEMSIZE_LARGE
		one_handed_penalty = 10
		extended = 1
		update_icon()
	else if(!collapsible)
		to_chat(user, "<span class='danger'>The [src] doesn't have a stock!</span>")
		return
	else
		to_chat(user, "<span class='notice'>You push the stock back into the [src], making it more compact.</span>")
		w_class = ITEMSIZE_NORMAL
		one_handed_penalty = 30
		extended = 0
		update_icon()

/obj/item/gun/projectile/fnseven/pathfinder
	pin = /obj/item/firing_pin/explorer

/obj/item/gun/projectile/fnseven/vintage
	name = "5.7 sidearm"
	desc = "This classic sidearm design utilizes an adaptable round considered to be superior to 9mm parabellum. It shares a round type with the H90K."
	icon_state = "fnseven"
	collapsible = 0
	extended = 1

/obj/item/gun/projectile/fnseven/vintage/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "fnseven"
	else
		icon_state = "fnseven-e"

//Apidean Weapons
/obj/item/gun/projectile/apinae_pistol
	name = "\improper Apinae Enforcer pistol"
	desc = "Used by Hive-guards to detain deviants."
	icon_state = "apipistol"
	item_state = "florayield"
	caliber = "apidean"
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_BIO = 5)
	magazine_type = /obj/item/ammo_magazine/biovial
	allowed_magazines = list(/obj/item/ammo_magazine/biovial)
	projectile_type = /obj/item/projectile/bullet/organic/wax

/obj/item/gun/projectile/apinae_pistol/update_icon_state()
	. = ..()
	icon_state = "apipistol-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"

//Tyrmalin Weapons
/obj/item/gun/projectile/pirate/junker_pistol
	name = "scrap pistol"
	desc = "A strange handgun made from industrial parts. It appears to accept multiple rounds thanks to an internal magazine. Favored by Tyrmalin wannabe-gunslingers."
	icon_state = "junker_pistol"
	item_state = "revolver"
	load_method = SINGLE_CASING
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	recoil = 3
	handle_casings = CYCLE_CASINGS
	max_shells = 3

//Donksoft Weapons
/obj/item/gun/projectile/pistol/foam
	name = "toy pistol"
	desc = "The Donk Co line of DONKsoft weapons is taking the galaxy by storm. Made of quality plastic, nothing launches darts better."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_pistol"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "foamdart"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mfoam/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam/pistol)
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/pistol/foam/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/pistol/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0
	return

/obj/item/gun/projectile/pistol/foam/blue
	icon_state = "toy_pistol_blue"

/obj/item/gun/projectile/pistol/foam/magnum
	name = "toy automag"
	icon_state = "toy_pistol_orange"
	w_class = ITEMSIZE_NORMAL
