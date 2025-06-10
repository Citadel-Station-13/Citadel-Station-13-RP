/**
 * Supertype of many different types of beams.
 *
 * * This is a type that should have no special behavior!
 *
 * todo: get rid of said special behavior, or just decide it's okay and keep it.
 */
/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/weaponsounds_rifleshot.ogg'
	damage_force = 60
	damage_type = DAMAGE_TYPE_BRUTE
	nodamage = 0
	damage_flag = ARMOR_BULLET
	embed_chance = 20	//Modified in the actual embed process, but this should keep embed chance about the same
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_PIERCE
	projectile_type = PROJECTILE_TYPE_KINETIC

	legacy_muzzle_type = /obj/effect/projectile/muzzle/bullet
	miss_sounds = list('sound/weapons/guns/miss1.ogg','sound/weapons/guns/miss2.ogg','sound/weapons/guns/miss3.ogg','sound/weapons/guns/miss4.ogg')
	ricochet_sounds = list('sound/weapons/guns/ricochet1.ogg', 'sound/weapons/guns/ricochet2.ogg',
							'sound/weapons/guns/ricochet3.ogg', 'sound/weapons/guns/ricochet4.ogg')
	impact_sound = PROJECTILE_IMPACT_SOUNDS_KINETIC

/obj/projectile/bullet/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	var/mob/living/L = target
	if(!istype(L))
		return
	shake_camera(L, 3, 2)

/obj/projectile/bullet/process_legacy_penetration(atom/A)
	var/chance = damage_force
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(damage_force/W.material_outer.density*1.8)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(damage_force/D.integrity_max*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100
	else if(ismob(A))
		chance = damage_force >= 20 && prob(damage_force)

	. = prob(chance)
	if(.)
		damage_force *= 0.7
