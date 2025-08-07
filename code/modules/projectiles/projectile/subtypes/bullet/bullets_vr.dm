/obj/projectile/bullet/pistol/rubber/strong //"rubber" bullets for revolvers and matebas
	damage_force = 10
	damage_inflict_agony = 60
	embed_chance = 0
	damage_flag = ARMOR_MELEE

/obj/projectile/energy/flash/strong
	name = "chemical shell"
	icon_state = "bullet"
	damage_force = 10
	range = WORLD_ICON_SIZE * 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	flash_strength = 15
	brightness = 15

/obj/projectile/energy/electrode/stunshot/strong
	name = "stunshot"
	icon_state = "bullet"
	damage_force = 10
	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_agony = 100;
		}
	)
