/singleton/music_track
	var/artist
	var/title
	var/album
	var/decl/license/license
	var/song
	var/url // Remember to include http:// or https:// or BYOND will be sad
	var/volume = 70

/singleton/music_track/Initialize()
	. = ..()
	license = GET_SINGLETON(license)

/singleton/music_track/proc/play_to(var/listener)
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]</span>")
	if(url)
		to_chat(listener, url)

	to_chat(listener, "<span class='good'>License: <a href='[license.url]'>[license.name]</a></span>")

// No VV editing anything about music tracks
/singleton/music_track/VV_static()
	return ..() + vars
