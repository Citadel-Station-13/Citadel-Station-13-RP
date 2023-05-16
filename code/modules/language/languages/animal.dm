/datum/language/corgi
	id = LANGUAGE_ID_DOG
	name = "Dog"
	translation_class = TRANSLATION_CLASS_ANIMAL
	desc = "Woof woof woof."
	speech_verb = "barks"
	ask_verb = "woofs"
	exclaim_verb = "howls"
	language_flags = LANGUAGE_RESTRICTED
	key = null	// demoted
	space_chance = 100
	syllables = list("bark", "woof", "bowwow", "yap", "arf")
	shorthand = "DOG"

/datum/language/cat
	id = LANGUAGE_ID_CAT
	name = "Cat"
	translation_class = TRANSLATION_CLASS_ANIMAL
	desc = "Meow meow meow."
	speech_verb = "meows"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	language_flags = LANGUAGE_RESTRICTED
	key = null	// demoted
	space_chance = 100
	syllables = list("meow", "mrowl", "purr", "meow", "meow", "meow")
	shorthand = "CAT"

/datum/language/mouse
	id = LANGUAGE_ID_MOUSE
	name = "Mouse"
	translation_class = TRANSLATION_CLASS_ANIMAL
	desc = "Squeak squeak. *Nibbles on cheese*"
	speech_verb = "squeaks"
	ask_verb = "squeaks"
	exclaim_verb = "squeaks"
	language_flags = LANGUAGE_RESTRICTED
	key = null	// demoted
	space_chance = 100
	syllables = list("squeak")	// , "gripes", "oi", "meow")
	shorthand = "MSE"

/datum/language/bird
	id = LANGUAGE_ID_BIRD
	name = "Bird"
	translation_class = TRANSLATION_CLASS_ANIMAL
	desc = "Chirp chirp, give me food"
	speech_verb = "chirps"
	ask_verb = "tweets"
	exclaim_verb = "squawks"
	language_flags = LANGUAGE_RESTRICTED
	key = null	// demoted
	space_chance = 100
	syllables = list("chirp", "squawk", "tweet")
	shorthand = "BIRD"
