
/obj/item/organ/internal/brain/promethean
	icon = 'icons/obj/surgery.dmi'
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon_state = "core"
	decays = FALSE
	parent_organ = BP_TORSO
	clone_source = TRUE
	atom_flags = OPENCONTAINER
	var/list/owner_flavor_text = list()

	var/owner_species
	var/owner_base_species

	/**
	 * Stargazer mindnet holder
	 */
	var/datum/stargazer_mindnet/promethean/mindnet

	organ_actions = list(
		/datum/action/organ_action/promethean_stargazer_mindnet_panel,
	)

	#warn organ action for mindnet

/obj/item/organ/internal/brain/promethean/Initialize(mapload)
	. = ..()
	create_reagents(50)
	set_owner_vars()
	mindnet = new(src)
	addtimer(CALLBACK(src, PROC_REF(sync_color)), 10 SECONDS)

/obj/item/organ/internal/brain/promethean/Destroy()
	QDEL_NULL(mindnet)
	return ..()

/obj/item/organ/internal/brain/promethean/is_open_container()
	return TRUE

/obj/item/organ/internal/brain/promethean/proc/set_owner_vars()
	if(!ishuman(owner))
		return
	owner_species = owner.species.name
	owner_base_species = owner.species.base_species || owner_species

/obj/item/organ/internal/brain/promethean/proc/sync_color()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		color = rgb(min(H.r_skin + 40, 255), min(H.g_skin + 40, 255), min(H.b_skin + 40, 255))

/obj/item/organ/internal/brain/promethean/removed(mob/living/user)
	if(istype(owner))
		owner_flavor_text = owner.flavor_texts.Copy()
	..()

/obj/item/organ/internal/brain/promethean/proc/reviveBody()
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
		if(clonemind.ckey != R.ckey)
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
	H.name = H.real_name
	H.ooc_notes = brainmob.ooc_notes

	H.nutrition = 260 //Enough to try to regenerate ONCE.
	H.adjustBruteLoss(40)
	H.adjustFireLoss(40)
	H.afflict_unconscious(20 * 4)
	H.update_health()
	for(var/obj/item/organ/external/E in H.organs) //They've still gotta congeal, but it's faster than the clone sickness they'd normally get.
		if(E && E.organ_tag == BP_L_ARM || E.organ_tag == BP_R_ARM || E.organ_tag == BP_L_LEG || E.organ_tag == BP_R_LEG)
			E.removed()
			qdel(E)
			E = null
	H.regenerate_icons()
	clonemind.transfer(H)
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	for(var/datum/prototype/language/L in R.languages)
		H.add_language(L.name)
	H.flavor_texts = R.flavor.Copy()
	qdel(src)
	return TRUE

/datum/action/organ_action/promethean_stargazer_mindnet_panel
	target_type = /obj/item/organ/internal/brain/promethean

	#warn srpite
	name = "Stargazer Mindlink"
	desc = "Psychically commune with those around you."

/datum/action/organ_action/promethean_stargazer_mindnet_panel/invoke_target(obj/item/organ/internal/brain/promethean/target, datum/event_args/actor/actor)
	if(!target.mindnet)
		actor.chat_feedback(SPAN_WARNING("You don't have a mindnet anymore, somehow."))
		return TRUE
	target.mindnet.ui_interact(actor.initiator)
	return TRUE

/datum/chemical_reaction/promethean_brain_revival
	name = "Promethean Revival"
	id = "prom_revival"
	required_reagents = list(
		/datum/reagent/toxin/phoron = 40,
	)
	required_container_path = /obj/item/organ/internal/brain/promethean

/datum/chemical_reaction/promethean_brain_revival/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	var/obj/item/organ/internal/brain/promethean/brain = holder.my_atom
	if(brain.reviveBody())
		brain.visible_message(SPAN_NOTICE("[brain] bubbles, surrounding itself with a rapidly expanding mass of slime!"))
	else
		brain.visible_message(SPAN_NOTICE("[brain] shifts strangely, but falls still."))
