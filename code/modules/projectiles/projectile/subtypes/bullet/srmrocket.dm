

/obj/projectile/bullet/srmrocket
	name ="SRM-8 Rocket"
	desc = "Boom"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	damage_force = 30	//Meaty whack. *Chuckles*
	movable_flags = MOVABLE_NO_THROW_SPIN | MOVABLE_NO_THROW_DAMAGE_SCALING | MOVABLE_NO_THROW_SPEED_SCALING

/obj/projectile/bullet/srmrocket/on_impact(atom/target, impact_flags, def_zone, efficiency)
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4)
	else
		explosion(target, 0, 0, 2, 4)
	return PROJECTILE_IMPACT_DELETE

/obj/projectile/bullet/srmrocket/weak	//Used in the jury rigged one.
	damage_force = 10

/obj/projectile/bullet/srmrocket/weak/on_impact(atom/target, impact_flags, def_zone, efficiency)
	explosion(target, 0, 0, 2, 4)//No need to have a question.
	return PROJECTILE_IMPACT_DELETE
