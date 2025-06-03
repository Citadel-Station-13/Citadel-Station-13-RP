// todo: rework to /obj/projectile/emp

/obj/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage_force = 0
	damage_type = DAMAGE_TYPE_BURN
	nodamage = 1
	damage_flag = ARMOR_ENERGY
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"

	combustion = FALSE

	projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_2 = 1;
			sev_3 = 2;
		}
	)

/obj/projectile/ion/small
	projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_3 = 2;
		}
	)

/obj/projectile/ion/pistol
