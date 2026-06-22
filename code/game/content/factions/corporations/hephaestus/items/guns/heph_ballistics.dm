//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* Calibers *//

/datum/ammo_caliber/hephaestus
	abstract_type = /datum/ammo_caliber/hephaestus

/datum/ammo_caliber/hephaestus/antimateriel

	id = "heph-antimateriel"
	caliber = ".50 arcadian"
	diameter = 12
	length = 92

/datum/ammo_caliber/hephaestus/heavy_rifle

	id = "hephaestus-heavy-rifle"
	caliber = "7.5mm ares"
	diameter = 7.5
	length = 54

/datum/ammo_caliber/hephaestus/heavy_sidearm

	id = "hephaestus-heavy-sidearm"
	caliber = ".355 special"
	diameter = 9
	length = 34

/datum/ammo_caliber/hephaestus/light_sidearm

	id = "hephaestus-light-sidearm"
	caliber = ".355 auto"
	diameter = 9
	length = 29

//* Ammo Casings *//

/obj/item/ammo_casing/hephaestus
	icon = 'icons/content/factions/corporations/hephaestus/cartridges.dmi'
	icon_state = "basic"
	icon_spent = TRUE

/obj/item/ammo_casing/hephaestus/antimateriel
	name = "ammo casing (.50 arc)"
	desc = "A standardized 12x92mm cartridge produced by Hephaestus Industries."
	description_fluff = "Undoubtedly humanity's most well-established anti-materiel cartridge, it seems to follow humans anywhere they can be found across the Orion Spur. The name .50 Arcadian was chosen by Hephaestus Industries to represent it's provenance from Mars' Arcadia Planitia, where a large fraction of the cartridges were being produced at the time it was first introduced in the 2440s."
	icon_state = "antimateriel_cartridge"
	casing_caliber = /datum/ammo_caliber/hephaestus/antimateriel
	projectile_type = /obj/projectile/bullet/hephaestus/antimateriel

	/// specifically for /obj/item/ammo_magazine/hephaestus/antimateriel's
	///
	/// * null to default to "[base_icon_state || initial(icon_state)]"
	var/magazine_state

///obj/item/ammo_casing/hephaestus/antimaterial/penetrator
//	icon_state = "penetrator_cartridge"
	// todo: implement casing + magazine

///obj/item/ammo_casing/hephaestus/antimaterial/emp
//	icon_state = "emp_cartridge"
	// todo: implement casing + magazine

///obj/item/ammo_casing/hephaestus/antimaterial/explosive
//	icon_state = "explosive_cartridge"
	// todo: implement casing + magazine

///obj/item/ammo_casing/hephaestus/antimaterial/titanium
//	icon_state = "titanium_cartridge"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/heavy_rifle
	name = "ammo casing (7.5mm ares)"
	desc = "A standardized 7.5x54mm cartridge produced by Hephaestus Industries."
	description_fluff = "Hephaestus Industries' standard-issue full-powered rifle cartridge, utilized by a tremendous catalog of weaponry where heavy stopping power is required, from general purpose machineguns to bolt-action sniper rifles."
	icon_state = "heavyrifle_cartridge"
	casing_caliber = /datum/ammo_caliber/hephaestus/heavy_rifle
	projectile_type = /obj/projectile/bullet/hephaestus/heavy_rifle

	/// specifically for /obj/item/ammo_magazine/hephaestus/heavy_rifle's
	//var/stripper_state = "basic"

///obj/item/ammo_casing/hephaestus/heavy_rifle/piercing
//	icon_state = "piercing_cartridge"
//	stripper_state = "piercing"
	// todo: implement casing + magazine

///obj/item/ammo_casing/hephaestus/heavy_rifle/rubber
//	icon_state = "rubber_cartridge"
//	stripper_state = "rubber"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/heavy_sidearm
	name = "ammo casing (.355 special)"
	desc = "A standardized 9x34mm cartridge produced by Hephaestus Industries."
	description_fluff = "The bigger brother of .355 Auto, Hephaestus Industries' .355 Special was introduced, as the name suggests, for situations where the shorter cartridge would simply not cut it. It's semi-rimmed design allows it to be used in both revolvers and standard magazine-fed weapons alike."
	icon_state = "heavysidearm_cartridge"
	casing_caliber = /datum/ammo_caliber/hephaestus/heavy_sidearm
	projectile_type = /obj/projectile/bullet/hephaestus/heavy_sidearm

	materials_base = list(
		/datum/prototype/material/steel::id = 85,
	)

	/// specifically for /obj/item/ammo_magazine/hephaestus/heavy_sidearm's
	var/speedloader_state = "basic"

// todo: implement projectile + magazine
// /obj/item/ammo_casing/hephaestus/heavy_sidearm/piercing
// 	icon_state = "piercing"
// 	speedloader_state = "piercing"

// todo: implement projectile + magazine
// /obj/item/ammo_casing/hephaestus/heavy_sidearm/rubber
// 	icon_state = "rubber"
// 	speedloader_state = "rubber"

/obj/item/ammo_casing/hephaestus/light_sidearm
	name = "ammo casing (.355 auto)"
	desc = "A standardized 9x29mm cartridge produced by Hephaestus Industries."
	description_fluff = "Hephaestus Industries' compact handgun cartridge. Lightweight, good performance, ubiquitous."
	icon_state = "lightsidearm_cartridge"
	casing_caliber = /datum/ammo_caliber/hephaestus/light_sidearm
	projectile_type = /obj/projectile/bullet/hephaestus/light_sidearm

	materials_base = list(
		/datum/prototype/material/steel::id = 75,
	)

	/// specifically for /obj/item/ammo_magazine/hephaestus/light_sidearm's
	var/speedloader_state = "basic"

// todo: implement projectile + magazine
// /obj/item/ammo_casing/hephaestus/light_sidearm/piercing
// 	icon_state = "piercing"
// 	speedloader_state = "piercing"

// todo: implement projectile + magazine
// /obj/item/ammo_casing/hephaestus/light_sidearm/rubber
// 	icon_state = "rubber"
// 	speedloader_state = "rubber"

//* Projectiles *//

/obj/projectile/bullet/hephaestus/antimateriel
	name = "antimateriel bullet"
	damage_force = 55
	damage_tier = 6

/obj/projectile/bullet/hephaestus/heavy_rifle
	name = "rifle bullet"
	damage_force = 32.5
	damage_tier = 4.75

/obj/projectile/bullet/hephaestus/heavy_sidearm
	name = "bullet"
	damage_force = 30
	damage_tier = 3.75

/obj/projectile/bullet/hephaestus/light_sidearm
	name = "bullet"
	damage_force = 30
	damage_tier = 3
