
#define TEMP_CULTURE_SHADEKIN "Temp Shadekin Culture"
#define TEMP_CULTURE_DREMACHIR "Temp Dremachir Culture"
#define TEMP_CULTURE_AURIL "Temp Auril Culture"
#define TEMP_CULTURE_REPLICANT "Temp Replicant Culture"
#define TEMP_CULTURE_ALARUNE "Temp Alarune Culture"
#define TEMP_CULTURE_PHORONOID "Temp Phoronoid Culture"
#define TEMP_CULTURE_PROMETHEAN "Temp Promethean Culture"
#define TEMP_CULTURE_VASILISSAN "Temp Vasilissan Culture"
#define TEMP_CULTURE_WEREBEAST "Temp Werebeast Culture"
#define TEMP_CULTURE_ZADDAT "Temp Zaddat Culture"
#define TEMP_CULTURE_SERGAL "Temp Sergal Culture"
#define TEMP_CULTURE_AKULA "Temp Akula Culture"
#define TEMP_CULTURE_NEVREAN "Temp Nevrean Culture"
#define TEMP_CULTURE_ZORREN "Temp Zorren Culture"
#define TEMP_CULTURE_VULPKANIN "Temp Vulpkanin Culture"
#define TEMP_CULTURE_RAPALA "Temp Rapala Culture"



/decl/lore_info/culture/temp/
	default_language = LANGUAGE_GALCOM
	optional_languages = list(LANGUAGE_GALCOM)
	hidden = TRUE
	description = "This is a Temporary holder for your species' language."


/decl/lore_info/culture/temp/shadekin
	name = TEMP_CULTURE_SHADEKIN
	language = LANGUAGE_SHADEKIN
	default_language = LANGUAGE_SHADEKIN

/decl/lore_info/culture/temp/auril
	name = TEMP_CULTURE_AURIL
	language = LANGUAGE_ENOCHIAN

/decl/lore_info/culture/temp/dremachir
	name = TEMP_CULTURE_DREMACHIR
	language = LANGUAGE_DAEMON

/decl/lore_info/culture/temp/replicant
	name = TEMP_CULTURE_REPLICANT
	language = LANGUAGE_TERMINUS

/decl/lore_info/culture/temp/alraune
	name = TEMP_CULTURE_ALARUNE
	language = LANGUAGE_VERNAL

/decl/lore_info/culture/temp/phoronoid
	name = TEMP_CULTURE_PHORONOID
	language = LANGUAGE_BONES

/decl/lore_info/culture/temp/promethean
	name = TEMP_CULTURE_PROMETHEAN
	language = LANGUAGE_SOL_COMMON

/decl/lore_info/culture/temp/vasilissan
	name = TEMP_CULTURE_VASILISSAN
	language = LANGUAGE_VESPINAE

/decl/lore_info/culture/temp/werebeast
	name = TEMP_CULTURE_WEREBEAST
	name_language = LANGUAGE_CANILUNZT
	secondary_langs = LANGUAGE_CANILUNZT

/decl/lore_info/culture/temp/zaddat
	name = TEMP_CULTURE_ZADDAT
	language = LANGUAGE_ZADDAT
	name_language = LANGUAGE_ZADDAT
	secondary_langs = LANGUAGE_UNATHI
	economic_power = 3 // idk why they so rich but cool, I like it.

/decl/lore_info/culture/temp/sergal
	name = TEMP_CULTURE_SERGAL
	language = LANGUAGE_SAGARU
	name_language = LANGUAGE_SAGARU

/decl/lore_info/culture/temp/akula
	name = TEMP_CULTURE_AKULA
	language = LANGUAGE_SKRELLIAN
	name_language = LANGUAGE_SKRELLIAN

/decl/lore_info/culture/temp/nevrean
	name = TEMP_CULTURE_NEVREAN
	language = LANGUAGE_BIRDSONG
	name_language = LANGUAGE_BIRDSONG

// Split this into the proper hl/fl zorren cultures
/decl/lore_info/culture/temp/zorren
	name = TEMP_CULTURE_ZORREN
	language = LANGUAGE_TERMINUS
	name_language = LANGUAGE_TERMINUS

/decl/lore_info/culture/temp/vulpkanin
	name = TEMP_CULTURE_VULPKANIN
	language = LANGUAGE_SOL_COMMON
	name_language = LANGUAGE_CANILUNZT
	secondary_langs = LANGUAGE_CANILUNZT

/decl/lore_info/culture/temp/rapala
	name = TEMP_CULTURE_RAPALA
	language = LANGUAGE_BIRDSONG
