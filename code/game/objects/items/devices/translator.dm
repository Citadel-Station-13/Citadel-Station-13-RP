//Universal translator
/obj/item/universal_translator
	name = "handheld translator"
	desc = "This handy device appears to translate the languages it hears into onscreen text for a user."
	icon = 'icons/obj/device.dmi'
	icon_state = "translator"
	atom_flags = ATOM_HEAR
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	/// our translation context; set to path to start as path
	var/datum/translation_context/context = /datum/translation_context/simple/universal_translator

	var/mult_icons = 1	//Changes sprite when it translates
	var/visual = 1		//If you need to see to get the message
	var/audio = 0		//If you need to hear to get the message
	var/listening = 0
	var/datum/language/langset
	/// allow us to translate tapes
	var/cassette_translation = TRUE
	/// allow knowledge transfering
	var/allow_knowledge_transfer = TRUE

/obj/item/universal_translator/Initialize(mapload)
	. = ..()
	if(ispath(context))
		set_context(context)

/obj/item/universal_translator/Destroy()
	if(context && !ispath(context))
		QDEL_NULL(context)
	return ..()

/obj/item/universal_translator/proc/set_context(datum/translation_context/context_or_path)
	if(istype(context, /datum/translation_context/variable/learning))
		var/datum/translation_context/variable/learning/CTX = context
		CTX.on_train = null
	if(ispath(context_or_path))
		context_or_path = new context_or_path
	context = context_or_path
	if(istype(context, /datum/translation_context/variable/learning))
		var/datum/translation_context/variable/learning/CTX = context
		CTX.on_train = CALLBACK(src, .proc/on_learn)

/obj/item/universal_translator/proc/on_learn(datum/translation_context/context, datum/language/L, old_efficiency)
	if(old_efficiency)
		return
	if(!ismob(loc))
		return
	to_chat(loc, SPAN_NOTICE("New language detected. Beginning translation network training."))

/obj/item/universal_translator/examine(mob/user, dist)
	. = ..()
	if(cassette_translation)
		. += SPAN_NOTICE("Use a cassette tape on this to translate the tape's contents where possible.")

/obj/item/universal_translator/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cassette_tape))
		if(TIMER_COOLDOWN_CHECK(src, CD_INDEX_TAPE_TRANSLATION))
			user.action_feedback(SPAN_WARNING("[src] cannot translate tapes that fast."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/cassette_tape/T = I
		var/datum/cassette_tape_iterator/translator/iter = T.lock_for_translation()
		if(!iter)
			user.action_feedback(SPAN_WARNING("Could not lock [T] for translation."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/amt = iter.translate(context)
		user.action_feedback(SPAN_NOTICE("Translated [amt] lines on [T]. Processor cooling down for 10 seconds."), src)
		TIMER_COOLDOWN_START(src, CD_INDEX_TAPE_TRANSLATION, 10 SECONDS)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/universal_translator/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!isrobot(target))
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(!istype(context, /datum/translation_context/variable))
		user.action_feedback(SPAN_WARNING("[src] does not have a variable translation matrix."), src)
		return
	if(!allow_knowledge_transfer)
		user.action_feedback(SPAN_WARNING("[src] doesn't have a data port."), src)
		return
	var/mob/living/silicon/robot/R = target
	var/datum/translation_context/variable/theirs = R.translation_context
	if(!istype(theirs))
		user.action_feedback(SPAN_WARNING("[R] does not have a variable translation matrix."), src)
		return
	var/datum/translation_context/variable/ours = context
	ours.copy_knowledge(theirs)

/obj/item/universal_translator/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!listening) //Turning ON
		var/list/allowed = list()
		for(var/datum/language/L in user.languages)
			if(L.language_flags & (LANGUAGE_NONVERBAL | LANGUAGE_HIVEMIND))
				continue
			if(!context.can_translate(L))
				continue
			allowed += L
		if(!length(allowed))
			to_chat(user, SPAN_WARNING("There's no language you know that this can translate to."))
			return
		langset = input(user,"Translate to which of your languages?","Language Selection") as null|anything in allowed
		if(!langset)
			return
		listening = 1
		listening_objects |= src
		if(mult_icons)
			icon_state = "[initial(icon_state)]1"
		to_chat(user, "<span class='notice'>You enable \the [src], translating into [langset.name].</span>")
	else	//Turning OFF
		listening = 0
		listening_objects -= src
		langset = null
		icon_state = "[initial(icon_state)]"
		to_chat(user, "<span class='notice'>You disable \the [src].</span>")

/obj/item/universal_translator/hear_say(raw_message, message, name, voice_ident, atom/actor, remote, list/params, datum/language/lang, list/spans)
	. = ..()

	if(!listening || !istype(actor))
		return

	//Show the "I heard something" animation.
	if(mult_icons)
		flick("[initial(icon_state)]2",src)

	//Handheld or pocket only.
	if(!isliving(loc))
		return

	var/mob/living/L = loc

	if(!lang)
		return //Borgs were causing runtimes when passing language=null

	if (lang && (lang.language_flags & LANGUAGE_NONVERBAL))
		return //Not gonna translate sign language

	if (visual && ((L.sdisabilities & SDISABILITY_NERVOUS) || L.eye_blind))
		return //Can't see the screen, don't get the message

	if (audio && ((L.sdisabilities & SDISABILITY_DEAF) || L.ear_deaf))
		return //Can't hear the translation, don't get the message

	//Only translate if they can't understand, otherwise pointlessly spammy
	//I'll just assume they don't look at the screen in that case

	//They don't understand the spoken language we're translating FROM
	if(!L.say_understands(actor, lang))
		//They understand the output language
		if(L.say_understands(null,langset))
			to_chat(L, "<i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[context.attempt_translation(lang, actor, message)]</span>\"")

//Let's try an ear-worn version
/obj/item/universal_translator/ear
	name = "translator earpiece"
	desc = "This handy device appears to translate the languages it hears into another language for a user."
	icon_state = "earpiece"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	visual = 0
	audio = 1
	context = /datum/translation_context/simple/universal_translator

/obj/item/universal_translator/adaptive
	name = "handheld adaptive translator"
	desc = "This handheld translator has been upgraded with a positronic accelerator, allowing it to \
		slowly learn certain languages that wasn't originally included."
	context = /datum/translation_context/variable/learning/universal_translator

/obj/item/universal_translator/ear/adaptive
	name = "omni-translator earpiece"
	desc = "This earpiece translator has been upgraded with a positronic accelerator, allowing it to \
		slowly learn certain languages that wasn't originally included."
	context = /datum/translation_context/variable/learning/universal_translator

/datum/translation_context/simple/universal_translator
	translation_class = TRANSLATION_CLASSES_STANDARD_TRANSLATE

/datum/translation_context/variable/learning/universal_translator
	translation_class = TRANSLATION_CLASSES_STANDARD_TRANSLATE
	translation_class_learn = TRANSLATION_CLASSES_STANDARD_ADAPTIVE
