// todo: better storage insertion broad-spectrum check system
//       to not need to list all paths out.
/obj/item/storage/belt/security
	name = "security belt"
	desc = "Standard issue belt capable of storing many kinds of tactical gear."
	icon_state = "security"
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	insertion_whitelist = list(
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/a10g,
		/obj/item/ammo_casing/a12g,
		/obj/item/ammo_magazine,
		// TODO: PLEASE FOR THE LOVE OF GOD REFACTOR FUCKING BELTS ALREADY
		/obj/item/cell/basic/tier_1/weapon,
		/obj/item/cell/basic/tier_2/weapon,
		/obj/item/cell/basic/tier_3/weapon,
		/obj/item/cell/basic/tier_4/weapon,
		/obj/item/cell/basic/tier_5/weapon,
		/obj/item/cell/basic/regen/weapon,
		/obj/item/cell/basic/regen/fractal/weapon,
		/obj/item/cell/basic/infinite/weapon,
		/obj/item/cell/basic/microfission/weapon,
		/obj/item/melee/baton,
		/obj/item/gun/projectile/energy/taser,
		/obj/item/gun/projectile/energy/stunrevolver,
		/obj/item/gun/projectile/energy/gun,
		/obj/item/flame/lighter,
		/obj/item/flashlight,
		/obj/item/tape_recorder,
		/obj/item/barrier_tape_roll,
		/obj/item/pda,
		/obj/item/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/melee,
		/obj/item/clothing/accessory/badge,
		/obj/item/gun/projectile/ballistic/sec,
		/obj/item/gun/projectile/ballistic/p92x,
		/obj/item/barrier_tape_roll,
		/obj/item/gun/projectile/ballistic/colt/detective,
		/obj/item/holowarrant,
		/obj/item/gun/projectile/energy/nt_isd/sidearm,
	)

/obj/item/storage/belt/security/nt_isd_preload
	starts_with = list(
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/gun/projectile/energy/nt_isd/sidearm/with_light,
		/obj/item/melee/baton,
		/obj/item/cell/basic/tier_2/weapon,
		/obj/item/reagent_containers/spray/pepper,
	)
