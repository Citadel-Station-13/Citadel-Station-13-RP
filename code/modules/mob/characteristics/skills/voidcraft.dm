/datum/characteristic_skill/voidcraft
	abstract_type = /datum/characteristic_skill/voidcraft
	category = "General"

/**
 * EVA
 *
 * implementation status: not started
 */
/datum/characteristic_skill/voidcraft/eva
	id = "eva"
	name = "EVA"
	desc = "How well you can perform EVA."
	desc_untrained = "You don't really go into space. While you can handle it, it probably is very uneasy for you."
	desc_novice = "You have had some basic EVA training. You now slip less often at high speeds, and can operate hardsuits a bit faster."
	desc_trained = "You have had a decent amount of EVA training. You now move faster in magboots, and always see your jetpack gauge. Hardsuits are now faster."
	desc_experienced = "You have worked in space for long periods of time. Jetpacks and oxygen supplies last longer than you. Hardsuits are now faster."
	desc_professional = "Space is second nature to you. EVA equipment bonuses are maximized, and you inherently have the effects of magboots as long as there is support near you."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MINOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * piloting
 *
 * implementation status: not started
 */
/datum/characteristic_skill/voidcraft/piloting
	id = "pilot"
	name = "Piloting"
	desc = "How well you can pilot voidcraft of various function."
	desc_untrained = "You don't really fly ships. The only way you manage to pilot is through modern automation and guided instruction."
	desc_novice = "You have had some practice piloting. You gain a small increase in control and a decrease in response latency."
	desc_trained = "You are a trained pilot. You gain more control, and can dodge meteors at low speeds, while piloting small craft. Manual landing is now far faster."
	desc_experienced = "You have been piloting for a while. You can now dodge meteors at faster speeds, or for larger craft. You gain a small boost in engine performance as well. Some ship components can be analyzed by you with a glance."
	desc_professional = "You are a professional pilot. You gain more boosts in engine performance and control, and can dock ships with ease."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR
