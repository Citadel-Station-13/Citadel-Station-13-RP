//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* helpers / API for the resleeving module *//

/mob/living/carbon/human/resleeving_supports_mirrors()
	return TRUE

#warn put in chest

/mob/living/carbon/human/resleeving_create_mirror()
	#warn impl
	// var/obj/item/organ/internal/mirror/new_imp = new()
	// if(new_imp.handle_implant(occupant, BP_TORSO))
	// 	new_imp.post_implant(occupant)
		// if((client.prefs.organ_data[O_BRAIN] != null))
		// 	var/obj/item/organ/internal/mirror/positronic/F = new /obj/item/organ/internal/mirror/positronic(new_character)
		// 	F.handle_implant(new_character)
		// 	F.post_implant(new_character)
		// else
		// 	var/obj/item/organ/internal/mirror/E = new /obj/item/organ/internal/mirror(new_character)
		// 	E.handle_implant(new_character)
		// 	E.post_implant(new_character)

/mob/living/carbon/human/resleeving_get_mirror()
	#warn impl

/mob/living/carbon/human/resleeving_remove_mirror(atom/new_loc)
	#warn impl

	// if(target_zone == BP_TORSO && imp == null)
	// 	for(var/obj/item/organ/I in H.organs)
	// 		for(var/obj/item/organ/internal/mirror/MI in I.contents)
	// 			if(imp == null)
	// 				H.visible_message("<span class='warning'>[user] is attempting remove [H]'s mirror!</span>")
	// 				user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN)
	// 				user.do_attack_animation(H)
	// 				var/turf/T1 = get_turf(H)
	// 				if (T1 && ((H == user) || do_after(user, 20)))
	// 					if(user && H && (get_turf(H) == T1) && src)
	// 						H.visible_message("<span class='warning'>[user] has removed [H]'s mirror.</span>")
	// 						add_attack_logs(user,H,"Mirror removed by [user]")
	// 						src.imp = MI
	// 						qdel(MI)
	// else if (target_zone == BP_TORSO && imp != null)
	// 	if (imp)
	// 		H.visible_message("<span class='warning'>[user] is attempting to implant [H] with a mirror.</span>")
	// 		user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN)
	// 		user.do_attack_animation(H)
	// 		var/turf/T1 = get_turf(H)
	// 		if (T1 && ((H == user) || do_after(user, 20)))
	// 			if(user && H && (get_turf(H) == T1) && src && src.imp)
	// 				H.visible_message("<span class='warning'>[H] has been implanted by [user].</span>")
	// 				add_attack_logs(user,H,"Implanted with [imp.name] using [name]")
	// 				if(imp.handle_implant(H))
	// 					imp.post_implant(H)
	// 				src.imp = null
