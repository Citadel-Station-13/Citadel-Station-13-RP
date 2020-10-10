//Overriding carbon move proc that forces default hunger factor. Merged from now-defunct Human life_vr.
/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			if(ishuman(src))
				var/mob/living/carbon/human/M = src
				if(M.stat != 2 && M.nutrition > 0)
					M.nutrition -= M.species.hunger_factor/10
					if(M.m_intent == "run")
						M.nutrition -= M.species.hunger_factor/10
					if(M.nutrition < 0)
						M.nutrition = 0
			else
				src.nutrition -= DEFAULT_HUNGER_FACTOR/10
				if(src.m_intent == "run")
					src.nutrition -= DEFAULT_HUNGER_FACTOR/10
		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++

/* VOREStation Removal - Needless duplicate feature
/mob/living/carbon/relaymove(var/mob/living/user, direction)
	if((user in src.stomach_contents) && istype(user))
		if(user.last_special <= world.time)
			user.last_special = world.time + 50
			src.visible_message("<span class='danger'>You hear something rumbling inside [src]'s stomach...</span>")
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/organ = H.get_organ(BP_TORSO)
					if (istype(organ))
						if(organ.take_damage(d, 0))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				user.visible_message("<span class='danger'>[user] attacks [src]'s stomach wall with the [I.name]!</span>")
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()
*/
