// Rod for railguns. Slightly less nasty than the sniper round.
/obj/projectile/bullet/magnetic
	name = "rod"
	icon_state = "rod"
	fire_sound = 'sound/weapons/railgun.ogg'
	damage_force = 65
	damage_tier = 4.75
	stun = 1
	weaken = 1
	legacy_penetrating = 5

/obj/projectile/bullet/magnetic/slug
	name = "slug"
	icon_state = "gauss_silenced"
	damage_force = 75
	damage_tier = 5.25

/obj/projectile/bullet/magnetic/flechette
	name = "flechette"
	icon_state = "flechette"
	fire_sound = 'sound/weapons/rapidslice.ogg'
	damage_force = 20
	damage_tier = 6

/obj/projectile/bullet/magnetic/flechette/hunting
	name = "shredder slug"
	damage_tier = 4.5
	SA_bonus_damage = 40
	SA_vulnerability = SA_ANIMAL

/obj/projectile/bullet/magnetic/heated
	name = "slug"
	icon_state = "gauss"
	weaken = 0
	stun = 0
	damage_force = 30
	damage_type = DAMAGE_TYPE_SEARING
	embed_chance = 0

/obj/projectile/bullet/magnetic/heated/weak
	icon_state = "gauss_silenced"
	damage_force = 15
	damage_inflict_agony = 5
	embed_chance = 0
	damage_tier = 4.25

/obj/projectile/bullet/magnetic/fuelrod
	name = "fuel rod"
	icon_state = "fuel-deuterium"
	damage_force = 70 //it's a fusion fuel rod propelled faster than sound, it should hurt.
	stun = 1
	weaken = 0
	damage_inflict_agony = 50
	incendiary = 1
	flammability = 0 //Deuterium and Tritium are both held in water, but the object moving so quickly will ignite the target.
	legacy_penetrating = 2
	embed_chance = 0
	damage_tier = 4.75
	range = WORLD_ICON_SIZE * 20

	var/searing = 0 //Does this fuelrod ignore shields?
	var/detonate_travel = 0 //Will this fuelrod explode when it reaches maximum distance?
	var/detonate_mob = 0 //Will this fuelrod explode when it hits a mob?
	var/energetic_impact = 0 //Does this fuelrod cause a bright flash on impact with a mob?

/obj/projectile/bullet/magnetic/fuelrod/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(searing)
		efficiency = max(efficiency, 1)
	if(. & PROJECTILE_IMPACT_BLOCKED)
		return

	if(istype(target,/mob/living))
		var/mob/living/V = target
		if(detonate_mob)
			if(V.loc)
				explosion(V.loc, -1, -1, 2, 3)

		if(energetic_impact)
			var/eye_coverage = 0
			for(var/mob/living/carbon/M in viewers(world.view, get_turf(src)))
				eye_coverage = 0
				if(iscarbon(M))
					eye_coverage = M.eyecheck()
				if(eye_coverage < 2)
					M.flash_eyes()
					M.afflict_stun(20 * 2)
					M.afflict_paralyze(20 * 10)

	// what the fuck??
	if(src.loc)
		if(detonate_travel && detonate_mob)
			visible_message("<span class='warning'>\The [src] shatters in a violent explosion!</span>")
			explosion(src.loc, 0, 1, 3, 4)
		else if(detonate_travel)
			visible_message("<span class='warning'>\The [src] explodes in a shower of embers!</span>")
			explosion(src.loc, 0, 1, 2, 3)

/obj/projectile/bullet/magnetic/fuelrod/tritium
	icon_state = "fuel-tritium"
	damage_force = 100 //Much harder to get than tritium - needs mhydrogen
	flammability = -1
	damage_tier = 4.5
	legacy_penetrating = 3

/obj/projectile/bullet/magnetic/fuelrod/phoron
	name = "blazing fuel rod"
	icon_state = "fuel-phoron"
	damage_force = 65 //leaves a trail of fire, irradiates and is much easier to get than the other two, so less damage is fine
	incendiary = 2
	flammability = 2
	damage_tier = 4.75
	legacy_penetrating = 5
	irradiate = 20
	detonate_mob = 1

/obj/projectile/bullet/magnetic/fuelrod/supermatter
	name = "painfully incandescent fuel rod"
	icon_state = "fuel-supermatter"
	damage_force = 15 //it qdels things
	incendiary = 2
	flammability = 4
	weaken = 2
	damage_tier = 10 // goodbye
	legacy_penetrating = 100 //Theoretically, this shouldn't stop flying for a while, unless someone lines it up with a wall or fires it into a mountain.
	irradiate = 120
	range = WORLD_ICON_SIZE * 75
	searing = 1
	detonate_travel = 1
	detonate_mob = 1
	energetic_impact = 1

/obj/projectile/bullet/magnetic/fuelrod/supermatter/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(istype(target,/turf/simulated/wall) || istype(target,/mob/living))
		target.visible_message("<span class='danger'>The [src] burns a perfect hole through \the [target] with a blinding flash!</span>")
		playsound(target.loc, 'sound/effects/teleport.ogg', 40, 0)

/obj/projectile/bullet/magnetic/fuelrod/supermatter/pre_impact(atom/target, impact_flags, def_zone)
	return ..() | PROJECTILE_IMPACT_PIERCE

/obj/projectile/bullet/magnetic/bore
	name = "phorogenic blast"
	icon_state = "purpleemitter"
	damage_force = 20
	incendiary = 1
	damage_tier = 4
	legacy_penetrating = 0
	damage_flag = ARMOR_MELEE
	irradiate = 20
	range = WORLD_ICON_SIZE * 6

/obj/projectile/bullet/magnetic/bore/pre_impact(atom/target, impact_flags, def_zone)
	if(istype(target, /turf/simulated/mineral))
		return PROJECTILE_IMPACT_PIERCE | impact_flags
	return ..()

/obj/projectile/bullet/magnetic/bore/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(istype(target, /turf/simulated/mineral))
		var/turf/simulated/mineral/MI = target
		MI.GetDrilled(TRUE)
	else if(istype(target, /turf/simulated/wall) || istype(target, /turf/simulated/shuttle/wall))
		explosion(target, 0, 0, 1, 3)
		. |= PROJECTILE_IMPACT_DELETE

/obj/projectile/bullet/magnetic/bore/powerful
	name = "energetic phorogenic blast"
	icon_state = "purpleemitter"
	damage_force = 30
	incendiary = 2
	damage_tier = 4.25
	legacy_penetrating = 0
	damage_flag = ARMOR_MELEE
	irradiate = 20
	range = WORLD_ICON_SIZE * 12
