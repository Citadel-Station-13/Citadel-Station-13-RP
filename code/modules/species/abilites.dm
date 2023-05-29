/datum/ability/species
	abstract_type = /datum/ability/species

/datum/ability/species/sonar
	name = "Sonar Ping"
	desc = "You send out a echolocating pulse, briefly showing your environment past the visible"
	action_state = "shield"
	cooldown = 8 SECONDS
	always_bind = TRUE

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

	owner.visible_message(
		SPAN_WARNING("[src] emits a quiet click."),
		SPAN_WARNING("You emit a quiet click."),
		SPAN_WARNING("You hear a quiet, high-pitched click.")
	)
	owner.self_perspective.set_plane_visible(/atom/movable/screen/plane_master/sonar, "sonar_pulse")
	owner.plane_holder.set_vis(VIS_SONAR, TRUE)
	var/datum/automata/wave/sonar/single_mob/sonar_automata = new
	sonar_automata.receiver = owner
	sonar_automata.setup_auto(get_turf(owner), 14)
	sonar_automata.start()
	addtimer(CALLBACK(self_perspective, TYPE_PROC_REF(/datum/perspective, unset_plane_visible), /atom/movable/screen/plane_master/sonar, "sonar_pulse"), 5 SECONDS, flags = TIMER_OVERRIDE | TIMER_UNIQUE)

//Toggle Flight Ability
/datum/ability/species/toggle_flight
	name = "Toggle Flight"
	desc = "Flying allows you to cross various hazards and pits safely, while being able to ascend, and descend."
	cooldown = 0
	windup = 0.5 SECONDS
	interact_type = ABILITY_INTERACT_TOGGLE
	windup_requires_still = FALSE
	action_state = "flight"
	always_bind = TRUE

/datum/ability/species/toggle_flight/available_check()
	if(owner.nutrition < 25 && !owner.flying)	//too hungry
		return FALSE
	. = ..()

/datum/ability/species/toggle_flight/unavailable_reason()
	if(owner.nutrition < 25 && !owner.flying)	//too hungry
		return "You're too hungry to fly."
	. = ..()

/datum/ability/species/toggle_flight/on_enable()
	. = ..()
	owner.flying = TRUE
	owner.update_floating()
	to_chat(owner, "<span class='notice'>You have started flying.</span>")

/datum/ability/species/toggle_flight/on_disable()
	. = ..()
	owner.flying = FALSE
	owner.update_floating()
	to_chat(owner, "<span class='notice'>You have stopped flying.</span>")

//Toggle Agility Ability
/datum/ability/species/toggle_agility
	name = "Toggle Agility"
	desc = "Allows the user to traverse over tables, trays and other solid climbable objects with ease."
	action_state = "agility"
	windup = 1 SECOND
	interact_type = ABILITY_INTERACT_TOGGLE
	always_bind = TRUE

/datum/ability/species/toggle_agility/on_enable()
	. = ..()
	owner.visible_message(
	SPAN_NOTICE("[owner] seems to gain a lithe, agile gait."),
	SPAN_NOTICE("You focus on your movement. You're able to walk over tables and similar easily.")
	)
	owner.pass_flags |= ATOM_PASS_TABLE

/datum/ability/species/toggle_agility/on_disable()
	. = ..()
	owner.visible_message(
	SPAN_NOTICE("[owner] seems to relax their stance, no longer seeming as agile."),
	SPAN_NOTICE("Your legs tire. Tables are an obstacle once more.")
	)
	owner.pass_flags &= ~ATOM_PASS_TABLE
