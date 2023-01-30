/datum/disease2/effectholder
	var/name = "Holder"
	var/datum/disease2/effect/effect
	var/chance = 0 //Chance in percentage each tick
	var/cure = "" //Type of cure it requires
	var/happensonce = 0
	var/multiplier = 1 //The chance the effects are WORSE
	var/stage = 0

/datum/disease2/effectholder/proc/runeffect(var/mob/living/carbon/human/mob,var/stage)
	if(happensonce > -1 && effect.stage <= stage && prob(chance))
		effect.activate(mob, multiplier)
		if(happensonce == 1)
			happensonce = -1

/datum/disease2/effectholder/proc/getrandomeffect(var/badness = 1, exclude_types=list())
	var/list/datum/disease2/effect/list = list()
	for(var/e in (typesof(/datum/disease2/effect) - /datum/disease2/effect))
		var/datum/disease2/effect/f = e
		if(e in exclude_types)
			continue
		if(initial(f.badness) > badness)	//we don't want such strong effects
			continue
		if(initial(f.stage) <= src.stage)
			list += f
	var/type = pick(list)
	effect = new type()
	effect.generate()
	chance = rand(0,effect.chance_maxm)
	multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/minormutate()
	switch(pick(1,2,3,4,5))
		if(1)
			chance = rand(0,effect.chance_maxm)
		if(2)
			multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/majormutate(exclude_types=list())
	getrandomeffect(3, exclude_types)

////////////////////////////////////////////////////////////////
////////////////////////EFFECTS/////////////////////////////////
////////////////////////////////////////////////////////////////

/datum/disease2/effect
	var/chance_maxm = 50 //note that disease effects only proc once every 3 ticks for humans
	var/name = "Blanking effect"
	var/stage = 4
	var/maxm = 1
	var/badness = 1
	var/data = null // For semi-procedural effects; this should be generated in generate() if used

/datum/disease2/effect/proc/activate(mob/living/carbon/mob, multiplier)
/datum/disease2/effect/proc/deactivate(mob/living/carbon/mob)
/datum/disease2/effect/proc/generate(copy_data) // copy_data will be non-null if this is a copy; it should be used to initialise the data for this effect if present

/datum/disease2/effect/invisible
	name = "Waiting Syndrome"
	stage = 1
	badness = 3

/datum/disease2/effect/invisible/activate(var/mob/living/carbon/mob,var/multiplier)
	return

////////////////////////STAGE 4/////////////////////////////////

/datum/disease2/effect/nothing
	name = "Nil Syndrome"
	stage = 4
	badness = 1
	chance_maxm = 0

/datum/disease2/effect/gibbingtons
	name = "Gibbington's Syndrome"
	stage = 4
	badness = 3

/datum/disease2/effect/gibbingtons/activate(var/mob/living/carbon/mob,var/multiplier)
	// Probabilities have been tweaked to kill in ~2-3 minutes, giving 5-10 messages.
	// Probably needs more balancing, but it's better than LOL U GIBBED NOW, especially now that viruses can potentially have no signs up until Gibbingtons.
	// Tweaking this further cause WTF for a "~2-3 minutes" window god damn holy hell.
	mob.adjustBruteLoss(10*multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/external/O = pick(H.organs)
		if(prob(25))
			to_chat(mob, "<span class='warning'>Your [O.name] feels as if it might burst!</span>")
		if(prob(3))
			spawn(50)
				if(O)
					O.droplimb(0,DROPLIMB_BLUNT)
	else
		if(prob(75))
			to_chat(mob, "<span class='warning'>Your whole body feels like it might fall apart!</span>")
		if(prob(3))
			mob.adjustBruteLoss(25*multiplier)

/datum/disease2/effect/radian
	name = "Radian's Syndrome"
	stage = 4
	maxm = 3
	badness = 2

// Nerfing the value of the base rad to adjust and not cause immediate rad poisoning to a crew member.
/datum/disease2/effect/radian/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.afflict_radiation(RAD_MOB_AFFLICT_VIRUS_RADIAN(multiplier))

/datum/disease2/effect/deaf
	name = "Deafness"
	stage = 4
	badness = 2

/datum/disease2/effect/deaf/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.ear_deaf += 20

// This will either be removed cause, god damn why do we need to have stuff that changes a person's model to something.
// Going to make this similar to gibbingtons' to make sure it's not an instant monkifying
/datum/disease2/effect/monkey
	name = "Genome Regression"
	stage = 4
	badness = 3

/datum/disease2/effect/monkey/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob,/mob/living/carbon/human))
		var/mob/living/carbon/human/h = mob
		if(prob(25))
			to_chat(mob, "<span class='warning'> You feel as if your body is trying to rapidly regress...</span>")
		if(prob(3))
			h.monkeyize()
	else
		to_chat(mob, "<span class='warning'>You feel an odd attraction to consume banana's...</span>")



// Yeah no just turning this to constant ticking oxyloss from a dying windpipe with the name
/datum/disease2/effect/suicide
	name = "Windpipe Contraction"
	stage = 4
	badness = 3

/datum/disease2/effect/suicide/activate(var/mob/living/carbon/mob,var/multiplier)
	var/datum/gender/TM = GLOB.gender_datums[mob.get_visible_gender()]
	if(prob(25))
		mob.visible_message("<font color='red'><b>[mob.name] is holding [TM.his] breath. It looks like [TM.his] ability to breath [TM.is] constricted!</b></font>")
		mob.apply_damage(15, OXY)

// Nerfing from 15 to 10
/datum/disease2/effect/killertoxins
	name = "Autoimmune Reponse"
	stage = 4
	badness = 2

/datum/disease2/effect/killertoxins/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.adjustToxLoss(10*multiplier)

// DNA Damage
/datum/disease2/effect/dna
	name = "Catastrophic DNA Degeneration"
	stage = 4
	badness = 2

/datum/disease2/effect/dna/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.bodytemperature = max(mob.bodytemperature, 350)
	scramble(0,mob,10)
	mob.apply_damage(10, CLONE)

/datum/disease2/effect/organs
	name = "Limb Paralysis"
	stage = 4
	badness = 2

/datum/disease2/effect/organs/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/organ = pick(list("r_arm","l_arm","r_leg","l_leg"))
		var/obj/item/organ/external/E = H.organs_by_name[organ]
		if (!(E.status & ORGAN_DEAD))
			E.status |= ORGAN_DEAD
			to_chat(H, "<span class='notice'>You can't feel your [E.name] anymore...</span>")
			for (var/obj/item/organ/external/C in E.children)
				C.status |= ORGAN_DEAD
		H.update_icons_body()
	mob.adjustToxLoss(15*multiplier)

/datum/disease2/effect/organs/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.status &= ~ORGAN_DEAD
			for (var/obj/item/organ/external/C in E.children)
				C.status &= ~ORGAN_DEAD
		H.update_icons_body()

// Added a delay into how fast this will act
/datum/disease2/effect/internalorgan
	name = "Organ Shutdown"
	stage = 4
	badness = 2

/datum/disease2/effect/internalorgan/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/organ = pick(list("heart","kidney","liver", "lungs"))
		var/obj/item/organ/internal/O = H.organs_by_name[organ]
		if (O.robotic != ORGAN_ROBOT)
			if(prob(15))
				O.take_damage(5 * multiplier)
				to_chat(H, "<span class='notice'>You feel a cramp in your guts.</span>")
			else
				to_chat(H, "<span class='warning'>You feel like doom is coming.. you should head to medical!</span>")

/datum/disease2/effect/immortal
	name = "Hyperaccelerated Aging"
	stage = 4
	badness = 2

/datum/disease2/effect/immortal/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			if (E.status & ORGAN_BROKEN && prob(30))
				E.status ^= ORGAN_BROKEN
	var/heal_amt = -5*multiplier
	mob.apply_damages(heal_amt,heal_amt,heal_amt,heal_amt)

/datum/disease2/effect/immortal/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		to_chat(H, "<span class='notice'>You suddenly feel hurt and old...</span>")
		H.age += 8
	var/backlash_amt = 5*multiplier
	mob.apply_damages(backlash_amt,backlash_amt,backlash_amt,backlash_amt)

/datum/disease2/effect/better_bones
	name = "Better Bones"
	stage = 4
	chance_maxm = 10

/datum/disease2/effect/better_bones/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.min_broken_damage = max(5, E.min_broken_damage + 30)

/datum/disease2/effect/better_bones/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.min_broken_damage = initial(E.min_broken_damage)

/datum/disease2/effect/bones
	name = "Brittle Bones"
	stage = 4
	badness = 2

/datum/disease2/effect/bones/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.min_broken_damage = max(5, E.min_broken_damage - 30)

/datum/disease2/effect/bones/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.min_broken_damage = initial(E.min_broken_damage)

/datum/disease2/effect/combustion
	name = "Organic Ignition"
	stage = 4
	badness = 3

/datum/disease2/effect/combustion/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/external/O = pick(H.organs)
		if(prob(25))
			to_chat(mob, "<span class='warning'>It feels like your [O.name] is on fire and your blood is boiling!</span>")
			H.adjust_fire_stacks(1)
		if(prob(10))
			to_chat(mob, "<span class='warning'>Flames erupt from your skin, your entire body is burning!</span>")
			H.adjust_fire_stacks(2)
			H.IgniteMob()

// Upgraded Chem Synth. Provided only good meds to heal a patient
/datum/disease2/effect/improved_chem_synthesis
	name = "Improved Chemical Synthesis"
	stage = 4
	chance_maxm = 45

/datum/disease2/effect/improved_chem_synthesis/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = pick("bicaridine", "kelotane", "anti_toxin", "tricordrazine")
	var/datum/reagent/R = SSchemistry.chemical_reagents[data]
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/improved_chem_synthesis/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 5)
		mob.reagents.add_reagent(data, 4)



////////////////////////STAGE 3/////////////////////////////////

// Organ Repair
/datum/disease2/effect/organ_repair
	name = "Minor Organ Repair"
	stage = 3
	chance_maxm = 20

/datum/disease2/effect/organ_repair/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = "peridaxon"
	var/datum/reagent/R = data
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/organ_repair/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 8)
		to_chat(mob, "<span class='notice'>You feel like your insides relaxed and you feel healthier after.</span>")
		mob.reagents.add_reagent(data, 3)

/datum/disease2/effect/toxins
	name = "Hyperacidity"
	stage = 3
	maxm = 3

/datum/disease2/effect/toxins/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.adjustToxLoss((2*multiplier))

/datum/disease2/effect/shakey
	name = "Nervous Motor Instability"
	stage = 3
	maxm = 3

/datum/disease2/effect/shakey/activate(var/mob/living/carbon/mob,var/multiplier)
	shake_camera(mob,5*multiplier)

/datum/disease2/effect/telepathic
	name = "Pineal Gland Decalcification"
	stage = 3

/datum/disease2/effect/telepathic/activate(var/mob/living/carbon/mob,var/multiplier)
		mob.dna.SetSEState(DNABLOCK_REMOTETALK,1)
		domutcheck(mob, null, MUTCHK_FORCED)

/datum/disease2/effect/mind
	name = "Neurodegeneration"
	stage = 3

/datum/disease2/effect/mind/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/internal/brain/B = H.internal_organs_by_name["brain"]
		if (B && B.damage < B.min_broken_damage)
			B.take_damage(5)
	else
		mob.setBrainLoss(10)

/datum/disease2/effect/hallucinations
	name = "Hallucination"
	stage = 3

/datum/disease2/effect/hallucinations/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.hallucination += 25

/datum/disease2/effect/minordeaf
	name = "Hearing Loss"
	stage = 3

/datum/disease2/effect/minordeaf/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.ear_deaf = 5

/datum/disease2/effect/giggle
	name = "Uncontrolled Laughter"
	stage = 3
	chance_maxm = 20

/datum/disease2/effect/giggle/activate(var/mob/living/carbon/mob,var/multiplier)
	if(prob(66))
		mob.say("*giggle")
	else
		to_chat(mob,"<span class='notice'>What's so funny?</span>")

/datum/disease2/effect/confusion
	name = "Topographical Cretinism"
	stage = 3

/datum/disease2/effect/confusion/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='notice'>You have trouble telling right and left apart all of a sudden.</span>")
	mob.Confuse(10)

/datum/disease2/effect/mutation
	name = "DNA Degradation"
	stage = 3

/datum/disease2/effect/mutation/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.apply_damage(2, CLONE)

/datum/disease2/effect/groan
	name = "Phantom Aches"
	stage = 3
	chance_maxm = 20

/datum/disease2/effect/groan/activate(var/mob/living/carbon/mob,var/multiplier)
	if(prob(66))
		mob.say("*groan")
	else if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/external/E = pick(H.organs)
		to_chat(mob,"<span class='warning'>Your [E] aches.</span>")

/datum/disease2/effect/chem_synthesis
	name = "Chemical Synthesis"
	stage = 3
	chance_maxm = 25

/datum/disease2/effect/chem_synthesis/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = pick("bicaridine", "kelotane", "anti_toxin", "inaprovaline", "space_drugs", "sugar",
					"tramadol", "dexalin", "cryptobiolin", "impedrezene", "hyperzine", "ethylredoxrazine",
					"mindbreaker", "glucose")
	var/datum/reagent/R = SSchemistry.chemical_reagents[data]
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/chem_synthesis/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 5)
		mob.reagents.add_reagent(data, 2)

/datum/disease2/effect/nonrejection
	name = "Genetic Chameleonism"
	stage = 3

/datum/disease2/effect/nonrejection/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/internal/O = H.organs_by_name
		for (var/organ in H.organs_by_name)
			if (O.robotic != ORGAN_ROBOT)
				O.rejecting = 0


////////////////////////STAGE 2/////////////////////////////////

/datum/disease2/effect/scream
	name = "Involuntary Vocalization"
	stage = 2
	chance_maxm = 10

/datum/disease2/effect/scream/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*scream")

// Will provide energy to the user
/datum/disease2/effect/energy_boost
	name = "Increased Energy"
	stage = 2
	chance_maxm = 30

/datum/disease2/effect/energy_boost/activate(var/mob/living/carbon/mob,var/multiplier)
	if(prob(30))
		if(mob.drowsyness < 10)
			mob.drowsyness = 0
		else
			mob.drowsyness -= 8

/datum/disease2/effect/drowsness
	name = "Excessive Sleepiness"
	stage = 2

/datum/disease2/effect/drowsness/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.drowsyness += 10

/datum/disease2/effect/sleepy
	name = "Narcolepsy"
	stage = 2
	chance_maxm = 15

/datum/disease2/effect/sleepy/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*collapse")

/datum/disease2/effect/blind
	name = "Vision Loss"
	stage = 2

/datum/disease2/effect/blind/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.SetBlinded(4)

/datum/disease2/effect/cough
	name = "Severe Cough"
	stage = 2
	chance_maxm = 20

/datum/disease2/effect/cough/activate(var/mob/living/carbon/mob,var/multiplier)
	if(prob(60))
		mob.say("*cough")
		for(var/mob/living/carbon/M in oview(2,mob))
			mob.spread_disease_to(M)
	else
		to_chat(mob,"<span class='warning'>Something gets caught in your throat.</span>")

/datum/disease2/effect/hungry
	name = "Digestive Inefficiency"
	stage = 2

/datum/disease2/effect/hungry/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.nutrition = max(0, mob.nutrition - 200)

/datum/disease2/effect/fridge
	name = "Reduced Circulation"
	stage = 2
	chance_maxm = 25

/datum/disease2/effect/fridge/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*shiver")

/datum/disease2/effect/hair
	name = "Hair Loss"
	stage = 2

/datum/disease2/effect/hair/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		if(H.species.name == SPECIES_HUMAN && !(H.h_style == "Bald") && !(H.h_style == "Balding Hair"))
			to_chat(H, "<span class='danger'>Your hair starts to fall out in clumps...</span>")
			spawn(50)
				H.h_style = "Balding Hair"
				H.update_hair()

/datum/disease2/effect/stimulant
	name = "Overactive Adrenal Gland"
	stage = 2

/datum/disease2/effect/stimulant/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='notice'>You feel a rush of energy inside you!</span>")
	if (mob.reagents.get_reagent_amount("hyperzine") < 10)
		mob.reagents.add_reagent("hyperzine", 4)
	if (prob(30))
		mob.jitteriness += 10

/datum/disease2/effect/ringing
	name = "Tinnitus"
	stage = 2
	chance_maxm = 25

/datum/disease2/effect/ringing/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		to_chat(H, "<span class='notice'>You hear an awful ringing in your ears.</span>")
		SEND_SOUND(H, sound('sound/weapons/flash.ogg'))

/datum/disease2/effect/vomiting
	name = "Vomiting"
	stage = 2
	chance_maxm = 15

/datum/disease2/effect/vomiting/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='notice'>Your stomach churns!</span>")
	if (prob(50))
		mob.say("*vomit")

// Feeds protein slowly over time.
/datum/disease2/effect/protein_synthesis
	name = "Protein Synthesis"
	stage = 2
	chance_maxm = 15

/datum/disease2/effect/protein_synthesis/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = "protein"
	var/datum/reagent/R = data
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/protein_synthesis/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 30)
		mob.reagents.add_reagent(data, 5)

// Feeds nutriment slowly over time.
/datum/disease2/effect/nutriment_synthesis
	name = "Nutriment Synthesis"
	stage = 2
	chance_maxm = 15

/datum/disease2/effect/nutriment_synthesis/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = "protein"
	var/datum/reagent/R = data
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/nutriment_synthesis/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 30)
		mob.reagents.add_reagent(data, 5)

////////////////////////STAGE 1/////////////////////////////////

// Feeds sugar VERY slowly over time.
/datum/disease2/effect/sugar_synthesis
	name = "Sugar Synthesis"
	stage = 1
	chance_maxm = 5

/datum/disease2/effect/sugar_synthesis/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = "sugar"
	var/datum/reagent/R = data
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/sugar_synthesis/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 30)
		mob.reagents.add_reagent(data, 5)

/datum/disease2/effect/sneeze
	name = "Sneezing"
	stage = 1
	chance_maxm = 20

/datum/disease2/effect/sneeze/activate(var/mob/living/carbon/mob,var/multiplier)
	if(prob(20))
		to_chat(mob,"<span class='warning'>You go to sneeze, but it gets caught in your sinuses!</span>")
	else if(prob(80))
		if(prob(30))
			to_chat(mob,"<span class='warning'>You feel like you are about to sneeze!</span>")
		spawn(5) //Sleep may have been hanging Mob controller.
			mob.say("*sneeze")
			for(var/mob/living/carbon/M in get_step(mob,mob.dir))
				mob.spread_disease_to(M)
			if (prob(50))
				var/obj/effect/debris/cleanable/mucus/M = new(get_turf(mob))
				M.virus2 = virus_copylist(mob.virus2)

/datum/disease2/effect/gunck
	name = "Mucus Buildup"
	stage = 1

/datum/disease2/effect/gunck/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='warning'>Mucous runs down the back of your throat.</span>")

/datum/disease2/effect/drool
	name = "Salivary Gland Stimulation"
	stage = 1
	chance_maxm = 15

/datum/disease2/effect/drool/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*drool")
	if (prob(30))
		var/obj/effect/debris/cleanable/mucus/M = new(get_turf(mob))
		M.virus2 = virus_copylist(mob.virus2)

/datum/disease2/effect/twitch
	name = "Involuntary Twitching"
	stage = 1
	chance_maxm = 15

/datum/disease2/effect/twitch/activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*twitch")

/datum/disease2/effect/headache
	name = "Headache"
	stage = 1

/datum/disease2/effect/headache/activate(var/mob/living/carbon/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>Your head hurts a bit.</span>")
