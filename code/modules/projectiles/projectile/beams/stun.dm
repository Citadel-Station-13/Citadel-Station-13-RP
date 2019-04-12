/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = TRUE
	taser_effect = TRUE
	agony = 35
	damage_type = HALLOSS
	light_color = "#FFFFFF"

	combustion = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/stun/weak
	name = "weak stun beam"
	icon_state = "stun"
	agony = 25

/obj/item/projectile/beam/stun/med
	name = "stun beam"
	icon_state = "stun"
	agony = 30

/obj/item/projectile/beam/disable
	projectile/beam/lasername = "disabler beam"
	icon_state = "omnilaser"
	nodamage = TRUE
	armor_flag = ARMOR_ENERGY
	agony = 15
	damage_type = HALLOSS
	light_color = "#00CECE"

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/stun/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue

/obj/item/projectile/beam/stun/xeno
	icon_state = "omni"
	agony = 4
	nodamage = TRUE
	// For whatever reason the projectile qdels itself early if this is on, meaning on_hit() won't be called on prometheans.
	// Probably for the best so that it doesn't harm the slime.
	taser_effect = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

	var/slime_agony = 40
	var/slimebaton_strength = 2
	var/slime_weaken = 2

/obj/item/projectile/beam/stun/xeno/weak //Weaker variant for non-research equipment, turrets, or rapid fire types.
	agony = 3
	var/slime_agony = 30
	var/slimebaton_strength = 1.5
	var/slime_weaken = 1.5

/obj/item/projectile/beam/stun/xeno/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	. = ..()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(L.mob_class & MOB_CLASS_SLIME)
			if(isslime(L))
				var/mob/living/simple_mob/slime/S = L
				S.slimebatoned(firer, slimebaton_strength)
			else
				L.Weaken(slime_weaken)

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.name == SPECIES_PROMETHEAN)
				agony = slime_agony							//WHY DOES THIS NOT DIRECTLY DO DAMAGE REFACTOR THIS LATER - KEV

/obj/item/projectile/beam/stun/darkmatter
	name = "dark matter wave"
	icon_state = "darkt"
	fire_sound = 'sound/weapons/eLuger.ogg'
	nodamage = TRUE
	taser_effect = TRUE
	agony = 55
	damage_type = HALLOSS
	light_color = "#8837A3"

	muzzle_type = /obj/effect/projectile/muzzle/darkmatterstun
	tracer_type = /obj/effect/projectile/tracer/darkmatterstun
	impact_type = /obj/effect/projectile/impact/darkmatterstun
