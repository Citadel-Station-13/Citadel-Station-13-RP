/datum/ability/species
	abstract_type = /datum/ability/species

/datum/ability/species/sonar
	name = "Sonar Ping"
	desc = "You send out a echolocating pulse, briefly showing your environment past the visible"
	action_state = "shield"
	cooldown = 2 SECONDS
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
		SPAN_WARNING("[owner] emits a quiet click."),
		SPAN_WARNING("You emit a quiet click."),
		SPAN_WARNING("You hear a quiet, high-pitched click.")
	)
	owner.self_perspective.set_plane_visible(/atom/movable/screen/plane_master/sonar, "sonar_pulse")
	var/datum/automata/wave/sonar/single_mob/sonar_automata = new
	sonar_automata.receiver = owner
	sonar_automata.setup_auto(get_turf(owner), 14)
	sonar_automata.start()
	addtimer(CALLBACK(owner.self_perspective, TYPE_PROC_REF(/datum/perspective, unset_plane_visible), /atom/movable/screen/plane_master/sonar, "sonar_pulse"), 5 SECONDS, flags = TIMER_OVERRIDE | TIMER_UNIQUE)

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

//binocular-esque zoomout for winged species, can only be used outside
/datum/ability/species/soar
	name = "Soar"
	desc = "Soaring up into the skies gives you a better view. Allows the use of items during the duration."
	cooldown = 60 SECONDS
	windup = 0
	interact_type = ABILITY_INTERACT_TRIGGER
	windup_requires_still = TRUE
	action_state = "soar"
	always_bind = TRUE
	var/soar_duration = 10 SECONDS
	var/fake_windup = 2 SECONDS
	var/crashmean = 40			//average damage from crashing into a ceiling & stun duration
	var/viewsize = 9			//soar viewsize, any positive value will increase vision

/datum/ability/species/soar/available_check()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(H.nutrition < 50 || H.flying || !H.wing_style)	//too hungry or already in flight or no wings
		return FALSE
	. = ..()

/datum/ability/species/soar/unavailable_reason()
	if(!ishuman(owner))
		return "You're not sapient enough for this!"
	var/mob/living/carbon/human/H = owner
	if(!H.wing_style)
		return "You don't have wings to soar with!"
	if(owner.nutrition < 50)
		return "You're too hungry to fly."
	if(owner.flying)
		return "You need solid flooring to jump off of!"
	. = ..()

/datum/ability/species/soar/proc/land(var/mob/living/carbon/human/H)
	H.ensure_self_perspective()
	H.self_perspective.set_augmented_view(0, 0)
	to_chat(owner, SPAN_NOTICE("You gently land from the skies."))
	QDEL_NULL(H.particles)
	animate(H, pixel_y = 0, time = 2 SECONDS, easing = SINE_EASING | EASE_IN)

/datum/ability/species/soar/proc/crash(mob/living/carbon/human/H,turf/T)
	owner.visible_message(SPAN_DANGER("[owner] crashes into the ceiling with a horrible sound!"), SPAN_DANGER("<b>YOU CRASH INTO THE CEILING!</b>"), SPAN_DANGER("You hear a horrible crashing sound!"), 7)
	H.afflict_stun(crashmean)
	H.afflict_paralyze(crashmean)
	H.adjustBruteLoss(rand(crashmean/2,crashmean*2))
	var/turf/land = get_step(T,owner.dir)
	H.throw_at(land, rand(2, 5), 1, null)
	playsound(owner, "punch", 50, 1)

/datum/ability/species/soar/proc/liftoff()
	owner.ensure_self_perspective()
	owner.self_perspective.set_augmented_view(viewsize,viewsize)
	owner.particles = new /particles/smoke/soar()
	animate(owner, time = 1.5 SECONDS, FALSE, ELASTIC_EASING, pixel_y = owner.pixel_y + 48)	//Rise up into the sky with an animation
	owner.particles.position = list(0,-64,0)

/datum/ability/species/soar/proc/sendmessages()
	for(var/datum/mind/observer in SSticker.minds)
		if(get_z(owner) == get_z(observer.current) && observer != owner.mind)
			var/dist = get_dist(observer.current.loc, owner.loc)
			if(dist > 7 && dist <= 7 + viewsize/2)	//If they're off-screen, but within the vision range of the soar
				to_chat(observer.current, SPAN_NOTICE("You see something fly into the sky to your <b>[dir2text(get_dir(observer.current.loc, owner.loc))]!</b>"))
	owner.visible_message(SPAN_NOTICE("[owner] soars into the sky, gaining a wide field of vision!"), SPAN_NOTICE("<b>You soar into the sky, the land opening up to you.</b>"), SPAN_NOTICE("You hear and feel a gust of wind as something takes off into the sky above you."), 7)

/datum/ability/species/soar/on_trigger()
	. = ..()
	var/turf/T = owner?.loc
	var/willcrash = FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(owner, SPAN_NOTICE("You brace yourself to leap into the sky with your wings."))
		if(!T.outdoors)
			willcrash = TRUE
			to_chat(owner, SPAN_DANGER("There's something above you! This is a bad idea!"))
		if(do_after(owner,fake_windup))
			if(willcrash)
				crash(H,T)
				return
			liftoff()
			sendmessages()

			if(do_after(owner, soar_duration, flags = DO_AFTER_IGNORE_ACTIVE_ITEM, mobility_flags = MOBILITY_IS_STANDING & MOBILITY_IS_CONSCIOUS))
				land(H)
			else
				var/statuspaths = typesof(/datum/status_effect/incapacitation)
				for(var/stat in statuspaths)				//We got cancelled because we got incapacitated
					if(owner.has_status_effect(stat))
						crash(H,T)
					else
						land(H)
