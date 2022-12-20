/**
 *! Subtypes & Cosmetics
 */

/mob/living/bot/medibot/fire
	name = "\improper Mr. Burns"
	skin = "burn"

/mob/living/bot/medibot/toxin
	name = "\improper Toxic"
	skin = "toxin"

/mob/living/bot/medibot/o2
	name = "\improper Lifeless"
	skin = "o2"

/mob/living/bot/medibot/red
	name = "\improper Super Medibot"
	skin = "advfirstaid"

/mob/living/bot/medibot/mysterious
	name = "\improper Mysterious Medibot"
	desc = "International Medibot of mystery."
	skin = "bezerk"

	treatment_brute = "bicaridine"
	treatment_fire  = "dermaline"
	treatment_oxy   = "dexalin"
	treatment_tox   = "anti_toxin"

/mob/living/bot/medibot/purple
	name = "\improper Leaky"
	skin = "clottingkit"

/mob/living/bot/medibot/pink
	name = "\improper Pinky"
	skin = "pinky"

/mob/living/bot/medibot/medass //Don't laugh, she's trying her hardest :(
	name = "\improper Miss Bandages"
	desc = "A little medical robot. This one looks very busy."
	skin = "assistant"

//! Beebot
/mob/living/bot/medibot/apidean
	name = "\improper Apidean Beebot"
	desc = "An organic creature heavily augmented with components from a medical drone. It was made to assist nurses in Apidaen hives."
	icon_state = "beebot0"
	base_icon_state = "beebot"
	use_overlays = FALSE

/mob/living/bot/medibot/apidean/update_icon_state()
	. = ..()
	if(busy)
		icon_state = "[base_icon_state]-active"
	else
		icon_state = "[base_icon_state]-[on]"

/mob/living/bot/medibot/apidean/handleIdle()
	if(is_tipped) //Don't handle idle things if we're incapacitated!
		return

	if(vocal && prob(1))
		var/message_options = list(
			"Bzzz bzzz!" = 'sound/voice/moth/scream_moth.ogg',
			"Chk scchk hhk!" = 'sound/voice/moth/mothchitter.ogg',
			"Hhhk bzchk." = 'sound/voice/moth/mothsqueak.ogg',
		)
		var/message = pick(message_options)
		say(message)
		playsound(loc, message_options[message], 50, FALSE)
