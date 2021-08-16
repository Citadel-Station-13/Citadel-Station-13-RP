GLOBAL_LIST_BOILERPLATE(all_brain_organs, /obj/item/organ/internal/brain)

/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = ITEMSIZE_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/clone_source = FALSE
	var/mob/living/carbon/brain/brainmob = null
	var/can_assist = TRUE

	//Baymed vars
	var/can_use_mmi = TRUE
	var/mob/living/carbon/brain/brainmob = null
	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1
	var/oxygen_reserve = 6

/obj/item/organ/internal/brain/proc/can_assist()
	return can_assist

/obj/item/organ/internal/brain/proc/implant_assist(var/targ_icon_state = null)
	name = "[owner.real_name]'s assisted [initial(name)]"
	if(targ_icon_state)
		icon_state = targ_icon_state
		if(dead_icon)
			dead_icon = "[targ_icon_state]_dead"
	else
		icon_state = "[initial(icon_state)]_assisted"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_assisted"

/obj/item/organ/internal/brain/robotize()
	replace_self_with(/obj/item/organ/internal/mmi_holder/posibrain)

/obj/item/organ/internal/brain/mechassist()
	replace_self_with(/obj/item/organ/internal/mmi_holder)

/obj/item/organ/internal/brain/digitize()
	replace_self_with(/obj/item/organ/internal/mmi_holder/robot)

/obj/item/organ/internal/brain/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Bacterial meningitis (more of a spine thing but 'brain infection' isn't a common thing)
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("Your neck aches, and feels very stiff!",0)
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("Your feel very dizzy for a moment!",0)
			owner.Confuse(2)

/obj/item/organ/internal/brain/proc/replace_self_with(replace_path)
	var/mob/living/carbon/human/tmp_owner = owner
	qdel(src)
	if(tmp_owner)
		tmp_owner.internal_organs_by_name[organ_tag] = new replace_path(tmp_owner, 1)
		tmp_owner = null


/obj/item/organ/internal/brain/Initialize(mapload, ...)
	. = ..()
	health = config_legacy.default_brain_health
	addtimer(CALLBACK(src, .proc/clear_brainmob_hud), 15)

/obj/item/organ/internal/brain/proc/clear_brainmob_hud()
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	QDEL_NULL(brainmob)
	return ..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)

	if(!brainmob)
		brainmob = new(src)
		brainmob.name = H.real_name
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.timeofhostdeath = H.timeofdeath

		// Copy modifiers.
		for(var/datum/modifier/M in H.modifiers)
			if(M.flags & MODIFIER_GENETIC)
				brainmob.add_modifier(M.type)

	if(H.mind)
		H.mind.transfer_to(brainmob)

	brainmob.languages = H.languages

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user) // -- TLE
	. = ..()
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		. += "You can feel the small spark of life still left in this one."
	else
		. += "This one seems particularly lifeless. Perhaps it will regain some of its luster later..."

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	if(name == initial(name))
		name = "\the [owner.real_name]'s [initial(name)]"

	var/mob/living/simple_mob/animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	var/obj/item/organ/internal/brain/B = src
	if(istype(B) && istype(owner))
		B.transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
	..()

/obj/item/organ/internal/brain/proc/get_control_efficiency()
	. = max(0, 1 - (round(damage / max_damage * 10) / 10))

	return .

//Baymed Procs

/obj/item/organ/internal/brain/robotize()
	replace_self_with(/obj/item/organ/internal/posibrain)

/obj/item/organ/internal/brain/mechassist()
	replace_self_with(/obj/item/organ/internal/mmi_holder)

/obj/item/organ/internal/brain/getToxLoss()
	return 0


/obj/item/organ/internal/brain/robotize()
	. = ..()
	icon_state = "brain-prosthetic"

/obj/item/organ/internal/brain/New(var/mob/living/carbon/holder)
	..()
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)

	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/set_max_damage(var/ndamage)
	..()
	damage_threshold_value = round(max_damage / damage_threshold_count)

/obj/item/organ/internal/brain/Destroy()
	QDEL_NULL(brainmob)
	. = ..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)

	if(!brainmob)
		brainmob = new(src)
		brainmob.SetName(H.real_name)
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.timeofhostdeath = H.timeofdeath

	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user)
	. = ..()
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		to_chat(user, "You can feel the small spark of life still left in this one.")
	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/brain/removed(var/mob/living/user)
	if(!istype(owner))
		return ..()

	if(name == initial(name))
		name = "\the [owner.real_name]'s [initial(name)]"

	var/mob/living/simple_animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(!..()) return 0

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key

	return 1

/obj/item/organ/internal/brain/can_recover()
	return ~status & ORGAN_DEAD

/obj/item/organ/internal/brain/proc/get_current_damage_threshold()
	return round(damage / damage_threshold_value)

/obj/item/organ/internal/brain/proc/past_damage_threshold(var/threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/internal/brain/proc/handle_severe_brain_damage()
	set waitfor = FALSE
	healed_threshold = 0
	to_chat(owner, "<span class = 'notice' font size='10'><B>Where am I...?</B></span>")
	sleep(5 SECONDS)
	if (!owner || owner.stat == DEAD || (status & ORGAN_DEAD))
		return
	to_chat(owner, "<span class = 'notice' font size='10'><B>What's going on...?</B></span>")
	sleep(10 SECONDS)
	if (!owner || owner.stat == DEAD || (status & ORGAN_DEAD))
		return
	to_chat(owner, "<span class = 'notice' font size='10'><B>What happened...?</B></span>")
	alert(owner, "You have taken massive brain damage! You will not be able to remember the events leading up to your injury.", "Brain Damaged")
	if (owner.psi)
		owner.psi.check_latency_trigger(20, "physical trauma")

/obj/item/organ/internal/brain/Process()
	if(owner)
		if(damage > max_damage / 2 && healed_threshold)
			handle_severe_brain_damage()

		if(damage < (max_damage / 4))
			healed_threshold = 1

		handle_disabilities()
		handle_damage_effects()

		// Brain damage from low oxygenation or lack of blood.
		if(owner.should_have_organ(BP_HEART))

			// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
			var/blood_volume = owner.get_blood_oxygenation()
			if(blood_volume < BLOOD_VOLUME_SURVIVE)
				if(!owner.chem_effects[CE_STABLE] || prob(60))
					oxygen_reserve = max(0, oxygen_reserve-1)
			else
				oxygen_reserve = min(initial(oxygen_reserve), oxygen_reserve+1)
			if(!oxygen_reserve) //(hardcrit)
				owner.Paralyse(3)
			var/can_heal = damage && damage < max_damage && (damage % damage_threshold_value || owner.chem_effects[CE_BRAIN_REGEN] || (!past_damage_threshold(3) && owner.chem_effects[CE_STABLE]))
			var/damprob
			//Effects of bloodloss
			switch(blood_volume)

				if(BLOOD_VOLUME_SAFE to INFINITY)
					if(can_heal)
						damage = max(damage-1, 0)
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					if(prob(1))
						to_chat(owner, "<span class='warning'>You feel [pick("dizzy","woozy","faint")]...</span>")
					damprob = owner.chem_effects[CE_STABLE] ? 30 : 60
					if(!past_damage_threshold(2) && prob(damprob))
						take_internal_damage(1)
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 40 : 80
					if(!past_damage_threshold(4) && prob(damprob))
						take_internal_damage(1)
					if(!owner.paralysis && prob(10))
						owner.Paralyse(rand(1,3))
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 60 : 100
					if(!past_damage_threshold(6) && prob(damprob))
						take_internal_damage(1)
					if(!owner.paralysis && prob(15))
						owner.Paralyse(3,5)
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(-(INFINITY) to BLOOD_VOLUME_SURVIVE) // Also see heart.dm, being below this point puts you into cardiac arrest.
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 80 : 100
					if(prob(damprob))
						take_internal_damage(1)
					if(prob(damprob))
						take_internal_damage(1)
	..()

/obj/item/organ/internal/brain/take_internal_damage(var/damage, var/silent)
	set waitfor = 0
	..()
	if(damage >= 20) //This probably won't be triggered by oxyloss or mercury. Probably.
		var/damage_secondary = damage * 0.20
		if (owner)
			owner.flash_eyes()
			owner.eye_blurry += damage_secondary
			owner.confused += damage_secondary * 2
			owner.Paralyse(damage_secondary)
			owner.Weaken(round(damage, 1))
			if (prob(30))
				addtimer(CALLBACK(src, .proc/brain_damage_callback, damage), rand(6, 20) SECONDS, TIMER_UNIQUE)

/obj/item/organ/internal/brain/proc/brain_damage_callback(var/damage) //Confuse them as a somewhat uncommon aftershock. Side note: Only here so a spawn isn't used. Also, for the sake of a unique timer.
	if (!owner || owner.stat == DEAD || (status & ORGAN_DEAD))
		return

	to_chat(owner, "<span class = 'notice' font size='10'><B>I can't remember which way is forward...</B></span>")
	owner.confused += damage

/obj/item/organ/internal/brain/proc/handle_disabilities()
	if(owner.stat)
		return
	if((owner.disabilities & EPILEPSY) && prob(1))
		owner.seizure()
	else if((owner.disabilities & TOURETTES) && prob(10))
		owner.Stun(10)
		switch(rand(1, 3))
			if(1)
				owner.emote("twitch")
			if(2 to 3)
				owner.say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
		owner.make_jittery(100)
	else if((owner.disabilities & NERVOUS) && prob(10))
		owner.stuttering = max(10, owner.stuttering)

/obj/item/organ/internal/brain/proc/handle_damage_effects()
	if(owner.stat)
		return
	if(damage > 0 && prob(1))
		owner.custom_pain("Your head feels numb and painful.",10)
	if(is_bruised() && prob(1) && owner.eye_blurry <= 0)
		to_chat(owner, "<span class='warning'>It becomes hard to see for some reason.</span>")
		owner.eye_blurry = 10
	if(damage >= 0.5*max_damage && prob(1) && owner.get_active_hand())
		to_chat(owner, "<span class='danger'>Your hand won't respond properly, and you drop what you are holding!</span>")
		owner.unequip_item()
	if(damage >= 0.6*max_damage)
		owner.slurring = max(owner.slurring, 2)
	if(is_broken())
		if(!owner.lying)
			to_chat(owner, "<span class='danger'>You black out!</span>")
		owner.Paralyse(10)

/obj/item/organ/internal/brain/surgical_fix(mob/user)
	var/blood_volume = owner.get_blood_oxygenation()
	if(blood_volume < BLOOD_VOLUME_SURVIVE)
		to_chat(user, "<span class='danger'>Parts of [src] didn't survive the procedure due to lack of air supply!</span>")
		set_max_damage(Floor(max_damage - 0.25*damage))
	heal_damage(damage)

/obj/item/organ/internal/brain/get_scarring_level()
	. = (species.total_health - max_damage)/species.total_health

/obj/item/organ/internal/brain/get_mechanical_assisted_descriptor()
	return "machine-interface [name]"



//End of baymedprocs

/obj/item/organ/internal/brain/pariah_brain
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	vital = 1
	can_assist = FALSE

/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	can_assist = FALSE

/obj/item/organ/internal/brain/slime
	icon = 'icons/obj/surgery_vr.dmi' // Vorestation edit
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon_state = "core"
	decays = FALSE
	parent_organ = BP_TORSO
	clone_source = TRUE
	flags = OPENCONTAINER

/obj/item/organ/internal/brain/slime/is_open_container()
	return 1

/obj/item/organ/internal/brain/slime/Initialize(mapload)
	. = ..()
	create_reagents(50)
	addtimer(CALLBACK(src, .proc/sync_color), 10 SECONDS)

/obj/item/organ/internal/brain/slime/proc/sync_color()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		color = rgb(min(H.r_skin + 40, 255), min(H.g_skin + 40, 255), min(H.b_skin + 40, 255))

/obj/item/organ/internal/brain/slime/proc/reviveBody()
	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna = brainmob.dna
	R.ckey = brainmob.ckey
	R.id = copytext(md5(brainmob.real_name), 2, 6)
	R.name = R.dna.real_name
	R.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages = brainmob.languages
	R.flavor = list()
	for(var/datum/modifier/mod in brainmob.modifiers)
		if(mod.flags & MODIFIER_GENETIC)
			R.genetic_modifiers.Add(mod.type)

	var/datum/mind/clonemind = brainmob.mind

	if(!istype(clonemind, /datum/mind))	//not a mind
		return 0
	if(clonemind.current && clonemind.current.stat != DEAD)	//mind is associated with a non-dead body
		return 0
	if(clonemind.active)	//somebody is using that mind
		if(ckey(clonemind.key) != R.ckey)
			return 0
	else
		for(var/mob/observer/dead/G in player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return 0

	for(var/modifier_type in R.genetic_modifiers)	//Can't be revived. Probably won't happen...?
		if(istype(modifier_type, /datum/modifier/no_clone))
			return 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(get_turf(src), R.dna.species)

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna

	H.UpdateAppearance()
	H.sync_organ_dna()
	if(!R.dna.real_name)	//to prevent null names
		R.dna.real_name = "promethean ([rand(0,999)])"
	H.real_name = R.dna.real_name

	H.nutrition = 260 //Enough to try to regenerate ONCE.
	H.adjustBruteLoss(40)
	H.adjustFireLoss(40)
	H.Paralyse(4)
	H.updatehealth()
	for(var/obj/item/organ/external/E in H.organs) //They've still gotta congeal, but it's faster than the clone sickness they'd normally get.
		if(E && E.organ_tag == BP_L_ARM || E.organ_tag == BP_R_ARM || E.organ_tag == BP_L_LEG || E.organ_tag == BP_R_LEG)
			E.removed()
			qdel(E)
			E = null
	H.regenerate_icons()
	clonemind.transfer_to(H)
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	for(var/datum/language/L in R.languages)
		H.add_language(L.name)
	H.flavor_texts = R.flavor.Copy()
	qdel(src)
	return 1

/datum/chemical_reaction/promethean_brain_revival
	name = "Promethean Revival"
	id = "prom_revival"
	result = null
	required_reagents = list("phoron" = 40)
	result_amount = 1

/datum/chemical_reaction/promethean_brain_revival/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/organ/internal/brain/slime))
		return ..()
	return FALSE

/datum/chemical_reaction/promethean_brain_revival/on_reaction(var/datum/reagents/holder)
	var/obj/item/organ/internal/brain/slime/brain = holder.my_atom
	if(brain.reviveBody())
		brain.visible_message("<span class='notice'>[brain] bubbles, surrounding itself with a rapidly expanding mass of slime!</span>")
	else
		brain.visible_message("<span class='warning'>[brain] shifts strangely, but falls still.</span>")

/obj/item/organ/internal/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	can_assist = FALSE

/obj/item/organ/internal/brain/grey
	desc = "A piece of juicy meat found in a person's head. This one is strange."
	icon_state = "brain_grey"

/obj/item/organ/internal/brain/grey/colormatch/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, .proc/sync_color), 15)

/obj/item/organ/internal/brain/grey/colormatch/proc/sync_color()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		color = H.species.blood_color
