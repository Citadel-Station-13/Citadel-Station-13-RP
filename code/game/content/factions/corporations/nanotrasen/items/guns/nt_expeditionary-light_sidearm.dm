//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Light Sidearms *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/light_sidearm
	caliber = /datum/ammo_caliber/nt_expeditionary/light_sidearm

//* Pistol *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm/pistol
	name = "light pistol"
	desc = "The XNS MK.6 \"Standby\" pump-action shotgun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A pump-action design based on the proven pump-action mechanism developed centuries ago,
		the XNS Mk.6 or “Standby” is designed around a tube magazine using 12-gauge ammunition.
		Rugged, if not fancy, this weapon is a good fallback option for anyone
		requiring access to a long arm when out on their own or in small groups.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

//* SMG *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm/smg
	name = "machine pistol"
	desc = "The XNS MK.6 \"Standby\" pump-action shotgun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A pump-action design based on the proven pump-action mechanism developed centuries ago,
		the XNS Mk.6 or “Standby” is designed around a tube magazine using 12-gauge ammunition.
		Rugged, if not fancy, this weapon is a good fallback option for anyone
		requiring access to a long arm when out on their own or in small groups.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

#warn impl all
