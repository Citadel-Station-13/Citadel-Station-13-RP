//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Caliber *//

#warn def base caliber in calibers
/datum/caliber/a7_75mm/nt_proto
	length = 75

//* Ammo *//

/obj/item/ammo_casing/a7_75mm/nt_proto
	name = "ammo casing"
	desc = "An obnoxiously long casing for some kind of rifle."
	caliber = /datum/caliber/a7_75mm/nt_proto

#warn impl all

//* Magazine *//

/obj/item/ammo_magazine/a7_75mm/nt_proto
	#warn name?
	desc = "A lightweight magazine for some kind of rifle."
	ammo_caliber = /datum/caliber/a7_75mm/nt_proto

#warn impl all
