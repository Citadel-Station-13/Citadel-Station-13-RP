/datum/characteristic_skill/security
	abstract_type = /datum/characteristic_skill/security
	category = "Security"

/**
 * Ranged
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/security/ranged
	id = "ranged"
	name = "Weapons Expertise"
	desc = "How skilled you are with assorted weaponry."
	desc_untrained = "You know how to hold a gun. Not well, though. That's it."
	desc_novice = "You have had some firearms safety. You can reflexively disable safeties when trying to aim and aiming is a bit easier for you. You know how to handle recoil more naturally now."
	desc_trained = "You have been using firearms for a while or it is part of your daily job. Your stability has further increased."
	desc_experienced = "Using a firearm is second nature to you. Your stability is further increased. You can use some alien weaponry by just studying it."
	desc_professional = "You might have a career as an armorer or gunsmith, or just use guns daily. You have no penalties and can wield weapons with minimal recoil."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * Forensics
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/security/forensics
	id = "forensics"
	name = "Forensics"
	desc = "How skilled you are at forensic examinations and evidence collection."
	desc_untrained = "You have no experience doing forensics whatsoever. You can probably use a scanner to gather some data with guided evidence, but that's it."
	desc_novice = "You have been doing forensics for a while. Things are faster for you than before and you can use manual collection methods without a scanner."
	desc_trained = "You are trained in forensics. You can efficiently gather data from crime scenes, with or without technological assistance."
	desc_experienced = "You have a career in forensics. You can efficiently determine some sources of evidence with just a glance."
	desc_professional = "You are a master of forensics. A mere glance is enough to tell you about many kinds of data about something, whether it be be at people or objects around you."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR
