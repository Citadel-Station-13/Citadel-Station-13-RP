
/obj/vehicle_old/train/security

/obj/vehicle_old/train/security/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

//cargo trains are open topped, so there is a chance the projectile will hit the mob ridding the train instead
/obj/vehicle_old/train/security/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	if(has_buckled_mobs() && prob(70))
		var/mob/buckled = pick(buckled_mobs)
		return proj.impact_redirect(buckled, args)
	return ..()

/obj/vehicle_old/train/security/RunOver(var/mob/living/M)
	var/list/parts = list(BP_HEAD, BP_TORSO, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	M.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		M.apply_damage(rand(1,5), DAMAGE_TYPE_BRUTE, pick(parts))

/obj/item/key/security
	name = "The Security Cart key"
	desc = "The Security Cart Key used to start it."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "securikey"
	w_class = WEIGHT_CLASS_TINY
