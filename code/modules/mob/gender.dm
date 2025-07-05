GLOBAL_LIST_INIT(gender_datums, gender_datums())

/proc/gender_datums()
	. = list()
	for(var/path in typesof(/datum/gender))
		var/datum/gender/G = new path
		.[G.key] = G

GLOBAL_LIST_INIT(gender_select_list, gender_selection())

/proc/gender_selection()
	. = list()
	for(var/path in typesof(/datum/gender))
		var/datum/gender/G = new path
		.[G.pronoun_preview] = G.key

/datum/gender
	var/key		= "plural"
	var/pronoun_preview = "they/them"

	var/He		= "They"
	var/he		= "they"
	var/His		= "Their"
	var/his		= "their"
	var/Him		= "Them"
	var/him		= "them"
	var/has		= "have"
	var/is		= "are"
	var/does	= "do"
	var/himself	= "themselves"
	var/s		= ""
	var/hes		= "they're"
	var/Hes = "They're"

	/// Uses plural forms like 'appear' instead of 'appears'
	var/use_plurals = TRUE

/datum/gender/male
	key		= "male"
	pronoun_preview = "He/him"

	He		= "He"
	he		= "he"
	His		= "His"
	his		= "his"
	Him		= "Him"
	him		= "him"
	has		= "has"
	is		= "is"
	does	= "does"
	himself	= "himself"
	s		= "s"
	hes		= "he's"
	Hes = "He's"

	use_plurals = FALSE

/datum/gender/female
	key		= "female"
	pronoun_preview = "She/her"

	He		= "She"
	he		= "she"
	His		= "Her"
	his		= "her"
	Him		= "Her"
	him		= "her"
	has		= "has"
	is		= "is"
	does	= "does"
	himself	= "herself"
	s		= "s"
	hes		= "she's"
	Hes = "She's"

	use_plurals = FALSE

/datum/gender/neuter
	key		= "neuter"
	pronoun_preview = "It/its"

	He		= "It"
	he		= "it"
	His		= "Its"
	his		= "its"
	Him		= "It"
	him		= "it"
	has		= "has"
	is		= "is"
	does	= "does"
	himself	= "itself"
	s		= "s"
	hes		= "it's"
	Hes = "It's"

	use_plurals = FALSE

/datum/gender/herm
	key		= "herm"
	pronoun_preview = "Shi/hir"

	He		= "Shi"
	he		= "shi"
	His		= "Hir"
	his		= "hir"
	Him		= "Hir"
	him		= "hir"
	has		= "has"
	is		= "is"
	does	= "does"
	himself	= "hirself"
	s		= "s"
	hes		= "shi's"
	Hes = "Shi's"

	use_plurals = FALSE

/mob/proc/p_they()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.he

/mob/proc/p_them()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.him

/mob/proc/p_They()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.He

/mob/proc/p_Them()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.Him

/mob/proc/p_their()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.his

/mob/proc/p_Their()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.His

/mob/proc/p_theyre()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.hes

/mob/proc/p_Theyre()
	var/datum/gender/G = GLOB.gender_datums[gender]
	return G.Hes
