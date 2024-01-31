/datum/physiology_modifier/intrinsic/species/xenochimera
	carry_strength_add = CARRY_STRENGTH_ADD_XENOCHIMERA
	carry_strength_factor = CARRY_FACTOR_MOD_XENOCHIMERA

/datum/species/shapeshifter/xenochimera //Scree's race.
	uid = SPECIES_ID_XENOCHIMERA
	id = SPECIES_ID_XENOCHIMERA
	name = SPECIES_XENOCHIMERA
	name_plural = "Xenochimeras"
	base_species = SPECIES_XENOCHIMERA
	category = "Special"
	mob_physiology_modifier = /datum/physiology_modifier/intrinsic/species/xenochimera

	selects_bodytype = TRUE

	icobase      = 'icons/mob/species/xenochimera/body.dmi'
	deform       = 'icons/mob/species/xenochimera/deformed_body.dmi'
	preview_icon = 'icons/mob/species/xenochimera/preview.dmi'
	husk_icon    = 'icons/mob/species/xenochimera/husk.dmi'
	tail = "tail" //Scree's tail. Can be disabled in the Species Customization tab by choosing "hide species specific tail sprite"
	icobase_tail = 1

	max_additional_languages = 5

	vision_innate = /datum/vision/baseline/species_tier_3
	slowdown      = -0.2  //scuttly, but not as scuttly as a tajara or a teshari.
	brute_mod     = 0.8   //About as tanky to brute as a Unathi. They'll probably snap and go feral when hurt though.
	burn_mod      = 1.15  //As vulnerable to burn as a Tajara.
	radiation_mod = 1.15  //To help simulate the volatility of a living 'viral' cluster.

	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.

	virus_immune = TRUE // They practically ARE one.
	max_age = 200

	blurb = {"
	Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners.
	Widely known for their voracious nature and violent tendencies when stressed or left unfed for long periods of time.  Most, if not
	all chimeras possess the ability to undergo some type of regeneration process, at the cost of energy.
	"}
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_The_Xenochimera"
	catalogue_data = list(/datum/category_item/catalogue/fauna/xenochimera)

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.

	cold_level_1 = -1 // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	heal_rate = 0.5
	infect_wounds = TRUE

	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"

	reagent_tag = IS_CHIMERA

	valid_transform_species = list(
		SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_UNATHI_DIGI, SPECIES_TAJ, SPECIES_SKRELL,
		SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY,SPECIES_SERGAL,
		SPECIES_AKULA,SPECIES_NEVREAN,SPECIES_ZORREN_HIGH,
		SPECIES_ZORREN_FLAT, SPECIES_VULPKANIN, SPECIES_VASILISSAN,
		SPECIES_RAPALA, SPECIES_MONKEY_SKRELL, SPECIES_MONKEY_UNATHI,
		SPECIES_MONKEY_TAJ, SPECIES_MONKEY_AKULA, SPECIES_MONKEY_VULPKANIN,
		SPECIES_MONKEY_SERGAL, SPECIES_MONKEY_NEVREAN, SPECIES_VOX,
	)

	species_flags = NO_SCAN | NO_INFECT | NO_DEFIB //Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is.
	species_spawn_flags = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED  //Whitelisted as restricted is broken.
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

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

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	abilities = list(
		/datum/ability/species/xenochimera/regenerate,
		/datum/ability/species/xenochimera/thermal_sight,
		/datum/ability/species/xenochimera/voice_mimic,
		/datum/ability/species/xenochimera/hatch,
		/datum/ability/species/xenochimera/commune,
		/datum/ability/species/xenochimera/dissonant_shriek,
		/datum/ability/species/sonar,
		/datum/ability/species/toggle_flight,
	)

	inherent_verbs = list( //Xenochimera get all the special verbs since they can't select traits.
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
		/mob/living/proc/set_size,
		/mob/living/proc/shred_limb,
		/mob/living/proc/eat_trash,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/carbon/human/proc/resp_biomorph,
		/mob/living/carbon/human/proc/biothermic_adapt,
		/mob/living/carbon/human/proc/atmos_biomorph,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_horns,
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
	)

	var/has_feral_abilities = FALSE

/datum/species/shapeshifter/xenochimera/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
	//If they're KO'd/dead, they're probably not thinking a lot about much of anything.
	if(!H.stat)
		handle_feralness(H)

	//While regenerating
	if(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE)
		H.does_not_breathe = TRUE

	//Cold/pressure effects when not regenerating
	else
		//Cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage or trigger feral.
		//NB: 'body_temperature' used here is the 'setpoint' species var
		var/temp_diff = body_temperature - H.bodytemperature
		if(temp_diff >= 50)
			H.shock_stage = min(H.shock_stage + (temp_diff/20), 160) // Divided by 20 is the same as previous numbers, but a full scale
			H.eye_blurry = max(5,H.eye_blurry)
	..()

/datum/species/shapeshifter/xenochimera/proc/handle_feralness(var/mob/living/carbon/human/H)

	//Low-ish nutrition has messages and eventually feral
	var/hungry = H.nutrition <= 200 && !isbelly(H.loc)

	//At 360 nutrition, this is 30 brute/burn, or 18 halloss. Capped at 50 brute/30 halloss - if they take THAT much, no amount of satiation will help them. Also they're fat.
	var/shock = H.traumatic_shock > min(60, H.nutrition/10)

	//Caffeinated xenochimera can become feral and have special messages
	var/jittery = H.jitteriness >= 100

	//To reduce distant object references
	var/feral = H.feral

//Are we in danger of ferality?
	var/danger = FALSE

//Handle feral triggers and pre-feral messages
	if(!feral && (hungry || shock || jittery))
		// Did we go feral as a result of this check
		var/go_feral = FALSE

		// If they're hungry, give nag messages (when not bellied)
		if(H.nutrition >= 100 && prob(0.5))
			switch(H.nutrition)
				if(150 to 200)
					to_chat(H,"<span class='info'>You feel rather hungry. It might be a good idea to find some some food...</span>")
				if(100 to 150)
					to_chat(H,"<span class='warning'>You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat...</span>")
					danger = TRUE

		// Going feral due to hunger
		else if(H.nutrition < 100)
			to_chat(H,"<span class='danger'><big>Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.</big></span>")
			log_and_message_admins("has gone feral due to hunger.", H)
			go_feral = TRUE

		// If they're hurt, chance of snapping.
		else if(shock)
			//If the majority of their shock is due to halloss, greater chance of snapping.
			if(H.halloss >= H.traumatic_shock/2.5)
				if(prob(min(10,(0.2 * H.traumatic_shock))))
					to_chat(H,"<span class='danger'><big>The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...</big></span>")
					log_and_message_admins("has gone feral due to halloss.", H)
					go_feral = TRUE

			//Majority due to other damage sources
			else if(prob(min(10,(0.1 * H.traumatic_shock))))
				to_chat(H,"<span class='danger'><big>Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.</big></span>")
				log_and_message_admins("has gone feral due to injury.", H)
				go_feral = TRUE

		//No hungry or shock, but jittery
		else if(jittery)
			to_chat(H,"<span class='warning'><big>Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!</big></span>")
			log_and_message_admins("has gone feral due to jitteriness.", H)
			go_feral = TRUE

		if(go_feral)
			feral = 5
			danger = TRUE
			if(!H.stat)
				H.emote("twitch")

	// Handle being feral
	if(feral)
		has_feral_abilities = TRUE

		// check conditions and increase ferality if they are still met
		if(shock && H.halloss >= H.traumatic_shock/2.5)
			danger = TRUE
			feral = max(feral, H.halloss)

		else if(shock)
			danger = TRUE
			feral = max(feral, H.traumatic_shock * 2)

		if(jittery)
			danger = TRUE
			feral = max(feral, H.jitteriness-100)

		// if not hungry, reduce feral by 1
		if(H.feral + H.nutrition < 150)
			danger = TRUE
			feral++
		else
			feral = max(0,--feral)

		H.feral = feral

		//Handle no longer being feral
		if(!feral)
			has_feral_abilities = FALSE
			to_chat(H,"<span class='info'>Your thoughts start clearing, your feral urges having passed - for the time being, at least.</span>")
			log_and_message_admins("is no longer feral.", H)
			update_xenochimera_hud(H, danger, FALSE)
			return

		//If they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.
		H.shock_stage = max(H.shock_stage-(feral/20), 0)

		//Handle light/dark areas
		var/turf/T = get_turf(H)
		if(!T)
			update_xenochimera_hud(H, danger, TRUE)
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
			update_xenochimera_hud(H, danger, TRUE)
			return

		// In the darkness or "hidden". No need for custom scene-protection checks as it's just an occational infomessage based on the main feral conditions
		if(darkish || !isturf(H.loc))
			if (shock)
				to_chat(H,"<span class='info'>This place seems safe, secure, hidden, a place to lick your wounds and recover...</span>")

			else if(hungry)
				to_chat(H,"<span class='info'>Secure in your hiding place, your hunger still gnaws at you. You need to catch some food...</span>")

			else if(jittery)
				to_chat(H,"<span class='info'>sneakysneakyyesyesyescleverhidingfindthingsyessssss</span>")

			else
				to_chat(H,"<span class='info'>...safe...</span>")

		// NOT in the darkness
		else
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

	update_xenochimera_hud(H, danger, feral > 0)

/datum/species/shapeshifter/xenochimera/get_bodytype_legacy()
	return base_species

/datum/species/shapeshifter/xenochimera/get_race_key(mob/living/carbon/human/H)
	var/datum/species/real = SScharacters.resolve_species_name(base_species)
	return real.real_race_key(H)

/atom/movable/screen/xenochimera
	icon = 'icons/mob/chimerahud.dmi'
	invisibility = 101

/atom/movable/screen/xenochimera/danger_level
	name = "danger level"
	icon_state = "danger00"		//first number is bool of whether or not we're in danger, second is whether or not we're feral
	alpha = 200

/datum/species/shapeshifter/xenochimera/proc/update_xenochimera_hud(var/mob/living/carbon/human/H, var/danger, var/feral)
	if(H.xenochimera_danger_display)
		H.xenochimera_danger_display.invisibility = 0
		H.xenochimera_danger_display.icon_state = "danger[danger][feral > 0]"
	return

//Verbs Follow

/mob/living/carbon/human/proc/resp_biomorph(mob/living/carbon/human/target in view(1))
	set name = "Respiratory Biomorph"
	set desc = "Changes the gases we need to breathe."
	set category = "Abilities"

	var/list/gas_choices = list(
		"oxygen" = GAS_ID_OXYGEN,
		"phoron" = GAS_ID_PHORON,
		"nitrogen" = GAS_ID_NITROGEN,
		"carbon dioxide" = GAS_ID_CARBON_DIOXIDE
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
			if(GAS_ID_OXYGEN)
				target.species.breath_type = GAS_ID_OXYGEN
				target.species.poison_type = GAS_ID_PHORON
				target.species.exhale_type = GAS_ID_CARBON_DIOXIDE
			if(GAS_ID_PHORON)
				target.species.breath_type = GAS_ID_PHORON
				target.species.poison_type = null
				target.species.exhale_type = GAS_ID_NITROGEN
			if(GAS_ID_NITROGEN)
				target.species.breath_type = GAS_ID_NITROGEN
				target.species.poison_type = null
			if(GAS_ID_CARBON_DIOXIDE)
				target.species.breath_type = GAS_ID_CARBON_DIOXIDE
				target.species.exhale_type = GAS_ID_OXYGEN
		if(target == src)
			to_chat("<span class = 'Notice'>It is done.</span>")
		else
			if(prob(10))
				var/datum/disease2/disease/virus2 = new /datum/disease2/disease
				virus2.makerandom()
				infect_virus2(target, virus2)
				log_and_message_admins("Infected [target] with a virus. (Xenochimera)", src)
			target.visible_message(
				SPAN_DANGER("[src] pulls the tendrils out!"),
				SPAN_WARNING("The sensation fades. You feel made anew."),
			)


/mob/living/carbon/human/proc/biothermic_adapt(mob/living/carbon/human/target in view(1))
	set name = "Biothermic Adaptation"
	set desc = "Changes our core body temperature."
	set category = "Abilities"

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
			target.visible_message(
				SPAN_DANGER("[src] pulls the tendrils out!"),
				SPAN_WARNING("The sensation fades. You feel made anew."),
			)

/mob/living/carbon/human/proc/atmos_biomorph(mob/living/carbon/human/target in view(1))
	set name = "Atmospheric Biomorph"
	set desc = "Changes our sensitivity to atmospheric pressure."
	set category = "Abilities"


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
			target.visible_message(
				SPAN_DANGER("[src] pulls the tendrils out!"),
				SPAN_WARNING("The sensation fades. You feel made anew."),
			)

//? Abilities

/datum/ability/species/xenochimera
	abstract_type = /datum/ability/species/xenochimera
	category = "Xenochimera"
	ability_check_flags = NONE
	always_bind = TRUE
	action_icon = 'icons/screen/actions/actions.dmi'

	var/nutrition_cost_minimum = 50
	var/nutrition_cost_proportional = 20 //percentage of nutriment it should cost if it's higher than the minimum
	var/nutrition_enforced = TRUE
	var/is_feral = FALSE

/datum/ability/species/xenochimera/check_trigger(mob/user, toggling)
	. = ..()
	if(!.)
		return
	if(!ishuman(owner))
		return FALSE
	if(istype(owner,/mob/living/carbon/human))		//is there seriously no better way
		var/mob/living/carbon/human/H = owner
		if(H.species.get_species_id() == SPECIES_ID_XENOCHIMERA)
			var/datum/species/shapeshifter/xenochimera/X = H.species
			if(X.has_feral_abilities)
				return TRUE	//hunger limits don't apply when feral

	var/mob/living/carbon/human/H = owner
	if(nutrition_enforced)
		if(nutrition_cost_minimum > H.nutrition)
			to_chat(user,"<span class = 'notice'>We don't have enough nutriment. This ability is costly.</span>")
			return FALSE
	else
		return TRUE


/datum/ability/species/xenochimera/on_trigger(mob/user, toggling)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/nut = (H.nutrition * nutrition_cost_proportional) / 100
	var/final_cost
	if(nut > nutrition_cost_minimum)
		final_cost = nut
	else
		final_cost = nutrition_cost_minimum

	if((H.nutrition - final_cost) >= 0)
		H.nutrition -= final_cost
	else
		H.nutrition = 0		//We're already super starved, and feral, so cast it for free, you're likely using it to get food at this point.

		////////////////
		//Regeneration//
		////////////////
/datum/ability/species/xenochimera/regenerate
	name = "Regeneration"
	desc = "We shed our skin, purging it of damage, regrowing limbs."
	action_state = "ling_fleshmend"
	nutrition_cost_minimum = 150
	nutrition_cost_proportional = 30
	nutrition_enforced = TRUE
	cooldown = 1 MINUTE
	windup = 10 SECONDS
	var/healing_amount = 60

/datum/ability/species/xenochimera/regenerate/on_trigger()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.restore_blood()
	H.species.create_organs(H, TRUE)
	H.restore_all_organs()
	H.adjustBruteLoss(-healing_amount)
	H.adjustFireLoss(-healing_amount)
	H.adjustOxyLoss(-healing_amount)
	H.adjustCloneLoss(-healing_amount)
	H.adjustBrainLoss(-healing_amount)
	H.blinded = FALSE
	H.SetBlinded(FALSE)
	H.eye_blurry = FALSE
	H.ear_deaf = FALSE
	H.ear_damage = FALSE

	H.regenerate_icons()

	playsound(H, 'sound/effects/blobattack.ogg', 30, 1)
	var/T = get_turf(src)
	new /obj/effect/gibspawner/human(T, H.dna,H.dna.blood_color,H.dna.blood_color)
	H.visible_message("<span class='warning'>With a sickening squish, [src] reforms their whole body, casting their old parts on the floor!</span>",
	"<span class='notice'>We reform our body.  We are whole once more.</span>",
	"<span class='italics'>You hear organic matter ripping and tearing!</span>")

////////////////////////
//Timed thermal sight.//
////////////////////////
/datum/ability/species/xenochimera/thermal_sight
	name = "Thermal Sight"
	desc = "We focus ourselves, able to sense prey and threat through walls or mist. We cannot sustain this for long."
	action_state = "ling_augmented_eyesight"
	cooldown = 35 SECONDS
	nutrition_cost_minimum = 15		//The hungrier you get the less it will cost
	nutrition_cost_proportional = 10
	var/active = FALSE
	var/duration = 30 SECONDS

/datum/ability/species/xenochimera/thermal_sight/on_trigger()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	toggle_sight(owner)
	addtimer(CALLBACK(src, PROC_REF(toggle_sight),H), duration, TIMER_UNIQUE)

/datum/ability/species/xenochimera/thermal_sight/proc/toggle_sight(mob/living/carbon/human/H)
	if(!active)
		to_chat(H, "<span class='notice'>We focus outward, gaining a keen sense of all those around us.</span>")
		H.species.vision_flags |= SEE_MOBS
		H.species.vision_flags &= ~SEE_BLACKNESS
		H.species.has_glowing_eyes = TRUE
		H.add_vision_modifier(/datum/vision/augmenting/legacy_ghetto_nvgs)
		active = TRUE
	else
		to_chat(H, "<span class='notice'>Our senses dull.</span>")
		H.species.vision_flags &= ~SEE_MOBS
		H.species.vision_flags |= SEE_BLACKNESS
		H.species.has_glowing_eyes = FALSE
		H.remove_vision_modifier(/datum/vision/augmenting/legacy_ghetto_nvgs)
		active = FALSE
	H.update_eyes()

///////////////
//Voice Mimic//
///////////////
//It's a toggle, but doesn't cost nutriment to be toggled off
/datum/ability/species/xenochimera/voice_mimic
	name = "Voice Mimicry"
	desc = "We shape our throat and tongue to imitate a person, or a sound. This ability is a toggle."
	action_state = "ling_mimic_voice"
	cooldown = 5 SECONDS
	nutrition_cost_minimum = 25
	nutrition_cost_proportional = 5
	var/active = FALSE

/datum/ability/species/xenochimera/voice_mimic/on_trigger()
	. = ..()
	if(owner.stat != DEAD)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			if(!active)
				var/mimic_voice = sanitize(input(usr, "Enter a name to mimic. Leave blank to cancel.", "Mimic Voice", null), MAX_NAME_LEN)
				if(!mimic_voice)
					return

				to_chat(owner, "<span class='notice'>We shift and morph our tongues, ready to reverberate as: <b>[mimic_voice]</b>.</span>")
				H.SetSpecialVoice(mimic_voice)
				active = TRUE
				..()	//Processes nutriment cost
			else
				to_chat(owner, "<span class='notice'>We return our voice to our normal identity.</span>")
				H.UnsetSpecialVoice()
				active = FALSE
		else
			return

///////////////
//EMP Shriek //
///////////////
//Only to be used during feral state, has a very long cooldown. Mostly to get away.

/datum/ability/species/xenochimera/dissonant_shriek
	name = "Dissonant Shriek"
	desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."
	action_state = "ling_resonant_shriek"
	range = 8
	//Slightly more potent than an EMP grenade
	var/emp_heavy = 3
	var/emp_med = 6
	var/emp_light = 9
	var/emp_long = 12
	var/smoke_spread = 1
	var/smoke_amt = 1
	cooldown = 10 MINUTES	//Let's not be able to spam this
	nutrition_enforced = TRUE
	is_feral = TRUE


/datum/ability/species/xenochimera/dissonant_shriek/on_trigger()
	. = ..()

	if(owner.incapacitated())
		return

	for(var/mob/living/T in get_hearers_in_view(range, owner))
		if(iscarbon(T))
			if(T.mind)
				if(T.get_ear_protection() >= 2 || T == owner)
					continue
				to_chat(T, "<span class='danger'>You hear an extremely loud screeching sound!  It slightly \
				[pick("confuses","confounds","perturbs","befuddles","dazes","unsettles","disorients")] you.</span>")
				T.Confuse(10)
	playsound(get_turf(owner),'sound/effects/screech.ogg', 75, TRUE)

	empulse(get_turf(owner), emp_heavy, emp_med, emp_light, emp_long)

	owner.visible_message("<span class='danger'>[owner] vibrates and bubbles, letting out an inhuman shriek, reverberating through your ears!</span>")

	add_attack_logs(owner,null,"Used dissonant shriek (Xenochimera) ")

	for(var/obj/machinery/light/L in range(range, src))
		L.on = TRUE
		L.broken()

/datum/ability/species/xenochimera/dissonant_shriek/available_check()
	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner
	if(H.species.get_species_id() == SPECIES_ID_XENOCHIMERA)
		var/datum/species/shapeshifter/xenochimera/X = H.species
		if(X.has_feral_abilities)
			return TRUE
		else
			..()
	..()

//////////////////
//Revive ability//
//////////////////
//Will incapacitate you for 10 minutes, and then you can revive.
/datum/ability/species/xenochimera/hatch
	name = "Hatch Stasis"
	desc = "We attempt to grow an entirely new body from scratch, or death."
	action_state = "ling_regenerative_stasis"
	cooldown = 30 MINUTES
	nutrition_cost_minimum = 1
	nutrition_cost_proportional = 1
	nutrition_enforced = FALSE

/datum/ability/species/xenochimera/hatch/check_trigger(mob/user, toggling, feedback)
	if(!..())
		return FALSE
	else
		return alert("Are you sure you want to use Hatch Stasis? This takes ten minutes and cannot be cancelled!", "Confirm Hatch", "Yes", "No") == "Yes"

/datum/ability/species/xenochimera/hatch/on_trigger()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.stat == DEAD)
			H.visible_message("<span class = 'warning'> [H] lays eerily still. Something about them seems off, even when dead.</span>","<span class = 'notice'>We begin to gather up whatever is left to begin regrowth.</span>")
		else
			H.visible_message("<span class = 'warning'> [H] suddenly collapses, seizing up and going eerily still. </span>", "<span class = 'notice'>We begin the regrowth process to start anew.</span>")
			H.set_unconscious(8000) //admin style self-stun

		//These are only messages to give the player and everyone around them an idea of which stage they're at
		//visible_message doesn't seem to relay selfmessages if you're paralysed, so we use to_chat
		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom, visible_message),"<span class = 'warning'> [H]'s skin begins to ripple and move, as if something was crawling underneath.</span>"), 4 MINUTES)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat),H,"<span class = 'notice'>We begin to recycle the dead tissue.</span>"), 2 MINUTES)

		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom, visible_message),"<span class = 'warning'> <i>[H]'s body begins to lose its shape, skin sloughing off and melting, losing form and composure.</i></span>","<span class = 'notice'>There is little left. We will soon be ready.</span>"), 8 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat),H,"<span class = 'notice'>There is little left. We will soon be ready.</span>"), 4 MINUTES)

		addtimer(CALLBACK(src, PROC_REF(add_pop),H,), 5 MINUTES)

/datum/ability/species/xenochimera/hatch/proc/add_pop()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.visible_message("<span class = 'warning'> <b>[H] looks ready to burst!</b></span>")
		to_chat(H,"<span class = 'notice'><b>We are ready.</b></span>")
		var/datum/ability/species/xenochimera/hatch_pop/pop = new()
		pop.associate(owner)


/////////////////////////
//Actual Revive Ability//
/////////////////////////
//Not to be used normally. Given by the 'hatch' ability
/datum/ability/species/xenochimera/hatch_pop
	name = "Emerge"
	desc = "We emerge in our new form."
	action_state = "ling_revive"
	cooldown = 10 SECONDS	//It gets removed after_cast anyway
	nutrition_enforced = FALSE
	nutrition_cost_minimum = 1
	nutrition_cost_proportional = 1

/datum/ability/species/xenochimera/hatch_pop/on_trigger()
	. = ..()
	var/mob/living/carbon/human/H = owner

	H.revive(full_heal = TRUE)
	H.remove_all_restraints()
	LAZYREMOVE(H.mutations, MUTATION_HUSK)
	H.nutrition = 50		//Hungy, also guarantees ferality without any other tweaking

	//Drop everything
	H.drop_inventory(TRUE, TRUE)
	H.visible_message("<span class = 'warning'>[H] emerges from a cloud of viscera!</b>")
	H.set_unconscious(0)
	//Unfreeze some things
	H.does_not_breathe = FALSE
	H.update_mobility()
	H.set_paralyzed(2)
	//Visual effects
	var/T = get_turf(H)
	new /obj/effect/gibspawner/human(T, H.dna,H.dna.blood_color,H.dna.blood_color)
	playsound(T, 'sound/effects/splat.ogg')
	disassociate(owner)
	qdel(src)

//////////////////////////////
//Commune / Psychic Messages//
//////////////////////////////

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
