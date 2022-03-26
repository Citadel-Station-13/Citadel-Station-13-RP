///////////////File for all snowflake/special races/////////////////////////////
/////Anything that is spectacularly special should be put in here///////////////
////////////////////////////////////////////////////////////////////////////////



/datum/species/shapeshifter/xenochimera //Scree's race.
	name = SPECIES_XENOCHIMERA
	name_plural = "Xenochimeras"
	icobase = 'icons/mob/human_races/r_xenochimera.dmi'
	deform = 'icons/mob/human_races/r_def_xenochimera.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	rarity_value = 4
	darksight = 8		//critters with instincts to hide in the dark need to see in the dark - about as good as tajara.
	slowdown = -0.2		//scuttly, but not as scuttly as a tajara or a teshari.
	brute_mod = 0.8		//About as tanky to brute as a Unathi. They'll probably snap and go feral when hurt though.
	burn_mod =  1.15	//As vulnerable to burn as a Tajara.
	radiation_mod = 1.15	//To help simulate the volatility of a living 'viral' cluster.
	base_species = "Xenochimera"
	selects_bodytype = TRUE

	num_alternate_languages = 5
	secondary_langs = list("Sol Common")

	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.
	tail = "tail" //Scree's tail. Can be disabled in the vore tab by choosing "hide species specific tail sprite"
	icobase_tail = 1
	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/shred_limb,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/eat_trash,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/carbon/human/proc/resp_biomorph,
		/mob/living/carbon/human/proc/biothermic_adapt,
		/mob/living/carbon/human/proc/atmos_biomorph,
		/mob/living/carbon/human/proc/vocal_biomorph,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/commune
		) //Xenochimera get all the special verbs since they can't select traits.

	inherent_spells = list(
		/spell/targeted/chimera/thermal_sight,
		/spell/targeted/chimera/voice_mimic,
		/spell/targeted/chimera/regenerate,
		/spell/targeted/chimera/hatch,
		/spell/targeted/chimera/no_breathe
	)

	var/list/feral_spells = list(
		/spell/aoe_turf/dissonant_shriek
	)

	var/list/removable_spells = list()

	var/has_feral_spells = FALSE
	virus_immune = 1 // They practically ARE one.
	min_age = 18
	max_age = 200

	blurb = "Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners. \
	Widely known for their voracious nature and violent tendencies when stressed or left unfed for long periods of time. \
	Most, if not all chimeras possess the ability to undergo some type of regeneration process, at the cost of energy."

	wikilink = "https://wiki.vore-station.net/Xenochimera"

	catalogue_data = list(/datum/category_item/catalogue/fauna/xenochimera)

	breath_type = /datum/gas/oxygen
	poison_type = /datum/gas/phoron
	exhale_type = /datum/gas/carbon_dioxide

	hazard_high_pressure = HAZARD_HIGH_PRESSURE
	warning_high_pressure = WARNING_HIGH_PRESSURE
	warning_low_pressure = WARNING_LOW_PRESSURE
	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	safe_pressure = ONE_ATMOSPHERE

	cold_level_1 = -1     // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	cold_discomfort_level = 285
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	heat_discomfort_level = 315
	heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)

	valid_transform_species = list(
		"Human", "Unathi", "Tajara", "Skrell",
		"Diona", "Teshari", "Monkey","Sergal",
		"Akula","Nevrean","Highlander Zorren",
		"Flatland Zorren", "Vulpkanin", "Vasilissan",
		"Rapala", "Neaera", "Stok", "Farwa", "Sobaka",
		"Wolpin", "Saru", "Sparra", "Vox")

	//primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE//Whitelisted as restricted is broken.
	flags = NO_SCAN | NO_INFECT | NO_DEFIB //Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart/xenochimera,
		O_LUNGS =    /obj/item/organ/internal/lungs/xenochimera,
		O_VOICE = 		/obj/item/organ/internal/voicebox/xenochimera,
		O_LIVER =    /obj/item/organ/internal/liver/xenochimera,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys/xenochimera,
		O_BRAIN =    /obj/item/organ/internal/brain/xenochimera,
		O_EYES =     /obj/item/organ/internal/eyes/xenochimera,
		O_STOMACH =		/obj/item/organ/internal/stomach/xenochimera,
		O_INTESTINE =	/obj/item/organ/internal/intestine/xenochimera
		)

	heal_rate = 0.5
	infect_wounds = 1
	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"

	reagent_tag = IS_CHIMERA

/datum/species/shapeshifter/xenochimera/handle_environment_special(var/mob/living/carbon/human/H)
	//If they're KO'd/dead, they're probably not thinking a lot about much of anything.
	if(!H.stat)
		handle_feralness(H)

	//While regenerating
	if(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE)
		H.weakened = 5
		H.canmove = 0
		H.does_not_breathe = TRUE

	//Cold/pressure effects when not regenerating
	else
		var/datum/gas_mixture/environment = H.loc.return_air()
		var/pressure2 = environment.return_pressure()
		var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

		//Very low pressure damage
		if(adjusted_pressure2 <= 20)
			H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")

		//Cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage or trigger feral.
		//NB: 'body_temperature' used here is the 'setpoint' species var
		var/temp_diff = body_temperature - H.bodytemperature
		if(temp_diff >= 50)
			H.shock_stage = min(H.shock_stage + (temp_diff/20), 160) // Divided by 20 is the same as previous numbers, but a full scale
			H.eye_blurry = max(5,H.eye_blurry)
	..()

/datum/species/shapeshifter/xenochimera/add_inherent_spells(var/mob/living/carbon/human/H)
	var/master_type = /atom/movable/screen/movable/spell_master/chimera
	var/atom/movable/screen/movable/spell_master/chimera/new_spell_master = new master_type

	if(!H.spell_masters)
		H.spell_masters = list()

	if(H.client)
		H.client.screen += new_spell_master
	new_spell_master.spell_holder = H
	H.spell_masters.Add(new_spell_master)

	for(var/spell_to_add in inherent_spells)
		var/spell/S = new spell_to_add(H)
		H.add_spell(S, "cult", master_type)

/datum/species/shapeshifter/xenochimera/proc/add_feral_spells(var/mob/living/carbon/human/H)
	if(!has_feral_spells)
		var/check = FALSE
		var/master_type = /atom/movable/screen/movable/spell_master/chimera
		for(var/spell/S as anything in feral_spells)
			var/spell/spell_to_add = new S(H)
			check = H.add_spell(spell_to_add, "cult", master_type)
			removable_spells += spell_to_add
		if(check)
			has_feral_spells = TRUE
		else
			return
	else
		return

/datum/species/shapeshifter/xenochimera/proc/remove_feral_spells(var/mob/living/carbon/human/H)
	for(var/spell/S as anything in removable_spells)
		S.remove_self(H)
	removable_spells.Cut()
	has_feral_spells = FALSE

/datum/species/shapeshifter/xenochimera/handle_post_spawn(mob/living/carbon/human/H)
	..()
	for(var/spell/S as anything in feral_spells)
		S = new S(H)

/datum/species/shapeshifter/xenochimera/proc/handle_feralness(var/mob/living/carbon/human/H)

	//Low-ish nutrition has messages and eventually feral
	var/hungry = H.nutrition <= 200

	//At 360 nutrition, this is 30 brute/burn, or 18 halloss. Capped at 50 brute/30 halloss - if they take THAT much, no amount of satiation will help them. Also they're fat.
	var/shock = H.traumatic_shock > min(60, H.nutrition/10)

	//Caffeinated xenochimera can become feral and have special messages
	var/jittery = H.jitteriness >= 100

	//To reduce distant object references
	var/feral = H.feral

//Are we in danger of ferality?
	var/danger = FALSE
	var/feral_state = FALSE

//Handle feral triggers and pre-feral messages
	if(!feral && (hungry || shock || jittery))

		// If they're hungry, give nag messages (when not bellied)
		if(H.nutrition >= 100 && prob(0.5) && !isbelly(H.loc))
			switch(H.nutrition)
				if(150 to 200)
					to_chat(H,"<span class='info'>You feel rather hungry. It might be a good idea to find some some food...</span>")
				if(100 to 150)
					to_chat(H,"<span class='warning'>You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat...</span>")
					danger = TRUE

		// Going feral due to hunger
		else if(H.nutrition < 100 && !isbelly(H.loc))
			to_chat(H,"<span class='danger'><big>Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.</big></span>")
			log_and_message_admins("has gone feral due to hunger.", H)
			feral = 5
			danger = TRUE
			feral_state = TRUE
			if(!H.stat)
				H.emote("twitch")

		// If they're hurt, chance of snapping.
		else if(shock)

			//If the majority of their shock is due to halloss, greater chance of snapping.
			if(2.5*H.halloss >= H.traumatic_shock)
				if(prob(min(10,(0.2 * H.traumatic_shock))))
					to_chat(H,"<span class='danger'><big>The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...</big></span>")
					log_and_message_admins("has gone feral due to halloss.", H)
					feral = 5
					danger = TRUE
					feral_state = TRUE
					if(!H.stat)
						H.emote("twitch")

			//Majority due to other damage sources
			else if(prob(min(10,(0.1 * H.traumatic_shock))))
				to_chat(H,"<span class='danger'><big>Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.</big></span>")
				feral = 5
				danger = TRUE
				feral_state = TRUE
				log_and_message_admins("has gone feral due to injury.", H)
				if(!H.stat)
					H.emote("twitch")

		//No hungry or shock, but jittery
		else if(jittery)
			to_chat(H,"<span class='warning'><big>Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!</big></span>")
			feral = 5
			danger = TRUE
			feral_state = TRUE
			log_and_message_admins("has gone feral due to jitteriness.", H)
			if(!H.stat)
				H.emote("twitch")

	// Handle being feral
	if(feral)
		//we're feral
		feral_state = TRUE

		//We check if the current spell list already has feral spells.
		if(!has_feral_spells)
			add_feral_spells(H)

		//Shock due to mostly halloss. More feral.
		if(shock && 2.5*H.halloss >= H.traumatic_shock)
			danger = TRUE
			feral = max(feral, H.halloss)

		//Shock due to mostly injury. More feral.
		else if(shock)
			danger = TRUE
			feral = max(feral, H.traumatic_shock * 2)

		//Still jittery? More feral.
		if(jittery)
			danger = TRUE
			feral = max(feral, H.jitteriness-100)

		//Still hungry? More feral.
		if(H.feral + H.nutrition < 150)
			danger = TRUE
			feral++
		else
			feral = max(0,--feral)

		//Set our real mob's var to our temp var
		H.feral = feral

		//Did we just finish being feral?
		if(!feral)
			feral_state = FALSE
			if(has_feral_spells)
				remove_feral_spells(H)
			to_chat(H,"<span class='info'>Your thoughts start clearing, your feral urges having passed - for the time being, at least.</span>")
			log_and_message_admins("is no longer feral.", H)
			update_xenochimera_hud(H, danger, feral_state)
			return

		//If they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.
		H.shock_stage = max(H.shock_stage-(feral/20), 0)

		//Handle light/dark areas
		var/turf/T = get_turf(H)
		if(!T)
			update_xenochimera_hud(H, danger, feral_state)
			return //Nullspace
		var/darkish = T.get_lumcount() <= 0.1

		//Don't bother doing heavy lifting if we weren't going to give emotes anyway.
		if(!prob(1))

			//This is basically the 'lite' version of the below block.
			var/list/nearby = H.living_mobs(world.view)

			//Not in the dark and out in the open.
			if(!darkish && isturf(H.loc))

				//Always handle feral if nobody's around and not in the dark.
				if(!nearby.len)
					H.handle_feral()

				//Rarely handle feral if someone is around
				else if(prob(1))
					H.handle_feral()

			//And bail
			update_xenochimera_hud(H, danger, feral_state)
			return

		// In the darkness or "hidden". No need for custom scene-protection checks as it's just an occational infomessage.
		if(darkish || !isturf(H.loc))
			// If hurt, tell 'em to heal up
			if (shock)
				to_chat(H,"<span class='info'>This place seems safe, secure, hidden, a place to lick your wounds and recover...</span>")

			//If hungry, nag them to go and find someone or something to eat.
			else if(hungry)
				to_chat(H,"<span class='info'>Secure in your hiding place, your hunger still gnaws at you. You need to catch some food...</span>")

			//If jittery, etc
			else if(jittery)
				to_chat(H,"<span class='info'>sneakysneakyyesyesyescleverhidingfindthingsyessssss</span>")

			//Otherwise, just tell them to keep hiding.
			else
				to_chat(H,"<span class='info'>...safe...</span>")

		// NOT in the darkness
		else

			//Twitch twitch
			if(!H.stat)
				H.emote("twitch")

			var/list/nearby = H.living_mobs(world.view)

			// Someone/something nearby
			if(nearby.len)
				var/M = pick(nearby)
				if(shock)
					to_chat(H,"<span class='danger'>You're hurt, in danger, exposed, and [M] looks to be a little too close for comfort...</span>")
				else if(hungry || jittery)
					to_chat(H,"<span class='danger'>Every movement, every flick, every sight and sound has your full attention, your hunting instincts on high alert... In fact, [M] looks extremely appetizing...</span>")

			// Nobody around
			else
				if(hungry)
					to_chat(H,"<span class='danger'>Confusing sights and sounds and smells surround you - scary and disorienting it may be, but the drive to hunt, to feed, to survive, compels you.</span>")
				else if(jittery)
					to_chat(H,"<span class='danger'>yesyesyesyesyesyesgetthethingGETTHETHINGfindfoodsfindpreypounceyesyesyes</span>")
				else
					to_chat(H,"<span class='danger'>Confusing sights and sounds and smells surround you, this place is wrong, confusing, frightening. You need to hide, go to ground...</span>")

	// HUD update time
	update_xenochimera_hud(H, danger, feral_state)

/datum/species/shapeshifter/xenochimera/proc/produceCopy(var/datum/species/to_copy,var/list/traits,var/mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = GLOB.all_species[to_copy]

	var/datum/species/shapeshifter/xenochimera/new_copy = new()

	//Initials so it works with a simple path passed, or an instance
	new_copy.base_species = to_copy.name
	new_copy.icobase = to_copy.icobase
	new_copy.deform = to_copy.deform
	new_copy.tail = to_copy.tail
	new_copy.tail_animation = to_copy.tail_animation
	new_copy.icobase_tail = to_copy.icobase_tail
	new_copy.color_mult = to_copy.color_mult
	new_copy.primitive_form = to_copy.primitive_form
	new_copy.appearance_flags = to_copy.appearance_flags
	new_copy.flesh_color = to_copy.flesh_color
	new_copy.base_color = to_copy.base_color
	new_copy.blood_mask = to_copy.blood_mask
	new_copy.damage_mask = to_copy.damage_mask
	new_copy.damage_overlays = to_copy.damage_overlays

	//Set up a mob
	H.species = new_copy
	H.icon_state = lowertext(new_copy.get_bodytype())

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy

/datum/species/shapeshifter/xenochimera/get_bodytype()
	return base_species

/datum/species/shapeshifter/xenochimera/get_race_key()
	var/datum/species/real = GLOB.all_species[base_species]
	return real.race_key

/datum/species/shapeshifter/xenochimera/proc/update_xenochimera_hud(var/mob/living/carbon/human/H, var/danger, var/feral)
	if(H.xenochimera_danger_display)
		H.xenochimera_danger_display.invisibility = 0
		if(danger && feral)
			H.xenochimera_danger_display.icon_state = "danger11"
		else if(danger && !feral)
			H.xenochimera_danger_display.icon_state = "danger10"
		else if(!danger && feral)
			H.xenochimera_danger_display.icon_state = "danger01"
		else
			H.xenochimera_danger_display.icon_state = "danger00"

	return

/atom/movable/screen/xenochimera
	icon = 'icons/mob/chimerahud.dmi'
	invisibility = 101

/atom/movable/screen/xenochimera/danger_level
	name = "danger level"
	icon_state = "danger00"		//first number is bool of whether or not we're in danger, second is whether or not we're feral
	alpha = 200

//Verbs Follow

/mob/living/carbon/human/proc/resp_biomorph(mob/living/carbon/human/target in view(1))
	set name = "Respiratory Biomorph"
	set desc = "Changes the gases we need to breathe."
	set category = "Chimera"

	var/list/gas_choices = list(
		"oxygen" = /datum/gas/oxygen,
		"phoron" = /datum/gas/phoron,
		"nitrogen" = /datum/gas/nitrogen,
		"carbon dioxide" = /datum/gas/carbon_dioxide
	)
	var/choice
	if(target && target != src)
		choice= input(src, "How should we modify their respiration?") as null|anything in gas_choices
	if(target == src)
		choice = input(src, "How should we adapt our respiration?") as null|anything in gas_choices
	if(!choice || !target)
		return
	if(target.isSynthetic())
		to_chat(src,"<span class = 'Notice'>We cannot change a being of metal!</span>")
		return
	var/resp_biomorph = gas_choices[choice]
	if(target == src)
		to_chat(src,"<span class = 'Notice'>We begin modifying our internal structure.</span>")
	else
		target.visible_message("<span class = 'danger'>[src] begins to burrow their digits into [target], slithering down their throat!</span>", "<span class = 'warning'>You feel an extremely uncomfortable slithering sensation going through your throat and into your chest...</span>")
	if(do_after(src,15 SECONDS))
		switch(resp_biomorph)
			if(/datum/gas/oxygen)
				target.species.breath_type = /datum/gas/oxygen
				target.species.poison_type = /datum/gas/phoron
				target.species.exhale_type = /datum/gas/carbon_dioxide
			if(/datum/gas/phoron)
				target.species.breath_type = /datum/gas/phoron
				target.species.poison_type = null
				target.species.exhale_type = /datum/gas/nitrogen
			if(/datum/gas/nitrogen)
				target.species.breath_type = /datum/gas/nitrogen
				target.species.poison_type = null
			if(/datum/gas/carbon_dioxide)
				target.species.breath_type = /datum/gas/carbon_dioxide
				target.species.exhale_type = /datum/gas/oxygen
		if(target == src)
			to_chat("<span class = 'Notice'>It is done.</span>")
		else
			if(prob(10))
				var/datum/disease2/disease/virus2 = new /datum/disease2/disease
				virus2.makerandom()
				infect_virus2(target, virus2)
				log_and_message_admins("Infected [target] with a virus. (Xenochimera)", src)
		target.visible_message("<span class = 'danger'>[src] pulls the tendrils out!</span>", "<span class = 'warning'>The sensation fades. You feel made anew.</span>")


/mob/living/carbon/human/proc/biothermic_adapt(mob/living/carbon/human/target in view(1))
	set name = "Biothermic Adaptation"
	set desc = "Changes our core body temperature."
	set category = "Chimera"

	var/list/temperature_options = list(
	"warm-blooded",
	"cold-blooded",
	"hot-blooded"
	)

	var/biothermic_adapt
	if(target && target != src)
		biothermic_adapt = input(src, "How should we modify their core temperature?") as null|anything in temperature_options
	if(target == src)
		biothermic_adapt = input(src, "How should we modify our core temperature?") as null|anything in temperature_options

	if(!biothermic_adapt || !target)
		return
	if(target.isSynthetic())
		to_chat(src,"<span class = 'Notice'>We cannot change a being of metal!</span>")
		return
	if(target == src)
		to_chat(src, "<span class = 'Notice'>We begin modifying our internal biothermic structure.</span>")
	else
		target.visible_message("<span class = 'danger'>[src] has fleshy tendrils emerge and begin slither inside the veins of [target]!</span>", "<span class = 'warning'>You feel an extremely uncomfortable slithering sensation going through your skin, your veins suddenly feeling as if they have bugs crawling inside...</span>")
	if(do_after(src,15 SECONDS))
		switch(biothermic_adapt)
			if("warm-blooded")	//reverts to default
				target.species.cold_discomfort_level = 285
				target.species.cold_level_1 = 260
				target.species.cold_level_2 = 180
				target.species.cold_level_3 = 100

				target.species.breath_cold_level_1 = 240
				target.species.breath_cold_level_2 = 160
				target.species.breath_cold_level_3 = 80

				target.species.heat_level_1 = 360
				target.species.heat_level_2 = 400
				target.species.heat_level_3 = 1000

				target.species.breath_heat_level_1 = 380
				target.species.breath_heat_level_2 = 450
				target.species.breath_heat_level_3 = 1250

				target.species.heat_discomfort_level = 315
			if("cold-blooded")
				target.species.cold_discomfort_level = T0C+21

				target.species.cold_level_1 = T0C+19
				target.species.cold_level_2 = T0C
				target.species.cold_level_3 = T0C - 15

				target.species.breath_cold_level_1 = T0C + 5
				target.species.breath_cold_level_2 = T0C - 10
				target.species.breath_cold_level_3 = T0C - 25

				target.species.heat_level_1 = 1000
				target.species.heat_level_2 = 1200
				target.species.heat_level_3 = 1400

				target.species.breath_heat_level_1 = 800
				target.species.breath_heat_level_2 = 1000
				target.species.breath_heat_level_3 = 1200

			if("hot-blooded")
				target.species.cold_level_1 = T0C - 75
				target.species.cold_level_2 = T0C - 100
				target.species.cold_level_3 = T0C - 125

				target.species.breath_cold_level_1 = T0C - 75
				target.species.breath_cold_level_2 = T0C - 100
				target.species.breath_cold_level_3 = T0C - 125

				target.species.heat_level_1 = T0C + 25
				target.species.heat_level_2 = T0C + 50
				target.species.heat_level_3 = T0C + 100

				target.species.breath_heat_level_1 = T0C + 50
				target.species.breath_heat_level_2 = T0C + 75
				target.species.breath_heat_level_3 = T0C + 100

				target.species.heat_discomfort_level = T0C+19
		if(target == src)
			to_chat(src, "<span class = 'Notice'>It is done.</span>")
		else
			if(prob(10))
				var/datum/disease2/disease/virus2 = new /datum/disease2/disease
				virus2.makerandom()
				infect_virus2(target, virus2)
				log_and_message_admins("Infected [target] with a virus. (Xenochimera)", src)
		target.visible_message("<span class = 'danger'>[src] pulls the tendrils out!</span>", "<span class = 'warning'>The sensation fades. You feel made anew.</span>")

/mob/living/carbon/human/proc/atmos_biomorph(mob/living/carbon/human/target in view(1))
	set name = "Atmospheric Biomorph"
	set desc = "Changes our sensitivity to atmospheric pressure."
	set category = "Chimera"


	var/list/pressure_options = list(
	"flexible",
	"compact",
	"elastic"
	)
	var/atmos_biomorph
	if(target && target != src)
		atmos_biomorph = input(src, "How should we modify their atmospheric sensitivity?") as null|anything in pressure_options
	if(target == src)
		atmos_biomorph = input(src, "How should we modify our atmospheric sensitivity?") as null|anything in pressure_options
	if(!atmos_biomorph || !target)
		return
	if(target.isSynthetic())
		to_chat(src,"<span class = 'Notice'>We cannot change a being of metal!</span>")
		return
	if(target == src)
		to_chat("<span class = 'Notice'>We begin modifying our skin...</span>")
	else
		target.visible_message("<span class = 'danger'>[src] has fleshy tendrils emerge and begin to merge and mold with [target]!</span>", "<span class = 'warning'>You feel an extremely uncomfortable slithering sensation going through your skin, it begins to feel foreign and dead, emanating from them...</span>")
	if(do_after(src,15 SECONDS))
		switch(atmos_biomorph)
			if("flexible")
				target.species.warning_low_pressure = WARNING_LOW_PRESSURE
				target.species.hazard_low_pressure = -1
				target.species.warning_high_pressure = WARNING_HIGH_PRESSURE
				target.species.hazard_high_pressure = HAZARD_HIGH_PRESSURE
			if("compact")
				target.species.warning_low_pressure = 50
				target.species.hazard_low_pressure = -1
			if("elastic")
				target.species.warning_high_pressure = WARNING_HIGH_PRESSURE + 200
				target.species.hazard_high_pressure = HAZARD_HIGH_PRESSURE + 400

		if(target == src)
			to_chat(src, "<span class = 'notice'>It is done.</span>")
		else
			if(prob(10))
				var/datum/disease2/disease/virus2 = new /datum/disease2/disease
				virus2.makerandom()
				infect_virus2(target, virus2)
				log_and_message_admins("Infected [target] with a virus. (Xenochimera)", src)
		target.visible_message("<span class = 'danger'>[src] pulls the tendrils out!</span>", "<span class = 'warning'>The sensation fades. You feel made anew.</span>")


/mob/living/carbon/human/proc/vocal_biomorph()
	set name = "Vocalization Biomorph"
	set desc = "Changes our speech pattern."
	set category = "Chimera"

	var/vocal_biomorph = input(src, "How should we adjust our speech?") as null|anything in list("common", "unathi", "tajaran")
	if(!vocal_biomorph)
		return
	to_chat(src, "You begin modifying your internal structure!")
	if(do_after(src,15 SECONDS))
		switch(vocal_biomorph)
			if("common")
				return
			if("unathi")
				species.autohiss_basic_map = list("s" = list("ss", "sss", "ssss"))
				species.autohiss_extra_map = list("x" = list("ks", "kss", "ksss"))
				species.autohiss_exempt = "Sinta'unathi"
			if("tajaran")
				species.autohiss_basic_map = list("r" = list("rr", "rrr", "rrrr"))
				species.autohiss_exempt = "Siik"

/////////////////////
/////SPIDER RACE/////
/////////////////////
/datum/species/spider //These actually look pretty damn spooky!
	name = SPECIES_VASILISSAN
	name_plural = "Vasilissans"
	icobase = 'icons/mob/human_races/r_spider.dmi'
	deform = 'icons/mob/human_races/r_def_spider.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing)
	darksight = 8		//Can see completely in the dark. They are spiders, after all. Not that any of this matters because people will be using custom race.
	slowdown = -0.15	//Small speedboost, as they've got a bunch of legs. Or something. I dunno.
	brute_mod = 0.8		//20% brute damage reduction
	burn_mod =  1.15	//15% burn damage increase. They're spiders. Aerosol can+lighter = dead spiders.

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_VESPINAE)
	color_mult = 1
	tail = "tail" //Spider tail.
	icobase_tail = 1

	is_weaver = TRUE
	silk_reserve = 500
	silk_max_reserve = 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_silk_amount,
		/mob/living/carbon/human/proc/toggle_silk_production,
		/mob/living/carbon/human/proc/weave_structure,
		/mob/living/carbon/human/proc/weave_item,
		/mob/living/carbon/human/proc/set_silk_color,
		/mob/living/carbon/human/proc/tie_hair
		)

	min_age = 18
	max_age = 80

	blurb = "Vasilissans are a tall, lanky, spider like people. \
	Each having four eyes, an extra four, large legs sprouting from their back, and a chitinous plating on their body, and the ability to spit webs \
	from their mandible lined mouths.  They are a recent discovery by Nanotrasen, only being discovered roughly seven years ago.  \
	Before they were found they built great cities out of their silk, being united and subjugated in warring factions under great Star Queens  \
	Who forced the working class to build huge, towering cities to attempt to reach the stars, which they worship as gems of great spiritual and magical significance."

	wikilink = "https://wiki.vore-station.net/Vasilissans"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vasilissan)

	hazard_low_pressure = 20 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -1    // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	//primitive_form = "Monkey" //I dunno. Replace this in the future.

	flags = NO_MINOR_CUT | CONTAMINATION_IMMUNE
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#0952EF" //Spiders have blue blood.

/datum/species/spider/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat == DEAD) // If they're dead they won't need anything.
		return

	if(H.bodytemperature <= 260) //If they're really cold, they go into stasis.
		var/coldshock = 0
		if(H.bodytemperature <= 260 && H.bodytemperature >= 200) //Chilly.
			coldshock = 4 //This will begin to knock them out until they run out of oxygen and suffocate or until someone finds them.
			H.eye_blurry = 5 //Blurry vision in the cold.
		if(H.bodytemperature <= 199 && H.bodytemperature >= 100) //Extremely cold. Even in somewhere like the server room it takes a while for bodytemp to drop this low.
			coldshock = 8
			H.eye_blurry = 5
		if(H.bodytemperature <= 99) //Insanely cold.
			coldshock = 16
			H.eye_blurry = 5
		H.shock_stage = min(H.shock_stage + coldshock, 160) //cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage.
		return

/datum/species/werebeast
	name = SPECIES_WEREBEAST
	name_plural = "Werebeasts"
	icobase = 'icons/mob/human_races/r_werebeast.dmi'
	deform = 'icons/mob/human_races/r_def_werebeast.dmi'
	icon_template = 'icons/mob/human_races/r_werebeast.dmi'
	tail = "tail"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	total_health = 200
	brute_mod = 0.85
	burn_mod = 0.85
	metabolic_rate = 2
	item_slowdown_mod = 0.25
	hunger_factor = 0.4
	darksight = 8
	mob_size = MOB_LARGE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_CANILUNZT)
	name_language = LANGUAGE_CANILUNZT
	primitive_form = "Wolpin"
	color_mult = 1

	min_age = 18
	max_age = 200

	blurb = "Big buff werewolves. These are a limited functionality event species that are not balanced for regular gameplay. Adminspawn only."

	wikilink="N/A"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/proc/eat_trash)

	flesh_color = "#AFA59E"
	base_color = "#777777"

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/vr/werebeast),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/////////////////////
/////INSECTOIDS/////
/////////////////////
/datum/species/apidaen
	name = SPECIES_APIDAEN
	name_plural = "Apidaen"
	icobase = 'icons/mob/human_races/r_def_apidaen.dmi'
	deform = 'icons/mob/human_races/r_def_apidaen.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 6		//Not quite as good as spiders. Meant to represent compound eyes and/or better hearing.
	slowdown = -0.10	//Speed boost similar to spiders, slightly nerfed due to two less legs.
	brute_mod = 0.8		//20% brute damage reduction seems fitting to match spiders, due to exoskeletons.
	burn_mod =  1.15	//15% burn damage increase, the same as spiders. For the same reason.

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_VESPINAE)
	color_mult = 1
	tail = "tail" //Bee tail. I've desaturated it for the sprite sheet.
	icobase_tail = 1

	reagent_tag = IS_APIDAEN

	inherent_verbs = list(
		/mob/living/carbon/human/proc/nectar_select,
		/mob/living/carbon/human/proc/nectar_pick,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair
		)

	min_age = 18
	max_age = 80

	blurb = "Apidaens are an insectoid race from the far galactic rim. \
	Although they have only recently been formally acknowledged on the Galactic stage, Apidaens are an aged and advanced spacefaring civilization. \
	Although their exact phyisololgy changes based on caste or other unknown selective qualities, Apidaens generally possess compound eyes, \
	between four to six limbs, and wings. Apidaens are able to produce a substance molecularly identical to honey in what is considered to be \
	a dramatic example of parallel evolution - or perhaps genetic tampering. Apidaens inhabit multiple planets in a chain of connected star systems, \
	preferring to live in hive-like structures - both subterranean and above ground. Apidaens possess some form of hive intelligence, although they still \
	exhibit individual identities and habits. This remnant hive connection is believed to be vestigial, but aids Apidaen navigators in charting courses \
	for their biomechanical Hive ships."

	wikilink = null

	catalogue_data = list(/datum/category_item/catalogue/fauna/apidaen)

	hazard_low_pressure = 20

	//primitive_form = "Monkey" //I dunno. Replace this in the future.

	flags = NO_MINOR_CUT
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#D8BB00" //Chitinous yellow.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#D3C77C" //Internet says Bee haemolymph is a 'pale straw' color.

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_VOICE =    /obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_SPLEEN =   /obj/item/organ/internal/spleen/minor,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes,
		O_STOMACH =	 /obj/item/organ/internal/stomach,
		O_INTESTINE =/obj/item/organ/internal/intestine,
		H_STOMACH =  /obj/item/organ/internal/honey_stomach
		)

//Did you know it's actually called a honey stomach? I didn't!
/obj/item/organ/internal/honey_stomach
	icon = 'icons/obj/surgery.dmi'
	icon_state = "innards"
	name = "honey stomach"
	desc = "A squishy enzymatic processor that turns airborne pollen into nectar."
	organ_tag = H_STOMACH
	var/generated_reagents = list("honey" = 5)
	var/usable_volume = 50
	var/transfer_amount = 50
	var/empty_message = list("You have no nectar inside.", "You have a distinct lack of nectar.")
	var/full_message = list("Your honey stomach is full!", "You have waxcomb that is ready to be regurgitated!")
	var/emote_descriptor = list("nectar fresh from the Apidae!", "nectar from the Apidae!")
	var/verb_descriptor = list("scoops", "coaxes", "collects")
	var/self_verb_descriptor = list("scoop", "coax", "collect")
	var/short_emote_descriptor = list("coaxes", "scoops")
	var/self_emote_descriptor = list("scoop", "coax", "heave")
	var/nectar_type = "nectar (honey)"
	var/mob/organ_owner = null
	var/gen_cost = 5

/obj/item/organ/internal/honey_stomach/Initialize(mapload)
	. = ..()
	create_reagents(usable_volume)

/obj/item/organ/internal/honey_stomach/process(delta_time)
	if(!owner) return
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	var/before_gen
	if(parent && generated_reagents && organ_owner) //Is it in the chest/an organ, has reagents, and is 'activated'
		before_gen = reagents.total_volume
		if(reagents.total_volume < reagents.maximum_volume)
			if(organ_owner.nutrition >= gen_cost)
				do_generation()

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(organ_owner, "<span class='notice'>[pick(empty_message)]</span>")
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(organ_owner, "<span class='warning'>[pick(full_message)]</span>")

/obj/item/organ/internal/honey_stomach/proc/do_generation()
	organ_owner.nutrition -= gen_cost
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])


/mob/living/carbon/human/proc/nectar_select() //So if someone doesn't want to vomit jelly, they don't have to.
	set name = "Produce Honey"
	set desc = "Begin producing honey."
	set category = "Abilities"
	var/obj/item/organ/internal/honey_stomach/honey_stomach
	for(var/F in contents)
		if(istype(F, /obj/item/organ/internal/honey_stomach))
			honey_stomach = F
			break

	if(honey_stomach)
		var/selection = input(src, "Choose your character's nectar. Choosing nothing will result in a default of honey.", "Nectar Type", honey_stomach.nectar_type) as null|anything in acceptable_nectar_types
		if(selection)
			honey_stomach.nectar_type = selection
		verbs |= /mob/living/carbon/human/proc/nectar_pick
		verbs -= /mob/living/carbon/human/proc/nectar_select
		honey_stomach.organ_owner = src
		honey_stomach.emote_descriptor = list("nectar fresh from [honey_stomach.organ_owner]!", "nectar from [honey_stomach.organ_owner]!")

	else
		to_chat(src, "<span class='notice'>You lack the organ required to produce nectar.</span>")
		return

/mob/living/carbon/human/proc/nectar_pick()
	set name = "Collect Waxcomb"
	set desc = "Coax waxcomb from [src]."
	set category = "Abilities"
	set src in view(1)
	var/mob/user = usr

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/organ/internal/honey_stomach/honey_stomach
	for(var/H in contents)
		if(istype(H, /obj/item/organ/internal/honey_stomach))
			honey_stomach = H
			break
	if (honey_stomach) //Do they have the stomach?
		if(honey_stomach.reagents.total_volume < honey_stomach.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(honey_stomach.empty_message)]</span>")
			return

		var/nectar_item_type = /obj/item/reagent_containers/organic/waxcomb

		new nectar_item_type(get_turf(user))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if (usr != src)
			return
		else
			visible_message("<span class='notice'>[src] [pick(honey_stomach.short_emote_descriptor)] nectar.</span>",
								"<span class='notice'>You [pick(honey_stomach.self_emote_descriptor)] up a bundle of waxcomb.</span>")
			honey_stomach.reagents.remove_any(honey_stomach.transfer_amount)

//End of repurposed honey stomach code.
