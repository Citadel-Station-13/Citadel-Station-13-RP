/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/hmg
	name = "\improper \"Sturmkönig\" RAC/5"
	desc = "A superior version of the standard Ultra AC 2 design. Bigger bullets, larger burst, tears through ammo stores."
	icon_state = "mecha_uac2"
	equip_cooldown = 5
	projectile = /obj/item/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/machinegun.ogg'
	projectiles = 60
	projectiles_per_shot = 6
	deviation = 0.4
	projectile_energy_cost = 25
	fire_cooldown = 0.5

/obj/item/mecha_parts/mecha_equipment/weapon/energy/burstlaser
	equip_cooldown = 3
	name = "\improper c-MPL \"Slagger\" rapid-cycling laser"
	desc = "A laser carbine's firing system, overcharged for lower cooldowns between shots and mounted on a high-powered exosuit weapon socket."
	icon_state = "mecha_laser"
	energy_drain = 40
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/projectile/bullet/rifle/a145/slow
	hitscan = 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/amr
	name = "\improper \"Bishop\" UAC/20"
	desc = "A bastardized Ultra AC/2. A larger barrel firing the same kind of shells you'd find in the HI PTR-7, but on a larger, two-shot-burst scale."
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/rifle/a145/slow
	fire_sound = 'sound/weapons/svd_shot.ogg'
	projectiles = 20
	projectiles_per_shot = 2
	deviation = 0
	projectile_energy_cost = 60
	fire_cooldown = 1.5