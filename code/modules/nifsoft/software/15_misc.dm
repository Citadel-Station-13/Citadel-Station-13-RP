/datum/nifsoft/apc_recharge
	name = "APC Connector"
	desc = "A small attachment that allows synthmorphs to recharge themselves from APCs."
	list_pos = NIF_APCCHARGE
	cost = 50
	wear = 2
	applies_to = NIF_SYNTHETIC
	tick_flags = NIF_ACTIVETICK
	var/obj/machinery/power/apc/apc
	other_flags = (NIF_O_APCCHARGE)

/datum/nifsoft/apc_recharge/activate()
	if((. = ..()))
		var/mob/living/carbon/human/H = nif.human
		apc = locate(/obj/machinery/power/apc) in get_step(H,H.dir)
		if(!apc)
			apc = locate(/obj/machinery/power/apc) in get_step(H,0)
		if(!apc)
			nif.notify("You must be facing an APC to connect to.",TRUE)
			spawn(0)
				deactivate()
			return FALSE

		H.visible_message(SPAN_WARNING("Thin snakelike tendrils grow from [H] and connect to \the [apc]."), \
			SPAN_NOTICE("Thin snakelike tendrils grow from you and connect to \the [apc]."))

/datum/nifsoft/apc_recharge/deactivate(var/force = FALSE)
	if((. = ..()))
		apc = null

/datum/nifsoft/apc_recharge/on_life(seconds, times_fired)
	if((. = ..()))
		var/mob/living/carbon/human/H = nif.human
		if((apc?.cell?.percent() > 1) && (get_dist(H,apc) <= 1) && H.nutrition < (H.species.max_nutrition - 1)) // 440 vs 450, life() happens before we get here so it'll never be EXACTLY 450
			var/needed = clamp(H.species.max_nutrition - H.nutrition, 0, 10)
			var/in_kj = SYNTHETIC_NUTRITION_KJ_PER_UNIT * needed
			var/got = apc.drain_energy(src, in_kj)
			H.adjust_nutrition(got / SYNTHETIC_NUTRITION_KJ_PER_UNIT)
			return TRUE
		else
			nif.notify("APC charging has ended.")
			H.visible_message(SPAN_WARNING("[H]'s snakelike tendrils whip back into their body from \the [apc]."), \
				SPAN_NOTICE("The APC connector tendrils return to your body."))
			deactivate()
			return FALSE

/datum/nifsoft/pressure
	name = "Pressure Seals"
	desc = "Creates pressure seals around important synthetic components to protect them from vacuum. Almost impossible on organics."
	list_pos = NIF_PRESSURE
	cost = 250
	a_drain = 0.5
	wear = 3
	applies_to = NIF_SYNTHETIC
	other_flags = (NIF_O_PRESSURESEAL)

/datum/nifsoft/heatsinks
	name = "Heat Sinks"
	desc = "Advanced heat sinks for internal heat storage of heat on a synth until able to vent it in atmosphere."
	list_pos = NIF_HEATSINK
	cost = 250
	a_drain = 0.25
	wear = 3
	var/used = 0
	tick_flags = NIF_ALWAYSTICK
	applies_to = NIF_SYNTHETIC
	other_flags = (NIF_O_HEATSINKS)

/datum/nifsoft/heatsinks/activate()
	if((. = ..()))
		if(used >= 1500)
			nif.notify("Heat sinks not safe to operate again yet! Max 75% on activation.",TRUE)
			spawn(0)
				deactivate()
			return FALSE

/datum/nifsoft/heatsinks/stat_text()
	return "[active ? "Active" : "Disabled"] (Stored Heat: [FLOOR((used/20), 1)]%)"

/datum/nifsoft/heatsinks/on_life()
	if((. = ..()))
		//Not being used, all clean.
		if(!active && !used)
			return TRUE

		//Being used, and running out.
		else if(active && ++used == 2000)
			nif.notify("Heat sinks overloaded! Shutting down!",TRUE)
			deactivate()

		//Being cleaned, and finishing empty.
		else if(!active && --used == 0)
			nif.notify("Heat sinks re-chilled.")

/datum/nifsoft/compliance
	name = "Compliance Module"
	desc = "A system that allows one to apply 'laws' to sapient life. Extremely illegal, of course."
	list_pos = NIF_COMPLIANCE
	cost = 1000
	wear = 4
	illegal = TRUE
	vended = FALSE
	access = 999 //Prevents anyone from buying it without an emag.
	var/laws = "Be nice to people!"

/datum/nifsoft/compliance/New(var/newloc,var/newlaws)
	laws = newlaws //Sanitize before this (the disk does)
	..(newloc)

/datum/nifsoft/compliance/activate()
	if((. = ..()))
		to_chat(nif.human,"<span class='danger'>You feel a strong compulsion towards these directives: </span><br><span class='notify'>[laws]</span>\
		<br><span class='danger'>While the disk has a considerable hold on your mind, you feel like you would be able to resist the control if you were pushed to do something you would consider utterly unacceptable.\
		<br>\[OOC NOTE: Compliance laws are only a scene tool, and not something that is effective in actual gameplay, hence the above. For example, if you are compelled to do something that would affect the round or other players (kill a crewmember, steal an item, give the disker elevated access), you should not do so.\]</span>")


/datum/nifsoft/compliance/install()
	if((. = ..()))
		log_game("[nif.human? nif.human : "ERROR: NO HUMAN ON NIF"] was compliance disked with [laws]")
		to_chat(nif.human,"<span class='danger'>You feel a strong compulsion towards these directives: </span><br><span class='notify'>[laws]</span>\
		<br><span class='danger'>While the disk has a considerable hold on your mind, you feel like you would be able to resist the control if you were pushed to do something you would consider utterly unacceptable.\
		<br>\[OOC NOTE: Compliance laws are only a scene tool, and not something that is effective in actual gameplay, hence the above. For example, if you are compelled to do something that would affect the round or other players (kill a crewmember, steal an item, give the disker elevated access), you should not do so.\]</span>")

/datum/nifsoft/compliance/uninstall()
	nif.notify("ERROR! Unable to comply!",TRUE)
	return FALSE //NOPE.

/datum/nifsoft/compliance/stat_text()
	return "Show Laws"

/datum/nifsoft/sizechange
	name = "Mass Alteration"
	desc = "A system that allows one to change their size, through drastic mass rearrangement. Causes significant wear when installed."
	list_pos = NIF_SIZECHANGE
	cost = 175 // this doesn't get nerfed that much because size shifters are annoying sorry
	wear = 6

/datum/nifsoft/sizechange/activate()
	if((. = ..()))
		var/new_size = input("Put the desired size (25-200%)", "Set Size", 200) as num

		if (!ISINRANGE(new_size,25,200))
			to_chat(nif.human, SPAN_NOTICE("The safety features of the NIF Program prevent you from choosing this size."))
			return
		else
			nif.human.resize(new_size/100)
			to_chat(nif.human, SPAN_NOTICE("You set the size to [new_size]%"))

		nif.human.visible_message(SPAN_WARNING("Swirling grey mist envelops [nif.human] as they change size!"), SPAN_NOTICE("Swirling streams of nanites wrap around you as you change size!"))
		nif.human.update_icons() //Apply matrix transform asap
		log_game("[key_name(nif.human)] was resized to [new_size / 100] scale via nifsoft.")

		if (new_size < 75)
			to_chat(nif.human, SPAN_WARNING("You get dizzy as the floor rushes up to you!"))
		else if(new_size > 125)
			to_chat(nif.human, SPAN_WARNING("You feel disoriented as the floor falls away from you!"))
		else
			to_chat(nif.human, SPAN_WARNING("You feel sick as your mass is rearranged!"))
		spawn(0)
			deactivate()

/datum/nifsoft/sizechange/stat_text()
	return "Change Size"

/datum/nifsoft/worldbend
	name = "World Bender"
	desc = "Alters your perception of various objects in the world. Only has one setting for now: displaying all your crewmates as farm animals."
	list_pos = NIF_WORLDBEND
	cost = 50
	a_drain = 0.01

/datum/nifsoft/worldbend/activate()
	if((. = ..()))
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			var/datum/atom_hud/world_bender/animals/A = GLOB.huds[WORLD_BENDER_HUD_ANIMALS]
			if(A && H)
				A.add_hud_to(H)

/datum/nifsoft/worldbend/deactivate(var/force = FALSE)
	if((. = ..()))
		var/mob/living/carbon/human/H = nif.human
		var/datum/atom_hud/world_bender/animals/A = GLOB.huds[WORLD_BENDER_HUD_ANIMALS]
		if(A && H)
			A.remove_hud_from(H)
