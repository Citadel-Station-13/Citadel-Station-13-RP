
/obj/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	damage_force = 0
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER
	eyeblur = 2
	impact_sound = null

/obj/projectile/beam/weaklaser
	name = "weak laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	damage_force = 15
	damage_tier = 3

/obj/projectile/beam/smalllaser
	damage_force = 25
	damage_tier = 3.25
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'

/obj/projectile/beam/burstlaser
	damage_force = 30
	damage_tier = 3.5
	fire_sound = 'sound/weapons/weaponsounds_lasermid.ogg'

/obj/projectile/beam/midlaser
	damage_force = 40
	damage_tier = 3.75
	fire_sound = 'sound/weapons/weaponsounds_lasermid.ogg'

/obj/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	damage_force = 60
	damage_tier = 4.5
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_heavy
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_heavy
	legacy_impact_type = /obj/effect/projectile/impact/laser_heavy

/obj/projectile/beam/heavylaser/fakeemitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	light_color = "#00CC33"
	excavation_amount = 140	// 2 shots to dig a standard rock turf. Superior due to being a mounted tool beam, to make it actually viable.

	legacy_muzzle_type = /obj/effect/projectile/muzzle/emitter
	legacy_tracer_type = /obj/effect/projectile/tracer/emitter
	legacy_impact_type = /obj/effect/projectile/impact/emitter

/obj/projectile/beam/heavylaser/cannon
	damage_force = 60
	damage_tier = 5
	light_color = "#FF0D00"

/obj/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage_force = 30
	damage_tier = 5
	light_color = "#00CC33"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/xray
	legacy_tracer_type = /obj/effect/projectile/tracer/xray
	legacy_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/gamma
	name = "gamma beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage_force = 10
	damage_tier = 6
	irradiate = 20
	light_color = "#00CC33"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/xray
	legacy_tracer_type = /obj/effect/projectile/tracer/xray
	legacy_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/cyan
	name = "cyan beam"
	icon_state = "cyan"
	fire_sound = 'sound/weapons/weaponsounds_alienlaser.ogg'
	damage_force = 40
	damage_tier = 4
	light_color = "#00C6FF"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/weak
	name = "weak cyan beam"
	icon_state = "cyan"
	fire_sound = 'sound/weapons/Dissolverray.ogg'
	damage_force = 20
	damage_tier = 2.75
	light_color = "#74b1c2"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/antigravbeamwraith
	name = "dark energy beam"
	icon_state = "darkb"
	fire_sound = 'sound/weapons/SuperHeavyLaser.ogg' //Knowers will recognize it
	damage_force = 30 //Targets energy armor which is kinda rare
	damage_type = DAMAGE_TYPE_BRUTE //Dark energy displaces instead of burning
	damage_flag = ARMOR_ENERGY
	irradiate= 5 //Scifi Antigrav bullshit side effect
	light_color = "#8902f0" //Purple

	legacy_muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	legacy_tracer_type = /obj/effect/projectile/tracer/darkmatter
	legacy_impact_type = /obj/effect/projectile/impact/darkmatter

/obj/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage_force = 40
	damage_tier = 5
	light_color = "#00CC33"
	excavation_amount = 70 // 3 shots to mine a turf

	legacy_muzzle_type = /obj/effect/projectile/muzzle/emitter
	legacy_tracer_type = /obj/effect/projectile/tracer/emitter
	legacy_impact_type = /obj/effect/projectile/impact/emitter

/obj/projectile/beam/lasertag
	name = "lasertag beam"
	damage_force = 0
	eyeblur = 0
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER

	combustion = FALSE

/obj/projectile/beam/lasertag/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_blue
	legacy_impact_type = /obj/effect/projectile/impact/laser_blue

/obj/projectile/beam/lasertag/blue/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.afflict_paralyze(1.5 SECONDS)

/obj/projectile/beam/lasertag/red
	icon_state = "laser"
	light_color = "#FF0D00"

/obj/projectile/beam/lasertag/red/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.afflict_paralyze(1.5 SECONDS)

/obj/projectile/beam/lasertag/omni//A laser tag bolt that stuns EVERYONE
	icon_state = "omnilaser"
	light_color = "#00C6FF"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/lasertag/omni/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.afflict_paralyze(1.5 SECONDS)

/obj/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	damage_force = 60
	damage_tier = 5
	light_color = "#00CC33"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/xray
	legacy_tracer_type = /obj/effect/projectile/tracer/xray
	legacy_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = TRUE
	damage_force = 0
	light_color = "#FFFFFF"

	combustion = FALSE

	legacy_muzzle_type = /obj/effect/projectile/muzzle/stun
	legacy_tracer_type = /obj/effect/projectile/tracer/stun
	legacy_impact_type = /obj/effect/projectile/impact/stun

	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_agony = 40;
		}
	)

/obj/projectile/beam/stun/weak
	name = "weak stun beam"
	icon_state = "stun"
	damage_inflict_agony = 27.5

/obj/projectile/beam/stun/med
	name = "stun beam"
	icon_state = "stun"
	damage_inflict_agony = 40

//Disabler Beams - It didn't feel right just to recolor Stun beams. We have uses for them still.
/obj/projectile/beam/disabler
	name = "disabler beam"
	icon_state = "lightning"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	damage_inflict_agony = 30
	damage_type = DAMAGE_TYPE_HALLOSS
	light_color = "#FFFFFF"

	combustion = FALSE

	legacy_muzzle_type = /obj/effect/projectile/muzzle/lightning
	legacy_tracer_type = /obj/effect/projectile/tracer/lightning
	legacy_impact_type = /obj/effect/projectile/impact/lightning
	impact_sound = null

/obj/projectile/beam/disabler/weak
	name = "weak disabler beam"
	icon_state = "lightning"
	damage_inflict_agony = 25

/obj/projectile/beam/disabler/strong
	name = "strong disabler beam"
	icon_state = "lightning"
	damage_inflict_agony = 40

/obj/projectile/beam/stun/disabler
	name = "disabler beam"
	icon_state = "stun"

	damage_inflict_agony = 20

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/stun/disabler/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(!(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT))
		return
	if(istype(target, /mob/living/silicon/robot) && prob(damage_inflict_agony))
		var/mob/living/silicon/robot/R = target
		var/drainamt = damage_inflict_agony * (rand(5, 15) / 10)
		// 100 to 300 drain
		R.drain_energy(DYNAMIC_CELL_UNITS_TO_KJ(drainamt * 10))
		if(istype(firer, /mob/living/silicon/robot)) // Mischevious sappers, the swarm drones are.
			var/mob/living/silicon/robot/A = firer
			A.cell?.give(drainamt * 2)

/obj/projectile/beam/shock
	name = "shock beam"
	icon_state = "lightning"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/lightning
	legacy_tracer_type = /obj/effect/projectile/tracer/lightning
	legacy_impact_type = /obj/effect/projectile/impact/lightning

	damage_force = 0
	eyeblur = 2

	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_energy = 100;
			shock_damage = 30;
			shock_agony = 15;
			shock_flags = ELECTROCUTE_ACT_FLAG_DISTRIBUTE;
		},
	)

/obj/projectile/beam/excavation
	name = "excavation beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	light_color = "#00CC33"
	damage_force = 1 //mining tool
	excavation_amount = 1000	// 1 shot to dig a standard rock turf. Made for mining. Should be able to consistently one hit rocks now

	legacy_muzzle_type = /obj/effect/projectile/muzzle/emitter
	legacy_tracer_type = /obj/effect/projectile/tracer/emitter
	legacy_impact_type = /obj/effect/projectile/impact/emitter

/obj/projectile/beam/pointdefense
	name = "point defense salvo"
	icon_state = "laser"
	damage_force = 15
	light_color = "#A9980A"

	excavation_amount = 200 // Good at shooting rocks

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni
