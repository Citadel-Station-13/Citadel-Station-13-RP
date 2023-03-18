/datum/weather/rain
	abstract_type = /datum/weather/rain
	ticks_mobs = TRUE
	indoors_messages = list(
		"<i>A gentle white noise of rain taps away a restless song.</i>",
		"<i>Stray droplets of rain momentarily obscure your vision.</i>",
		"<i>The rainfall lessens for the span of a breath, stirring your mind from the ambience of it.</i>",
	)
	weather_components = list(
		/datum/weather_component/inflicts_wet,
	)

/datum/weather/rain/light
	light_cover = 0.15
	sky_message = "There's a bit of light rain."
	transition_messages_outdoors = list(
		"A few droplets of rain starts falling from the sky.",
	)

/datum/weather/rain/moderate
	light_cover = 0.3
	light_cover = 0.15
	sky_message = "It's raining."
	transition_messages_outdoors = list(
		"Rain starts falling from the sky.",
	)

/datum/weather/rain/severe
	light_cover = 0.45
	light_cover = 0.15
	sky_cover = TRUE
	sky_message = "Your view is obscured by heavy rain."
	transition_messages_outdoors = list(
		"Water starts crashing down from the sky in sheets - heavy rain peltering you and obscuring your view.",
	)

/datum/weather/rain/thunderstorm
	light_cover = 0.6
	light_cover = 0.15
	sky_cover = TRUE
	sky_message = "Your view is obstructed by a full blown thunderstorm.."
	transition_messages_outdoors = list(
		"Thick, dark clouds obscure your view, as rain starts crashing out of the sky in sheets..",
	)
	weather_components = list(
		/datum/weather_component/lightning,
		/datum/weather_component/inflicts_wet,
	)

/datum/weather/rain/thunderstorm/dry
	light_cover = 0.3
	light_cover = 0.15
	sky_cover = TRUE
	sky_message = "There's a bit of light rain."
	transition_messages_outdoors = list(
		"Thick, dark clouds obscure your view - while no rain is to be found, you can see that it is nonetheless, a thunderstorm.",
	)
	weather_components = list(
		/datum/weather_component/lightning,
	)
