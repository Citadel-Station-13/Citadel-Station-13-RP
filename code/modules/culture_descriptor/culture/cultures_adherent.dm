/decl/cultural_info/culture/adherent
	name = CULTURE_ADHERENT_REMNANT
	language = LANGUAGE_ADHERENT
	additional_langs = list(LANGUAGE_GALCOM)


/decl/cultural_info/culture/adherent/council
	name = CULTURE_ADHERENT_COUNCIL



///decl/cultural_info/culture/adherent/get_random_name(var/gender)
	//return "[uppertext("[pick(GLOB.full_alphabet)][pick(GLOB.full_alphabet)]-[pick(GLOB.full_alphabet)] [rand(1000,9999)]")]"

/decl/cultural_info/culture/adherent/sanitize_name(name)
	return sanitizeName(name, allow_numbers=TRUE)
