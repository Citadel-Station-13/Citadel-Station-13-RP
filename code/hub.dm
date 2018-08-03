/world

	hub = "Exadv1.spacestation13"
	//hub_password = "SORRYNOPASSWORD"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Space Station 13"

/* This is for any host that would like their server to appear on the main SS13 hub.
To use it, simply replace the password above, with the password found below, and it should work.
If not, let us know on the main tgstation IRC channel of irc.rizon.net #tgstation13 we can help you there.

	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Space Station 13"
*/

/world/proc/update_hub_visibility(new_value)
	if(new_value)				//I'm lazy so this is how I wrap it to a bool number
		new_value = TRUE
	else
		new_value = FALSE
	if(new_value == visibility)
		return

	visibility = new_value
	if(visibility)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"
