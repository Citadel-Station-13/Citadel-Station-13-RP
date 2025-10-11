/obj/item/vehicle_module/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	desc = "A superior version of the standard Hephaestus Autocannon MK2 design."
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/projectile/bullet/pistol/medium
	fire_sound = 'sound/weapons/Gunshot_machinegun.ogg'
	projectiles = 30 //10 bursts, matching the Scattershot's 10. Also, conveniently, doesn't eat your powercell when reloading like 300 bullets does.
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

/obj/item/vehicle_module/weapon/ballistic/lmg_heavy
	name = "\improper AC 10"
	desc = "The original in anti-mech firepower, the standard Hephaestus Autocannon MK10 design fires AP slugs in order to damage other heavy armor suits. This does mean its rate between bursts is longer than most."
	icon_state = "mecha_uac2"
	equip_cooldown = 1 SECONDS
	projectile = /obj/projectile/bullet/rifle/a762/ap
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	projectiles = 20 //Mag size
	projectiles_per_shot = 2
	deviation = 0.3
	projectile_energy_cost = 60
	fire_cooldown = 2

/obj/item/vehicle_module/weapon/ballistic/gauss_rifle
	name = "\improper gauss rifle"
	desc = "The current standard in non-laser, anti-armor firepower, this weapon is the same as those mounted on light tanks for their primary weapon. Fires a single nickle-iron slug at high speed. Requires a long charge time between shots. "
	icon_state = "mecha_uac2-rig"
	equip_cooldown = 3 SECONDS
	projectile = /obj/projectile/bullet/mecha/a12mm_gauss
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
	projectiles = 10 //Mag size
	projectiles_per_shot = 1
	projectile_energy_cost = 100

/obj/item/vehicle_module/weapon/ballistic/cannon/hag_30
	name = "HAG 30"
	desc = "The HAG30 is a weapon that is usually paired with the Quasimodo, a 155mm artillery cannon that travels in large, massive arc. Be careful where you're pointing."
	icon_state = "mecha_uac2"
	equip_cooldown = 50 // 5 seconds
	projectile = /obj/projectile/arc/hag30
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
	projectiles = 1
	projectile_energy_cost = 2000
	equip_type = EQUIP_HEAVY_WEAPON


/obj/item/vehicle_module/weapon/ballistic/lmg/rigged
	name = "jury-rigged machinegun"
	desc = "The cross between a jackhammer and a whole lot of zipguns."
	icon_state = "mecha_uac2-rig"
	equip_cooldown = 12
	projectile = /obj/projectile/bullet/pistol
	deviation = 0.5

	equip_type = EQUIP_UTILITY
