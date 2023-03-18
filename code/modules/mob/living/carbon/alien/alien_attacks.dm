//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/L = user
	if(!istype(L))
		return

	switch(L.a_intent)

		if (INTENT_HELP)
			help_shake_act(L)

		if (INTENT_GRAB)
			if (L == src)
				return
			var/obj/item/grab/G = new /obj/item/grab( L, src )

			L.put_in_active_hand(G)

			grabbed_by += G
			G.affecting = src
			G.synch()

			LAssailant = L

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("<font color='red'>[] has grabbed [] passively!</font>", L, src), 1)

		else
			var/damage = rand(1, 9)
			if (prob(90))
				if (MUTATION_HULK in L.mutations)
					damage += 5
					spawn(0)
						Unconscious(1)
						step_away(src,L,15)
						sleep(3)
						step_away(src,L,15)
				playsound(loc, "punch", 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<font color='red'><B>[] has punched []!</B></font>", L, src), 1)
				if (damage > 4.9)
					afflict_knockdown(20 * rand(10,15))
					for(var/mob/O in viewers(L, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("<font color='red'><B>[] has weakened []!</B></font>", L, src), 1, "<font color='red'>You hear someone fall.</font>", 2)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<font color='red'><B>[] has attempted to punch []!</B></font>", L, src), 1)
	return
