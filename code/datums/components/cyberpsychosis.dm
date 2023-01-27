/*
Following a resurgence in interest regarding cybernetics, augments, and general Cyberpunk themes, I was asked if I could make Cyberpsychosis viable.
This is an attempt at that. It isn't intended to produce any serious long-term effects, so much as provide some internal feedback to Role-Play off of.
Initial Design Goals (X = Complete, / = WIP):
[X]Occasional visual glitching, similar to hallucinations, but less pervasive.
[X]Occasional audio glitching, as above.
[X]Messages posted in the user's chat randomly. (Snippets of memories, visual glitching descriptions, intrusive thoughts, etc.)
[X]The creation of a specialized drug that can reduce the above symptoms when ingested.
[X]Related to the drug, some form of temporarily extending the time between symptom firing while the chem is in-system.
[X]Some form of system that calculates "instability" based off of prosthetics, augments, and implants at spawn, that also increases when more are added.
*/

/datum/component/cyberpsychosis
	var/capacity = 100
	var/cybernetics_count = 0
	var/counted = 0
	var/adjusted = 0
	var/medicated = 0
	var/symptom_delay = 3000
	var/last_symptom = 0

/datum/component/cyberpsychosis/Initialize(radius)
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/cyberpsychosis/process()
	count_cybernetics()
	update_capacity()
	update_medication()
	process_symptoms()

//This proc will tabulate the number of prosthetic limbs, organs, augments, and implants into a number.
/datum/component/cyberpsychosis/proc/count_cybernetics()
	var/mob/living/carbon/human/H = parent
	. = 0
	if(counted)
		return
	else
		for(var/obj/item/organ/O in H.organs)
			if(O.robotic < ORGAN_ROBOT)
				cybernetics_count++
				counted = 1

//This subtracts the above sum from var/capacity, which is set to 100 by default.
/datum/component/cyberpsychosis/proc/update_capacity()
	if(adjusted)
		return
	if(!adjusted && cybernetics_count >= 1)
		capacity -= cybernetics_count*5
		adjusted = 1

/datum/component/cyberpsychosis/proc/update_medication()
	var/mob/living/carbon/human/H = parent
	if(!medicated && H.reagents.has_reagent("neuratrextate", 1))
		medicated = 1
	if(medicated && !H.reagents.has_reagent("neuratrextate", 1))
		medicated = 0

//Dynamically changing the Capacity of a cyberware user isn't really working out.
//So instead I think we can just flag them as medicated, and use that as a check in rendering symptoms.
//This proc will provide different symptoms, with the frequency inversely related to the value of capacity.
//This is basically the one that all the above checkboxes will address.

/datum/component/cyberpsychosis/proc/process_symptoms()
	if(medicated)
		return
	if(world.time > last_symptom + symptom_delay)
		fire_symptoms()
		last_symptom = world.time

/datum/component/cyberpsychosis/proc/fire_symptoms()
	var/mob/living/carbon/human/H = parent
	if(capacity <= 95) //This level is benign in terms of capacity loss. Don't want to just dump symptoms on them on the daily.
		var/message_t1 = rand(1,6)
		switch(message_t1)
			if(1)
				to_chat(H, SPAN_NOTICE("The skin around your implants itches."))
			if(2)
				to_chat(H, SPAN_NOTICE("You feel momentary pressure behind your eyes."))
			if(3)
				to_chat(H, SPAN_NOTICE("Your tongue feels too big."))
			if(4)
				to_chat(H, SPAN_NOTICE("You hear someone whispering nearby."))
			if(5)
				to_chat(H, SPAN_NOTICE("There is a stinging pain in your scalp."))
			if(6)
				to_chat(H, SPAN_NOTICE("For a brief moment you nearly remember the scent of your mother's perfume."))
	else if(capacity < 90) //At this level, we just want snippets of memories and audible hallucinations.
		var/message_t2 = rand(1,8)
		var/audio_t1 = rand(1,8)
		var/select_symptom = rand(1,2)
		switch(select_symptom)
			if(1)
				switch(message_t2)
					if(1)
						to_chat(H, SPAN_NOTICE("You catch a whiff of your favorite food."))
					if(2)
						to_chat(H, SPAN_NOTICE("The sound of your childhood home in Summer rings in your ears for a split second."))
					if(3)
						to_chat(H, SPAN_NOTICE("You remember the temperature of your oldest bedroom."))
					if(4)
						to_chat(H, SPAN_NOTICE("The eyes of your first friend stare curiously up at you."))
					if(5)
						to_chat(H, SPAN_NOTICE("Someone familiar calls your first name."))
					if(6)
						to_chat(H, SPAN_NOTICE("You came here once, on a school trip."))
					if(7)
						to_chat(H, SPAN_NOTICE("Didn't I tell you not to come back?"))
					if(8)
						to_chat(H, SPAN_NOTICE("The walls seem to bubble at the corners of your vision."))
			if(2)
				switch(audio_t1)
					if(1)
						SEND_SOUND(src, sound('sound/machines/airlock.ogg'))
					if(2)
						if(prob(50))
							SEND_SOUND(src, sound('sound/soundbytes/effects/explosion/explosion1.ogg'))
						else
							SEND_SOUND(src, sound('sound/soundbytes/effects/explosion/explosion2.ogg'))
					if(3)
						SEND_SOUND(src, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					if(4)
						SEND_SOUND(src, sound('sound/effects/Glassbr1.ogg'))
					if(5)
						SEND_SOUND(src, sound('sound/effects/Glassbr2.ogg'))
					if(6)
						SEND_SOUND(src, sound('sound/effects/Glassbr3.ogg'))
					if(7)
						SEND_SOUND(src, sound('sound/machines/twobeep.ogg'))
					if(8)
						SEND_SOUND(src, sound('sound/machines/windowdoor.ogg'))
	else if(capacity < 70) //At this level, the user starts to get snippets and messages reminding them of past memories. If this is coded right, they cascade down to the bottom.
		var/message_t3 = rand(1,8)
		switch(message_t3)
			if(1)
				to_chat(H, SPAN_DANGER("You can remember how they all stared at you."))
			if(2)
				to_chat(H, SPAN_DANGER("The stinging pain of your biggest regret spreads deep into your chest."))
			if(3)
				to_chat(H, SPAN_DANGER("Someone is watching you."))
			if(4)
				to_chat(H, SPAN_DANGER("The memory of their screaming is as strong as when you were actually there."))
			if(5)
				to_chat(H, SPAN_DANGER("Who are you?"))
			if(6)
				to_chat(H, SPAN_DANGER("Wind whips by your face as you stare blankly out at the horizon. You feel alone."))
			if(7)
				to_chat(H, SPAN_DANGER("You look down at your hands. Weren't you going to make it big? What happened?"))
			if(8)
				to_chat(H, SPAN_DANGER("You are having trouble breathing. Oh God. You're drowning."))
	else if(capacity < 40) //At this level, the victim begins to have more pronounced visual hallucinations, on top of the stacking symptoms above.
		var/message_t4 = rand(1,2)
		switch(message_t4)
			if(1)
				to_chat(H, SPAN_NOTICE("Visual pixel artifacting crackles into the air before you. Just as quickly as it appears, it's gone."))
			if(2)
				to_chat(H, SPAN_NOTICE("The ground suddenly falls out from under you, smearing into neon vertex lines on a skewed Z-Axis."))
	else if(capacity < 20) //The user's condition is rapidly degrading. More aggressive and intrusive messages come into play. Paranoia and aggravation increases.
		var/message_t5 = rand(1,7)
		switch(message_t5)
			if(1)
				to_chat(H, SPAN_DANGER("You should rip out your implants."))
			if(2)
				to_chat(H, SPAN_DANGER("I know what you did."))
			if(3)
				to_chat(H, SPAN_DANGER("Security is already on its way."))
			if(4)
				to_chat(H, SPAN_DANGER("They're going to find it. Then you're fucked."))
			if(5)
				to_chat(H, SPAN_DANGER("Kill them all. It's the only way to be safe."))
			if(6)
				to_chat(H, SPAN_DANGER("KILLKILLKILLKILLKILLKILL"))
			if(7)
				to_chat(H, SPAN_DANGER("The screeching pain of your cybernetics is unending. It drowns you."))
			if(8) //Cruelty Squad direct quote here. Bit of an easter egg.
				to_chat(H, SPAN_DANGER("A point in the horizon, a melting scene from your childhood. Your mortality is showing. A frantic drift towards nothing, biology doomed to an infinite recursive loop. Teeth with teeth with teeth. Take a bite. Serene scent of a coastal town, warmth of the sun. Bitter tears. Lust for power. This is where you abandoned your dreams. You are a high net worth individual, an expanding vortex of pathetic trauma. Finally a beautiful fucking nerve ape. A pure soul is born, its neurotransactions stutter into being. 30583750937509353 operations per nanosecond. Beauty eludes your porous mind."))
			if(9)
				to_chat(H, SPAN_DANGER("An image of a fractal parrot renders over your vision. Something about it draws you in, crushing, spinning. A black hole. Glory unending. You taste meat between your synapses. You cannot think. You are falling into the Parrot."))
	else if(capacity < 10) //This is the most critical level. On top of stacking everything above, this should be pretty critical in some way.
		var/modifier_to_add = /datum/modifier/berserk
		var/berserk_length = 30 SECONDS
		H.add_modifier(modifier_to_add * berserk_length)
		return

/datum/component/cyberpsychosis/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
