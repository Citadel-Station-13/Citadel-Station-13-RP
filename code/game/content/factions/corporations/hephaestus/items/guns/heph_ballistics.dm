//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* Calibers *//

/datum/ammo_caliber/hephaestus
	abstract_type = /datum/ammo_caliber/hephaestus

/datum/ammo_caliber/hephaestus/antimaterial
	name = ".50 Arcadian"
	id = "heph-antimaterial"
	caliber = "heph-antimaterial"
	diameter = 12
	length = 92

/datum/ammo_caliber/hephaestus/heavy_rifle
	name = "7.5mm Ares"
	id = "hephaestus-heavy-rifle"
	caliber = "hephaestus-heavy-rifle"
	diameter = 7.5
	length = 54

/datum/ammo_caliber/hephaestus/heavy_sidearm
	name = ".355 Special"
	id = "hephaestus-heavy-sidearm"
	caliber = "hephaestus-heavy-sidearm"
	diameter = 9
	length = 34

/datum/ammo_caliber/hephaestus/light_sidearm
	name = ".355 Auto"
	id = "hephaestus-light-sidearm"
	caliber = "hephaestus-light-sidearm"
	diameter = 9
	length = 29

//* Ammo Casings *//

/obj/item/ammo_casing/hephaestus
	icon = 'icons/content/factions/corporations/hephaestus/cartridges.dmi'
	icon_state = "basic"
	icon_spent = TRUE

/obj/item/ammo_casing/hephaestus/antimateriel
	name = "ammo casing (.50 Arc)"
	desc = "A standardized 12x92mm cartridge produced by Hephaestus Industries."
	description_fluff = "Undoubtedly humanity's most well-established anti-materiel cartridge, it seems to follow humans anywhere they can be found across the Orion Spur. The name .50 Arcadian was chosen by Hephaestus Industries to represent it's provenance from Mars' Arcadia Planitia, where a large fraction of the cartridges were being produced at the time it was first introduced in the 2440s."
	icon_state = "antimateriel"
	casing_caliber = /datum/ammo_caliber/hephaestus/antimateriel
	projectile_type = /obj/projectile/bullet/hephaestus/antimateriel

	/// specifically for /obj/item/ammo_magazine/hephaestus/antimateriel's
	///
	/// * null to default to "[base_icon_state || initial(icon_state)]"
	var/magazine_state

/obj/item/ammo_casing/hephaestus/antimaterial/penetrator
	icon_state = "penetrator"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/antimaterial/emp
	icon_state = "emp"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/antimaterial/explosive
	icon_state = "explosive"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/antimaterial/titanium
	icon_state = "titanium"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/heavy_rifle
	name = "ammo casing (7.5mm Ares)"
	desc = "A standardized 7.5x54mm cartridge produced by Hephaestus Industries."
	description_fluff = "Hephaestus Industries' standard-issue full-powered rifle cartridge, utilized by a tremendous catalog of weaponry where heavy stopping power is required, from general purpose machineguns to bolt-action sniper rifles."
	icon_state = "heavyrifle"
	casing_caliber = /datum/ammo_caliber/hephaestus/heavy_rifle
	projectile_type = /obj/projectile/bullet/hephaestus/heavy_rifle

	/// specifically for /obj/item/ammo_magazine/hephaestus/heavy_rifle's
	var/stripper_state = "basic"

/obj/item/ammo_casing/nt_expedition/heavy_rifle/piercing
	icon_state = "piercing"
	stripper_state = "piercing"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/heavy_rifle/rubber
	icon_state = "rubber"
	stripper_state = "rubber"
	// todo: implement casing + magazine

/obj/item/ammo_casing/hephaestus/heavy_sidearm
	name = "ammo casing (.355 Special)"
	desc = "A standardized 9x34mm cartridge produced by Hephaestus Industries."
	description_fluff = "The bigger brother of .355 Auto, Hephaestus Industries' .355 Special was introduced, as the name suggests, for situations where a shorter cartridge would simply not cut it. It's semi-rimmed design allows it to be used in both revolvers and standard magazine-fed weapons alike."
	icon_state = "heavysidearm"
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
	name = "ammo casing (.355 Auto)"
	desc = "A standardized 9x29mm cartridge produced by Hephaestus Industries."
	description_fluff = "Hephaestus Industries' definitive handgun cartridge. Highly compact, well-performing, ubiquitous."
	icon_state = "lightsidearm"
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

