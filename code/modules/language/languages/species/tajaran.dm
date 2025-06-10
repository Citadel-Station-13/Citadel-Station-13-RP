/datum/prototype/language/tajaran
	id = LANGUAGE_ID_TAJARAN
	name = LANGUAGE_SIIK
	translation_class = TRANSLATION_CLASS_DEFAULT_CORE_RACE
	desc = "The traditionally employed tongue of Adhomai, comprised of expressive yowls and chirps. Native to the Tajara."
	speech_verb = "mrowls"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	colour = "tajaran"
	key = "j"
	syllables = list("mrr","rr","tajr","kir","raj","kii","mir","kra","ahk","nal","vah","khaz","jri","ran","darr",
	"mi","jri","dynh","manq","rhe","zar","rrhaz","kal","chur","eech","thaa","dra","jurl","mah","sanu","dra","ii'r",
	"ka","aasi","far","wa","baq","ara","qara","zir","saam","mak","hrar","nja","rir","khan","jun","dar","rik","kah",
	"hal","ket","jurl","mah","tul","cresh","azu","ragh","mro","mra","mrro","mrra")
	shorthand = "MAAS"

/datum/prototype/language/tajaran/get_random_name(var/gender)
	var/new_name = ..(gender,1)
	if(prob(50))
		new_name += " [pick(list("Hadii","Kaytam","Nazkiin","Zhan-Khazan","Hharar","Njarir'Akhan","Faaira'Nrezi","Rhezar","Mi'dynh","Rrhazkal","Bayan","Al'Manq","Mi'jri","Chur'eech","Sanu'dra","Ii'rka"))]"
	else
		new_name += " [..(gender,1)]"
	return new_name

/datum/prototype/language/tajaranakhani
	id = LANGUAGE_ID_TAJARAN_ALT
	name = LANGUAGE_AKHANI
	translation_class = TRANSLATION_CLASS_DEFAULT_CORE_RACE
	desc = "The language of the noble Njarir'Akhan Tajaran. Borrowing some elements from Siik, the language is distinctly more structured."
	speech_verb = "chatters"
	ask_verb = "mrowls"
	exclaim_verb = "wails"
	colour = "akhani"
	key = "h"
	syllables = list("mrr","rr","marr","tar","ahk","ket","hal","kah","dra","nal","kra","vah","dar","hrar", "eh",
	"ara","ka","zar","mah","ner","zir","mur","hai","raz","ni","ri","nar","njar","jir","ri","ahn","kha","sir",
	"kar","yar","kzar","rha","hrar","err","fer","rir","rar","yarr","arr","ii'r","jar","kur","ran","rii","ii",
	"nai","ou","kah","oa","ama","uuk","bel","chi","ayt","kay","kas","akor","tam","yir","enai")
	shorthand = "AKH"

/datum/prototype/language/tajsign
	id = LANGUAGE_ID_TAJARAN_SIGN
	name = LANGUAGE_SIIK_TAJR
	translation_class = TRANSLATION_CLASS_DEFAULT_CORE_RACE
	desc = "A standardized Tajaran sign language, incorporating hand gestures and movements of the ears and tail."
	signlang_verb = list("gestures with their hands", "gestures with their ears and tail", "gestures with their ears, tail and hands")
	colour = "tajaran"
	key = "l"
	language_flags = LANGUAGE_SIGNLANG | LANGUAGE_NO_STUTTER | LANGUAGE_NONVERBAL
	shorthand = "TAJR"

/datum/prototype/language/tajsign/can_speak_special(var/mob/speaker)	// TODO: If ever we make external organs assist languages, convert this over to the new format
	var/list/allowed_species = list(SPECIES_TAJ, SPECIES_TESHARI)	// Need a tail and ears and such to use this.
	if(iscarbon(speaker))
		var/obj/item/organ/external/hand/hands = locate() in speaker //you can't sign without hands
		if(!hands)
			return FALSE
		if(ishuman(speaker))
			var/mob/living/carbon/human/H = speaker
			if(H.species.get_bodytype_legacy(H) in allowed_species)
				return TRUE

	return FALSE
