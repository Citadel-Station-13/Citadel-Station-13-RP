///////////////File for all snowflake/special races/////////////////////////////
/////Anything that is spectacularly special should be put in here///////////////
////////////////////////////////////////////////////////////////////////////////





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

	//primitive_form = SPECIES_MONKEY //I dunno. Replace this in the future.

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
	primitive_form = SPECIES_MONKEY_VULPKANIN
	color_mult = 1

	max_age = 200

	blurb = "Big buff werewolves. These are a limited functionality event species that are not balanced for regular gameplay. Adminspawn only."

	wikilink = "N/A"

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
	name_plural = SPECIES_APIDAEN
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

	//primitive_form = SPECIES_MONKEY //I dunno. Replace this in the future.

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
		O_HONEYSTOMACH =  /obj/item/organ/internal/honey_stomach
		)

//Did you know it's actually called a honey stomach? I didn't!
/obj/item/organ/internal/honey_stomach
	icon = 'icons/obj/surgery.dmi'
	icon_state = "innards"
	name = "honey stomach"
	desc = "A squishy enzymatic processor that turns airborne pollen into nectar."
	organ_tag = O_HONEYSTOMACH
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
