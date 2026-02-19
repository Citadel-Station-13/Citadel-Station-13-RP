
/obj/vehicle_old/train/rover/RunOver(var/mob/living/M)
	var/list/parts = list(BP_HEAD, BP_TORSO, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	M.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		M.apply_damage(rand(1,5), DAMAGE_TYPE_BRUTE, pick(parts))

/obj/item/key/rover
	name = "The Rover key"
	desc = "The Rover key used to start it."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "securikey"
	w_class = WEIGHT_CLASS_TINY
