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
	ammo_caliber = /datum/ammo_caliber/nt_protomag

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

//* Rifle Magazines *//

/obj/item/ammo_magazine/nt_protomag/rifle
	name = "protomag rifle magazine"
	ammo_max = 16
	icon_state = "rifle-map"
	base_icon_state = "rifle"
	rendering_static_overlay = "rifle-stripe"

	rendering_system = GUN_RENDERING_SEGMENTS
	rendering_count = 6
	rendering_segment_x_offset = -2

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_SMALL
	slot_flags = SLOT_POCKET

//* Typegen *//

/datum/prototype/design/generated/nt_protomag_ammo
	abstract_type = /datum/prototype/design/generated/nt_protomag_ammo
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_AMMO

/datum/prototype/design/generated/nt_protomag_ammo/sidearm
	abstract_type = /datum/prototype/design/generated/nt_protomag_ammo/sidearm

/datum/prototype/design/generated/nt_protomag_ammo/rifle
	abstract_type = /datum/prototype/design/generated/nt_protomag_ammo/rifle

/**
 * Generates magazines and designs for normal protomag ammo.
 */
#define NT_PROTOMAG_MAGAZINE_TYPEGEN(_ID, _SUFFIX, _NAME, _AMMO) \
/obj/item/ammo_magazine/nt_protomag/sidearm##_SUFFIX { \
	name = "protomag sidearm magazine (" + _NAME + ")"; \
	ammo_preload = /obj/item/ammo_casing/nt_protomag##_AMMO; \
	rendering_static_overlay_color = /obj/item/ammo_casing/nt_protomag##_AMMO::stripe_color; \
} \
/obj/item/ammo_magazine/nt_protomag/rifle##_SUFFIX { \
	name = "protomag rifle magazine (" + _NAME + ")"; \
	ammo_preload = /obj/item/ammo_casing/nt_protomag##_AMMO; \
	rendering_static_overlay_color = /obj/item/ammo_casing/nt_protomag##_AMMO::stripe_color; \
} \
GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_protomag/sidearm##_SUFFIX, /nt_protomag_ammo/sidearm##_SUFFIX, "nt-ammo-magpistol-" + ##_ID); \
GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_protomag/rifle##_SUFFIX, /nt_protomag_ammo/rifle##_SUFFIX, "nt-ammo-magrifle-" + ##_ID);

/**
 * Generates magazines and designs for special protomag ammo.
 */
#define NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL(_ID, _SUFFIX, _NAME, _AMMO) \
NT_PROTOMAG_MAGAZINE_TYPEGEN(_ID, _SUFFIX, _NAME, _AMMO); \
/datum/prototype/design/generated/nt_protomag_ammo/sidearm##_SUFFIX { \
	lathe_type = LATHE_TYPE_PROTOLATHE; \
} \
/datum/prototype/design/generated/nt_protomag_ammo/rifle##_SUFFIX { \
	lathe_type = LATHE_TYPE_PROTOLATHE; \
}

NT_PROTOMAG_MAGAZINE_TYPEGEN("standard", /standard, "standard", /magboosted/standard)
NT_PROTOMAG_MAGAZINE_TYPEGEN("sabot", /sabot, "sabot", /magboosted/sabot)
// NT_PROTOMAG_MAGAZINE_TYPEGEN("shredder", /shredder, "shredder", /magboosted/shredder)
NT_PROTOMAG_MAGAZINE_TYPEGEN("impact", /impact, "impact", /magboosted/impact)
NT_PROTOMAG_MAGAZINE_TYPEGEN("practice", /practice, "practice", /magboosted/practice)

// NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("smoke", /smoke, "smoke", /magnetic/smoke)
NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("emp", /emp, "emp", /magnetic/emp)
// NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("concussive", /concussive, "concussive", /magnetic/concussive)
NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("penetrator", /penetrator, "penetrator", /magnetic/penetrator)
NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("Shock", /shock, "shock", /magnetic/shock)
// NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("flare", /flare, "flare", /magnetic/flare)
// NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("incendiary", /incendiary, "incendiary", /magnetic/incendiary)
// NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL("reagent", /reagent, "reagent", /magnetic/reagent)

#undef NT_PROTOMAG_MAGAZINE_TYPEGEN
#undef NT_PROTOMAG_MAGAZINE_TYPEGEN_SPECIAL
