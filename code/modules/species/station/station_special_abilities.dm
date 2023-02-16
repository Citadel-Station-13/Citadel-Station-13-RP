/mob/living/carbon/human/proc/reconstitute_form() //Scree's race ability.in exchange for: No cloning.
	set name = "Reconstitute Form"
	set category = "Abilities"

	// Sanity is mostly handled in chimera_regenerate()

	var/confirm = alert(usr, "Are you sure you want to completely reconstruct your form? This process can take up to twenty minutes, depending on how hungry you are, and you will be unable to move.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		chimera_regenerate()

/mob/living/carbon/human/proc/chimera_regenerate()
	//If they're already regenerating
	switch(revive_ready)
		if(REVIVING_NOW)
			to_chat(src, "You are already reconstructing, just wait for the reconstruction to finish!")
			return
		if(REVIVING_DONE)
			to_chat(src, "Your reconstruction is done, but you need to hatch now.")
			return
	if(revive_ready > world.time)
		to_chat(src, "You can't use that ability again so soon!")
		return

	var/nutrition_used = nutrition * 0.5
	var/time = (240+960/(1 + nutrition_used/75))

	//Clicked regen while dead.
	if(stat == DEAD)

		//Has nutrition and dead, allow regen.
		if(hasnutriment())
			to_chat(src, "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds.")

			//Scary spawnerization.
			revive_ready = REVIVING_NOW
			spawn(time SECONDS)
				// Was dead, now not dead.
				if(stat != DEAD)
					to_chat(src, "<span class='notice'>Your body has recovered from its ordeal, ready to regenerate itself again.</span>")
					revive_ready = REVIVING_READY //reset their cooldown

				// Was dead, still dead.
				else
					to_chat(src, "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch.</span>")
					add_verb(src, /mob/living/carbon/human/proc/hatch)
					revive_ready = REVIVING_DONE

		//Dead until nutrition injected.
		else
			to_chat(src, "<span class='warning'>Your body is too damaged to regenerate without additional nutrients to feed what few living cells remain.</span>")

	//Clicked regen while NOT dead
	else
		to_chat(src, "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds.")

		//Waiting for regen after being alive
		revive_ready = REVIVING_NOW
		spawn(time SECONDS)

			//If they're still alive after regenning.
			if(stat != DEAD)
				to_chat(src, "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>")
				add_verb(src, /mob/living/carbon/human/proc/hatch)
				revive_ready = REVIVING_DONE

			//Was alive, now dead
			else if(hasnutriment())
				to_chat(src, "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>")
				add_verb(src, /mob/living/carbon/human/proc/hatch)
				revive_ready = REVIVING_DONE

			//Dead until nutrition injected.
			else
				to_chat(src, "<span class='warning'>Your body was unable to regenerate, what few living cells remain require additional nutrients to complete the process.</span>")
				revive_ready = REVIVING_READY //reset their cooldown

/mob/living/carbon/human/proc/hasnutriment()
	return (nutrition+ bloodstr.get_reagent("protein") * 10 + bloodstr.get_reagent("nutriment") * 5 + ingested.get_reagent("protein") * 5 + ingested.get_reagent("nutriment") * 2.5) > 425


/mob/living/carbon/human/proc/hatch()
	set name = "Hatch"
	set category = "Abilities"

	if(revive_ready != REVIVING_DONE)
		//Hwhat?
		remove_verb(src, /mob/living/carbon/human/proc/hatch)
		return

	var/confirm = alert(usr, "Are you sure you want to hatch right now? This will be very obvious to anyone in view.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")

		//Dead when hatching
		if(stat == DEAD)
			chimera_hatch()
			adjustBrainLoss(10) // if they're reviving from dead, they come back with 10 brainloss on top of whatever's unhealed.
			visible_message("<span class='danger'><p><font size=4>The lifeless husk of [src] bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") //Bloody hell...
			return

		//Alive when hatching
		else
			chimera_hatch()
			visible_message("<span class='danger'><p><font size=4>The dormant husk of [src] bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") //Bloody hell...

/mob/living/carbon/human/proc/chimera_hatch()
	remove_verb(src, /mob/living/carbon/human/proc/hatch)
	to_chat(src, "<span class='notice'>Your new body awakens, bursting free from your old skin.</span>")

	//Modify and record values (half nutrition and braindamage)
	var/old_nutrition = nutrition * 0.5
	var/braindamage = (brainloss * 0.5) //Can only heal half brain damage.

	//I did have special snowflake code, but this is easier.
	revive()
	mutations.Remove(MUTATION_HUSK)
	nutrition = old_nutrition
	setBrainLoss(braindamage)

	//Drop everything
	drop_inventory(TRUE, TRUE, TRUE)

	//Unfreeze some things
	does_not_breathe = FALSE
	update_canmove()
	weakened = 2

	//Visual effects
	var/T = get_turf(src)
	new /obj/effect/gibspawner/human/xenochimera(T)

	revive_ready = world.time + 1 HOUR //set the cooldown

/mob/living/carbon/human/proc/revivingreset() // keep this as a debug proc or potential future use
		revive_ready = REVIVING_READY

/obj/effect/gibspawner/human/xenochimera
	fleshcolor = "#14AD8B"
	bloodcolor = "#14AD8B"

/mob/living/carbon/human/proc/getlightlevel() //easier than having the same code in like three places
	if(isturf(src.loc)) //else, there's considered to be no light
		var/turf/T = src.loc
		return T.get_lumcount() * 5
	else return 0

/mob/living/carbon/human/proc/handle_feral()
	if(handling_hal) return
	handling_hal = 1

	if(client && feral >= 10) // largely a copy of handle_hallucinations() without the fake attackers. Unlike hallucinations, only fires once - if they're still feral they'll get hit again anyway.
		spawn(rand(200,500)/(feral/10))
			if(!feral) return //just to avoid fuckery in the event that they un-feral in the time it takes for the spawn to proc
			var/halpick = rand(1,100)
			switch(halpick)
				if(0 to 15) //15% chance
					//Screwy HUD
					//to_chat(src, "Screwy HUD")
					hal_screwyhud = pick(1,2,3,3,4,4)
					spawn(rand(100,250))
						hal_screwyhud = 0
				if(16 to 25) //10% chance
					//Strange items
					//to_chat(src, "Traitor Items")
					if(!halitem)
						halitem = new
						var/list/slots_free = list(ui_lhand,ui_rhand)
						if(l_hand) slots_free -= ui_lhand
						if(r_hand) slots_free -= ui_rhand
						if(istype(src,/mob/living/carbon/human))
							var/mob/living/carbon/human/H = src
							if(!H.belt) slots_free += ui_belt
							if(!H.l_store) slots_free += ui_storage1
							if(!H.r_store) slots_free += ui_storage2
						if(slots_free.len)
							halitem.screen_loc = pick(slots_free)
							halitem.layer = 50
							switch(rand(1,6))
								if(1) //revolver
									halitem.icon = 'icons/obj/gun/ballistic.dmi'
									halitem.icon_state = "revolver"
									halitem.name = "Revolver"
								if(2) //c4
									halitem.icon = 'icons/obj/assemblies.dmi'
									halitem.icon_state = "plastic-explosive0"
									halitem.name = "Mysterious Package"
									if(prob(25))
										halitem.icon_state = "c4small_1"
								if(3) //sword
									halitem.icon = 'icons/obj/weapons.dmi'
									halitem.icon_state = "sword1"
									halitem.name = "Sword"
								if(4) //stun baton
									halitem.icon = 'icons/obj/weapons.dmi'
									halitem.icon_state = "stunbaton"
									halitem.name = "Stun Baton"
								if(5) //emag
									halitem.icon = 'icons/obj/card.dmi'
									halitem.icon_state = "emag"
									halitem.name = "Cryptographic Sequencer"
								if(6) //flashbang
									halitem.icon = 'icons/obj/grenade.dmi'
									halitem.icon_state = "flashbang1"
									halitem.name = "Flashbang"
							if(client) client.screen += halitem
							spawn(rand(100,250))
								if(client)
									client.screen -= halitem
								halitem = null
				if(26 to 35) //10% chance
					//Flashes of danger
					//to_chat(src, "Danger Flash")
					if(!halimage)
						var/list/possible_points = list()
						for(var/turf/simulated/floor/F in view(src,world.view))
							possible_points += F
						if(possible_points.len)
							var/turf/simulated/floor/target = pick(possible_points)

							switch(rand(1,3))
								if(1)
									//to_chat(src, "Space")
									halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
								if(2)
									//to_chat(src, "Fire")
									halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
								if(3)
									//to_chat(src, "C4")
									halimage = image('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


							if(client) client.images += halimage
							spawn(rand(10,50)) //Only seen for a brief moment.
								if(client) client.images -= halimage
								halimage = null

				if(36 to 55) //20% chance
					//Strange audio
					//to_chat(src, "Strange Audio")
					switch(rand(1,12))
						if(1) SEND_SOUND(src, sound('sound/machines/airlock.ogg'))
						if(2)
							if(prob(50))SEND_SOUND(src, sound('sound/soundbytes/effects/explosion/explosion1.ogg'))
							else SEND_SOUND(src, sound('sound/soundbytes/effects/explosion/explosion2.ogg'))
						if(3) SEND_SOUND(src, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
						if(4) SEND_SOUND(src, sound('sound/effects/Glassbr1.ogg'))
						if(5) SEND_SOUND(src, sound('sound/effects/Glassbr2.ogg'))
						if(6) SEND_SOUND(src, sound('sound/effects/Glassbr3.ogg'))
						if(7) SEND_SOUND(src, sound('sound/machines/twobeep.ogg'))
						if(8) SEND_SOUND(src, sound('sound/machines/windowdoor.ogg'))
						if(9)
							//To make it more realistic, I added two gunshots (enough to kill)
							SEND_SOUND(src, sound('sound/weapons/Gunshot1.ogg'))
							spawn(rand(10,30))
								SEND_SOUND(src, sound('sound/weapons/Gunshot2.ogg'))
						if(10) SEND_SOUND(src, sound('sound/weapons/smash.ogg'))
						if(11)
							//Same as above, but with tasers.
							SEND_SOUND(src, sound('sound/weapons/Taser.ogg'))
							spawn(rand(10,30))
								SEND_SOUND(src, sound('sound/weapons/Taser.ogg'))
					//Rare audio
						if(12)
	//These sounds are (mostly) taken from Hidden: Source
							var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
								'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
								'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
								'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
								'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
							SEND_SOUND(src, pick(creepyasssounds))
				if(56 to 60) //5% chance
					//Flashes of danger
					//to_chat(src, "Danger Flash")
					if(!halbody)
						var/list/possible_points = list()
						for(var/turf/simulated/floor/F in view(src,world.view))
							possible_points += F
						if(possible_points.len)
							var/turf/simulated/floor/target = pick(possible_points)
							switch(rand(1,4))
								if(1)
									halbody = image('icons/mob/human.dmi',target,"husk_l",TURF_LAYER)
								if(2,3)
									halbody = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
								if(4)
									halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)
		//						if(5)
		//							halbody = image('xcomalien.dmi',target,"chryssalid",TURF_LAYER)

							if(client) client.images += halbody
							spawn(rand(50,80)) //Only seen for a brief moment.
								if(client) client.images -= halbody
								halbody = null
				if(61 to 85) //25% chance
					//food
					if(!halbody)
						var/list/possible_points = list()
						for(var/turf/simulated/floor/F in view(src,world.view))
							possible_points += F
						if(possible_points.len)
							var/turf/simulated/floor/target = pick(possible_points)
							switch(rand(1,10))
								if(1)
									halbody = image('icons/mob/animal.dmi',target,"cow",TURF_LAYER)
								if(2)
									halbody = image('icons/mob/animal.dmi',target,"chicken",TURF_LAYER)
								if(3)
									halbody = image('icons/obj/food.dmi',target,"bigbiteburger",TURF_LAYER)
								if(4)
									halbody = image('icons/obj/food.dmi',target,"meatbreadslice",TURF_LAYER)
								if(5)
									halbody = image('icons/obj/food.dmi',target,"sausage",TURF_LAYER)
								if(6)
									halbody = image('icons/obj/food.dmi',target,"bearmeat",TURF_LAYER)
								if(7)
									halbody = image('icons/obj/food.dmi',target,"fishfillet",TURF_LAYER)
								if(8)
									halbody = image('icons/obj/food.dmi',target,"meat",TURF_LAYER)
								if(9)
									halbody = image('icons/obj/food.dmi',target,"meatstake",TURF_LAYER)
								if(10)
									halbody = image('icons/obj/food.dmi',target,"monkeysdelight",TURF_LAYER)

							if(client) client.images += halbody
							spawn(rand(50,80)) //Only seen for a brief moment.
								if(client) client.images -= halbody
								halbody = null
				if(86 to 100) //15% chance
					//hear voices. Could make the voice pick from nearby creatures, but nearby creatures make feral hallucinations rare so don't bother.
					var/list/hiddenspeakers = list("Someone distant", "A voice nearby","A familiar voice", "An echoing voice", "A cautious voice", "A scared voice", "Someone around the corner", "Someone", "Something", "Something scary", "An urgent voice", "An angry voice")
					var/list/speakerverbs = list("calls out", "yells", "screams", "exclaims", "shrieks", "shouts", "hisses", "snarls")
					var/list/spookyphrases = list("It's over here!","Stop it!", "Hunt it down!", "Get it!", "Quick, over here!", "Anyone there?", "Who's there?", "Catch that thing!", "Stop it! Kill it!", "Anyone there?", "Where is it?", "Find it!", "There it is!")
					to_chat(src, "<span class='game say'><span class='name'>[pick(hiddenspeakers)]</span> [pick(speakerverbs)], \"[pick(spookyphrases)]\"</span>")


	handling_hal = 0
	return


/mob/living/carbon/human/proc/bloodsuck()
	set name = "Partially Drain prey of blood"
	set desc = "Bites prey and drains them of a significant portion of blood, feeding you in the process. You may only do this once per minute."
	set category = "Abilities"

	/*if(last_special > world.time)
		return*/

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot bite anyone in your current state!")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(istype(M,/mob/living) && Adjacent(M))
			choices += M
			choices -= src

	var/mob/living/B = input(src,"Who do you wish to bite?") as null|anything in choices

	if(!B || !src || src.stat == DEAD) return

	if(!Adjacent(B)) return

	//if(last_special > world.time) return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot bite in your current state.")
		return

	last_special = world.time + 600
	src.visible_message("<font color='red'><b>[src] leans in close to [B]...</b></font>")
	B.add_fingerprint(src)
	add_attack_logs(src,B,"used bloodsuck() on [B]")
	if(istype(B,/mob/living/carbon/human) && istype(src,/mob/living/carbon))
		if(do_after(src, 50, B)) //Five seconds seems best
			if(!Adjacent(B)) return
			if(!src.isSynthetic())
				src.visible_message("<font color='red'><b>[src] suddenly extends their fangs and sinks them into [B]'s neck!</b></font>")
			else
				src.visible_message("<font color='red'><b>[src] suddenly bites [B]!</b></font>")
			sleep(25)
			if(!src.isSynthetic())
				to_chat(B, "<span class='danger'>You feel light headed as your blood is being drained!</span>")
			else
				to_chat(B, "<span class='danger'>Your sensors flare wildly as your power is being drained!</span>")
			var/mob/living/carbon/human/H = B
			H.drip(80) //Remove enough blood to make them a bit woozy, but not take oxyloss.
			sleep(50)
			H.drip(1)
			sleep(50)
			H.drip(1)

			//if(!B.bitten) // first time biting them
			src.nutrition += 400 //Commented out code to do with "B.bitten" in an attempt to rebalance vampires on a whole. Vampires now are more efficient
			B.nutrition -= 200
			//else
				//src.nutrition += 150 // halves our reward if we've already fed on this person before
				//B.nutrition -= 75
			if(src.nutrition > 901) //prevent going into the fat ranges of nutrition needlessly and prevents minmaxing certain racial traits/abilities that rely on nutrition via farming one victim
				src.nutrition = 900
			if(B.nutrition < 100)
				B.apply_damage(15, BRUTE, BP_TORSO) // if they have nothing to give, this just harms them
			B.bitten = 1 //debuff tracking for balance
	else if(!istype(B,/mob/living/carbon) && src.isSynthetic() || istype(B,/mob/living/carbon) && B.isSynthetic() && src.isSynthetic()) // for synths to feed on robots and other synths
		if(do_after(src, 50, B))
			if(!Adjacent(B)) return
			src.visible_message("<font color='red'><b>[src] suddenly lunges at [B]!</b></font>")
			if(B.nutrition > 100)
				src.nutrition += 300
				B.nutrition -= 150
			if(B.nutrition < 100)
				B.apply_damage(15, BRUTE, BP_TORSO)
	else if(istype(B,/mob/living/silicon) && !istype(src,/mob/living/silicon))
		if(do_after(src, 50, B))
			to_chat(src, "You don't sense any viable blood...")


//Welcome to the adapted changeling absorb code.
/mob/living/carbon/human/proc/succubus_drain()
	set name = "Drain prey of nutrition"
	set desc = "Slowly drain prey of all the nutrition in their body, feeding you in the process. You may only do this to one person at a time."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/mob/living/carbon/human/C = src
	var/obj/item/grab/G = src.get_active_held_item()
	if(!istype(G))
		to_chat(C, "<span class='warning'>You must be grabbing a creature in your active hand to absorb them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T)) // Allows for synths to be drained solargrub style
		to_chat(src, "<span class='warning'>\The [T] is not able to be drained.</span>")
		return

	if(G.state != GRAB_NECK)
		to_chat(C, "<span class='warning'>You must have a tighter grip to drain this creature.</span>")
		return

	if(C.absorbing_prey)
		to_chat(C, "<span class='warning'>You are already draining someone!</span>")
		return

	C.absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				if(T.isSynthetic())
					to_chat(C, "<span class='notice'>You begin to siphon power out of [T]...</span>")
					to_chat(T, "<span class='danger'>Various sensors and alarms flare as [C] begins to drain your power!</span>")
				else
					to_chat(C, "<span class='notice'>You begin to drain [T]...</span>")
					to_chat(T, "<span class='danger'>An odd sensation flows through your body as [C] begins to drain you!</span>")
				C.nutrition = (C.nutrition + (T.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				T.nutrition = T.nutrition*0.95
			if(2)
				if(C.isSynthetic())
					to_chat(C, "<span class='notice'>You feel energized with every passing moment of draining [T].</span>")
				else
					to_chat(C, "<span class='notice'>You feel stronger with every passing moment of draining [T].</span>")
				src.visible_message("<span class='danger'>[C] seems to be doing something to [T], resulting in [T]'s body looking weaker with every passing moment!</span>")
				if(T.isSynthetic())
					to_chat(T, "<span class='danger'>You feel weak as power drains from your mechanisms to [C]!</span>")
				else
					to_chat(T, "<span class='danger'>You feel weaker with every passing moment as [C] drains you!</span>")
				C.nutrition = (C.nutrition + (T.nutrition*0.1))
				T.nutrition = T.nutrition*0.9
			if(3 to 99)
				C.nutrition = (C.nutrition + (T.nutrition*0.1)) //Just keep draining them.
				T.nutrition = T.nutrition*0.9
				T.eye_blurry += 5 //Some eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done.
				if(T.nutrition < 100 && stage < 99 && C.drain_finalized == 1)//Did they drop below 100 nutrition? If so, immediately jump to stage 99 so it can advance to 100.
					stage = 99
				if(C.drain_finalized != 1 && stage == 99) //Are they not finalizing and the stage hit 100? If so, go back to stage 3 until they finalize it.
					stage = 3
			if(100)
				C.nutrition = (C.nutrition + T.nutrition)
				T.nutrition = 0 //Completely drained of everything.
				var/damage_to_be_applied = T.species.total_health //Get their max health.
				T.apply_damage(damage_to_be_applied, HALLOSS) //Knock em out.
				C.absorbing_prey = 0
				if(T.isSynthetic())
					to_chat(C, "<span class='notice'>You have siphoned the power out of [T], causing them to crumple on the floor.</span>")
					to_chat(T, "<span class='danger'>You feel powerless as all the power in your mechanisms has been drained by [C]!</span>")
				else
					to_chat(C, "<span class='notice'>You have completely drained [T], causing them to pass out.</span>")
					to_chat(T, "<span class='danger'>You feel weak, as if you have no control over your body whatsoever as [C] finishes draining you.!</span>")
				add_attack_logs(C,T,"Succubus drained")
				return

		if(!do_mob(src, T, 50) || G.state != GRAB_NECK) //One drain tick every 5 seconds.
			to_chat(src, "<span class='warning'>Your draining of [T] has been interrupted!</span>")
			C.absorbing_prey = 0
			return

/mob/living/carbon/human/proc/succubus_drain_lethal()
	set name = "Lethally drain prey" //Provide a warning that THIS WILL KILL YOUR PREY.
	set desc = "Slowly drain prey of all the nutrition in their body, feeding you in the process. Once prey run out of nutrition, you will begin to drain them lethally. You may only do this to one person at a time."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

	var/obj/item/grab/G = src.get_active_held_item()
	if(!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a creature in your active hand to drain them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T))
		to_chat(src, "<span class='warning'>\The [T] is not able to be drained.</span>")
		return

	if(G.state != GRAB_NECK)
		to_chat(src, "<span class='warning'>You must have a tighter grip to drain this creature.</span>")
		return

	if(absorbing_prey)
		to_chat(src, "<span class='warning'>You are already draining someone!</span>")
		return

	absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				if(T.stat == DEAD)
					to_chat(src, "<span class='warning'>[T] is dead and can not be drained..</span>")
					return
				if(T.isSynthetic())
					to_chat(src, "<span class='notice'>You begin to siphon power out of [T]...</span>")
					to_chat(T, "<span class='danger'>Various sensors and alarms flare as [src] begins to drain your power!</span>")
				else
					to_chat(src, "<span class='notice'>You begin to drain [T]...</span>")
					to_chat(T, "<span class='danger'>An odd sensation flows through your body as [src] begins to drain you!</span>")
				nutrition = (nutrition + (T.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				T.nutrition = T.nutrition*0.95
			if(2)
				if(src.isSynthetic())
					to_chat(src, "<span class='notice'>You feel energized with every passing moment of draining [T].</span>")
				else
					to_chat(src, "<span class='notice'>You feel stronger with every passing moment of draining [T].</span>")
				src.visible_message("<span class='danger'>[src] seems to be doing something to [T], resulting in [T]'s body looking weaker with every passing moment!</span>")
				if(T.isSynthetic())
					to_chat(T, "<span class='danger'>You feel weak as power drains from your mechanisms to [src]!</span>")
				else
					to_chat(T, "<span class='danger'>You feel weaker with every passing moment as [src] drains you!</span>")
				nutrition = (nutrition + (T.nutrition*0.1))
				T.nutrition = T.nutrition*0.9
			if(3 to 48) //Should be more than enough to get under 100.
				nutrition = (nutrition + (T.nutrition*0.1)) //Just keep draining them.
				T.nutrition = T.nutrition*0.9
				T.eye_blurry += 5 //Some eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done.
				if(T.nutrition < 100)//Did they drop below 100 nutrition? If so, do one last check then jump to stage 50 (Lethal!)
					stage = 49
			if(49)
				if(T.nutrition < 100)//Did they somehow not get drained below 100 nutrition yet? If not, go back to stage 3 and repeat until they get drained.
					stage = 3 //Otherwise, advance to stage 50 (Lethal draining.)
			if(50)
				if(!T.digestable)
					if(T.isSynthetic())
						to_chat(src, "<span class='notice'>You have siphoned the power out of [T], causing them to crumple on the floor, but feel a sudden stop in power flow, cutting you off from the source.</span>")
						to_chat(T, "<span class='danger'>You feel utterly powerless as all the power in your mechanisms has been drained by [src], but safeguards kick in, preventing them from completely draining you!</span>")
					else
						to_chat(src, "<span class='danger'>You feel invigorated as you completely drain [T] and begin to move onto draining them lethally before realizing they are too strong for you to do so!</span>")
						to_chat(T, "<span class='danger'>You feel completely drained as [src] finishes draining you and begins to move onto draining you lethally, but you are too strong for them to do so!</span>")
					nutrition = (nutrition + T.nutrition)
					T.nutrition = 0 //Completely drained of everything.
					var/damage_to_be_applied = T.species.total_health //Get their max health.
					T.apply_damage(damage_to_be_applied, HALLOSS) //Knock em out.
					absorbing_prey = 0 //Clean this up before we return
					return
				if(T.isSynthetic())
					to_chat(src, "<span class='notice'>You begin to siphon what power remains in [T] and their internal mechanisms.</span>")
					to_chat(T, "<span class='danger'>You feel weaker and weaker as the power in your mechanisms is drained by [src]!</span>")
				else
					to_chat(src, "<span class='notice'>You begin to drain [T] completely...</span>")
					to_chat(T, "<span class='danger'>An odd sensation flows through your body as you as [src] begins to drain you to dangerous levels!</span>")
			if(51 to 98)
				if(T.stat == DEAD)
					T.apply_damage(500, OXY) //Bit of fluff.
					absorbing_prey = 0
					if(T.isSynthetic())
						to_chat(src, "<span class='notice'>You have completely drained the power from [T], shutting them down for good.</span>")
						to_chat(T, "<span class='danger'size='5'>Alarms flare and flash, before they suddenly turn off. And so do you.</span>")
					else
						to_chat(src, "<span class='notice'>You have completely drained [T], killing them.</span>")
						to_chat(T, "<span class='danger'size='5'>You feel... So... Weak...</span>")
					add_attack_logs(src,T,"Succubus drained (almost lethal)")
					return
				if(drain_finalized == 1 || T.getBrainLoss() < 55) //Let's not kill them with this unless the drain is finalized. This will still stack up to 55, since 60 is lethal.
					T.adjustBrainLoss(5) //Will kill them after a short bit!
				T.eye_blurry += 20 //A lot of eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done. More than non-lethal due to their lifeforce being sucked out
				nutrition = (nutrition + 25) //Assuming brain damage kills at 60, this gives 300 nutrition.
			if(99)
				if(drain_finalized != 1)
					stage = 51
			if(100) //They shouldn't  survive long enough to get here, but just in case.
				T.apply_damage(500, OXY) //Kill them.
				absorbing_prey = 0
				if(T.isSynthetic())
					to_chat(src, "<span class='notice'>You have completely drained the power from [T], shutting them down for good.</span>")
					to_chat(T, "<span class='danger'size='5'>Alarms flare and flash, before they suddenly turn off. And so do you.</span>")
				else
					to_chat(src, "<span class='notice'>You have completely drained [T], killing them.</span>")
					to_chat(T, "<span class='danger'size='5'>You feel... So... Weak...</span>")
				visible_message("<span class='danger'>[src] seems to finish whatever they were doing to [T].</span>")
				add_attack_logs(src,T,"Succubus drained (lethal)")
				return

		if(!do_mob(src, T, 50) || G.state != GRAB_NECK) //One drain tick every 5 seconds.
			to_chat(src, "<span class='warning'>Your draining of [T] has been interrupted!</span>")
			absorbing_prey = 0
			return

/mob/living/carbon/human/proc/slime_feed()
	set name = "Feed prey with self"
	set desc = "Slowly feed prey with your body, draining you in the process. You may only do this to one person at a time."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/mob/living/carbon/human/C = src
	var/obj/item/grab/G = src.get_active_held_item()
	if(!istype(G))
		to_chat(C, "<span class='warning'>You must be grabbing a creature in your active hand to feed them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T) || T.isSynthetic())
		to_chat(src, "<span class='warning'>\The [T] is not able to be fed.</span>")
		return

	if(!G.state) //This should never occur. But alright
		return

	if(C.absorbing_prey)
		to_chat(C, "<span class='warning'>You are already feeding someone!</span>")
		return

	C.absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				to_chat(C, "<span class='notice'>You begin to feed [T]...</span>")
				to_chat(T, "<span class='notice'>An odd sensation flows through your body as [C] begins to feed you!</span>")
				T.nutrition = (T.nutrition + (C.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				C.nutrition = C.nutrition*0.95
			if(2)
				to_chat(C, "<span class='notice'>You feel weaker with every passing moment of feeding [T].</span>")
				src.visible_message("<span class='notice'>[C] seems to be doing something to [T], resulting in [T]'s body looking stronger with every passing moment!</span>")
				to_chat(T, "<span class='notice'>You feel stronger with every passing moment as [C] feeds you!</span>")
				T.nutrition = (T.nutrition + (C.nutrition*0.1))
				C.nutrition = C.nutrition*0.90
			if(3 to 99)
				T.nutrition = (T.nutrition + (C.nutrition*0.1)) //Just keep draining them.
				C.nutrition = C.nutrition*0.9
				T.eye_blurry += 1 //Eating a slime's body is odd and will make your vision a bit blurry!
				if(C.nutrition < 100 && stage < 99 && C.drain_finalized == 1)//Did they drop below 100 nutrition? If so, immediately jump to stage 99 so it can advance to 100.
					stage = 99
				if(C.drain_finalized != 1 && stage == 99) //Are they not finalizing and the stage hit 100? If so, go back to stage 3 until they finalize it.
					stage = 3
			if(100)
				T.nutrition = (T.nutrition + C.nutrition)
				C.nutrition = 0 //Completely drained of everything.
				C.absorbing_prey = 0
				to_chat(C, "<span class='danger'>You have completely fed [T] every part of your body!</span>")
				to_chat(T, "<span class='notice'>You feel quite strong and well fed, as [C] finishes feeding \himself to you!</span>")
				add_attack_logs(C,T,"Slime fed")
				C.feed_grabbed_to_self_falling_nom(T,C) //Reused this proc instead of making a new one to cut down on code usage.
				return

		if(!do_mob(src, T, 50) || !G.state) //One drain tick every 5 seconds.
			to_chat(src, "<span class='warning'>Your feeding of [T] has been interrupted!</span>")
			C.absorbing_prey = 0
			return

/mob/living/carbon/human/proc/succubus_drain_finalize()
	set name = "Drain/Feed Finalization"
	set desc = "Toggle to allow for draining to be prolonged. Turn this on to make it so prey will be knocked out/die while being drained, or you will feed yourself to the prey's selected stomach if you're feeding them. Can be toggled at any time."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src
	C.drain_finalized = !C.drain_finalized
	to_chat(C, "<span class='notice'>You will [C.drain_finalized?"now":"not"] finalize draining/feeding.</span>")


//Test to see if we can shred a mob. Some child override needs to pass us a target. We'll return it if you can.
/mob/living/var/vore_shred_time = 45 SECONDS
/mob/living/proc/can_shred(var/mob/living/carbon/human/target)
	//Needs to have organs to be able to shred them.
	if(!istype(target))
		to_chat(src,"<span class='warning'>You can't shred that type of creature.</span>")
		return FALSE
	//Needs to be capable (replace with incapacitated call?)
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src,"<span class='warning'>You cannot do that in your current state!</span>")
		return FALSE
	//Needs to be adjacent, at the very least.
	if(!Adjacent(target))
		to_chat(src,"<span class='warning'>You must be next to your target.</span>")
		return FALSE
	//Cooldown on abilities
	if(last_special > world.time)
		to_chat(src,"<span class='warning'>You can't perform an ability again so soon!</span>")
		return FALSE

	return target

//Human test for shreddability, returns the mob if they can be shredded.
/mob/living/carbon/human/vore_shred_time = 10 SECONDS
/mob/living/carbon/human/can_shred()
	//Humans need a grab
	var/obj/item/grab/G = get_active_held_item()
	if(!istype(G))
		to_chat(src,"<span class='warning'>You have to have a very strong grip on someone first!</span>")
		return FALSE
	if(G.state != GRAB_NECK)
		to_chat(src,"<span class='warning'>You must have a tighter grip to severely damage this creature!</span>")
		return FALSE

	return ..(G.affecting)

//PAIs, borgs, and animals don't need a grab or anything
/mob/living/silicon/pai/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,"<span class='warning'>There's nobody nearby to use this on.</span>")

		target = input(src,"Who do you wish to target?","Damage/Remove Prey's Organ") as null|anything in choices
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/silicon/robot/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,"<span class='warning'>There's nobody nearby to use this on.</span>")

		target = input(src,"Who do you wish to target?","Damage/Remove Prey's Organ") as null|anything in choices
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/simple_mob/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,"<span class='warning'>There's nobody nearby to use this on.</span>")

		target = input(src,"Who do you wish to target?","Damage/Remove Prey's Organ") as null|anything in choices
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/proc/shred_limb()
	set name = "Damage/Remove Prey's Organ"
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Abilities"

	//can_shred() will return a mob we can shred, if we can shred any.
	var/mob/living/carbon/human/T = can_shred()
	if(!istype(T))
		return //Silent, because can_shred does messages.

	//Let them pick any of the target's external organs
	var/obj/item/organ/external/T_ext = input(src,"What do you wish to severely damage?") as null|anything in T.organs //D for destroy.
	if(!T_ext) //Picking something here is critical.
		return
	if(T_ext.vital)
		if(alert("Are you sure you wish to severely damage their [T_ext]? It will likely kill [T]...",,"Yes", "No") != "Yes")
			return //If they reconsider, don't continue.

	//Any internal organ, if there are any
	var/obj/item/organ/internal/T_int = input(src,"Do you wish to severely damage an internal organ, as well? If not, click 'cancel'") as null|anything in T_ext.internal_organs
	if(T_int && T_int.vital)
		if(alert("Are you sure you wish to severely damage their [T_int]? It will likely kill [T]...",,"Yes", "No") != "Yes")
			return //If they reconsider, don't continue.

	//And a belly, if they want
	var/obj/belly/B = input(src,"Do you wish to swallow the organ if you tear if out? If not, click 'cancel'") as null|anything in vore_organs

	if(can_shred(T) != T)
		to_chat(src,"<span class='warning'>Looks like you lost your chance...</span>")
		return

	last_special = world.time + vore_shred_time
	visible_message("<span class='danger'>[src] appears to be preparing to do something to [T]!</span>") //Let everyone know that bad times are ahead

	if(do_after(src, vore_shred_time, T)) //Ten seconds. You have to be in a neckgrab for this, so you're already in a bad position.
		if(can_shred(T) != T)
			to_chat(src,"<span class='warning'>Looks like you lost your chance...</span>")
			return

		//Removing an internal organ
		if(T_int && T_int.damage >= 25) //Internal organ and it's been severely damaged
			T.apply_damage(15, BRUTE, T_ext) //Damage the external organ they're going through.
			T_int.removed()
			if(B)
				T_int.forceMove(B) //Move to pred's gut
				visible_message("<span class='danger'>[src] severely damages [T_int.name] of [T]!</span>")
			else
				T_int.forceMove(T.loc)
				visible_message("<span class='danger'>[src] severely damages [T_ext.name] of [T], resulting in their [T_int.name] coming out!</span>","<span class='warning'>You tear out [T]'s [T_int.name]!</span>")

		//Removing an external organ
		else if(!T_int && (T_ext.damage >= 25 || T_ext.brute_dam >= 25))
			T_ext.droplimb(1,DROPLIMB_EDGE) //Clean cut so it doesn't kill the prey completely.

			//Is it groin/chest? You can't remove those.
			if(T_ext.cannot_amputate)
				T.apply_damage(25, BRUTE, T_ext)
				visible_message("<span class='danger'>[src] severely damages [T]'s [T_ext.name]!</span>")
			else if(B)
				T_ext.forceMove(B)
				visible_message("<span class='warning'>[src] swallows [T]'s [T_ext.name] into their [lowertext(B.name)]!</span>")
			else
				T_ext.forceMove(T.loc)
				visible_message("<span class='warning'>[src] tears off [T]'s [T_ext.name]!</span>","<span class='warning'>You tear off [T]'s [T_ext.name]!</span>")

		//Not targeting an internal organ w/ > 25 damage , and the limb doesn't have < 25 damage.
		else
			if(T_int)
				T_int.take_damage(25 - T_int.damage)
			T.apply_damage(25, BRUTE, T_ext)
			visible_message("<span class='danger'>[src] severely damages [T]'s [T_ext.name]!</span>")

		add_attack_logs(src,T,"Shredded (hardvore)")

/mob/living/proc/shred_limb_temp()
	set name = "Damage/Remove Prey's Organ (beartrap)"
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Abilities"
	shred_limb()

/mob/living/proc/flying_toggle()
	set name = "Toggle Flight"
	set desc = "While flying over open spaces, you will use up some nutrition. If you run out nutrition, you will fall. Additionally, you can't fly if you are too heavy."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot fly in this state!")
		return
	if(C.nutrition < 25 && !C.flying) //Don't have any food in you?" You can't fly.
		to_chat(C, "<span class='notice'>You lack the nutrition to fly.</span>")
		return
	if(C.nutrition > 1000 && !C.flying)
		to_chat(C, "<span class='notice'>You have eaten too much to fly! You need to lose some nutrition.</span>")
		return

	C.flying = !C.flying
	update_floating()
	to_chat(C, "<span class='notice'>You have [C.flying?"started":"stopped"] flying.</span>")

//Proc to stop inertial_drift. Exchange nutrition in order to stop gliding around.
/mob/living/proc/start_wings_hovering()
	set name = "Hover"
	set desc = "Allows you to stop gliding and hover. This will take a fair amount of nutrition to perform."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src
	if(!C.flying)
		to_chat(src, "You must be flying to hover!")
		return
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot hover in your current state!")
		return
	if(C.nutrition < 50 && !C.flying) //Don't have any food in you?" You can't hover, since it takes up 25 nutrition. And it's not 25 since we don't want them to immediately fall.
		to_chat(C, "<span class='notice'>You lack the nutrition to fly.</span>")
		return
	if(C.anchored)
		to_chat(C, "<span class='notice'>You are already hovering and/or anchored in place!</span>")
		return

	if(!C.anchored && !C.pulledby) //Not currently anchored, and not pulled by anyone.
		C.anchored = 1 //This is the only way to stop the inertial_drift.
		C.nutrition -= 25
		update_floating()
		to_chat(C, "<span class='notice'>You hover in place.</span>")
		spawn(6) //.6 seconds.
			C.anchored = 0
	else
		return

/mob/living/proc/toggle_pass_table()
	set name = "Toggle Agility" //Dunno a better name for this. You have to be pretty agile to hop over stuff!!!
	set desc = "Allows you to start/stop hopping over things such as hydroponics trays, tables, and railings."
	set category = "Abilities"
	pass_flags ^= ATOM_PASS_TABLE //I dunno what this fancy ^= is but Aronai gave it to me.
	to_chat(src, "You [pass_flags&ATOM_PASS_TABLE ? "will" : "will NOT"] move over tables/railings/trays!")

/mob/living/carbon/human/proc/check_silk_amount()
	set name = "Check Silk Amount"
	set category = "Abilities"

	if(species.is_weaver)
		to_chat(src, "Your silk reserves are at [species.silk_reserve]/[species.silk_max_reserve].")
	else
		to_chat(src, "<span class='warning'>You are not a weaver! How are you doing this? Tell a developer!</span>")

/mob/living/carbon/human/proc/toggle_silk_production()
	set name = "Toggle Silk Production"
	set category = "Abilities"

	if(species.is_weaver)
		species.silk_production = !(species.silk_production)
		to_chat(src, "You are [species.silk_production ? "now" : "no longer"] producing silk.")
	else
		to_chat(src, "<span class='warning'>You are not a weaver! How are you doing this? Tell a developer!</span>")

/mob/living/carbon/human/proc/weave_structure()
	set name = "Weave Structure"
	set category = "Abilities"

	if(!(species.is_weaver))
		to_chat(src, "<span class='warning'>You are not a weaver! How are you doing this? Tell a developer!</span>")
		return

	var/choice
	var/datum/weaver_recipe/structure/desired_result
	var/finalized = "No"

	while(finalized == "No" && src.client)
		choice = tgui_input_list(src,"What would you like to weave?", "Weave Choice", weavable_structures)
		desired_result  = weavable_structures[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(src, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	if(!desired_result || !istype(desired_result))
		return

	if(desired_result.cost > species.silk_reserve)
		to_chat(src, "<span class='warning'>You don't have enough silk to weave that!</span>")
		return

	if(stat)
		to_chat(src, "<span class='warning'>You can't do that in your current state!</span>")
		return

	if(locate(desired_result.result_type) in src.loc)
		to_chat(src, "<span class='warning'>You can't create another weaversilk [desired_result.title] here!</span>")
		return

	if(!isturf(src.loc))
		to_chat(src, "<span class='warning'>You can't weave here!</span>")
		return

	if(do_after(src, desired_result.time))
		if(desired_result.cost > species.silk_reserve)
			to_chat(src, "<span class='warning'>You don't have enough silk to weave that!</span>")
			return

		if(locate(desired_result.result_type) in src.loc)
			to_chat(src, "<span class='warning'>You can't create another weaversilk [desired_result.title] here!</span>")
			return

		if(!isturf(src.loc))
			to_chat(src, "<span class='warning'>You can't weave here!</span>")
			return

		species.silk_reserve = max(species.silk_reserve - desired_result.cost, 0)

		//new desired_result.result_type(src.loc)
		var/atom/O = new desired_result.result_type(src.loc)
		O.color = species.silk_color


/mob/living/carbon/human/proc/weave_item()
	set name = "Weave Item"
	set category = "Abilities"

	if(!(species.is_weaver))
		return

	var/choice
	var/datum/weaver_recipe/item/desired_result
	var/finalized = "No"

	while(finalized == "No" && src.client)
		choice = tgui_input_list(src,"What would you like to weave?", "Weave Choice", weavable_items)
		desired_result  = weavable_items[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(src, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	if(!desired_result || !istype(desired_result))
		return

	if(!(species.is_weaver))
		to_chat(src, "<span class='warning'>You are not a weaver! How are you doing this? Tell a developer!</span>")
		return

	if(desired_result.cost > species.silk_reserve)
		to_chat(src, "<span class='warning'>You don't have enough silk to weave that!</span>")
		return

	if(stat)
		to_chat(src, "<span class='warning'>You can't do that in your current state!</span>")
		return

	if(!isturf(src.loc))
		to_chat(src, "<span class='warning'>You can't weave here!</span>")
		return

	if(do_after(src, desired_result.time))
		if(desired_result.cost > species.silk_reserve)
			to_chat(src, "<span class='warning'>You don't have enough silk to weave that!</span>")
			return

		if(!isturf(src.loc))
			to_chat(src, "<span class='warning'>You can't weave here!</span>")
			return

		species.silk_reserve = max(species.silk_reserve - desired_result.cost, 0)

		//new desired_result.result_type(src.loc)
		var/atom/O = new desired_result.result_type(src.loc)
		O.color = species.silk_color

/mob/living/carbon/human/proc/set_silk_color()
	set name = "Set Silk Color"
	set category = "Abilities"

	if(!(species.is_weaver))
		to_chat(src, "<span class='warning'>You are not a weaver! How are you doing this? Tell a developer!</span>")
		return

	var/new_silk_color = input(usr, "Pick a color for your woven products:","Silk Color", species.silk_color) as null|color
	if(new_silk_color)
		species.silk_color = new_silk_color
