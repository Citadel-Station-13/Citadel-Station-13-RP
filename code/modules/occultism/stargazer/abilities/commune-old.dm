
/datum/ability/species/xenochimera/commune
	name = "Commune"
	desc = "Send a telepathic message to an unlucky recipient."
	action_state = "gen_project"
	nutrition_enforced = FALSE
	nutrition_cost_minimum = 20
	nutrition_cost_proportional = 5
	cooldown = 20 SECONDS


/datum/ability/species/xenochimera/commune/on_trigger()
	. = ..()
	var/list/targets = list()
	var/target = null
	var/text = null

//If the target is not a synth, not us, and a valid mob
	for(var/datum/mind/possible_target in SSticker.minds)
		if (istype(possible_target.current, /mob/living))
			if(possible_target != owner.mind)
				if(!possible_target.current.isSynthetic())
					if(isStationLevel(get_z(owner)))									//If we're on station, go through the station
						if(isStationLevel(get_z(possible_target.current)))
							LAZYADD(targets,possible_target.current)
					else if (get_z(owner) == get_z(possible_target.current))			//Otherwise, go through the z level we're on
						LAZYADD(targets,possible_target.current)

	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets
	if(!target)
		return

	text = sanitize(input("What would you like to say or project?", "Commune to creature", null, null) as message|null)

	if(!text)
		return

	var/mob/living/M = target
	if(M.stat == DEAD)
		to_chat(owner, "Not even an Xenochimera can speak to the dead.")
		return

	//The further the target is, the longer it takes.
	var/distance = get_dist(M.loc,owner.loc)

	var/delay = clamp((distance / 2), 1, 8) SECONDS
	owner.visible_message(SPAN_WARNING("[owner] seems to focus for a few seconds."),"You begin to seek [target] out. This may take a while.")

	if(do_after(owner, delay))
		log_and_message_admins("COMMUNED to [key_name(M)]) [text]", owner)

		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.get_species_id() == SPECIES_ID_XENOCHIMERA)	//thing to thing communication
				to_chat(H, SPAN_DANGER("You feel an alien, yet familiar thought seep into your collective consciousness: " + SPAN_NOTICE("<b>[text]</b>")))
				return
			to_chat(M, SPAN_INTERFACE("Like lead slabs crashing into the ocean, alien thoughts drop into your mind: ") + SPAN_NOTICE("<b>[text]</b>"))
			to_chat(H, SPAN_DANGER("Your nose begins to bleed..."))
			H.drip(1)
