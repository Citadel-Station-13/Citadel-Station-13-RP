/**
 * Supertype of many different types of beams.
 *
 * * This is a type that should have no special behavior!
 */
/obj/projectile/beam
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	pass_flags = ATOM_PASS_FLAGS_BEAM
	damage_force = 40
	damage_type = DAMAGE_TYPE_BURN
	damage_tier = 3
	damage_flag = ARMOR_LASER
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_PHOTONIC
	eyeblur = 4
	hitscan = TRUE
	embed_chance = 0
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser
	legacy_tracer_type = /obj/effect/projectile/tracer/laser
	legacy_impact_type = /obj/effect/projectile/impact/laser
