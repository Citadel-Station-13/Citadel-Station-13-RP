//Try not to do anything stupid like list addition in these three defines.
#define TRAIT_SOURCES_FORCE_REMOVE list(TRAIT_SOURCE_ADMIN)			//These trait sources require force variable, or specific inclusion in the remove call to be removed.
#define TRAIT_CLEAR_DEFAULT_SOURCE_BLACKLIST TRAIT_SOURCES_FORCE_REMOVE			//by default, these sources will be ignored on clear_traits()
#define TRAIT_CLEAR_DEFAULT_TRAIT_BLACKLIST null								//by default, these traits will be ignored on clear_traits()

#define TRAIT_SOURCE_ADMIN		"ADMIN"


