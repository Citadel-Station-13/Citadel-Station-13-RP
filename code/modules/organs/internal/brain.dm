GLOBAL_LIST_BOILERPLATE(all_brain_organs, /obj/item/organ/internal/brain)

/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	vital = 1
	decay_rate = ORGAN_DECAY_PER_SECOND_BRAIN
	icon_state = "brain2"
	force = 1.0
	w_class = ITEMSIZE_SMALL
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
	health = config_legacy.default_brain_health
	addtimer(CALLBACK(src, .proc/clear_brainmob_hud), 15)

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
		H.mind.transfer_to(brainmob)

	brainmob.languages = H.languages

	to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [initial(src.name)]."))
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
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
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

/obj/item/organ/internal/brain/slime
	icon = 'icons/obj/surgery.dmi'
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon_state = "core"
	decays = FALSE
	parent_organ = BP_TORSO
	clone_source = TRUE
	flags = OPENCONTAINER
	var/list/owner_flavor_text = list()

	var/owner_species
	var/owner_base_species

/obj/item/organ/internal/brain/slime/is_open_container()
	return TRUE

/obj/item/organ/internal/brain/slime/Initialize(mapload)
	. = ..()
	create_reagents(50)
	set_owner_vars()
	addtimer(CALLBACK(src, .proc/sync_color), 10 SECONDS)

/obj/item/organ/internal/brain/slime/proc/set_owner_vars()
	if(!ishuman(owner))
		return
	owner_species = owner.dna.species
	owner_base_species = owner.dna.base_species

/obj/item/organ/internal/brain/slime/proc/sync_color()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		color = rgb(min(H.r_skin + 40, 255), min(H.g_skin + 40, 255), min(H.b_skin + 40, 255))

/obj/item/organ/internal/brain/slime/removed(mob/living/user)
	if(istype(owner))
		owner_flavor_text = owner.flavor_texts.Copy()
	..()

/obj/item/organ/internal/brain/slime/proc/reviveBody()
	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna       = brainmob.dna
	R.name      = R.dna.real_name
	R.id        = copytext(md5(brainmob.real_name), 2, 6)
	R.ckey      = brainmob.ckey
	R.types     = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages = brainmob.languages
	R.flavor    = list()
	//! Dumb hack to make sure the slime core knows what species to revive the body as.
	R.dna.base_species = owner_base_species
	R.dna.species      = owner_species
	if(islist(owner_flavor_text))
		R.flavor = owner_flavor_text.Copy()
	for(var/datum/modifier/mod in brainmob.modifiers)
		if(mod.flags & MODIFIER_GENETIC)
			R.genetic_modifiers.Add(mod.type)

	var/datum/mind/clonemind = brainmob.mind

	// Not a mind.
	if(!istype(clonemind, /datum/mind))
		return FALSE
	// Mind is associated with a non-dead body.
	if(clonemind.current && clonemind.current.stat != DEAD)
		return FALSE
	/// Somebody is using that mind.
	if(clonemind.active)
		if(ckey(clonemind.key) != R.ckey)
			return FALSE
	else
		for(var/mob/observer/dead/G in GLOB.player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return FALSE

	// Can't be revived. Probably won't happen...?
	for(var/modifier_type in R.genetic_modifiers)
		if(istype(modifier_type, /datum/modifier/no_clone))
			return FALSE

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
	H.ooc_notes = brainmob.ooc_notes

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
	return TRUE

/datum/chemical_reaction/promethean_brain_revival
	name = "Promethean Revival"
	id = "prom_revival"
	result = null
	required_reagents = list(MAT_PHORON = 40)
	result_amount = 1

/datum/chemical_reaction/promethean_brain_revival/can_happen(datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/organ/internal/brain/slime))
		return ..()
	return FALSE

/datum/chemical_reaction/promethean_brain_revival/on_reaction(datum/reagents/holder)
	var/obj/item/organ/internal/brain/slime/brain = holder.my_atom
	if(brain.reviveBody())
		brain.visible_message(SPAN_NOTICE("[brain] bubbles, surrounding itself with a rapidly expanding mass of slime!"))
	else
		brain.visible_message(SPAN_NOTICE("[brain] shifts strangely, but falls still."))

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
