/datum/characteristic_skill/service
	abstract_type = /datum/characteristic_skill/service
	category = "Service"

/**
 * Cooking
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/service/cooking
	id = "cooking"
	name = "Cooking"
	desc = "How good you are at cooking."
	desc_untrained = "You will probably need a cookbook to do anything."
	desc_basic = "You have had some practice cooking. Actions are inherently faster for you now."
	desc_novice = "You have been cooking for a while, hobby or otherwise. You can now see some nutritional information at a glance."
	desc_trained = "You are a professionally trained chef. You now gain double outputs from some recipes at random."
	desc_experienced = "You now have a higher chance of getting doubled outputs."
	cost_basic = SKILLCOST_INCREMENT_NEGLIGIBLE
	cost_novice = SKILLCOST_INCREMENT_NEGLIGIBLE
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_professional = SKILLCOST_INCREMENT_MINOR

/**
 * Botany
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/service/botany
	id = "botany"
	name = "Botany"
	desc = "How good you are at growing plants."
	#warn impl
