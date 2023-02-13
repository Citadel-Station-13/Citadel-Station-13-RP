#define WEATHER_CLEAR				"clear"
#define WEATHER_OVERCAST			"overcast"
#define WEATHER_LIGHT_SNOW			"light snow"
#define WEATHER_SNOW				"snow"
#define WEATHER_BLIZZARD			"blizzard"
#define WEATHER_RAIN				"rain"
#define WEATHER_STORM				"storm"
#define WEATHER_HAIL				"hail"
#define WEATHER_WINDY				"windy"
#define WEATHER_HOT					"hot"
/// For admin fun or cult later on.
#define WEATHER_BLOOD_MOON			"blood moon"
/// More adminbuse, from TG. Harmless.
#define WEATHER_EMBERFALL			"emberfall"
#define WEATHER_PRE_ASH_STORM       "approaching ash storm"
/// Ripped from TG, like the above. Less harmless.
#define WEATHER_ASH_STORM			"ash storm"
/// Modified emberfall, actually harmful. Admin only.
#define WEATHER_FALLOUT				"fallout"
#define WEATHER_SANDSTORM			"sandstorm"

#define PLANET_PROCESS_SUN		0x1
#define PLANET_PROCESS_TEMP		0x2

/// If you want planet time to go faster than realtime, increase this number.
#define PLANET_TIME_MODIFIER		1

//? sector_updates flags
/// weather, including graphics/atmospherics updates involved, is potentially changing
#define SECTOR_UPDATE_WEATHER (1<<0)
/// sunlight, including ambient lighting, is potentially changing
#define SECTOR_UPDATE_SUNLIGHT (1<<1)
/// planetary gasmixture is potentially changing
#define SECTOR_UPDATE_ATMOS (1<<2)

#warn bad shit
