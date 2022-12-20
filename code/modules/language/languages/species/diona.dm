/datum/language/diona_local
	id = LANGUAGE_ID_DIONA
	name = LANGUAGE_ROOTLOCAL
	translation_class = TRANSLATION_CLASS_DEFAULT_RARE_RACE
	desc = "A complex language known instinctively by Dionaea, 'spoken' by emitting modulated radio waves. This version uses high frequency waves for quick communication at short ranges."
	speech_verb = "creaks and rustles"
	ask_verb = "creaks"
	exclaim_verb = "rustles"
	colour = "soghun"
	key = "q"
	language_flags = LANGUAGE_RESTRICTED
	syllables = list("hs","zt","kr","st","sh")
	shorthand = "DIO"

/datum/language/diona_local/get_random_name()
	var/new_name = "[pick(list("To Sleep Beneath","Wind Over","Embrace of","Dreams of","Witnessing","To Walk Beneath","Approaching the"))]"
	new_name += " [pick(list("the Void","the Sky","Encroaching Night","Planetsong","Starsong","the Wandering Star","the Empty Day","Daybreak","Nightfall","the Rain"))]"
	return new_name

/datum/language/diona_global
	id = LANGUAGE_ID_DIONA_HIVEMIND
	name = LANGUAGE_ROOTGLOBAL
	desc = "A complex language known instinctively by Dionaea, 'spoken' by emitting modulated radio waves. This version uses low frequency waves for slow communication at long ranges."
	key = "w"
	language_flags = LANGUAGE_RESTRICTED | LANGUAGE_HIVEMIND
