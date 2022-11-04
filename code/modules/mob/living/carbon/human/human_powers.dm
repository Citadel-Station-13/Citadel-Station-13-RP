//TODO: Organize these into a "abilities" folder.
// These should all be procs, you can add them to humans/subspecies by species.dm's inherent_verbs

/mob/living/carbon/human/proc/tie_hair()
	set name = "Tie Hair"
	set desc = "Style your hair."
	set category = "IC"

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You can't mess with your hair right now!"))
		return

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		var/selected_string
		if(!(hair_style.flags & HAIR_TIEABLE))
			to_chat(src, SPAN_WARNING("Your hair isn't long enough to tie."))
			return
		else
			var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
			for(var/hair_string in hair_styles_list)
				var/datum/sprite_accessory/hair/test = hair_styles_list[hair_string]
				if(test.flags & HAIR_TIEABLE)
					valid_hairstyles.Add(hair_string)
			selected_string = input("Select a new hairstyle", "Your hairstyle", hair_style) as null|anything in valid_hairstyles
		if(incapacitated())
			to_chat(src, SPAN_WARNING("You can't mess with your hair right now!"))
			return
		else if(selected_string && h_style != selected_string)
			h_style = selected_string
			regenerate_icons()
			visible_message(SPAN_NOTICE("[src] pauses a moment to style their hair."))
		else
			to_chat(src, SPAN_NOTICE("You're already using that style."))

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot tackle in your current state.")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("<font color='red'><B>[] [failed ? "tried to tackle" : "has tackled"] down []!</font></B>", src, T), 1)

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null
	var/default_distance_mod = 0 SECONDS

	if(nutrition < 50)
		to_chat(src, SPAN_NOTICE("You don't have enough energy! Try eating. "))
		return



	for(var/datum/mind/possible_target in SSticker.minds)
		if (istype(possible_target.current, /mob/living) && possible_target != src.mind)
			LAZYADD(targets,possible_target.current)

	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets
	if(!target)
		return

	text = input("What would you like to say?", "Speak to creature", null, null)
	text = sanitize(text)

	if(!text)
		return

	var/mob/living/M = target
	if(M.stat == DEAD)
		to_chat(src, "Not even a [src.species.name] can speak to the dead.")
		return

	//The further the target is, the longer it takes.
	var/distance = get_dist(M.loc,loc)
	var/distance_modifier
	var/turf/target_location = get_turf(M.loc)
	if(target_location)
		if(target_location.z in GLOB.using_map.station_levels)
			distance_modifier = 0	//No additional values if they're on-station
	else
		distance_modifier = default_distance_mod	//No quick snapchatting with someone off-station

	var/delay = clamp((distance / 2), 1, 8) SECONDS + distance_modifier	//Half of distance worth of seconds, up to 8, plus 30 if they're off-station. Max: 38, min: 1.
	src.visible_message(SPAN_WARNING("[src] seems to focus for a few seconds."),"You begin to seek [target] out. This may take a while.")

	if(do_after(src, delay))
		log_and_message_admins("COMMUNED to [key_name(M)]) [text]", src)

		to_chat(M, SPAN_INTERFACE("Like lead slabs crashing into the ocean, alien thoughts drop into your mind: <b>[text]</b>"))
		nutrition -= 50
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.name == src.species.name)
				return
			to_chat(H, SPAN_DANGER("Your nose begins to bleed..."))
			H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.loc = loc
		src.visible_message(SPAN_BOLDDANGER("[src] hurls out the contents of their stomach!"))
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("(PWHISPER to [key_name(M)]) [msg]", src)
		to_chat(M, SPAN_GREEN("You hear a strange, alien voice in your head... <i>[msg]</i>"))
		to_chat(src, SPAN_GREEN("You said: \"[msg]\" to [M]"))
	return

/mob/living/carbon/human/proc/diona_split_nymph()
	set name = "Split"
	set desc = "Split your humanoid form into its constituent nymphs."
	set category = "Abilities"
	diona_split_into_nymphs(5)	// Separate proc to void argments being supplied when used as a verb

/mob/living/carbon/human/proc/diona_split_into_nymphs(var/number_of_resulting_nymphs)
	var/turf/T = get_turf(src)

	var/mob/living/carbon/alien/diona/S = new(T)
	S.setDir(dir)
	transfer_languages(src, S)

	if(mind)
		mind.transfer_to(S)

	message_admins("\The [src] has split into nymphs; player now controls [key_name_admin(S)]")
	log_admin("\The [src] has split into nymphs; player now controls [key_name(S)]")

	var/nymphs = 1

	for(var/mob/living/carbon/alien/diona/D in src)
		nymphs++
		D.forceMove(T)
		transfer_languages(src, D, WHITELISTED|RESTRICTED)
		D.setDir(pick(NORTH, SOUTH, EAST, WEST))

	if(nymphs < number_of_resulting_nymphs)
		for(var/i in nymphs to (number_of_resulting_nymphs - 1))
			var/mob/M = new /mob/living/carbon/alien/diona(T)
			transfer_languages(src, M, WHITELISTED|RESTRICTED)
			M.setDir(pick(NORTH, SOUTH, EAST, WEST))


	drop_inventory(TRUE, TRUE, TRUE)

	var/obj/item/organ/external/Chest = organs_by_name[BP_TORSO]

	if(Chest.robotic >= 2)
		visible_message(SPAN_WARNING("\The [src] shudders slightly, then ejects a cluster of nymphs with a wet slithering noise."))
		set_species(/datum/species/human, skip = TRUE, force = TRUE) // This is hard-set to default the body to a normal FBP, without changing anything.

		// Bust it
		src.death()

		for(var/obj/item/organ/internal/diona/Org in internal_organs) // Remove Nymph organs.
			qdel(Org)

		// Purge the diona verbs.
		verbs -= /mob/living/carbon/human/proc/diona_split_nymph
		verbs -= /mob/living/carbon/human/proc/regenerate

		for(var/obj/item/organ/external/E in organs) // Just fall apart.
			E.droplimb(TRUE)

	else
		visible_message(SPAN_WARNING("\The [src] quivers slightly, then splits apart with a wet slithering noise."))
		qdel(src)

/mob/living/carbon/human/proc/self_diagnostics()
	set name = "Self-Diagnostics"
	set desc = "Run an internal self-diagnostic to check for damage."
	set category = "IC"

	if(stat == DEAD) return

	to_chat(src, SPAN_NOTICE("Performing self-diagnostic, please wait..."))

	spawn(50)
		var/output = SPAN_NOTICE("Self-Diagnostic Results:\n")

		output += "Internal Temperature: [convert_k2c(bodytemperature)] Degrees Celsius\n"

		if(isSynthetic())
			output += "Current Battery Charge: [nutrition]\n"

		if(isSynthetic())
			var/toxDam = getToxLoss()
			if(toxDam)
				output += "System Instability: [SPAN_WARNING("[toxDam > 25 ? "Severe" : "Moderate"]")]. Seek charging station for cleanup.\n"
			else
				output += "System Instability: [SPAN_GREEN("OK\n")]"

		for(var/obj/item/organ/external/EO in organs)
			if(EO.robotic >= ORGAN_ASSISTED)
				if(EO.brute_dam || EO.burn_dam)
					output += "[EO.name] - [SPAN_WARNING("[EO.burn_dam + EO.brute_dam > EO.min_broken_damage ? "Heavy Damage" : "Light Damage"]")]\n"
				else
					output += "[EO.name] - [SPAN_GREEN("OK\n")]"

		for(var/obj/item/organ/IO in internal_organs)
			if(IO.robotic >= ORGAN_ASSISTED)
				if(IO.damage)
					output += "[IO.name] - [SPAN_WARNING("[IO.damage > 10 ? "Heavy Damage" : "Light Damage"]")]\n"
				else
					output += "[IO.name] - [SPAN_GREEN("OK\n")]"


		to_chat(src,output)

/mob/living/carbon/human/proc/setmonitor_state()
	set name = "Set monitor display"
	set desc = "Set your monitor display"
	set category = "IC"

	if(stat == DEAD) return

	var/obj/item/organ/external/head/E = organs_by_name[BP_HEAD]
	if(!E)
		to_chat(src, SPAN_WARNING("You don't seem to have a head!"))
		return

	var/datum/robolimb/robohead = GLOB.all_robolimbs[E.model]
	if(!robohead.monitor_styles || !robohead.monitor_icon)
		to_chat(src, SPAN_WARNING("Your head doesn't have a monitor, or it doesn't support being changed!"))
		return

	var/list/states
	if(!states)
		states = params2list(robohead.monitor_styles)
	var/choice = input("Select a screen icon.") as null|anything in states
	if(choice)
		E.eye_icon_location = robohead.monitor_icon
		E.eye_icon = states[choice]
		to_chat(src, SPAN_WARNING("You set your monitor to display [choice]!"))
		update_icons_body()

/mob/living/carbon/human

/mob/living/carbon/human/proc/sonar_ping()
	set name = "Sonar Pulse"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "Abilities"

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You need to recover before you can use this ability."))
		return
	if(is_deaf())
		to_chat(src, SPAN_WARNING("You are for all intents and purposes currently deaf!"))
		return
	if(!get_turf(src))
		to_chat(src, SPAN_WARNING("Not from here you can't."))
		return
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_SONAR_PULSE))
		to_chat(src, SPAN_WARNING("You need to wait some more to do that!"))
		return
	TIMER_COOLDOWN_START(src, COOLDOWN_SONAR_PULSE, 2 SECONDS)

	visible_message(
		SPAN_WARNING("[src] emits a quiet click."),
		SPAN_WARNING("You emit a quiet click."),
		SPAN_WARNING("You hear a quiet, high-pitched click.")
	)
	plane_holder.set_vis(VIS_SONAR, TRUE)
	var/datum/automata/wave/sonar/single_mob/sonar_automata = new
	sonar_automata.receiver = src
	sonar_automata.setup_auto(get_turf(src), 14)
	sonar_automata.start()
	addtimer(CALLBACK(plane_holder, /datum/plane_holder/proc/set_vis, VIS_SONAR, FALSE), 5 SECONDS, flags = TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/carbon/human/proc/regenerate()
	set name = "Regenerate"
	set desc = "Allows you to regrow limbs and heal organs after a period of rest."
	set category = "Abilities"

	if(nutrition < 250)
		to_chat(src, SPAN_WARNING("You lack the biomass to begin regeneration!"))
		return

	if(active_regen)
		to_chat(src, SPAN_WARNING("You are already regenerating tissue!"))
		return
	else
		active_regen = TRUE
		src.visible_message("<B>[src]</B>'s flesh begins to mend...")

	var/delay_length = round(active_regen_delay * species.active_regen_mult)
	if(do_after(src,delay_length))
		nutrition -= 200

		for(var/obj/item/organ/I in internal_organs)
			if(I.robotic >= ORGAN_ROBOT) // No free robofix.
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 30, 0) //Repair functionally half of a dead internal organ.
				I.status = 0	// Wipe status, as it's being regenerated from possibly dead.
				to_chat(src, SPAN_NOTICE("You feel a soothing sensation within your [I.name]..."))

		// Replace completely missing limbs.
		for(var/limb_type in src.species.has_limbs)
			var/obj/item/organ/external/E = src.organs_by_name[limb_type]

			if(E && E.disfigured)
				E.disfigured = 0
			if(E && (E.is_stump() || (E.status & (ORGAN_DESTROYED|ORGAN_DEAD|ORGAN_MUTATED))))
				E.removed()
				qdel(E)
				E = null
			if(!E)
				var/list/organ_data = src.species.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/O = new limb_path(src)
				organ_data["descriptor"] = O.name
				to_chat(src, SPAN_NOTICE("You feel a slithering sensation as your [O.name] reform."))

				var/agony_to_apply = round(0.66 * O.max_damage) // 66% of the limb's health is converted into pain.
				src.apply_damage(agony_to_apply, HALLOSS)

		for(var/organtype in species.has_organ) // Replace completely missing internal organs. -After- external ones, so they all should exist.
			if(!src.internal_organs_by_name[organtype])
				var/organpath = species.has_organ[organtype]
				var/obj/item/organ/Int = new organpath(src, TRUE)

				Int.rejuvenate(TRUE)

		handle_organs(2) // Update everything

		update_icons_body()
		active_regen = FALSE
	else
		to_chat(src, SPAN_NOTICE("Your regeneration is interrupted!"))
		nutrition -= 75
		active_regen = FALSE

/mob/living/carbon/human/proc/get_charge(var/mob/living/carbon/human/H)
	return H.nutrition

/mob/living/carbon/human/proc/spend_charge(var/spent, var/mob/living/carbon/human/H)
	H.nutrition = H.nutrition - spent

/mob/living/carbon/human/verb/toggle_eyes_layer()
	set name = "Switch Eyes/Monitor Layer"
	set desc = "Toggle rendering of eyes/monitor above markings."
	set category = "IC"

	if(stat)
		to_chat(src, SPAN_WARNING("You must be awake and standing to perform this action!"))
		return
	var/obj/item/organ/external/head/vr/H = organs_by_name[BP_HEAD]
	if(!H)
		to_chat(src, SPAN_WARNING("You don't seem to have a head!"))
		return

	H.eyes_over_markings = !H.eyes_over_markings
	update_icons_body()

	var/datum/robolimb/robohead = GLOB.all_robolimbs[H.model]
	if(robohead.monitor_styles && robohead.monitor_icon)
		to_chat(src, SPAN_NOTICE("You reconfigure the rendering order of your facial display."))

	return TRUE

/mob/living/carbon/human/proc/shadekin_get_energy()
	var/datum/species/shadekin/sk = species
	var/datum/species/crew_shadekin/besk = species

	if(istype(sk))
		return sk.get_energy(src)
	if(istype(besk))
		return besk.get_energy(src)
	return FALSE

/mob/living/carbon/human/proc/shadekin_get_max_energy()
	var/datum/species/shadekin/sk = species
	var/datum/species/crew_shadekin/besk = species

	if(istype(sk))
		return sk.get_max_energy(src)
	if(istype(besk))
		return besk.get_max_energy(src)
	return FALSE

/mob/living/carbon/human/proc/shadekin_set_energy(new_energy)
	var/datum/species/shadekin/sk = species
	var/datum/species/crew_shadekin/besk = species

	if(istype(sk))
		sk.set_energy(src, new_energy)
	if(istype(besk))
		sk.set_energy(src, new_energy)
	return FALSE

/mob/living/carbon/human/proc/shadekin_set_max_energy(new_max_energy)
	var/datum/species/shadekin/sk = species
	var/datum/species/crew_shadekin/besk = species

	if(istype(sk))
		sk.set_max_energy(src, new_max_energy)
	if(istype(besk))
		besk.set_max_energy(src, new_max_energy)
	return FALSE



/mob/living/carbon/human/proc/shadekin_adjust_energy(amount)
	var/datum/species/shadekin/sk = species
	var/datum/species/crew_shadekin/besk = species

	if(istype(sk))
		if(amount > 0 || !(sk.check_infinite_energy(src)))
			var/new_amount = sk.get_energy(src) + amount
			sk.set_energy(src, new_amount)
	if(istype(besk))
		if(amount > 0 || !(besk.check_infinite_energy(src)))
			var/new_amount = besk.get_energy(src) + amount
			besk.set_energy(src, new_amount)
	return FALSE
