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
