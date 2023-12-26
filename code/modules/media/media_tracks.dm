//
// Load the list of available music tracks for the jukebox (or other things that use music)
//

// Music track available for playing in a media machine.
/datum/media_track
	var/url			// URL to load song from
	var/title		// Song title
	var/artist		// Song's creator
	var/duration	// Song length in deciseconds
	var/secret		// Show up in regular playlist or secret playlist?
	var/lobby		// Be one of the choices for lobby music?
	var/jukebox		// Does it even show up in the jukebox?
	var/genre		// What is the genre of the song?

/datum/media_track/New(var/url, var/title, var/duration, var/artist = "", var/genre = "", var/secret = 0, var/emag = 0, var/lobby = 0, var/jukebox = 0)
	src.url = url
	src.title = title
	src.artist = artist
	src.genre = genre
	src.duration = duration
	src.secret = secret
	src.lobby = lobby
	src.jukebox = jukebox

/datum/media_track/proc/display()
	var str = "\"[title]\""
	if(artist)
		str += " by [artist]"
	return str

/datum/media_track/proc/toTguiList()
	return list("ref" = "\ref[src]", "title" = title, "artist" = artist, "genre" = genre, "duration" = duration)
