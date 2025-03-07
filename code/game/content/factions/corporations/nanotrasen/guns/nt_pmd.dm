/**
 * Transforming service weapon for the Nanotrasen PMD. Sprites & work by Captain277.
 */

/datum/firemode/energy/nt_pmd/service_revolver
	abstract_type = /datum/firemode/energy/nt_pmd/service_revolver
	cycle_cooldown = 0.4 SECONDS

/datum/firemode/energy/nt_pmd/service_revolver/normal
	name = "normal"
	projectile_type = /obj/projectile/bullet/pistol/medium/silver
	charge_cost = 2400 / 8

/datum/firemode/energy/nt_pmd/service_revolver/normal/make_radial_appearance()
	return image(/obj/item/gun/projectile/energy/nt_pmd/service_revolver::icon, "service-normal")

/datum/firemode/energy/nt_pmd/service_revolver/shatter
	name = "shatter"
	projectile_type = /obj/projectile/bullet/pellet/shotgun/silvershot
	cycle_cooldown = 1.5 SECONDS
	charge_cost = 2400 / 5

/datum/firemode/energy/nt_pmd/service_revolver/shatter/make_radial_appearance()
	return image(/obj/item/gun/projectile/energy/nt_pmd/service_revolver::icon, "service-shatter")

/datum/firemode/energy/nt_pmd/service_revolver/spin
	name = "spin"
	projectile_type = /obj/projectile/bullet/pistol/spin
	cycle_cooldown = 0.1 SECONDS
	charge_cost = 2400 / 80

/datum/firemode/energy/nt_pmd/service_revolver/spin/make_radial_appearance()
	return image(/obj/item/gun/projectile/energy/nt_pmd/service_revolver::icon, "service-spin")

/datum/firemode/energy/nt_pmd/service_revolver/pierce
	name = "pierce"
	projectile_type = /obj/projectile/bullet/rifle/a762/ap/silver
	cycle_cooldown = 1.5 SECONDS
	charge_cost = 2400 / 5

/datum/firemode/energy/nt_pmd/service_revolver/pierce/make_radial_appearance()
	return image(/obj/item/gun/projectile/energy/nt_pmd/service_revolver::icon, "service-pierce")

/datum/firemode/energy/nt_pmd/service_revolver/charge
	name = "charge"
	projectile_type = /obj/projectile/bullet/burstbullet/service
	cycle_cooldown = 2 SECONDS
	charge_cost = 2400 / 4

/datum/firemode/energy/nt_pmd/service_revolver/charge/make_radial_appearance()
	return image(/obj/item/gun/projectile/energy/nt_pmd/service_revolver::icon, "service-charge")

/obj/item/gun/projectile/energy/nt_pmd/service_revolver
	name = "service weapon"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/nt_pmd/service_revolver.dmi'
	icon_state = "service"
	base_icon_state = "service"
	desc = "An anomalous weapon, long kept secure. It has recently been acquired by Nanotrasen's Paracausal Monitoring Division. How did it get here?"
	damage_force = 5
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = null
	cell_type = /obj/item/cell/device/weapon/recharge/captain
	legacy_battery_lock = 1
	one_handed_penalty = 0
	safety_state = GUN_SAFETY_OFF
	firemodes = list(
		/datum/firemode/energy/nt_pmd/service_revolver/normal,
		/datum/firemode/energy/nt_pmd/service_revolver/shatter,
		/datum/firemode/energy/nt_pmd/service_revolver/spin,
		/datum/firemode/energy/nt_pmd/service_revolver/pierce,
		/datum/firemode/energy/nt_pmd/service_revolver/charge,
	)
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_single = TRUE;
		independent_firemode = TRUE;
	}
