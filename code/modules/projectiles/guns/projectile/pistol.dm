/obj/item/gun/ballistic/colt
	var/unique_reskin
	name = ".45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/projectile/bullet/pistol/medium
	icon_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/gun/ballistic/colt/update_icon_state()
	. = ..()
	if(ammo_magazine)
		if(unique_reskin)
			icon_state = unique_reskin
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin]-empty"
		else
			icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/ballistic/colt/detective
	desc = "A Martian recreation of an old pistol. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45/rubber

/obj/item/gun/ballistic/colt/detective/verb/rename_gun()
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

/obj/item/gun/ballistic/colt/detective/verb/reskin_gun()
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

/obj/item/gun/ballistic/colt/taj
	name = "Adhomai Pistol"
	desc = "The Adar'Mazy pistol, produced by the Hadii-Wrack group. This pistol is the primary sidearm for low ranking officers and officals in the People's Republic of Adhomai."
	icon_state = "colt-taj"

/*//apart of reskins that have two sprites, touching may result in frustration and breaks
/obj/item/gun/ballistic/colt/detective/attack_hand(mob/user, list/params)
	if(!unique_reskin && loc == user)
		reskin_gun(user)
		return
	..()
*/

/obj/item/gun/ballistic/sec
	name = ".45 pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. Found pretty much everywhere humans are. This one is a less-lethal variant that only accepts .45 rubber or flash magazines."
	icon_state = "secguncomp"
	magazine_type = /obj/item/ammo_magazine/m45/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/flash, /obj/item/ammo_magazine/m45/practice)
	projectile_type = /obj/projectile/bullet/pistol/medium
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/gun/ballistic/sec/flash
	name = ".45 signal pistol"
	magazine_type = /obj/item/ammo_magazine/m45/flash

/obj/item/gun/ballistic/sec/wood
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. This one has a sweet wooden grip and only accepts .45 rubber or flash magazines."
	name = "custom .45 pistol"
	icon_state = "secgundark"

/obj/item/gun/ballistic/silenced
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
	projectile_type = /obj/projectile/bullet/pistol/medium

/obj/item/gun/ballistic/deagle
	name = "desert eagle"
	desc = "The perfect handgun for shooters with a need to hit targets through a wall and behind a fridge in your neighbor's house. Uses .44 rounds."
	icon_state = "deagle"
	item_state = "deagle"
	damage_force = 14.0
	caliber = ".44"
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m44
	allowed_magazines = list(/obj/item/ammo_magazine/m44)

/obj/item/gun/ballistic/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .44 rounds."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/ballistic/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .44 rounds."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/ballistic/deagle/taj
	name = "Adhomai Hand Cannon"
	desc = "The Nal'dor heavy pistol, a powerful Hadii-Wrack group handcannon that has gained an infamous reputation through its use by Commissars of the People's Republic of Adhomai."
	icon_state = "deagle-taj"

/obj/item/gun/ballistic/gyropistol // Does this even appear anywhere outside of admin abuse?
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

/obj/item/gun/ballistic/gyropistol/bolter
	name = "\improper Scorpion bolt pistol"
	desc = "A boxy sidearm seemingly designed for a larger hand. Uses .75 gyrojet rounds."
	description_fluff = "The HI-GP mk 3 'Scorpion' was an attempt to downsize the larger Ballistae model even further. Many of the weapon's issues persisted, compounded by the smaller size of the mechanical components within. Most prototypes sheared or broke, and were prone to malfunction due to the instense strain of extensive firing."
	icon_state = "bolt_pistol"
	item_state = "bolt_pistol"
	max_shells = 10
	fire_sound = 'sound/weapons/gunshot/gunshot_bolter.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_ILLEGAL = 3)
	magazine_type = /obj/item/ammo_magazine/m75/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/m75/pistol)
	auto_eject = 0

/obj/item/gun/ballistic/gyropistol/bolter/update_icon_state()
	. = ..()
	icon_state = "bolt_pistol-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"

/obj/item/gun/ballistic/gyropistol/bolter/black
	desc = "A boxy sidearm seemingly designed for a larger hand. This one is painted black."
	icon_state = "bolt_pistolblack"
	item_state = "bolt_pistolblack"

/obj/item/gun/ballistic/gyropistol/bolter/black/update_icon_state()
	. = ..()
	icon_state = "bolt_pistolblack-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"

/obj/item/gun/ballistic/pistol
	name = "compact pistol"
	desc = "An ultra-compact pistol with a matte black finish. Uses 9mm."
	description_fluff = "The Lumoco Arms P3 Whisper is a compact, easily concealable gun. Designed by GMC as a simplified improvement to the Konigin, the Whisper comes with a threaded barrel and slender profile. This weapon was favored by Syndicate special operatives during the Phoron War, and retains a somewhat sinister reputation to this day. Due to its slim design it is only compatible with compact 9mm magazines."
	icon_state = "pistol"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "9mm"
	suppressible = TRUE
	silenced_icon = "pistol_silencer"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/gun/ballistic/pistol/flash
	name = "compact signal pistol"
	magazine_type = /obj/item/ammo_magazine/m9mm/compact/flash

/obj/item/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "silencer"
	w_class = ITEMSIZE_SMALL

/obj/item/gun/ballistic/pirate
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

/obj/item/gun/ballistic/pirate/Initialize(mapload)
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

/obj/item/gun/ballistic/derringer
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

/obj/item/gun/ballistic/luger
	name = "\improper P08 Luger"
	desc = "Not some cheap scheisse Martian knockoff! This Luger is an authentic reproduction by RauMauser. Accuracy, easy handling, and its signature appearance make it popular among historic gun collectors. Uses 9mm rounds."
	icon_state = "p08"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/gun/ballistic/luger/brown
	icon_state = "p08b"

/obj/item/gun/ballistic/p92x
	name = "9mm pistol"
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. Uses 9mm rounds."
	icon_state = "p92x"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm) // Can accept illegal large capacity magazines, or compact magazines.

/obj/item/gun/ballistic/p92x/sec
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. This one is a less-lethal variant that only accepts 9mm rubber or flash magazines."
	magazine_type = /obj/item/ammo_magazine/m9mm/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/flash)

//Ported this over from the _vr before deletion. Commenting them out because I'm not sure we want these in.
/*
/obj/item/gun/ballistic/p92x/large/licensed
	icon_state = "p92x-brown"
	magazine_type = /obj/item/ammo_magazine/m9mm/large/licensed // Spawns with big magazines that are legal.

/obj/item/gun/ballistic/p92x/large/licensed/hp
	magazine_type = /obj/item/ammo_magazine/m9mm/large/licensed/hp // Spawns with legal hollow-point mag
*/

/obj/item/gun/ballistic/p92x/brown
	icon_state = "p92x-brown"

/obj/item/gun/ballistic/p92x/large
	magazine_type = /obj/item/ammo_magazine/m9mm/large // Spawns with illegal magazines.

/obj/item/gun/ballistic/r9
	name = "C96-Red 9"
	desc = "A variation on the Mauser C-96, remade for a modern day. A Glithari Exports product, for gun collectors and private militaries alike. Uses 9mm stripper clips."
	icon_state = "r9"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL =1) //VERY OLD
	caliber = "9mm"
	load_method = SPEEDLOADER
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/a9mm

/obj/item/gun/ballistic/r9/holy
	name = "Blessed Red 9"
	desc = "Ah, the choice of an avid gun collector! It's a nice gun, stranger."
	ammo_type = /obj/item/ammo_casing/a9mm/silver
	holy = TRUE

/obj/item/gun/ballistic/clown_pistol
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
	projectile_type = /obj/projectile/bullet/organic

//Hey did you ever see Kingsman? Well, you know this gun then.
/obj/item/gun/ballistic/konigin
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

/obj/item/gun/ballistic/konigin
	firemodes = list(
		list(mode_name="pistol",       burst=1,    fire_delay=0,    move_delay=null, use_shotgun=null, burst_accuracy=null, dispersion=null),
		list(mode_name="shotgun",  burst=null, fire_delay=null, move_delay=null, use_shotgun=1,    burst_accuracy=null, dispersion=null)
		)

	var/use_shotgun = 0
	var/obj/item/gun/ballistic/shotgun/underslung/shotgun

/obj/item/gun/ballistic/konigin/Initialize(mapload)
	. = ..()
	shotgun = new(src)

/obj/item/gun/ballistic/konigin/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/a12g)))
		shotgun.load_ammo(I, user)
	else
		..()

/obj/item/gun/ballistic/konigin/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && use_shotgun)
		shotgun.unload_ammo(user)
	else
		..()

/obj/item/gun/ballistic/konigin/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_shotgun)
		shotgun.Fire(target, user, params, pointblank, reflex)
		//if(!shotgun.chambered)
			//switch_firemodes(user) //switch back automatically
	else
		..()

/* Having issues with getting this to work atm.
/obj/item/gun/ballistic/konigin/examine(mob/user, dist)
	. = ..()

	if(shotgun.loaded)
		. += "\The [shotgun] has \a [shotgun.loaded] loaded."
	else
		. += "\The [shotgun] is empty."
*/

//Exploration/Pathfinder Sidearms
/obj/item/gun/ballistic/ntles
	name = "NT-57 'LES'"
	desc = "The NT-57 'LES' (Light Expeditionary Sidearm) is a tried and tested pistol often issued to Pathfinders. Featuring a polymer frame, collapsible stock, and integrated optics, the LES is lightweight and reliably functions in nearly any hazardous environment, including vacuum."
	icon_state = "ntles"
	item_state = "pistol"
	caliber = "5.7x28mm"
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m57x28mm/ntles
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mm/ntles)
	projectile_type = /obj/projectile/bullet/pistol/lap
	one_handed_penalty = 30
	var/collapsible = 1
	var/extended = 0

/obj/item/gun/ballistic/ntles/update_icon_state()
	. = ..()
	if(!extended && ammo_magazine)
		icon_state = "ntles"
	else if(extended && ammo_magazine)
		icon_state = "ntles_extended"
	else if(extended && !ammo_magazine)
		icon_state = "ntles_extended-empty"
	else
		icon_state = "ntles-empty"

/obj/item/gun/ballistic/ntles/attack_self(mob/user, obj/item/gun/G)
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

/obj/item/gun/ballistic/ntles/pathfinder
	pin = /obj/item/firing_pin/explorer

/obj/item/gun/ballistic/fiveseven
	name = "\improper Five-seven sidearm"
	desc = "This classic sidearm design utilizes an adaptable round considered by some to be superior to 9mm parabellum. Favored amongst sheild bearers in tactical units for its stability in one-handed use, and high capacity magazines."
	icon_state = "fiveseven"
	item_state = "pistol"
	caliber = "5.7x28mm"
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m57x28mm/fiveseven
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mm/fiveseven)
	one_handed_penalty = 0

/obj/item/gun/ballistic/fiveseven/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap))
		icon_state = "fiveseven-extended"

//Apidean Weapons
/obj/item/gun/ballistic/apinae_pistol
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
	projectile_type = /obj/projectile/bullet/organic/wax

/obj/item/gun/ballistic/apinae_pistol/update_icon_state()
	. = ..()
	icon_state = "apipistol-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "e"]"

//Tyrmalin Weapons
/obj/item/gun/ballistic/pirate/junker_pistol
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
/obj/item/gun/ballistic/pistol/foam
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

/obj/item/gun/ballistic/pistol/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0
	return

/obj/item/gun/ballistic/pistol/foam/blue
	icon_state = "toy_pistol_blue"

/obj/item/gun/ballistic/pistol/foam/magnum
	name = "toy automag"
	icon_state = "toy_pistol_orange"
	w_class = ITEMSIZE_NORMAL
