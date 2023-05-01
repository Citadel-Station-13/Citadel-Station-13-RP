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
	var/slowdown = 0.2

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
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.species.item_slowdown_mod += slowdown
	owner.update_floating()
	to_chat(owner, "<span class='notice'>You have started flying.</span>")

/datum/ability/species/toggle_flight/on_disable()
	. = ..()
	owner.flying = FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.species.item_slowdown_mod -= slowdown
	owner.update_floating()
	to_chat(owner, "<span class='notice'>You have stopped flying.</span>")

//Toggle Agility Ability
/datum/ability/species/toggle_agility
	name = "Toggle Agility"
	desc = "Allows the user to traverse over tables, trays and other solid climbable objects with ease."
	action_state = "agility"
	windup = 1 SECOND
	cooldown = 2 MINUTES
	always_bind = TRUE
	var/duration = 1 MINUTE
	var/active = FALSE

/datum/ability/species/toggle_agility/on_trigger()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	toggle(H)
	addtimer(CALLBACK(src, .proc/toggle,owner), duration, TIMER_UNIQUE)

/datum/ability/species/toggle_agility/proc/toggle(mob/living/carbon/human/H)
	if(!active)
		H.visible_message(
			SPAN_NOTICE("[owner] seems to gain a lithe, agile gait."),
			SPAN_NOTICE("You focus on your movement. You're able to walk over tables and similar easily.")
		)
		H.pass_flags |= ATOM_PASS_TABLE
		active = TRUE
	else
		H.visible_message(
			SPAN_NOTICE("[owner] seems to get tired, their legs quivering slightly."),
			SPAN_NOTICE("Your legs tire. Tables are an obstacle once more.")
		)
		H.pass_flags &= ~ATOM_PASS_TABLE
		active = FALSE
