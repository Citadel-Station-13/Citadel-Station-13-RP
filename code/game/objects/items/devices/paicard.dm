GLOBAL_LIST_BOILERPLATE(all_pai_cards, /obj/item/paicard)

/obj/item/paicard
	name = "personal AI device"
	icon = 'icons/obj/pda.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2)
	show_messages = FALSE
	preserve_item = TRUE

	var/holoray_icon = 'icons/obj/pda.dmi'
	var/holoray_icon_state = "pai_holoray"
	var/image/displayed_hologram
	var/displaying_hologram = FALSE

	var/current_emotion = "off"
	var/obj/item/radio/radio
	var/looking_for_personality = FALSE
	var/mob/living/silicon/pai/pai
	var/image/cached_holo_image

/obj/item/paicard/relaymove(var/mob/user, var/direction)
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_MOVE))
		return
	var/obj/item/hardsuit/hardsuit = src.get_hardsuit()
	if(istype(hardsuit))
		hardsuit.forced_move(direction, user)

/obj/item/paicard/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(stop_displaying_hologram))
	add_overlay("pai-off")

/obj/item/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(!isnull(pai))
		pai.death(0)
	QDEL_NULL(radio)
	return ..()

/obj/item/paicard/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = {"
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html>
			<head>
				<style>
					body {
					    margin-top:5px;
					    font-family:Verdana;
					    color:white;
					    font-size:13px;
					    background-image:url('uiBackground.png');
					    background-repeat:repeat-x;
					    background-color:#272727;
						background-position:center top;
					}
					table {
					    font-size:13px;
					    margin-left:-2px;
					}
					table.request {
					    border-collapse:collapse;
					}
					table.desc {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					table.download {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					tr.d0 td, tr.d0 th {
					    background-color: #506070;
					    color: white;
					}
					tr.d1 td, tr.d1 th {
					    background-color: #708090;
					    color: white;
					}
					tr.d2 td {
					    background-color: #00FF00;
					    color: white;
					    text-align:center;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					td.button_red {
					    border: 1px solid #161616;
					    background-color: #B04040;
					    text-align: center;
					}
					td.download {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					th {
					    text-align:left;
					    width:125px;
					}
					td.request {
					    width:140px;
					    vertical-align:top;
					}
					td.radio {
					    width:90px;
					    vertical-align:top;
					}
					td.request {
					    vertical-align:top;
					}
					a {
					    color:#4477E0;
					}
					a.button {
					    color:white;
					    text-decoration: none;
					}
					h2 {
					    font-size:15px;
					}
				</style>
			</head>
			<body>
	"}

	if(pai)
		dat += {"
			<b><font size='3px'>Personal AI Device</font></b><br><br>
			<table class="request">
				<tr>
					<td class="request">Installed Personality:</td>
					<td>[pai.name]</td>
				</tr>
				<tr>
					<td class="request">Prime directive:</td>
					<td>[pai.pai_law0]</td>
				</tr>
				<tr>
					<td class="request">Additional directives:</td>
					<td>[pai.pai_laws]</td>
				</tr>
			</table>
			<br>
		"}
		dat += {"
			<table>
				<td class="button">
					<a href='byond://?src=\ref[src];setlaws=1' class='button'>Configure Directives</a>
				</td>
			</table>
		"}
		if(pai && (!pai.master_dna || !pai.master))
			dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];setdna=1' class='button'>Imprint Master DNA</a>
					</td>
				</table>
			"}
		dat += "<br>"
		if(radio)
			dat += "<b>Radio Uplink</b>"
			dat += {"
				<table class="request">
					<tr>
						<td class="radio">Transmit:</td>
						<td><a href='byond://?src=\ref[src];wires=4'>[radio.broadcasting ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>

						</td>
					</tr>
					<tr>
						<td class="radio">Receive:</td>
						<td><a href='byond://?src=\ref[src];wires=2'>[radio.listening ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>

						</td>
					</tr>
				</table>
				<br>
			"}
		else //</font></font>
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		dat += {"
			<table>
				<td class="button_red"><a href='byond://?src=\ref[src];wipe=1' class='button'>Wipe current pAI personality</a>

				</td>
			</table>
		"}
	else
		if(looking_for_personality)
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
				<p>Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>
				<img src='loading.gif' /> Searching for personalities<br><br>

				<table>
					<tr>
						<td class="button">
							<a href='byond://?src=\ref[src];request=1' class="button">Refresh available personalities</a>
						</td>
					</tr>
				</table><br>
			"}
		else
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
			    <p>No personality is installed.</p>
				<table>
					<tr>
						<td class="button"><a href='byond://?src=\ref[src];request=1' class="button">Request personality</a>
						</td>
					</tr>
				</table>
				<br>
				<p>Each time this button is pressed, a request will be sent out to any available personalities. Check back often give plenty of time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timeliness.</p>
			"}
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")

/obj/item/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if(href_list["setdna"])
		if(pai.master_dna)
			return
		var/mob/M = usr
		if(!istype(M, /mob/living/carbon))
			to_chat(usr, "<font color=blue>You don't have any DNA, or your DNA is incompatible with this device.</font>")
		else
			var/datum/dna/dna = usr.dna
			pai.master = M.real_name
			pai.master_dna = dna.unique_enzymes
			to_chat(pai, "<font color = red><h3>You have been bound to a new master.</h3></font>")
	if(href_list["request"])
		src.looking_for_personality = 1
		paiController.findPAI(src, usr)
	if(href_list["wipe"])
		var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
		if(confirm == "Yes")
			for(var/mob/M in src)
				to_chat(M, "<font color = #ff0000><h2>You feel yourself slipping away from reality.</h2></font>")
				to_chat(M, "<font color = #ff4d4d><h3>Byte by byte you lose your sense of self.</h3></font>")
				to_chat(M, "<font color = #ff8787><h4>Your mental faculties leave you.</h4></font>")
				to_chat(M, "<font color = #ffc4c4><h5>oblivion... </h5></font>")
			removePersonality()
	if(href_list["wires"])
		var/t1 = text2num(href_list["wires"])
		switch(t1)
			if(4)
				radio.ToggleBroadcast()
			if(2)
				radio.ToggleReception()
	if(href_list["setlaws"])
		var/newlaws = sanitize(input("Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.pai_laws) as message)
		if(newlaws)
			pai.pai_laws = newlaws
			to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
			to_chat(pai, "Prime Directive: <br>[pai.pai_law0]")
			to_chat(pai, "Supplemental Directives: <br>[pai.pai_laws]")
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	pai = personality
	setEmotion("null")
	src.forceMove(get_turf(src))
	pai.open_up()

/obj/item/paicard/proc/removePersonality()
	QDEL_NULL(pai)
	pai = null
	cached_holo_image = null
	displaying_hologram = FALSE
	displayed_hologram = null
	setEmotion("off")

/obj/item/paicard/proc/setEmotion(emotion)
	current_emotion = emotion
	update_icons()

/obj/item/paicard/proc/get_holo_image()
	if(cached_holo_image)
		return cached_holo_image
	if(!pai.last_rendered_hologram_icon)
		pai.last_rendered_hologram_icon = pai.get_holo_image()
	var/icon/new_icon = icon(pai.last_rendered_hologram_icon)
	var/crop_adjustment = (new_icon.Width() - 32) / 2
	new_icon.Crop(12 + crop_adjustment, 21, 21 + crop_adjustment, 30)
	var/image/image = image(new_icon, pixel_x = 11, pixel_y = 9)
	cached_holo_image = image
	return image

/obj/item/paicard/proc/alertUpdate()
	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<span class='notice'>\The [src] flashes a message across its screen, \"Additional personalities available for download.\"</span>", 3, "<span class='notice'>\The [src] bleeps electronically.</span>", 2)

/obj/item/paicard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)

/obj/item/paicard/legacy_ex_act(severity)
	if(pai)
		LEGACY_EX_ACT(pai, severity, null)
	else
		qdel(src)

/obj/item/paicard/show_message(msg, type, alt, alt_type)
	if(pai && pai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		pai.show_message(rendered, type)
	..()

/obj/item/paicard/proc/update_icons()
	cut_overlays()

	// handle our screen overlays
	if(current_emotion != "off" && current_emotion != "character")
		add_overlay("pai-underlay")
		add_overlay("pai-[current_emotion]")
	else if(current_emotion == "character")
		var/image/image = get_holo_image()
		if(displaying_hologram)
			image.pixel_x = 9
			image.pixel_y = 11
		else
			image.pixel_x = 11
			image.pixel_y = 9
		add_overlay(image)
	else
		add_overlay("pai-off")

	// if we are displaying a hologram currently, display it
	if(displaying_hologram)
		var/image/holoray_image = image(holoray_icon, holoray_icon_state)
		holoray_image.appearance_flags = RESET_TRANSFORM | KEEP_APART
		add_overlay(holoray_image)
		add_overlay(displayed_hologram)

		// we also make some adjustments to ourselves to make displaying it look nicer
		var/matrix/M = matrix()
		M.Turn(90)
		M.Translate(1, -8)

		transform = M
	else
		// not displaying a hologram? reset our transforms because it might be wrong
		var/matrix/M = matrix()
		transform = M

/obj/item/paicard/proc/display_hologram_from_image(image)
	displaying_hologram = TRUE
	displayed_hologram = image
	update_icons()

/obj/item/paicard/proc/stop_displaying_hologram()
	displaying_hologram = FALSE
	update_icons()
