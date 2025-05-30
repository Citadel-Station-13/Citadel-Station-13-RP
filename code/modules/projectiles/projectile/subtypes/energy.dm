/**
 * Supertype of many different types of beams.
 *
 * * This is a type that should have no special behavior!
 *
 * todo: get rid of said special behavior, or just decide it's okay and keep it.
 */
/obj/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage_force = 0
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_ENERGY
	projectile_type = PROJECTILE_TYPE_ENERGY
