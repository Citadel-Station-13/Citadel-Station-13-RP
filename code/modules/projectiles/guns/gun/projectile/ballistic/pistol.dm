/obj/item/gun/projectile/ballistic/colt
	var/unique_reskin
	name = ".45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_preload = /obj/item/ammo_magazine/a45/singlestack
	magazine_restrict = /obj/item/ammo_magazine/a45/singlestack

	icon_state = "colt"
	caliber = /datum/ammo_caliber/a45
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

/obj/item/gun/projectile/ballistic/colt/update_icon_state()
	. = ..()
	if(magazine)
		if(unique_reskin)
			icon_state = unique_reskin
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin]-empty"
		else
			icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/colt/detective
	desc = "A Martian recreation of an old pistol. Uses .45 rounds."
	magazine_preload = /obj/item/ammo_magazine/a45/singlestack/rubber

/obj/item/gun/projectile/ballistic/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
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

/obj/item/gun/projectile/ballistic/colt/detective/verb/reskin_gun()
	set name = "Resprite gun"
	set category = VERB_CATEGORY_OBJECT
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

/obj/item/gun/projectile/ballistic/sec
	name = ".45 pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a Nanotrasen subsidiary. Found pretty much everywhere humans are. This one is a less-lethal variant that only accepts .45 rubber or flash magazines."
	icon_state = "secguncomp"
	magazine_preload = /obj/item/ammo_magazine/a45/doublestack/rubber
	magazine_restrict = /obj/item/ammo_magazine/a45/doublestack/rubber
	caliber = /datum/ammo_caliber/a45
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

/obj/item/gun/projectile/ballistic/sec/flash
	name = ".45 signal pistol"
	magazine_preload = /obj/item/ammo_magazine/a45/doublestack/flash

/obj/item/gun/projectile/ballistic/sec/wood
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a Nanotrasen subsidiary. This one has a sweet wooden grip and only accepts .45 rubber or flash magazines."
	name = "custom .45 pistol"
	icon_state = "secgundark"

/obj/item/gun/projectile/ballistic/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = WEIGHT_CLASS_NORMAL
	caliber = /datum/ammo_caliber/a45
	silenced = 1
	recoil = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	magazine_preload = /obj/item/ammo_magazine/a45/doublestack
	magazine_restrict = /obj/item/ammo_magazine/a45/doublestack


/obj/item/gun/projectile/ballistic/deagle
	name = "desert eagle"
	desc = "The perfect handgun for shooters with a need to hit targets through a wall and behind a fridge in your neighbor's house. Uses .44 rounds."
	icon_state = "deagle"
	item_state = "deagle"
	damage_force = 14.0
	caliber = /datum/ammo_caliber/a44
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	magazine_preload = /obj/item/ammo_magazine/a44
	magazine_restrict = /obj/item/ammo_magazine/a44

/obj/item/gun/projectile/ballistic/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .44 rounds."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/projectile/ballistic/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .44 rounds."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/projectile/ballistic/gyropistol // Does this even appear anywhere outside of admin abuse?
	name = "gyrojet pistol"
	desc = "Speak softly, and carry a big gun. Fires rare .75 caliber self-propelled exploding bolts--because fuck you and everything around you."
	icon_state = "gyropistol"
	caliber = /datum/ammo_caliber/a75
	fire_sound = 'sound/weapons/railgun.ogg'
	origin_tech = list(TECH_COMBAT = 3)
	magazine_preload = /obj/item/ammo_magazine/a75
	magazine_restrict = /obj/item/ammo_magazine/a75
	magazine_auto_eject = TRUE

/obj/item/gun/projectile/ballistic/gyropistol/bolter
	name = "\improper Scorpion bolt pistol"
	desc = "A boxy sidearm seemingly designed for a larger hand. Uses .75 gyrojet rounds."
	description_fluff = "The HI-GP mk 3 'Scorpion' was an attempt to downsize the larger Ballistae model even further. Many of the weapon's issues persisted, compounded by the smaller size of the mechanical components within. Most prototypes sheared or broke, and were prone to malfunction due to the instense strain of extensive firing."
	icon_state = "bolt_pistol"
	item_state = "bolt_pistol"
	fire_sound = 'sound/weapons/gunshot/gunshot_bolter.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_ILLEGAL = 3)
	magazine_preload = /obj/item/ammo_magazine/a75
	magazine_restrict = /obj/item/ammo_magazine/a75
	magazine_auto_eject = FALSE

/obj/item/gun/projectile/ballistic/gyropistol/bolter/update_icon_state()
	. = ..()
	icon_state = "bolt_pistol-[magazine ? round(magazine.get_amount_remaining(), 2) : "empty"]"

/obj/item/gun/projectile/ballistic/gyropistol/bolter/black
	desc = "A boxy sidearm seemingly designed for a larger hand. This one is painted black."
	icon_state = "bolt_pistolblack"
	item_state = "bolt_pistolblack"

/obj/item/gun/projectile/ballistic/gyropistol/bolter/black/update_icon_state()
	. = ..()
	icon_state = "bolt_pistolblack-[magazine ? round(magazine.get_amount_remaining(), 2) : "empty"]"

/obj/item/gun/projectile/ballistic/pistol
	name = "compact pistol"
	desc = "An ultra-compact pistol with a matte black finish. Uses 9mm."
	description_fluff = "The Lumoco Arms P3 Whisper is a compact, easily concealable gun. Designed by GMC as a simplified improvement to the Konigin, the Whisper comes with a threaded barrel and slender profile. This weapon was favored by Syndicate special operatives during the Phoron War, and retains a somewhat sinister reputation to this day. Due to its slim design it is only compatible with compact 9mm magazines."
	icon_state = "pistol"
	item_state = null
	w_class = WEIGHT_CLASS_SMALL
	caliber = /datum/ammo_caliber/a9mm
	suppressible = TRUE
	silenced_icon = "pistol_silencer"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	magazine_preload = /obj/item/ammo_magazine/a9mm/compact
	magazine_restrict = /obj/item/ammo_magazine/a9mm/compact


/obj/item/gun/projectile/ballistic/pistol/flash
	name = "compact signal pistol"
	magazine_preload = /obj/item/ammo_magazine/a9mm/compact/flash

/obj/item/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "silencer"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/gun/projectile/ballistic/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3 //Improvised weapons = poor ergonomics
	internal_magazine = TRUE
	internal_magazine_size = 1
	chamber_cycle_after_fire = FALSE
	safety_state = GUN_NO_SAFETY
	unstable = 1

	// todo: caliber types?
	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/a357,
		/obj/item/ammo_casing/a9mm,
		/obj/item/ammo_casing/a45,
		/obj/item/ammo_casing/a10mm,
		/obj/item/ammo_casing/a12g,
		/obj/item/ammo_casing/a12g,
		/obj/item/ammo_casing/a12g/pellet,
		/obj/item/ammo_casing/a12g/pellet,
		/obj/item/ammo_casing/a12g/pellet,
		/obj/item/ammo_casing/a12g/beanbag,
		/obj/item/ammo_casing/a12g/stunshell,
		/obj/item/ammo_casing/a12g/flare,
		/obj/item/ammo_casing/a7_62mm,
		/obj/item/ammo_casing/a5_56mm,
	)

/obj/item/gun/projectile/ballistic/pirate/Initialize(mapload)
	var/ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.casing_caliber)
	return ..()

/obj/item/gun/projectile/ballistic/pirate/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
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
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	chamber_cycle_after_fire = FALSE
	chamber_spin_after_fire = TRUE
	internal_magazine = TRUE
	internal_magazine_revolver_mode = TRUE
	internal_magazine_size = 2
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a357
	caliber = /datum/ammo_caliber/a357

/obj/item/gun/projectile/ballistic/luger
	name = "\improper P08 Luger"
	desc = "Not some cheap scheisse Martian knockoff! This Luger is an authentic reproduction by RauMauser. Accuracy, easy handling, and its signature appearance make it popular among historic gun collectors. Uses 9mm rounds."
	icon_state = "p08"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = /datum/ammo_caliber/a9mm
	magazine_preload = /obj/item/ammo_magazine/a9mm/compact
	magazine_restrict = /obj/item/ammo_magazine/a9mm/compact

/obj/item/gun/projectile/ballistic/luger/brown
	icon_state = "p08b"

/obj/item/gun/projectile/ballistic/p92x
	name = "9mm pistol"
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. Uses 9mm rounds."
	icon_state = "p92x"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = /datum/ammo_caliber/a9mm
	magazine_preload = /obj/item/ammo_magazine/a9mm
	magazine_restrict = /obj/item/ammo_magazine/a9mm // Can accept illegal large capacity magazines, or compact magazines.

/obj/item/gun/projectile/ballistic/p92x/sec
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. This one is a less-lethal variant that only accepts 9mm rubber or flash magazines."
	magazine_preload = /obj/item/ammo_magazine/a9mm/rubber

/obj/item/gun/projectile/ballistic/p92x/brown
	icon_state = "p92x-brown"

/obj/item/gun/projectile/ballistic/p92x/large
	magazine_preload = /obj/item/ammo_magazine/a9mm/large // Spawns with illegal magazines.

/obj/item/gun/projectile/ballistic/r9
	name = "C96-Red 9"
	desc = "A variation on the Mauser C-96, remade for a modern day. A Glithari Exports product, for gun collectors and private militaries alike. Uses 9mm stripper clips."
	icon_state = "r9"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL =1) //VERY OLD
	caliber = /datum/ammo_caliber/a9mm
	internal_magazine = TRUE
	internal_magazine_preload_ammo = 10
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a9mm

/obj/item/gun/projectile/ballistic/r9/holy
	name = "Blessed Red 9"
	desc = "Ah, the choice of an avid gun collector! It's a nice gun, stranger."
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a9mm/silver

/obj/item/gun/projectile/ballistic/clown_pistol
	name = "clown pistol"
	desc = "This curious weapon feeds from a compressed biomatter cartridge, and seems to fabricate its ammunition from that supply."
	icon_state = "clownpistol"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/biomatter
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	magazine_preload = /obj/item/ammo_magazine/biomatter
	magazine_restrict = /obj/item/ammo_magazine/biomatter

//Hey did you ever see Kingsman? Well, you know this gun then.
/obj/item/gun/projectile/ballistic/konigin
	name = "Konigin-63 compact"
	desc = "A compact pistol with an underslung single-round shotgun barrel. Or at-least it should, if this was the real thing. Legends say some of those whom are left after the Gorlex Manufacturing Corporation \
	collapsed are trying to remake this iconic weapon. Uses 9mm."
	// desc = "A compact pistol with an underslung single-round shotgun barrel. Uses 9mm."
	// description_fluff = "Originally produced in 2463 by GMC, the Konigin is considered to be the direct ancestor to the P3 Whisper. Considerably more expensive to manufacture and maintain, the Konigin saw limited use outside of Syndicate special operations cells. By the time GMC ended production of the Konigin-63, the weapon had undergone significant design changes - most notably the installment of a single capacity underbarrel shotgun. This rare design is certainly inspired, and has become something of a collector's item post-war."
	icon_state = "konigin"
	item_state = null
	w_class = WEIGHT_CLASS_SMALL
	caliber = /datum/ammo_caliber/a9mm
	suppressible = TRUE
	silenced_icon = "konigin_silencer"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	magazine_preload = /obj/item/ammo_magazine/a9mm/compact/double
	magazine_restrict = /obj/item/ammo_magazine/a9mm/compact

// todo: this should be using an attachment
/obj/item/gun/projectile/ballistic/konigin
	firemodes = list(
		list(mode_name="pistol",       burst=1,    fire_delay=0,    move_delay=null, use_shotgun=null, burst_accuracy=null, dispersion=null),
		// list(mode_name="shotgun",  burst=null, fire_delay=null, move_delay=null, use_shotgun=1,    burst_accuracy=null, dispersion=null)
		)

// 	var/use_shotgun = 0
// 	var/obj/item/gun/projectile/ballistic/shotgun/underslung/shotgun

// /obj/item/gun/projectile/ballistic/konigin/Initialize(mapload)
// 	. = ..()
// 	shotgun = new(src)

// /obj/item/gun/projectile/ballistic/konigin/attackby(obj/item/I, mob/user)
// 	if((istype(I, /obj/item/ammo_casing/a12g)))
// 		shotgun.load_ammo(I, user)
// 	else
// 		..()

// /obj/item/gun/projectile/ballistic/konigin/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
// 	if(user.get_inactive_held_item() == src && use_shotgun)
// 		shotgun.unload_ammo(user)
// 	else
// 		..()

// /obj/item/gun/projectile/ballistic/konigin/fire(datum/gun_firing_cycle/cycle)
// 	if(use_shotgun)
// 		return shotgun.fire(cycle)
// 	return ..()

//Exploration/Pathfinder Sidearms
/obj/item/gun/projectile/ballistic/ntles
	name = "NT-57 'LES'"
	desc = "The NT-57 'LES' (Light Expeditionary Sidearm) is a tried and tested pistol often issued to Pathfinders. Featuring a polymer frame, collapsible stock, and integrated optics, the LES is lightweight and reliably functions in nearly any hazardous environment, including vacuum."
	icon_state = "ntles"
	item_state = "pistol"
	caliber = /datum/ammo_caliber/a5_7mm
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_preload = /obj/item/ammo_magazine/a5_7mm/nt_les
	magazine_restrict = /obj/item/ammo_magazine/a5_7mm/nt_les

	one_handed_penalty = 30
	var/collapsible = 1
	var/extended = 0

/obj/item/gun/projectile/ballistic/ntles/update_icon_state()
	. = ..()
	if(!extended && magazine)
		icon_state = "ntles"
	else if(extended && magazine)
		icon_state = "ntles_extended"
	else if(extended && !magazine)
		icon_state = "ntles_extended-empty"
	else
		icon_state = "ntles-empty"

/obj/item/gun/projectile/ballistic/ntles/attack_self(mob/user, datum/event_args/actor/actor)
	if(collapsible && !extended)
		to_chat(user, "<span class='notice'>You pull out the stock on the [src], steadying the weapon.</span>")
		set_weight_class(WEIGHT_CLASS_BULKY)
		one_handed_penalty = 10
		extended = 1
		update_icon()
	else if(!collapsible)
		to_chat(user, "<span class='danger'>The [src] doesn't have a stock!</span>")
		return
	else
		to_chat(user, "<span class='notice'>You push the stock back into the [src], making it more compact.</span>")
		set_weight_class(WEIGHT_CLASS_NORMAL)
		one_handed_penalty = 30
		extended = 0
		update_icon()

/obj/item/gun/projectile/ballistic/ntles/pathfinder
	pin = /obj/item/firing_pin/explorer

/obj/item/gun/projectile/ballistic/fiveseven
	name = "\improper Five-seven sidearm"
	desc = "This classic sidearm design utilizes an adaptable round considered by some to be superior to 9mm parabellum. Favored amongst sheild bearers in tactical units for its stability in one-handed use, and high capacity magazines."
	icon_state = "fiveseven"
	item_state = "pistol"
	caliber = /datum/ammo_caliber/a5_7mm
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_preload = /obj/item/ammo_magazine/a5_7mm/five_seven
	magazine_restrict = /obj/item/ammo_magazine/a5_7mm/five_seven
	one_handed_penalty = 0

/obj/item/gun/projectile/ballistic/fiveseven/update_icon_state()
	. = ..()
	if(istype(magazine, /obj/item/ammo_magazine/a5_7mm/five_seven/highcap))
		icon_state = "fiveseven-extended"

//AXHS Series
/obj/item/gun/projectile/ballistic/ax59 //Exploration model
	name = "large pistol"
	desc = "A bulky semi-automatic handgun with 'NT AX59' engraved on the slide. Comes with an integrated light module and a small lanyard loop at the bottom of the grip. Uses .45 rounds."
	description_fluff = "The Advanced Expeditionary Handgun System, more commonly known by it's model name 'AX59', or coloquially as the 'Axe', was one of the first attempts by Nanotrasen to modernize and standardize their Exploration department's gear in the years following the Phoron Wars, although it was swiftly replaced by more compact, field-rechargeable energy weapon designs within only a few years. A handgun chambered in the .45 ACP cartridge, it was designed to offer enough stopping power to handle common 'environmental threats' such as hostile fauna within a small form factor, ideally eliminating the need to carry a long gun, although the final design was still considered bulky even by the time of it's introduction. Some of this weight, thankfully, owes itself to features specifically designed for it's use in Exploration:  All base models come equipped with a non-detachable weapon-mounted light and are issued alongside a durable wire lanyard."

	icon_state = "ax59"
	caliber = /datum/ammo_caliber/a45
	magazine_preload = /obj/item/ammo_magazine/a45/doublestack
	magazine_restrict = /obj/item/ammo_magazine/a45/doublestack
	pin = /obj/item/firing_pin/explorer
	attachments = list(
		/obj/item/gun_attachment/flashlight/internal,
	)
	attachment_alignment = list(
		GUN_ATTACHMENT_SLOT_UNDERBARREL = list(0,0),
		GUN_ATTACHMENT_SLOT_GRIP = list(0,0)
	)

/obj/item/gun/projectile/ballistic/ax99 //PMD model
	name = "long-slide pistol"
	desc = "A bulky semi-automatic handgun with 'NT AX99' engraved on the slide. Uses .44 rounds."
	description_fluff = "A later derivative of what started as the Advanced Expeditionary Handgun System (AXHS), the AX99 entered production solely at the behest of the company's Paracausal Monitoring Division shortly after it's establishment due to the new department's need for a standardized handgun design that could operate reliably even under anomalous circumstances and against unknown threats. Compared to it's predecessor, it is chambered for the more powerful .44 Magnum cartridge and equipped with a partially redesigned operating system able to withstand the higher pressure, as well as a longer ported barrel and slide assembly. On the other hand, it has been stripped of fragile electronic utilities such as the underbarrel light. It has been occasionally referred to as the 'Silver Axe' due to it's use in conjuction with silver rounds, although it is perfectly capable of operating with standard ammunition."
	icon_state = "ax99"
	caliber = /datum/ammo_caliber/a44
	magazine_preload = /obj/item/ammo_magazine/a44
	magazine_restrict = /obj/item/ammo_magazine/a44

//Apidean Weapons
/obj/item/gun/projectile/ballistic/apinae_pistol
	name = "\improper Apinae Enforcer pistol"
	desc = "Used by Hive-guards to detain deviants."
	icon_state = "apipistol"
	item_state = "florayield"
	caliber = /datum/ammo_caliber/biomatter/wax
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_BIO = 5)
	magazine_preload = /obj/item/ammo_magazine/biovial
	magazine_restrict = /obj/item/ammo_magazine/biovial


/obj/item/gun/projectile/ballistic/apinae_pistol/update_icon_state()
	. = ..()
	icon_state = "apipistol-[magazine ? round(magazine.get_amount_remaining(), 2) : "e"]"

//Tyrmalin Weapons
/obj/item/gun/projectile/ballistic/pirate/junker_pistol
	name = "scrap pistol"
	desc = "A strange handgun made from industrial parts. It appears to accept multiple rounds thanks to an internal magazine. Favored by Tyrmalin wannabe-gunslingers."
	icon_state = "junker_pistol"
	item_state = "revolver"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	recoil = 3
	internal_magazine_size = 3
	internal_magazine_revolver_mode = TRUE
	chamber_spin_after_fire = TRUE

//Donksoft Weapons
/obj/item/gun/projectile/ballistic/pistol/foam
	name = "toy pistol"
	desc = "The Donk Co line of DONKsoft weapons is taking the galaxy by storm. Made of quality plastic, nothing launches darts better."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_pistol"
	item_state = null
	w_class = WEIGHT_CLASS_SMALL
	caliber = /datum/ammo_caliber/foam
	magazine_preload = /obj/item/ammo_magazine/foam/pistol
	magazine_restrict = /obj/item/ammo_magazine/foam/pistol
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/ballistic/pistol/foam/blue
	icon_state = "toy_pistol_blue"

/obj/item/gun/projectile/ballistic/pistol/foam/magnum
	name = "toy automag"
	icon_state = "toy_pistol_orange"
	w_class = WEIGHT_CLASS_NORMAL
