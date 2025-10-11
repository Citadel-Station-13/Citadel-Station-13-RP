//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general/sneeze

#warn impl

		// if("sneeze", "sneezes")
		// 	if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
		// 		message = "sneezes."
		// 		m_type = 1
		// 	else
		// 		if(!muzzled)
		// 			var/robotic = 0
		// 			m_type = 2
		// 			if(should_have_organ(O_LUNGS))
		// 				var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
		// 				if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
		// 					robotic = 1
		// 			if(!robotic)
		// 				message = "sneezes."
		// 				if(get_gender() == FEMALE)
		// 					playsound(src, species.female_sneeze_sound, 70)
		// 				else
		// 					playsound(src, species.male_sneeze_sound, 70)
		// 				m_type = 2
		// 			else
		// 				message = "emits a robotic sneeze"
		// 				var/use_sound
		// 				if(get_gender() == FEMALE)
		// 					use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
		// 				else
		// 					use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'
		// 				playsound(src.loc, use_sound, 50, 0)
		// 		else
		// 			message = "makes a strange noise."
		// 			m_type = 2
