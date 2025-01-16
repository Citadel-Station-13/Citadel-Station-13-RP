//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/design/generated/nt_protomag_ammo
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_AMMO

// todo: make this fit in webbing
/obj/item/ammo_magazine/nt_protomag
	abstract_type = /obj/item/ammo_magazine/nt_protomag
	desc = "A magazine for a magnetic weapon of some kind."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/protomag/magazines.dmi'
	ammo_caliber = /datum/caliber/nt_protomag

//* Sidearm Magazines *//

/obj/item/ammo_magazine/nt_protomag/sidearm
	name = "protomag sidearm magazine"
	ammo_max = 8
	icon_state = "pistol-1"
	base_icon_state = "pistol"
	rendering_static_overlay = "pistol-stripe"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_TINY
	slot_flags = SLOT_POCKET

	magazine_restrict = /obj/item/gun/ballistic/magnetic/modular/nt_protomag/sidearm

//* Rifle Magazines *//

/obj/item/ammo_magazine/nt_protomag/rifle
	name = "protomag rifle magazine"
	ammo_max = 16
	icon_state = "rifle-map"
	base_icon_state = "rifle"
	rendering_static_overlay = "rifle-stripe"

	rendering_system = GUN_RENDERING_STATES
	rendering_count = 6
	rendering_segment_x_offset = -2

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_SMALL
	slot_flags = SLOT_POCKET

	magazine_restrict = /obj/item/gun/ballistic/magnetic/modular/nt_protomag/rifle

//* Typegen *//

/**
 * Generates magazines and designs for normal protomag ammo.
 */
#define NT_PROTOMAG_MAG_TYPEGEN(ID, SUFFIX, NAME, AMMO) \
/obj/item/ammo_magazine/nt_protomag/pistol##SUFFIX { \
	name = "protomag sidearm magazine (" + NAME + ")"; \
	ammo_preload = /obj/item/ammo_casing/nt_protomag##AMMO; \
	rendering_static_overlay_color = /obj/item/ammo_casing/nt_protomag##AMMO::stripe_color; \
} \
/obj/item/ammo_magazine/nt_protomag/rifle##SUFFIX { \
	name = "protomag rifle magazine (" + NAME + ")"; \
	ammo_preload = /obj/item/ammo_casing/nt_protomag##AMMO; \
	rendering_static_overlay_color = /obj/item/ammo_casing/nt_protomag##AMMO::stripe_color; \
} \
GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_protomag/pistol##SUFFIX, /nt_protomag_ammo/pistol/##SUFFIX, "NTMagPistolAmmo" + ##ID); \
GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_protomag/rifle##SUFFIX, /nt_protomag_ammo/rifle/##SUFFIX, "NTMagRifleAmmo" + ##ID);

/**
 * Generates magazines and designs for special protomag ammo.
 */
#define NT_PROTOMAG_MAG_TYPEGEN_SPECIAL(ID, SUFFIX, NAME, AMMO) \
NT_PROTOMAG_MAG_TYPEGEN(ID, SUFFIX, NAME, AMMO); \
/datum/prototype/design/generated/nt_protomag_ammo/pistol/##SUFFIX { \
	lathe_type = LATHE_TYPE_AUTOLATHE | LATHE_TYPE_PROTOLATHE; \
} \
/datum/prototype/design/generated/nt_protomag_ammo/rifle/##SUFFIX { \
	lathe_type = LATHE_TYPE_AUTOLATHE | LATHE_TYPE_PROTOLATHE; \
}

NT_PROTOMAG_MAG_TYPEGEN("Standard", /standard, "standard", /magboosted/standard)
NT_PROTOMAG_MAG_TYPEGEN("Sabot", /sabot, "sabot", /magboosted/sabot)
// NT_PROTOMAG_MAG_TYPEGEN("Shredder", /shredder, "shredder", /magboosted/shredder)
NT_PROTOMAG_MAG_TYPEGEN("Impact", /impact, "impact", /magboosted/impact)
NT_PROTOMAG_MAG_TYPEGEN("Practice", /practice, "practice", /magboosted/practice)

// NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Smoke", /smoke, "smoke", /magnetic/smoke)
NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Emp", /emp, "emp", /magnetic/emp)
// NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Concussive", /concussive, "concussive", /magnetic/concussive)
NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Penetrator", /penetrator, "penetrator", /magnetic/penetrator)
NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Shock", /shock, "shock", /magnetic/shock)
// NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Flare", /flare, "flare", /magnetic/flare)
// NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Incendiary", /incendiary, "incendiary", /magnetic/incendiary)
// NT_PROTOMAG_MAG_TYPEGEN_SPECIAL("Reagent", /reagent, "reagent", /magnetic/reagent)

#undef NT_PROTOMAG_MAG_TYPEGEN
#undef NT_PROTOMAG_MAG_TYPEGEN_SPECIAL
