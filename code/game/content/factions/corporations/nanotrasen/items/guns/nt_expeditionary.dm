//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Caliber *//

/datum/ammo_caliber/nt_expeditionary
	abstract_type = /datum/ammo_caliber/nt_expeditionary

/datum/ammo_caliber/nt_expeditionary/light_sidearm
	caliber = "nt-light-sidearm"
	diameter = 9
	length = 29

/datum/ammo_caliber/nt_expeditionary/heavy_sidearm
	caliber = "nt-heavy-sidearm"
	diameter = 9
	length = 34

/datum/ammo_caliber/nt_expeditionary/light_rifle
	caliber = "nt-light-rifle"
	diameter = 7.5
	length = 39

/datum/ammo_caliber/nt_expeditionary/heavy_rifle
	caliber = "nt-heavy-rifle"
	diameter = 7.5
	length = 54

/datum/ammo_caliber/nt_expeditionary/antimaterial
	caliber = "nt-antimaterial"
	diameter = 12
	length = 92

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary
	description_fluff = {"
		A casing for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	caliber = /datum/ammo_caliber/nt_expeditionary
	#warn stripe
	#warn sprites

/obj/item/ammo_casing/nt_expeditionary/pistol_light
	name = "ammo casing (NT-9)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight pistols and sidearms."

/obj/item/ammo_casing/nt_expeditionary/pistol_heavy
	name = "ammo casing (NT-9-magnum)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy-duty sidearms."

/obj/item/ammo_casing/nt_expeditionary/rifle_light
	name = "ammo casing (NT-7.5-SR)"
	desc = "A standardized 7.5x39mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight automatics."

/obj/item/ammo_casing/nt_expeditionary/rifle_heavy
	name = "ammo casing (NT-7.5-LR)"
	desc = "A standardized 7.5x54mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy rifles."

/obj/item/ammo_casing/nt_expeditionary/antimaterial
	name = "ammo casing (NT-12.5-antimaterial)"
	desc = "A standardized 12.5x92mm cartridge for NT Expeditionary kinetics. This one seems ridiculous large, and is probably for a very powerful weapon."

//* Magazines *//

/obj/item/ammo_magazine/nt_expeditionary
	description_fluff = {"
		A casing for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	ammo_caliber = /datum/ammo_caliber/nt_expeditionary

#warn impl
#warn sprites

//* Weapons *//

/obj/item/gun/ballistic/nt_expeditionary
	description_fluff = {"
		Part of the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}

#warn impl
/**

New weapons line organization: Model Designation: X (Expeditionary) N (NanoTrasen) *type* (Shotgun, rifle, pistol, Machine Pistol, etc) Mark X

These weapons are part of a new series developed by NT, and soon to be manufactured via Hephaustus industries

(Shotguns)

XNS Mk.6 “Standby”
	A pump-action design based on the proven pump-action mechanism developed centuries ago, the XNS Mk.6 or “Standby” is designed around a six-shot tube magazine using 12-gauge ammunition. Rugged, if not fancy, this weapon is a good fallback option for anyone requiring access to a long arm when out on their own or in small groups.

XNS Mk.7 “Peacemaker”
	A semiautomatic evolution of the XNS Mk.6, using an internal inertial locking system and muzzle brake. Big, blocky, and using 10-round detachable box magazines of 12-gauge ammunition, the barrel tends to get quite warm if fired without pause. A common sight seen with specialist security personnel supporting work crews, the somewhat bulky weapon lives up to its name in helping deter both hostile animals and bandits from thinking they can make an easy score

---

(Light sidearms)

XNP Mk.1 “Noisy Moth”
	A hold-out semiautomatic pistol designed to fit in the pocket and with an easy-to-use system of controls, the “Noisy Moth” is chambered in a lengthened version of the classic 9mm, packing a little more punch than traditional sidearms in this caliber. A small compensator and internal recoil dampeners make the increase in felt recoil negligible, while its 10-shot magazine gives it enough ammunition for those in a pinch to take chance shots.

XNMP Mk.3 “Buzzer”
	A personal defense weapon with collapsing stock, the “Buzzer” is chambered in 9x29mm. A short-barreled weapon easily hung on a belt, and feeding from 20-round magazines to keep it handy, the simple “Buzzer” does tend to make more sound and fury than an effective combat weapon, but it will certainly raise the alarm when its shrill report sounds in the dead of night.

---







(semi-auto carbine)

XNR Mk.4 “Scout”
	The basis of a new family of carbines developed to make use of 7.5x39mm ammunition, the “Scout is a traditional pattern of semi-automatic rifle with a mid-length barrel and adjustable stock, using a short stroke gas piston to cycle the action. The basic design is fitted with a zero magnification optic and comes packaged with 10 round magazines. However, larger magazines will also work with this workhorse of a weapon.

(full auto carbine)
XNR Mk.4 Mod.1  “Auto Scout”

	The first modification of the Mk.4 carbine, the “Auto Scout” is the next logical step of the platform by adding an automatic fire control group. Still using the same short-stroke gas piston and featuring a compensator on the end to help control recoil, this rifle still sports a zero-magnification optic and adds a short vertical grip as standard to the forward handguard. Issued with 20-round magazines to make better use of the automatic fire this weapon is capable of.


(pistol) (why?)

(PDW)

XNR Mk.4 Mod.2 “Little Scout”


Taking the concept of the original “Scout” and chopping the barrel, this weapon is lighter, more handy, and easier to carry when you need something more than a pistol, but a rifle would interfere with other duties. Sticking to the semi-automatic fire control of the parent, but chopping the barrel and adding the compensator of the Mod.1, this weapon’s ability to fold away helps make it easy to package and store inside cramped cockpits and into survival kits with its 10-round magazines.


(SAW)

XNR Mk.4 Mod.3 “Machine Scout”

The final entry of the “Scout” series, the “Machine Scout” makes use of a heavier barrel, a recoil compensating gyro on the bottom of the handguard, and the option to feed from 30-round box and 50-round drum magazines, this gives a heavy punch to recon teams and security units while keeping a common set of parts to reduce the complexities of servicing and maintaining the series as a whole.

---

(Heavy sidearms)

XNP Mk. 2 “Angry Moth”

	Taking the original XNP Mk.1 to the next level, this time upscaling the frame to accept a magnum 9x34mm cartridge, the “Angry Moth” sidearm is best described as “Shaking hands with danger”. The recoil it imparts will make it hard to forget the experience, but the performance on target leaves little to complain about. Feeding from 14-round magazines, this full-sized service pistol is seen when fighting is expected and not simply a possibility.

XNP Mk. 5 “Roller”

	Something of a pet project of one member of the XN design team, the “Roller” harkens back to the revolvers of old, but chambered in the magnum 9x34mm cartridge. Sporting an 8-round cylinder and an inline barrel design to reduce muzzle flip, this weapon is seen in the hands of those who prefer style over functionality or want the fine trigger control a triple-action revolver provides.

XNMP Mk. 8 “Buzzsaw”

	Taking design notes from the Mk.3 “Buzzer, the “Buzzsaw” sports a longer barrel, a thicker receiver, and a folding stock typically seen on rifles. Using the magnum 9x34mm round in 25-round magazines, the “Buzzsaw”’s high rate of fire and punchy ammunition makes its unique sound hard to mistake when seen clearing rooms or in dense jungle foliage, where the high-velocity rounds batter aside light cover with relative ease.


---

(Heavy rifle)


XNR Mk9 “Ranger”

	Using the Mk.4 “Scout” as a baseline, this semiautomatic rifle is akin to holding a monster, disguised in the skin of a dearly beloved friend, in your hands. Using full-powered rifle rounds (7.5x54mm), this rifle is broken out when you absolutely positively have to blow a fist-sized hole in something and don’t have time to wait. A scaled-up version of the Scout, with 8-round box magazines, this long gun is often seen issued to hunters looking to take down game to sustain an expedition.

XNR Mk9 Mod.1 “Auto Ranger”

	“What if we just.. Put a bigger magazine in it and a full auto trigger pack?” is the question that led to the development of the “Auto Ranger”, at first. Then, after an ‘eventful’ initial test, a gyroscopic stabilizer was added below the handguard and a fixed stock was installed to handle the ‘roller coaster’ as one test participant described the experience. A 20-round magazine and limiting the rifle to 3-round maximum burst size keeps the rifle on target through most situations.

XNMG Mk.9 Mod.2 “Hailmaker”

	The tests of the Mod.2 design quickly turned development towards a general purpose machine gun (GPMG) version of the Ranger series, the “Hailmaker.”. Sporting a frame-mounted cryo-stabilized heavy barrel, a feed tray for quickly reloading via an assistant gunner,  a belt box for 100 rounds of 7.5x54mm, and a gyroscopic assist system, this weapon is seen in the guard towers of base camps and atop vehicles in addition to dedicated machine gun teams. The patter this weapon makes as it suppresses any hostile force makes this weapon’s name a logical choice.


XNR(S) Mk. 10 “Old Man”

	A single shot, break action rifle chambered in 7.5x54mm, and sporting a 2x magnified optic, this is the go-to hunting rifle for long-range patrols. Light, uncomplicated, and rugged, the “Old Man” has nothing fancy about it. But, time and again, it works, day in, and day out.



 */
