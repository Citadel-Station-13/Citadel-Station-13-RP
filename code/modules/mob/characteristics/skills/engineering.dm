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
	desc_untrained = "You need an instruction manual to put together even a table. All construction are slightly slower for you."
	desc_novice = "You've had some practice building things. Construction is now faster."
	desc_trained = "You're a handyman of sorts. Construction and deconstruction are now faster. Things will prompt you with what can be used on them if applicable."
	desc_experienced = "You're a skilled construction engineer. Automatic construction/deconstruction at a boosted speed is now available for you. Lathes are slightly more efficient for you. Construction is more efficient for you."
	desc_professional = "You're a master builder or ship architect. RCDs are more efficient for you. All speeds and lathe handling boosted. You can build more for less."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MODERATE
	cost_experienced = SKILLCOST_INCREMENT_MODERATE
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * Atmospherics
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/engineering/atmospherics
	id = "atmospherics"
	name = "Atmospherics"
	desc = "How experienced you are with gas mechanics, atmospherics machinery, etc."
	desc_untrained = "What's an air network? All you recall from the academy is PV=NRT. All atmospherics operations tend to slow for you."
	desc_novice = "You've had some practice managing air systems. Doing maintenance is now faster. Air alarms show slightly more information. Using an analyzer can be done at range."
	desc_trained = "You're an apprentice air technician. Speeds globally increased. You can do basic pipenet tracing with an analyzer rather than T-rays. You can memorize where pipes are after a pulse for a little while."
	desc_experienced = "You can intuit some information from the room, as well as some air networks with a glance. Speeds globally increased."
	desc_professional = "You can track multiple pieces of atmospherics machinery with a glance, even while far away. You can see the direction of breaches."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * Engines & Ship Systems
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/engineering/engines
	id = "engines"
	name = "Engine & Voidcraft Operation"
	desc = "How experienced you are with various engines, as well as with systems aboard a ship."
	desc_untrained = "You probably shouldn't be touching engines."
	desc_novice = "You've been shown how to set up a basic reactor, tune ship systems, so on and so forth. You can now do more efficient repairs on ship systems."
	desc_trained = "You've been working on ships, or complex industrial systems for a while. You can check components and efficiencies with a glance."
	desc_experienced = "You're a long-time reactor or ship technician. You can overclock ship components while near them. You can now see the engine's EER with a quick glance. You are no longer affected by certain engine emissions."
	desc_professional = "You are a master of everything electromechanical. You can now overclock ship components remotely, as well as perform stronger overclocking on the spot."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR
