

#define FACTION_EXAMPLE "Example Faction"	// Make a define for each faction you make.


/datum/lore_info/faction/example

///NAME

	// The defines you made will go here. This is the most important one as it also acts as the ID.a
	// If you don't understand that dw, we just need each name to be unique.
	name = CULTURE_EXAMPLE


///LANGUAGE

	// If you put a language here, it is forced onto the player's language list, aka non-optional, must have.
	// I recommend put the species primary language here, though if you have more complex rules, look at Tajara.
	language = LANGUAGE_LOREM_IPSUM

	// Also for each of the language vars you can use a list if needed.
	language = list(
		LANGUAGE_LOREM_IPSUM,
		LANGUAGE_DOLOR_SIT,
		LANGUAGE_AMET
		)


///DESCRIPTION

	// The description is one of the most important things as this will be the primary method of players to get a feeling for what they're getting into.
	// This is also the thing I suck at doing so pretty please do it. - Zandario
	description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\
	quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat\
	nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."


///OPTIONAL_LANGUAGES
	// Optional Languages appear as the languages you can select in the character creation process.
	// If your species has higher level language (think of High Skrell), I recommend putting it in one of these.a
	// Unless of course you want said faction to require it!
	optional_languages = LANGUAGE_DOLOR_SIT


///ECONOMIC_POWER

	// These are a modifier that affects how much money starts with. Please keep these realistic. 1 = 100%, 10 = 1,000%
	economic_power = 1


///NAME_LANGUAGE

	// Don't worry about this one, only a few species use this, if you know your species used it, just put the desired language in there.
	name_language = LANGUAGE_LOREM_IPSUM


///MOB_FACTION

	// Don't worry about this one, it was for bay's antag system. Thought it's handy for allowing a bunch of xenomorphs to not attack a xenomorph player.
	mob_faction = "xeno"


///SUBVERSIVE_POTENTIAL

	// Don't worry about this. Antag system stuff.
	subversive_potential = 0


////FULL EXAMPLE\\\\

/datum/lore_info/faction/example
	name = FACTION_EXAMPLE
	language = LANGUAGE_LOREM_IPSUM
	optional_languages = LANGUAGE_DOLOR_SIT
	economic_power = 1
	name_language = LANGUAGE_LOREM_IPSUM
	mob_faction = "xeno"
	subversive_potential = 15
	description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\
	quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat\
	nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
