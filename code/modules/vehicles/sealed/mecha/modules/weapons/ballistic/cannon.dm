
/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon
	name = "8.8cm KwK 47"
	desc = "<i>Precision German engineering!</i>" // Why would you ever take this off the mech, anyway?
	icon_state = "mecha_uac2"
	equip_cooldown = 60 // 6 seconds
	projectile = /obj/projectile/bullet/cannon
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
	projectiles = 1
	projectile_energy_cost = 1000
	salvageable = 0 // We don't want players ripping this off a dead mech. Could potentially be a prize for beating it if Devs bless me and someone offers a nerf idea.

/obj/projectile/bullet/cannon
	name ="armor-piercing shell"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "shell"
	damage_force = 1000 // In order to 1-hit any other mech and royally fuck anyone unfortunate enough to get in the way.

/obj/projectile/bullet/cannon/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	explosion(target, 0, 0, 2, 4)

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon/weak
	name = "8.8 cm KwK 36"
	equip_cooldown = 120 // 12 seconds.
	projectile = /obj/projectile/bullet/cannon/weak
	projectile_energy_cost = 400
	salvageable = 1

/obj/projectile/bullet/cannon/weak
	name ="canister shell"
	icon_state = "canister"
	damage_force = 120 //Do not get fucking shot.
