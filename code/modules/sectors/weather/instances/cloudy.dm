/datum/weather/cloudy
	abstract_type = /datum/weather/cloudy

/datum/weather/cloudy/light
	name = "light cloud cover"
	desc = "A bit of clouds are in the sky."
	sky_cover = FALSE
	sky_message = "You see a few clouds in the sky. It still looks pretty clear, though."
	light_cover = 0.05

/datum/weather/cloudy/moderate
	name = "moderate cloud cover"
	desc = "A moderate amount of clouds are in the sky."
	sky_cover = FALSE
	sky_message = "You see quite a few clouds in the sky. They roll across the landscape. The sky is mildly obstructed."
	light_cover = 0.15

/datum/weather/cloudy/severe
	name = "heavy cloud cover"
	desc = "A large amount of clouds are in the sky."
	sky_cover = TRUE
	sky_message = "There's many clouds in the sky. The sky is almost completely obtsructed."
	light_cover = 0.3
