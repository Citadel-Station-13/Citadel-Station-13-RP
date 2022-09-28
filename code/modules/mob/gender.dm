GLOBAL_LIST_INIT(gender_datums, gender_datums())

/proc/gender_datums()
	. = list()
	for(var/path in typesof(/datum/gender))
		var/datum/gender/G = new path
		.[G.key] = G

/datum/gender
	var/key		= "plural"

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

/datum/gender/male
	key		= "male"

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

/datum/gender/female
	key		= "female"

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

/datum/gender/neuter
	key		= "neuter"

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

/datum/gender/herm
	key		= "herm"

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
