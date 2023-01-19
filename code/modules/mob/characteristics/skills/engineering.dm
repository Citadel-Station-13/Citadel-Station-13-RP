/datum/characteristic_skill/engineering
	abstract_type = /datum/characteristic_skill/engineering
	category = "Engineering"

/**
 * Electrical Engineering: Wiring, power, etc
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/engineering/electrical
	id = "electrical"
	name = "Electrical Engineering"
	desc = "How experienced you are with powe, wiring, hacking, etc."
	desc_untrained = "What even are wires? You should not be caught dead without insulated gloves if you are messing with a panel. You probably will be caught dead if you do it anyways. Wiring interfaces can become shuffled at random."
	desc_novice = "You have some practice with wiring and electricity. Panels are no longer randomized."
	desc_trained = "You have general training in electrical maintenance. You can now perform some actions on hacking interfaces without testing for wires, at a random chance depending on the object in question."
	desc_experienced = "You do a lot of work with electronics. Departmental wire sets now always order the same way for you. More actions can be used without wire pulsing, and some wires reveal their functions entirely."
	desc_professional = "You are a highly skilled electrician. Wires always render in the same order for you, and you can simply manipulate most lower-end devices without hacking or access if you can get the cover off."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MODERATE
	cost_experienced = SKILLCOST_INCREMENT_MODERATE
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * Construction: Building, Teardowns, etc
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/engineering/construction
	id = "construction"
	name = "Construction"
	desc = "How good you are at building or breaking things down."
	#warn impl

/**
 * Atmospherics
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/engineering/atmospherics
	id = "atmospherics"
	name = "Atmospherics"
	desc = "How experienced you are with gas mechanics, atmospherics machinery, etc."
	#warn impl

/**
 * Engines & Ship Systems
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/engineering/engines
	id = "engines"
	name = "Engine & Voidcraft Operation"
	desc = "How experienced you are with various engines, as well as with systems aboard a ship."

	#warn impl

