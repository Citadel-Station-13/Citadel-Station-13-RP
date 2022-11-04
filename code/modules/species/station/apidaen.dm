/datum/species/apidaen
	name = SPECIES_APIDAEN
	name_plural = SPECIES_APIDAEN
	uid = SPECIES_ID_APIDAEN

	icobase      = 'icons/mob/species/apidaen/body.dmi'
	deform       = 'icons/mob/species/apidaen/body.dmi' // No deformed set has been made yet.
	preview_icon = 'icons/mob/species/apidaen/preview.dmi'
	husk_icon    = 'icons/mob/species/apidaen/husk.dmi'
	tail = "tail" //Bee tail. I've desaturated it for the sprite sheet.
	icobase_tail = 1

	darksight = 6     // Not quite as good as spiders. Meant to represent compound eyes and/or better hearing.
	slowdown  = -0.10 // Speed boost similar to spiders, slightly nerfed due to two less legs.
	brute_mod = 0.8   // 20% brute damage reduction seems fitting to match spiders, due to exoskeletons.
	burn_mod  = 1.15  // 15% burn damage increase, the same as spiders. For the same reason.

	max_additional_languages = 2
	intrinsic_languages = LANGUAGE_ID_VASILISSAN

	reagent_tag = IS_APIDAEN

	max_age = 80

	blurb = {"
	Apidaens are an insectoid race from the far galactic rim.  Although they have only recently been formally
	acknowledged on the Galactic stage, Apidaens are an aged and advanced spacefaring civilization.  Although their exact
	phyisololgy changes based on caste or other unknown selective qualities, Apidaens generally possess compound eyes, between
	four to six limbs, and wings.  Apidaens are able to produce a substance molecularly identical to honey in what is considered
	to be a dramatic example of parallel evolution - or perhaps genetic tampering.  Apidaens inhabit multiple planets in
	a chain of connected star systems, preferring to live in hive-like structures - both subterranean and above ground.

	Apidaens possess some form of hive intelligence, although they still exhibit individual identities and habits.  This
	remnant hive connection is believed to be vestigial, but aids Apidaen navigators in charting courses for their biomechanical
	Hive ships.
	"}

	wikilink = null
	catalogue_data = list(/datum/category_item/catalogue/fauna/apidaen)

	hazard_low_pressure = 20

	//primitive_form = SPECIES_MONKEY //I dunno. Replace this in the future.

	species_flags = NO_MINOR_CUT
	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	color_mult = 1
	flesh_color = "#D8BB00" // Chitinous yellow.
	base_color 	= "#333333" // Blackish-gray
	blood_color = "#D3C77C" // Internet says Bee haemolymph is a 'pale straw' color.

	has_organ = list(
		O_HEART        = /obj/item/organ/internal/heart,
		O_LUNGS        = /obj/item/organ/internal/lungs,
		O_VOICE        = /obj/item/organ/internal/voicebox,
		O_LIVER        = /obj/item/organ/internal/liver,
		O_KIDNEYS      = /obj/item/organ/internal/kidneys,
		O_SPLEEN       = /obj/item/organ/internal/spleen/minor,
		O_BRAIN        = /obj/item/organ/internal/brain,
		O_EYES         = /obj/item/organ/internal/eyes,
		O_STOMACH      = /obj/item/organ/internal/stomach,
		O_INTESTINE    = /obj/item/organ/internal/intestine,
		O_HONEYSTOMACH = /obj/item/organ/internal/honey_stomach,
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/nectar_select,
		/mob/living/carbon/human/proc/nectar_pick,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
	)

// Did you know it's actually called a honey stomach? I didn't!
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
	var/gen_cost = 5

/obj/item/organ/internal/honey_stomach/Initialize(mapload)
	. = ..()
	create_reagents(usable_volume)

/obj/item/organ/internal/honey_stomach/tick_life(dt)
	. = ..()
	if(.)
		return

	var/before_gen = reagents.total_volume
	if(reagents.total_volume < reagents.maximum_volume)
		if(owner.nutrition >= gen_cost)
			do_generation()

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(owner, SPAN_NOTICE("[pick(empty_message)]"))
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(owner, SPAN_WARNING("[pick(full_message)]"))

/obj/item/organ/internal/honey_stomach/proc/do_generation()
	owner.nutrition -= gen_cost
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])

/// So if someone doesn't want to vomit jelly, they don't have to.
/mob/living/carbon/human/proc/nectar_select()
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
		honey_stomach.emote_descriptor = list("nectar fresh from [honey_stomach.owner]!", "nectar from [honey_stomach.owner]!")

	else
		to_chat(src, SPAN_NOTICE("You lack the organ required to produce nectar."))
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
			to_chat(src, SPAN_NOTICE("[pick(honey_stomach.empty_message)]"))
			return

		var/nectar_item_type = /obj/item/reagent_containers/organic/waxcomb

		new nectar_item_type(get_turf(user))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if (usr != src)
			return
		else
			visible_message(
				SPAN_NOTICE("[src] [pick(honey_stomach.short_emote_descriptor)] nectar."),
				SPAN_NOTICE("You [pick(honey_stomach.self_emote_descriptor)] up a bundle of waxcomb."),
			)
			honey_stomach.reagents.remove_any(honey_stomach.transfer_amount)

//End of repurposed honey stomach code.
