/datum/characteristic_skill/medical
	abstract_type = /datum/characteristic_skill/medical
	category = "Medical"

/**
 * anatomy: surgery / evaluations / whatnot
 *
 * implementation status: not started
 */
/datum/characteristic_skill/medical/anatomy
	id = "anatomy"
	name = "Anatomy"
	desc = "How well you know the anatomical structures of living things."
	desc_untrained = "You really don't know much about the inner workings of living things beyond the basics. You cannot do surgery well other than in a perfect suite with holographic assistance from a computer."
	desc_novice = "You have had a little bit of study into the anatomy of living things. Surgery and dissections are now a bit faster, and you can see a bit more information on wounds with a glance."
	desc_trained = "You have formal anatomical training. You can now do risk-free surgery without holographic assistance, in a good enough lab."
	desc_experienced = "You have a decent amount of surgery experience. You now have less penalty from bad environments during surgery, and have some basic bonuses to surgery upon xenobiological lifeforms."
	desc_professional = "You are a world class surgeon. You can do surgery anywhere, at any place, only risking minor failures, as long as you are careful enough. You are great at avoiding wound infections during surgery and can perform experimental biotuning procedures with ease."
	cost_novice = SKILLCOST_INCREMENT_MAJOR
	cost_trained = SKILLCOST_INCREMENT_MAJOR
	cost_experienced = SKILLCOST_INCREMENT_MODERATE
	cost_professional = SKILLCOST_INCREMENT_MODERATE

/**
 * medicine: medical in general
 *
 * implementation status: not started
 */
/datum/characteristic_skill/medical/medicine
	id = "medicine"
	name = "Medicine"
	desc = "How well you know the nitty gritty of practicing medicine. Each level gives small boosts to tasks like CPR and equipment operation speed."
	desc_untrained = "You probably have to follow a step by step guide to treat anyone well. You get raw medical information from scanners - great if you practice on your own time, terrible in a pinch."
	desc_novice = "You have some experience with nursing, or similar. You get slightly more information from medical scanners, as well as when inspecting people visually."
	desc_trained = "You are a physician in training. You get more information from scanners, and more information on visual inspection. You can administer medicine with ease."
	desc_experienced = "You have had many years under your belt as a doctor. Many afflictions can be diagnosed at a close examination, and the intrinsics of treatment and triage are second nature to you."
	desc_professional = "You are a true, tried and tested, doctor. All but the most invasive problems can be determined by you without technological assistance, and you practically have a third sense for injury. Medical speed and efficiency globally increased. You will see visual pings when people are dying of common afflictions."
	// extremely harsh scaling as this skill is very useful
	cost_novice = SKILLCOST_INCREMENT_MAJOR
	cost_trained = SKILLCOST_INCREMENT_MAJOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * chemistry
 *
 * implementation status: not started
 */
/datum/characteristic_skill/medical/chemistry
	id = "chemistry"
	name = "Chemistry"
	desc = "How well you know chemistry."
	desc_untrained = "You don't know much about the nitty gritty of chemistry. Mixing chemicals is slow and tedious and you probably need a book with exact recipes."
	desc_novice = "You've had a few lessons in chemistry. Common chemicals are now second nature to you and can be made easily without much problems."
	desc_trained = "You have formal, or equivalent, training in chemistry. You can discern some basic things about reagents and mixtures at a glance, and more chemicals are now easily accessible by you."
	desc_experienced = "You have a lot of experience with chemicals. Some basic chemicals themselves can be discerned at a glance, and metabolic information can be read directly from some scanners."
	desc_professional = "You have been working with chemicals all your life. Nothing gets past your skills of perception, and you are able to go as far as to determine certain active ingrediants from trace signs alone. Chemistry machines now operate at a higher efficiency when used by you, with more product and less waste."
	cost_novice = SKILLCOST_INCREMENT_MAJOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MODERATE
	cost_professional = SKILLCOST_INCREMENT_MODERATE
