//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general/cough

#warn impl
			// if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
			// 	message = "appears to cough!"
			// 	m_type = 1
			// else
			// 	if(!muzzled)
			// 		var/robotic = 0
			// 		m_type = 2
			// 		if(should_have_organ(O_LUNGS))
			// 			var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
			// 			if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
			// 				robotic = 1
			// 		if(!robotic)
			// 			message = "coughs!"
			// 			if(get_gender() == FEMALE)
			// 				if(species.female_cough_sounds)
			// 					playsound(src, pick(species.female_cough_sounds), 120)
			// 			else
			// 				if(species.male_cough_sounds)
			// 					playsound(src, pick(species.male_cough_sounds), 120)
			// 		else
			// 			message = "emits a robotic cough"
			// 			var/use_sound
			// 			if(get_gender() == FEMALE)
			// 				use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
			// 			else
			// 				use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
			// 			playsound(src.loc, use_sound, 50, 0)
			// 	else
			// 		message = "makes a strong noise."
			// 		m_type = 2
