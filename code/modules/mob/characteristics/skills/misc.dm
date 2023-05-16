/datum/characteristic_skill/misc
	abstract_type = /datum/characteristic_skill/misc
	category = "General"

/**
 * Atheletics - TBD
 *
 * Scaling is harsh due to being a general skill.
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/security/athletics
	id = "athletics"
	name = "Athletics"
	desc = "How skilled you are with gymnastics, athletics, as well as general hand-eye coordination."
	desc_untrained = "You don't really have any experience with gymnastics or serious fitness."
	desc_novice = "You have a bit of recreational exercise. Fall damage is slightly decreased, and some minor tasks are slightly faster."
	desc_trained = "You are a recreational athlete. Fall damage is more decreased, and you get up faster from falls. Your metabolism is slightly more efficient."
	desc_experienced = "You are practically a professional gymnast. You can withstand minor falls with ease, as long as you are not in heavy equipment, and find yourself to be more resilient to many physical stressors."
	max_value = CHARACTER_SKILL_EXPERIENCED
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MAJOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
