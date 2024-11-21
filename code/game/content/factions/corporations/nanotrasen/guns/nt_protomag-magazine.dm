//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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

#define NT_PROTOMAG_AMMO_TYPEGEN(suffix, name, ammo) \
/obj/item/ammo_magazine/nt_protomag/pistol##suffix { \
	name = "protomag sidearm magazine (" + name + ")"; \
	ammo_preload = /obj/item/ammo_casing/nt_protomag##ammo; \
	rendering_static_color = /obj/item/ammo_casing/nt_protomag##ammo::stripe_color; \
} \
/obj/item/ammo_magazine/nt_protomag/rifle##suffix { \
	name = "protomag rifle magazine (" + name + ")"; \
	ammo_preload = /obj/item/ammo_casing/nt_protomag##ammo; \
	rendering_static_color = /obj/item/ammo_casing/nt_protomag##ammo::stripe_color; \
}

NT_PROTOMAG_AMMO_TYPEGEN(/standard, "standard", /magboosted/standard)
NT_PROTOMAG_AMMO_TYPEGEN(/sabot, "sabot", /magboosted/sabot)
// NT_PROTOMAG_AMMO_TYPEGEN(/shredder, "shredder", /magboosted/shredder)
NT_PROTOMAG_AMMO_TYPEGEN(/impact, "impact", /magboosted/impact)
NT_PROTOMAG_AMMO_TYPEGEN(/practice, "practice", /magboosted/practice)

NT_PROTOMAG_AMMO_TYPEGEN(/smoke, "smoke", /magnetic/smoke)
NT_PROTOMAG_AMMO_TYPEGEN(/emp, "emp", /magnetic/emp)
// NT_PROTOMAG_AMMO_TYPEGEN(/concussive, "concussive", /magnetic/concussive)
NT_PROTOMAG_AMMO_TYPEGEN(/penetrator, "penetrator", /magnetic/penetrator)
NT_PROTOMAG_AMMO_TYPEGEN(/shock, "shock", /magnetic/shock)
NT_PROTOMAG_AMMO_TYPEGEN(/flare, "flare", /magnetic/flare)
// NT_PROTOMAG_AMMO_TYPEGEN(/incendiary, "incendiary", /magnetic/incendiary)
// NT_PROTOMAG_AMMO_TYPEGEN(/reagent, "reagent", /magnetic/reagent)

#warn materials & R&D designs for all of the abvoe

#undef NT_PROTOMAG_AMMO_TYPEGEN
