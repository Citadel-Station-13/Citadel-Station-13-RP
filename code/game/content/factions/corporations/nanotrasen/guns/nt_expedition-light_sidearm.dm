//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Designs *//

/datum/prototype/design/generated/nt_expedition_ammo/light_sidearm
	abstract_type = /datum/prototype/design/generated/nt_expedition_ammo/light_sidearm

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/light_sidearm
	name = "ammo magazine (.355 auto)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-light.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/hephaestus/light_sidearm
	ammo_preload = /obj/item/ammo_casing/hephaestus/light_sidearm

/obj/item/ammo_magazine/nt_expedition/light_sidearm/pistol
	name = "pistol magazine (.355 auto)"
	icon_state = "pistol-5"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	weight_volume = ITEM_VOLUME_PISTOL_MAG
	rendering_count = 5
	rendering_static_overlay = "pistol-stripe"
	ammo_max = 14

GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_expedition/light_sidearm/smg, /nt_expedition_ammo/light_sidearm/smg, "nt-ammo-9mm-smg");
/obj/item/ammo_magazine/nt_expedition/light_sidearm/smg
	name = "smg magazine (.355 auto)"
	icon_state = "smg-1"
	base_icon_state = "smg"
	weight_volume = ITEM_VOLUME_RIFLE_MAG
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "smg-stripe"
	ammo_max = 28
	materials_base = list(
		/datum/prototype/material/steel::id = 325,
		/datum/prototype/material/glass::id = 125,
	)

//* Light Sidearms *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-light.dmi'
	caliber = /datum/ammo_caliber/hephaestus/light_sidearm

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

//* Pistol *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/pistol
	name = "light pistol"
	desc = "The XNP Mk.1 \"Chisel\" pistol; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A semi-compact semiautomatic pistol designed to fit in the pocket, the \"Chisel\" was designed in the late 2560s alongside Hephaestus Industries after
		the failure of Nanotrasen's internal AXHS program left their exploration department without a suitable ballistic handgun. In comparison to it's predecessor,
		the new design is much streamlined, chambered for Hephaestus' .355 Auto caliber, and devoid of unecessary features, making it exceptionally handy.
	"} + "<br>"
	icon_state = "pistol"
	base_icon_state = "pistol"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_sidearm/pistol
	w_class = WEIGHT_CLASS_FOR_SIDEARM

//* SMG *//

/datum/firemode/nt_expedition_light_smg
	abstract_type = /datum/firemode/nt_expedition_light_smg

/datum/firemode/nt_expedition_light_smg/semi_auto
	name = "semi-auto"

/datum/firemode/nt_expedition_light_smg/two_burst
	name = "2-burst"
	burst_amount = 2
	burst_delay = 1
	projectile_base_dispersion = 5.75

/datum/firemode/nt_expedition_light_smg/auto
	name = "automatic"
	cycle_cooldown = 1
	projectile_base_dispersion = 7
//	automatic = TRUE

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg
	name = "machine pistol"
	desc = "The XNP Mk.3 \"Sawtooth\" machine pistol; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A highly-portable machine pistol with a collapsible stock and folding vertical grip, the \"Sawtooth\" is chambered in .355 Auto.
		Automatic fire is generally not recommended due to the fast cyclic rate leading to poor ammo economy.
	"} + "<br>"
	icon_state = "smg"
	base_icon_state = "smg"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC | MAGAZINE_CLASS_EXTENDED
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_sidearm/smg
	materials_base = list(
		/datum/prototype/material/steel::id = 2500,
		/datum/prototype/material/glass::id = 1250,
		/datum/prototype/material/gold::id = 250,
		/datum/prototype/material/silver::id = 750,
		/datum/prototype/material/lead::id = 700,
		/datum/prototype/material/copper::id = 400,
	)
	firemodes = list(
		/datum/firemode/nt_expedition_light_smg/semi_auto,
		/datum/firemode/nt_expedition_light_smg/two_burst,
		/datum/firemode/nt_expedition_light_smg/auto,
	)
	w_class = WEIGHT_CLASS_FOR_SIDEARM

	one_handed_penalty = 30
	var/collapsible = 1
	var/extended = 0

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg/update_icon_state()
	. = ..()
	if(!extended && magazine)
		icon_state = "smg_f"
	else if(extended && magazine)
		icon_state = "smg"
	else if(extended && !magazine)
		icon_state = "smg-empty"
	else
		icon_state = "smg_f-empty"

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg/attack_self(mob/user, datum/event_args/actor/actor)
	if(collapsible && !extended)
		to_chat(user, "<span class='notice'>You pull out the stock on the [src], steadying the weapon.</span>")
		set_weight_class(WEIGHT_CLASS_FOR_SHORT_RIFLE)
		one_handed_penalty = 10
		extended = 1
		update_icon()
	else if(!collapsible)
		to_chat(user, "<span class='danger'>The [src] doesn't have a stock!</span>")
		return
	else
		to_chat(user, "<span class='notice'>You push the stock back into the [src], making it more compact.</span>")
		set_weight_class(WEIGHT_CLASS_FOR_SIDEARM)
		one_handed_penalty = 30
		extended = 0
		update_icon()

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg/no_pin, /nt_expedition/light_smg, "nt-expeditionary-light_smg")
/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg/no_pin
	pin = null
