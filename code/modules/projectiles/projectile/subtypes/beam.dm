/**
 * Supertype of many different types of beams.
 *
 * * This is a type that should have no special behavior!
 */
/obj/projectile/beam
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE
	damage_force = 40
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_PHOTONIC
	eyeblur = 4
	hitscan = TRUE
	embed_chance = 0
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)

	muzzle_type = /obj/effect/projectile/muzzle/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	impact_type = /obj/effect/projectile/impact/laser
