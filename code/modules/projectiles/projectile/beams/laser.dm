/obj/item/projectile/beam/laser
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 40
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 4
	color = COLOR_RED
	hitscan_light_intensity = 0.5
	hitscan_light_range = 2
	muzzle_flash_intesnity = 3
	muzzle_flas_range = 1.5
	impact_light_intensity = 2
	impact_light_range = 2
	muzzle_type = /obj/effect/projectile/muzzle/laser_greyscale
	tracer_type = /obj/effect/projectile/tracer/laser_greyscale
	impact_type = /obj/effect/projectile/impact/laser_greyscale

/obj/item/projectile/beam/laser/practice
	damage = 0
	damage_type = BURN
	nodamage = TRUE
	eyeblur = 2

/obj/item/projectile/beam/laser/weak
	name = "weak laser"
	damage = 15

/obj/item/projectile/beam/laser/small
	damage = 25

/obj/item/projectile/beam/laser/burst
	damage = 30
	armor_penetration = 10

/obj/item/projectile/beam/laser/medium
	damage = 40
	armor_penetration = 10

/obj/item/projectile/beam/laser/heavy
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 60
	armor_penetration = 30
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

	muzzle_type = /obj/effect/projectile/muzzle/laser_heavy
	tracer_type = /obj/effect/projectile/tracer/laser_heavy
	impact_type = /obj/effect/projectile/impact/laser_heavy

/obj/item/projectile/beam/laser/heavy/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/laser/heavy/cannon
	damage = 80
	armor_penetration = 50
	light_color = "#FF0D00"

/obj/item/projectile/beam/laser/xray
	name = "xray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 25
	armor_penetration = 50
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/laser/cyan
	name = "cyan beam"
	icon_state = "cyan"
	damage = 40
	color = COLOR_CYAN

	muzzle_type = /obj/effect/projectile/muzzle/laser_greyscale
	tracer_type = /obj/effect/projectile/tracer/laser_greyscale
	impact_type = /obj/effect/projectile/impact/laser_greyscale

/obj/item/projectile/beam/laser/dominator
	name = "dominator lethal beam"
	icon_state = "xray"
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray
