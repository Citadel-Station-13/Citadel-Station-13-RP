/datum/language/corgi
	id = LANGUAGE_ID_DOG
	name = "Dog"
	desc = "Woof woof woof."
	speech_verb = "barks"
	ask_verb = "woofs"
	exclaim_verb = "howls"
	key = null	// demoted
	language_flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("bark", "woof", "bowwow", "yap", "arf")

/datum/language/cat
	id = LANGUAGE_ID_CAT
	name = "Cat"
	desc = "Meow meow meow."
	speech_verb = "meows"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	key = null	// demoted 
	language_flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("meow", "mrowl", "purr", "meow", "meow", "meow")

/datum/language/mouse
	id = LANGUAGE_ID_MOUSE
	name = "Mouse"
	desc = "Squeak squeak. *Nibbles on cheese*"
	speech_verb = "squeaks"
	ask_verb = "squeaks"
	exclaim_verb = "squeaks"
	key = null	// demoted
	language_flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("squeak")	// , "gripes", "oi", "meow")

/datum/language/bird
	id = LANGUAGE_ID_BIRD
	name = "Bird"
	desc = "Chirp chirp, give me food"
	speech_verb = "chirps"
	ask_verb = "tweets"
	exclaim_verb = "squawks"
	key = null	// demoted
	language_flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("chirp", "squawk", "tweet")
