/obj/item/melee/baton/slime
	name = "slimebaton"
	desc = "A modified stun baton designed to stun slimes and other lesser slimy xeno lifeforms for handling."
	icon_state = "slimebaton"
	item_state = "slimebaton"
	slot_flags = SLOT_BELT
	damage_force = 9
	active_color = "#33CCFF"
	origin_tech = list(TECH_COMBAT = 2, TECH_BIO = 2)
	description_info = "This baton will stun a slime or other slime-based lifeform for about five seconds, if hit with it while on."
	charge_cost = /obj/item/cell/device::maxcharge / 10
	stun_power = 10

	var/extra_slime_stun_power = 40
	var/extra_slime_stun_flags = ELECTROCUTE_ACT_FLAG_SILENT | ELECTROCUTE_ACT_FLAG_DISTRIBUTE

/obj/item/melee/baton/slime/apply_powered_melee_impact(atom/target, mob/attacker, datum/event_args/actor/actor, use_target_zone, efficiency)
	..()
	if(istype(target, /mob/living))
		var/mob/living/living_target = target
		var/mob/living/carbon/human/maybe_human = target
		if((living_target.mob_class & MOB_CLASS_SLIME) || (istype(maybe_human) && maybe_human.species?.get_species_id() == SPECIES_ID_PROMETHEAN))
			if(istype(living_target, /mob/living/simple_mob/slime))
				var/mob/living/simple_mob/slime/slime_target = living_target
				slime_target.slimebatoned(attacker, extra_slime_stun_power * 0.1)
			else
				living_target.electrocute(
					stun_power = extra_slime_stun_power,
					source = src,
					hit_zone = use_target_zone || BP_TORSO,
					flags = extra_slime_stun_flags,
				)

/obj/item/melee/baton/slime/loaded
	cell_type = /obj/item/cell/device

// Research borg's version
/obj/item/melee/baton/slime/robot
	charge_cost = 200
	legacy_use_external_power = TRUE

/datum/firemode/energy/xeno_taser
	name = "stun"
	cycle_cooldown = 0.4 SECONDS
	projectile_type = /obj/projectile/beam/stun/xeno
	charge_cost = 240

// Xeno stun gun + projectile
/obj/item/gun/projectile/energy/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. \
	While marketed towards handling slimes, it may be useful for other creatures."
	icon_state = "taserold"
	fire_sound = 'sound/weapons/taser2.ogg'
	charge_cost = 120 // Twice as many shots.
	no_pin_required = 1
	accuracy = 30 // Make it a bit easier to hit the slimes.
	description_info = "This gun will stun a slime or other lesser slimy lifeform for about two seconds, if hit with the projectile it fires."
	description_fluff = "An easy to use weapon designed by Nanotrasen, for Nanotrasen.  This weapon is designed to subdue lesser \
	slime-based xeno lifeforms at a distance.  It is ineffective at stunning non-slimy lifeforms such as humanoids."
	firemodes = list(
		/datum/firemode/energy/xeno_taser
	)

/obj/item/gun/projectile/energy/taser/xeno/robot // Borg version
	self_recharge = 1
	use_external_power = 1
	recharge_time = 3

/obj/item/gun/projectile/energy/taser/xeno/sec //NT's corner-cutting option for their on-station security.
	desc = "An NT Mk30 NL retrofitted to fire beams for subduing non-humanoid slimy xeno life forms."
	icon_state = "taserold"
	item_state = "taser"
	accuracy = 0 //Same accuracy as a normal Sec taser.
	description_fluff = "An NT Mk30 NL retrofitted after the events that occurred aboard the NRS Prometheus."

/obj/item/gun/projectile/energy/taser/xeno/sec/robot //Cyborg variant of the security xeno-taser.
	self_recharge = 1
	use_external_power = 1
	recharge_time = 3

/obj/projectile/beam/stun/xeno
	icon_state = "omni"
	damage_inflict_agony = 4
	nodamage = TRUE

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/stun/xeno/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(L.mob_class & MOB_CLASS_SLIME)
			if(isslime(L))
				var/mob/living/simple_mob/slime/S = L
				S.slimebatoned(firer, round(damage_inflict_agony/2))
			else
				L.afflict_paralyze(20 * round(damage_inflict_agony/2))

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.get_species_id() == SPECIES_ID_PROMETHEAN)
				if(damage_inflict_agony == initial(damage_inflict_agony)) // ??????
					damage_inflict_agony = round((14 * damage_inflict_agony) - damage_inflict_agony) //60-4 = 56, 56 / 4 = 14. Prior was flat 60 - agony of the beam to equate to 60.
