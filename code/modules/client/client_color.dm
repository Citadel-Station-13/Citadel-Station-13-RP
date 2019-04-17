
/*
	Client color Priority System By RemieRichards
	A System that gives finer control over which client.color value to display on screen
	so that the "highest priority" one is always displayed as opposed to the default of
	"whichever was set last is displayed"
*/



/*
	Define subtypes of this datum
*/
/datum/client_color
	var/color = "" //Any client.color-valid value
	var/priority = 1 //Since only one client.color can be rendered on screen, we take the one with the highest priority value:
	//eg: "Bloody screen" > "goggles color" as the former is much more important


/mob
	var/list/client_colors = list()



/*
	Adds an instance of color_type to the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
*/
/mob/proc/add_client_color(color_type)
	if(!ispath(color_type, /datum/client_color))
		return

	var/datum/client_color/CC = new color_type()
	client_colors |= CC
	sortTim(client_colors, /proc/cmp_clientcolor_priority)
	update_client_color()


/*
	Removes an instance of color_type from the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
*/
/mob/proc/remove_client_color(color_type)
	if(!ispath(color_type, /datum/client_color))
		return

	for(var/cc in client_colors)
		var/datum/client_color/CC = cc
		if(CC.type == color_type)
			client_colors -= CC
			qdel(CC)
			break
	update_client_color()


/*
	Resets the mob's client.color to null, and then sets it to the highest priority
	client_color datum, if one exists
*/
/mob/proc/update_client_color()
	if(!client)
		return
	client.color = ""
	if(!client_colors.len)
		return
	var/datum/client_color/CC = client_colors[1]
	if(CC)
		animate(client, color = CC.color, time = 10)

/datum/client_color/glass_color
	priority = 0
	color = "red"

/datum/client_color/glass_color/green
	color = "#aaffaa"

/datum/client_color/glass_color/lightgreen
	color = "#ccffcc"

/datum/client_color/glass_color/blue
	color = "#aaaaff"

/datum/client_color/glass_color/lightblue
	color = "#ccccff"

/datum/client_color/glass_color/yellow
	color = "#ffff66"

/datum/client_color/glass_color/red
	color = "#ffaaaa"

/datum/client_color/glass_color/darkred
	color = "#bb5555"

/datum/client_color/glass_color/orange
	color = "#ffbb99"

/datum/client_color/glass_color/lightorange
	color = "#ffddaa"

/datum/client_color/glass_color/purple
	color = "#ff99ff"

/datum/client_color/glass_color/gray
	color = "#cccccc"


/datum/client_color/monochrome
	color = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	priority = INFINITY //we can't see colors anyway!
