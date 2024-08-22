//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Light Sidearms *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/light_sidearm
	caliber = /datum/ammo_caliber/nt_expeditionary/light_sidearm

#warn sprites

//* Pistol *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm/pistol
	name = "light pistol"
	desc = "The XNP Mk.1 \"Noisy Moth\" pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A hold-out semiautomatic pistol designed to fit in the pocket and with an easy-to-use
		system of controls, the “Noisy Moth” is chambered in a lengthened version of the classic 9mm,
		packing a little more punch than traditional sidearms in this caliber.
		A small compensator and internal recoil dampeners make the increase in felt recoil negligible,
		while its magazine gives it enough ammunition for those in a pinch to take chance shots.
	"} + "<br>"

//* SMG *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm/smg
	name = "machine pistol"
	desc = "The XNMP Mk.3 \"Buzzer\" machine pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A personal defense weapon with collapsing stock, the “Buzzer” is chambered in 9x29mm.
		A short-barreled weapon easily hung on a belt, and feeding from medium-sized magazines to
		keep it handy, the simple “Buzzer” does tend to make more sound and fury than an effective
		combat weapon, but it will certainly raise the alarm when its shrill report sounds in
		the dead of night.
	"} + "<br>"

#warn impl all
