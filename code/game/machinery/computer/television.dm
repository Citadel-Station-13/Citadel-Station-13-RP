/obj/machinery/computer/television/
	name = "television"
	desc = "Used for watching galactic public broadcast media"
	icon = 'icons/obj/status_display.dmi'
	icon_screen = "entertainment"
	light_color = "#FFEEDB"
	light_range_on = 2
	//circuit = /obj/item/circuitboard/security/telescreen/entertainment //Need to make a new circuit outide camera monitors

/obj/machinery/computer/television/Initialize(mapload)
	. = ..()
	SStelevision.all_tvs += src

/obj/machinery/computer/television/Destroy()
	SStelevision.all_tvs -= src
	return ..()
/*
/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon_state = "wallframe"
	layer = ABOVE_WINDOW_LAYER
	icon_keyboard = null
	icon_screen = null
	light_range_on = 0
	network = list(NETWORK_THUNDER)
	density = 0
	circuit = null

	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/status_display.dmi'
	icon_screen = "entertainment"
	light_color = "#FFEEDB"
	light_range_on = 2
	network = list(NETWORK_THUNDER)
	circuit = /obj/item/circuitboard/security/telescreen/entertainment
	var/obj/item/radio/radio = null

/obj/machinery/media/jukebox/
	name = "space jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/jukebox

	// Vars for hacking
	var/datum/wires/jukebox/wires = null
	/// Whether to show the hidden songs or not.
	var/hacked = 0
	/// Currently no effect, will return in phase II of mediamanager.
	var/freq = 0
	/// Behavior when finished playing a song.
	var/loop_mode = JUKEMODE_PLAY_ONCE
	/// How many songs are we allowed to queue up?
	var/max_queue_len = 3
	var/list/queue = list()
	/// What is our current genre?
	var/current_genre = "Electronic"
	var/list/genres = list("Arcade", "Alternative", "Classical and Orchestral", "Country and Western", "Disco, Funk, Soul, and R&B", "Electronic", "Folk and Indie", "Hip-Hop and Rap", "Jazz and Lounge", "Metal", "Pop", "Rock", "Sol Common Precursors") //Avaliable genres.
	var/datum/track/current_track
	var/list/datum/track/tracks = list(
	)

	// Only visible if hacked
	var/list/datum/track/secret_tracks = list(
)

	// Only visible if emagged
	var/list/datum/track/emag_tracks = list(
	)


/obj/machinery/media/jukebox/Destroy()
	qdel(wires)
	wires = null
	return ..()

*/
