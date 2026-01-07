/obj/item/organ/internal/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	vital = 1
	decay_rate = ORGAN_DECAY_PER_SECOND_BRAIN
	icon_state = "brain2"
	damage_force = 1.0
	w_class = WEIGHT_CLASS_SMALL
	throw_force = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/clone_source = FALSE
	var/mob/living/carbon/brain/brainmob = null
	var/can_assist = TRUE

/obj/item/organ/internal/brain/Initialize(mapload, ...)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(clear_brainmob_hud)), 15)

/obj/item/organ/internal/brain/Destroy()
	QDEL_NULL(brainmob)
	return ..()

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

/obj/item/organ/internal/brain/proc/clear_brainmob_hud()
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)

	if(!brainmob)
		brainmob = new(src)
		brainmob.name = H.real_name
		brainmob.real_name = H.real_name
		if(istype(H))
			brainmob.dna = H.dna.Clone()
			brainmob.timeofhostdeath = H.timeofdeath
			brainmob.ooc_notes = H.ooc_notes

		// Copy modifiers.
		for(var/datum/modifier/M in H.modifiers)
			if(M.flags & MODIFIER_GENETIC)
				brainmob.add_modifier(M.type)

	if(H.mind)
		H.mind.transfer(brainmob)

	brainmob.languages = H.languages

	to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [initial(src.name)]."))
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user, dist) // -- TLE
	. = ..()
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		. += "You can feel the small spark of life still left in this one."
	else
		. += "This one seems particularly lifeless. Perhaps it will regain some of its luster later..."

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	if(name == initial(name))
		name = "\the [owner.real_name]'s [initial(name)]"

	var/mob/living/simple_mob/animal/borer/borer = owner?.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed

	var/obj/item/organ/internal/brain/B = src
	if(istype(B) && owner)
		if(istype(owner, /mob/living/carbon))
			B.transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer(target)
		else
			brainmob.transfer_client_to(target)
	..()

/obj/item/organ/internal/brain/proc/get_control_efficiency()
	return max(0, 1 - (round(damage / max_damage * 10) / 10))

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
	addtimer(CALLBACK(src, PROC_REF(sync_color)), 15)

/obj/item/organ/internal/brain/grey/colormatch/proc/sync_color()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		color = H.species.blood_color

/obj/item/organ/internal/brain/holosphere
	decays = FALSE

/obj/item/organ/internal/brain/holosphere/take_damage(amount, var/silent=0)
	return

/obj/item/organ/internal/brain/holosphere/can_die()
	return FALSE

/obj/item/organ/internal/brain/holosphere/removed(var/mob/living/user)
	. = ..()
	QDEL_NULL(src)
