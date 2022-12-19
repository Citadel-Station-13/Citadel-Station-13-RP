/**
 * handles language translation
 *
 * individual context defines are scattered throughout the code
 * use find all implementations to find them!
 */
/datum/translation_context

/**
 * returns if we can translate something
 * partial/wrong translations are still translations
 *
 * @params
 * - L - the language
 * - speaker - guy talking, optional
 * - require_perfect - must be perfect translation; used by tape recorders
 */
/datum/translation_context/proc/can_translate(datum/language/L, atom/movable/speaker, require_perfect)
	CRASH("not implemented")

/**
 * translates a message
 * **warning**: translation doesn't always handle mid-message spans/formatting
 * we split words using the " " space character.
 *
 * should have **zero** side effects
 *
 * @return the translated message
 */
/datum/translation_context/proc/translate(datum/language/L, atom/movable/speaker, msg)
	PROTECTED_PROC(TRUE)	// please use attempt_translation.
	CRASH("not implemented")

/**
 * attempts to translate a message
 * has possible side effects like learning the language gradually
 *
 * @params
 * - L - the language
 * - speaker - guy talking, optional
 * - msg - the message to translate
 * - require_perfect - must be perfect translate; used by tape recorders
 */
/datum/translation_context/proc/attempt_translation(datum/language/L, atom/movable/speaker, msg, require_perfect)
	CRASH("not implemented")

/**
 * todo: for future implementation
 * directly modifies
 */

/**
 * directly translates languages; it either succeeds or fails
 */
/datum/translation_context/simple
	/// classes we can translate directly
	var/translation_class = NONE
	/// classes we cannot translate; overrides translation_class
	var/translation_class_forbid = NONE
	/// lazy assoclist of ids we can translate (secondary lookup); overrides all
	var/list/translated_ids

/datum/translation_context/simple/New()
	..()
	if(has_typelist(NAMEOF(src, translated_ids)))
		translated_ids = get_typelist(NAMEOF(src, translated_ids))
	else
		translated_ids = typelist(src, make_associative_inplace_keep_values(translated_ids))

/datum/translation_context/simple/can_translate(datum/language/L, atom/movable/speaker, require_perfect)
	if(translated_ids?[L.id])
		return TRUE
	return (translation_class & L.translation_class) && !(translation_class_forbid & L.translation_class)

/datum/translation_context/simple/attempt_translation(datum/language/L, atom/movable/speaker, msg, require_perfect)
	if(!can_translate(L, speaker))
		return null
	return translate(L, speaker, msg)

/datum/translation_context/simple/translate(datum/language/L, atom/movable/speaker, msg)
	return msg

/**
 * variable language translator
 *
 * todo: efficiency "sharing" for similar languages
 *
 * it can either fully translate,
 * fail to translate,
 * or partially translate
 */
/datum/translation_context/variable
	/// classes we can translate directly
	var/translation_class = NONE
	/// classes we cannot translate; overrides translation_class
	var/translation_class_forbid = NONE
	/// lazy assoclist of ids we can translate (secondary lookup); overrides all; also serves as efficiency;
	/// set to 1 or don't set anything for normal perfect behaviour
	var/list/translated_ids
	/// default efficiency
	var/translate_factor = 0
	/// are translated ids cloned? if not, we shouldn't modify directly due to typelists
	var/translated_list_detached = FALSE

/datum/translation_context/variable/New()
	..()
	if(has_typelist(NAMEOF(src, translated_ids)))
		translated_ids = get_typelist(NAMEOF(src, translated_ids))
	else
		for(var/id in translated_ids)
			if(!isnull(translated_ids[id]))
				continue
			translated_ids[id] = translate_factor
		translated_ids = typelist(src, make_associative_inplace_keep_values(translated_ids))

/datum/translation_context/variable/Destroy()
	translated_ids = null
	return ..()

/datum/translation_context/variable/proc/detach_translated_ids()
	if(translated_list_detached)
		return
	translated_ids = translated_ids.Copy()
	translated_list_detached = TRUE

/datum/translation_context/variable/attempt_translation(datum/language/L, atom/movable/speaker, msg, require_perfect)
	if((translation_class & L.translation_class) && !(translation_class_forbid & L.translation_class))
		return translate(L, speaker, msg)
	var/effective = translated_ids?[L.id]
	if(!effective)
		return L.scramble(msg)
	if(effective >= TRANSLATION_CONTEXT_PERFECT_THRESHOLD)
		return translate(L, speaker, msg)
	if(require_perfect)
		return null
	return imperfect_translation(L, speaker, msg, effective)

/datum/translation_context/variable/translate(datum/language/L, atom/movable/speaker, msg)
	return msg	// perfect translations

/datum/translation_context/variable/can_translate(datum/language/L, atom/movable/speaker, require_perfect)
	if((translation_class & L.translation_class) && !(translation_class_forbid & L.translation_class))
		return TRUE
	return require_perfect? (translated_ids?[L.id] >= TRANSLATION_CONTEXT_PERFECT_THRESHOLD) : (!!translated_ids?[L.id])

/datum/translation_context/variable/proc/imperfect_translation(datum/language/L, atom/movable/speaker, msg, efficiency)
	//! all aboard the marakov train
	var/effective_efficiency = clamp(efficiency, 0, 1)
	var/current_efficiency = effective_efficiency * 100
	var/translating = prob(current_efficiency)
	var/list/words = splittext(msg, " ")
	for(var/i in 1 to length(words))
		var/str = words[i]
		if(!str)
			continue	// genuinely don't care
		if(translating)
			// yay!
			// don't touch the string
			// see if we should stop translating
			if(prob(current_efficiency))
				// success; drop efficiency
				// current_efficiency *= effective_efficiency
				//! or don't because this is brutal enough just see how rimworld works lmao
			else
				// oops! failed to keep going; penalize the next one too
				current_efficiency = (effective_efficiency ** 2) * 100
				translating = FALSE
		else
			// nay!
			// scrmable string
			words[i] = L.scramble_word(str)
			// see if we should translate again
			if(prob(current_efficiency))
				// yes!
				current_efficiency = effective_efficiency * 100
				translating = TRUE
	return jointext(words, " ")

/**
 * copy all our knowledge to another if it can receive it
 */
/datum/translation_context/variable/proc/copy_knowledge(datum/translation_context/variable/other)
	other.receive_knowledge(src)

/**
 * copy all our knowledge to another if it can receive it
 */
/datum/translation_context/variable/proc/receive_knowledge(datum/translation_context/variable/giver)
	// typelists: if the lists are the same, don't bother
	if(giver.translated_ids == translated_ids)
		return
	// split list
	detach_translated_ids()
	// copy
	for(var/id in giver.translated_ids)
		var/efficiency = giver.translated_ids[id]
		if(efficiency >= translated_ids[id])
			continue
		translated_ids[id] = efficiency

/**
 * variable language translator
 *
 * it can either fully translate,
 * fail to translate,
 * or partially translate.
 *
 * it will learn over time supported languages.
 */
/datum/translation_context/variable/learning
	/// classes we automatically try to learn
	var/translation_class_learn = NONE
	/// classes we cannot automatically try to learn
	var/translation_class_learn_forbid = NONE
	/// lazy assoclist of ids we can learn (secondary lookup); also serves as efficiency override
	var/list/learnable_ids
	/// learning factor; 1, faster = up, slower = down; 0 to inf.
	var/learn_factor = 1
	/// callback to call with (src, datum/language/L, old_efficiency) on successful training
	var/datum/callback/on_train

/datum/translation_context/variable/learning/New()
	..()
	if(has_typelist(NAMEOF(src, learnable_ids)))
		learnable_ids = get_typelist(NAMEOF(src, learnable_ids))
	else
		for(var/id in learnable_ids)
			if(!isnull(learnable_ids[id]))
				continue
			learnable_ids[id] = learn_factor
		learnable_ids = typelist(src, make_associative_inplace_keep_values(learnable_ids))

/datum/translation_context/variable/learning/Destroy()
	learnable_ids = null
	on_train = null
	return ..()

/datum/translation_context/variable/learning/can_translate(datum/language/L, atom/movable/speaker, require_perfect)
	if(require_perfect)
		return ..()
	if((translation_class_learn & L.translation_class) && !(translation_class_learn_forbid & L.translation_class))
		return TRUE
	if(learnable_ids?[L.id])
		return TRUE
	return ..()

/datum/translation_context/variable/learning/attempt_translation(datum/language/L, atom/movable/speaker, msg)
	. = ..()
	var/efficiency = learnable_ids?[L.id]
	if(efficiency)
		train(L, speaker, msg, efficiency)
	else if((translation_class_learn & L.translation_class) && !(translation_class_learn_forbid & L.translation_class))
		train(L, speaker, msg, learn_factor)

/datum/translation_context/variable/learning/proc/train(datum/language/L, atom/movable/speaker, msg)
	// split list
	detach_translated_ids()
	var/old_efficiency = ((L.translation_class & translation_class) && !(L.translation_class & translation_class_forbid) && 1) || translated_ids[L.id] || 0
	if(old_efficiency >= TRANSLATION_CONTEXT_PERFECT_THRESHOLD)
		// good enough don't bother
		return
	var/list/words = splittext(msg, GLOB.multi_space_splitter)
	// short sentences suck, but long sentences only get you so far
	// if anyone codedives and abuses this, well, frankly:
	// don't make me bring out the actual math and lag the server to make
	// literally everyone miserable. just don't. roleplay it out.
	var/amt = length(words)
	var/gain = log((amt * 0.1) + 1) * 0.01
	var/new_efficiency = clamp(old_efficiency + gain, 0, 1)
	if(old_efficiency >= new_efficiency)
		return	// how
	translated_ids[L.id] = new_efficiency
	on_train?.Invoke(src, L, old_efficiency)

/**
 * translates everything
 */
/datum/translation_context/omni

/datum/translation_context/omni/can_translate(datum/language/L, atom/movable/speaker, require_perfect)
	return TRUE

/datum/translation_context/omni/translate(datum/language/L, atom/movable/speaker, msg)
	return msg

/datum/translation_context/omni/attempt_translation(datum/language/L, atom/movable/speaker, msg)
	return translate(L, speaker, msg)
