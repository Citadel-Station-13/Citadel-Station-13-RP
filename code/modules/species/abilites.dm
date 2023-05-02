/datum/ability/species
	abstract_type = /datum/ability/species


//Toggle Flight Ability
/datum/ability/species/toggle_flight
	name = "Toggle Flight"
	desc = "Flying allows you to cross various hazards and pits safely, while being able to ascend, and descend. Equipment slows you down more while in-flight."
	cooldown = 3 SECONDS
	windup = 1 SECOND
	interact_type = ABILITY_INTERACT_TOGGLE
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
