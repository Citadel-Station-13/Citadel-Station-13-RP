/obj/projectile/beam
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE
	damage = 40
	damage_type = BURN
	damage_flag = ARMOR_LASER
	eyeblur = 4
	var/frequency = 1
	hitscan = TRUE
	embed_chance = 0
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser
	hitscan_impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	damage = 0
	damage_type = BURN
	damage_flag = ARMOR_LASER
	eyeblur = 2
	impact_sounds = null

/obj/projectile/beam/weaklaser
	name = "weak laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	damage = 15

/obj/projectile/beam/smalllaser
	damage = 25
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'

/obj/projectile/beam/burstlaser
	damage = 30
	fire_sound = 'sound/weapons/weaponsounds_lasermid.ogg'
	armor_penetration = 10


/obj/projectile/beam/midlaser
	damage = 40
	fire_sound = 'sound/weapons/weaponsounds_lasermid.ogg'
	armor_penetration = 10

/obj/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	damage = 60
	armor_penetration = 30
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_heavy
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_heavy
	hitscan_impact_type = /obj/effect/projectile/impact/laser_heavy

/obj/projectile/beam/heavylaser/fakeemitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	light_color = "#00CC33"
	excavation_amount = 140	// 2 shots to dig a standard rock turf. Superior due to being a mounted tool beam, to make it actually viable.

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/emitter
	hitscan_tracer_type = /obj/effect/projectile/tracer/emitter
	hitscan_impact_type = /obj/effect/projectile/impact/emitter

/obj/projectile/beam/heavylaser/cannon
	damage = 80
	armor_penetration = 50
	light_color = "#FF0D00"

/obj/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 25
	armor_penetration = 50
	light_color = "#00CC33"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/xray
	hitscan_tracer_type = /obj/effect/projectile/tracer/xray
	hitscan_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/gamma
	name = "gamma beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 10
	armor_penetration = 90
	irradiate = 20
	light_color = "#00CC33"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/xray
	hitscan_tracer_type = /obj/effect/projectile/tracer/xray
	hitscan_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/cyan
	name = "cyan beam"
	icon_state = "cyan"
	fire_sound = 'sound/weapons/weaponsounds_alienlaser.ogg'
	damage = 40
	light_color = "#00C6FF"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_omni
	hitscan_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/gauss_shoot.ogg' // Needs a more meaty sound than what pulse.ogg currently is; this will be a placeholder for now.
	damage = 100	//Badmin toy, don't care
	armor_penetration = 100
	light_color = "#0066FF"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_pulse
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_pulse
	hitscan_impact_type = /obj/effect/projectile/impact/laser_pulse

/obj/projectile/beam/pulse/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		LEGACY_EX_ACT(target, 2, null)
	..()

/obj/projectile/beam/pulse/shotgun
	damage = 50
	armor_penetration = 25

/obj/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm
	light_color = "#00CC33"
	excavation_amount = 70 // 3 shots to mine a turf

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/emitter
	hitscan_tracer_type = /obj/effect/projectile/tracer/emitter
	hitscan_impact_type = /obj/effect/projectile/impact/emitter

/obj/projectile/beam/lasertag
	name = "lasertag beam"
	damage = 0
	eyeblur = 0
	no_attack_log = 1
	damage_type = BURN
	damage_flag = ARMOR_LASER

	combustion = FALSE

/obj/projectile/beam/lasertag/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_blue
	hitscan_impact_type = /obj/effect/projectile/impact/laser_blue

/obj/projectile/beam/lasertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.afflict_paralyze(20 * 5)
	return 1

/obj/projectile/beam/lasertag/red
	icon_state = "laser"
	light_color = "#FF0D00"

/obj/projectile/beam/lasertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.afflict_paralyze(20 * 5)
	return 1

/obj/projectile/beam/lasertag/omni//A laser tag bolt that stuns EVERYONE
	icon_state = "omnilaser"
	light_color = "#00C6FF"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_omni
	hitscan_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/lasertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.afflict_paralyze(20 * 5)
	return 1

/obj/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	damage = 60
	armor_penetration = 10
	light_color = "#00CC33"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/xray
	hitscan_tracer_type = /obj/effect/projectile/tracer/xray
	hitscan_impact_type = /obj/effect/projectile/impact/xray


/obj/projectile/beam/shock
	name = "shock beam"
	icon_state = "lightning"
	damage_type = ELECTROCUTE

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/lightning
	hitscan_tracer_type = /obj/effect/projectile/tracer/lightning
	hitscan_impact_type = /obj/effect/projectile/impact/lightning

	damage = 30
	agony = 15
	eyeblur = 2

/obj/projectile/beam/excavation
	name = "excavation beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	light_color = "#00CC33"
	damage = 1 //mining tool
	excavation_amount = 1000	// 1 shot to dig a standard rock turf. Made for mining. Should be able to consistently one hit rocks now

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/emitter
	hitscan_tracer_type = /obj/effect/projectile/tracer/emitter
	hitscan_impact_type = /obj/effect/projectile/impact/emitter

/obj/projectile/beam/pointdefense
	name = "point defense salvo"
	icon_state = "laser"
	damage = 15
	damage_type = ELECTROCUTE //You should be safe inside a voidsuit
	sharp = FALSE //"Wide" spectrum beam
	light_color = "#A9980A"

	excavation_amount = 200 // Good at shooting rocks

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_omni
	hitscan_impact_type = /obj/effect/projectile/impact/laser_omni
