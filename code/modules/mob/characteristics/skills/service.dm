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
	desc_novice = "You have had some practice cooking. Actions are inherently faster for you now."
	desc_trained = "You have been cooking for a while, hobby or otherwise. You can now see some nutritional information at a glance."
	desc_experienced = "You are a professionally trained chef. You now gain double outputs from some recipes at random."
	desc_professional = "You now have a higher chance of getting doubled outputs."
	cost_novice = SKILLCOST_INCREMENT_NEGLIGIBLE
	cost_trained = SKILLCOST_INCREMENT_NEGLIGIBLE
	cost_experienced = SKILLCOST_INCREMENT_MINOR
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
	desc_untrained = "You have no experience growing plants."
	desc_novice = "You have had some practice growing plants. Actions are inherently faster for you now, and you can see some plant stats by just looking at them."
	desc_trained = "You've been growing or gardening for a while. More stats are now visible, and fertilizing/watering plants is now more efficient."
	desc_experienced = "You are a professional grower, or a hydroponics worker. Plants tend to grow faster when tended to by you."
	desc_professional = "You have had extensive research in hydroponics. You now sometimes gain additional yield during harvest, and can determine some plant genes with ease."
	cost_novice = SKILLCOST_INCREMENT_NEGLIGIBLE
	cost_trained = SKILLCOST_INCREMENT_NEGLIGIBLE
	cost_experienced = SKILLCOST_INCREMENT_MINOR
	cost_professional = SKILLCOST_INCREMENT_MINOR
