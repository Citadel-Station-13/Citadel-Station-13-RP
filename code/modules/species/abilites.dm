/datum/ability/species
	abstract_type = /datum/ability/species

/datum/ability/species/sonar
	name = "Sonar Ping"
	desc = "You send out a echolocating pulse, briefly showing your environment past the visible"
	action_state = "ling_augmented_eyesight"
	cooldown = 8 SECONDS

/datum/ability/species/sonar/unavailable_reason()
	if(owner?.incapacitated())
		return "You need to recover before you can use this ability."
	if(owner?.is_deaf())
		return "You are for all intents and purposes currently deaf!"
	if(!get_turf(owner))
		return "Not from here you can't."
	. = ..()

/datum/ability/species/sonar/on_trigger(mob/user, toggling)
	. = ..()
	TIMER_COOLDOWN_START(src, CD_INDEX_SONAR_PULSE, 2 SECONDS)

	owner.visible_message(
		SPAN_WARNING("[src] emits a quiet click."),
		SPAN_WARNING("You emit a quiet click."),
		SPAN_WARNING("You hear a quiet, high-pitched click.")
	)
	owner.plane_holder.set_vis(VIS_SONAR, TRUE)
	var/datum/automata/wave/sonar/single_mob/sonar_automata = new
	sonar_automata.receiver = owner
	sonar_automata.setup_auto(get_turf(src), 14)
	sonar_automata.start()
	addtimer(CALLBACK(owner.plane_holder, /datum/plane_holder/proc/set_vis, VIS_SONAR, FALSE), 5 SECONDS, flags = TIMER_OVERRIDE|TIMER_UNIQUE)




