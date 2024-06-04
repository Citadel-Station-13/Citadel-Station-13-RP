/datum/pai_software/door_jack
	name = "Door Jack"
	ram_cost = 30
	id = "door_jack"
	toggle = 0

/datum/pai_software/door_jack/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	var/data[0]

	data["cable"] = user.cable != null
	data["machine"] = user.cable && (user.cable.machine != null)
	data["inprogress"] = user.hackdoor != null
	data["progress_a"] = round(user.hackprogress / 10)
	data["progress_b"] = user.hackprogress % 10
	data["aborted"] = user.hack_aborted

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "pai_doorjack.tmpl", "Door Jack", 300, 150)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/pai_software/door_jack/Topic(href, href_list)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P))
		return

	if(href_list["jack"])
		if(P.cable && P.cable.machine)
			P.hackdoor = P.cable.machine
			P.hackloop()
		return 1
	else if(href_list["cancel"])
		P.hackdoor = null
		return 1
	else if(href_list["cable"])
		var/turf/T = get_turf_or_move(P.loc)
		P.hack_aborted = 0
		P.cable = new /obj/item/pai_cable(T)
		for(var/mob/M in viewers(T))
			M.show_message("<span class='warning'>A port on [P] opens to reveal [P.cable], which promptly falls to the floor.</span>", 3,
							"<span class='warning'>You hear the soft click of something light and hard falling to the ground.</span>", 2)
		return 1

/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf_or_move(src.loc)
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		if(T.loc)
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>")
		else
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>")
	var/obj/machinery/door/D = cable.machine
	if(!istype(D))
		hack_aborted = 1
		hackprogress = 0
		cable.machine = null
		hackdoor = null
		return
	while(hackprogress < 1000)
		if(cable && cable.machine == D && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress = min(hackprogress+rand(1, 20), 1000)
		else
			hack_aborted = 1
			hackprogress = 0
			hackdoor = null
			return
		if(hackprogress >= 1000)
			hackprogress = 0
			D.open()
			cable.machine = null
			return
		sleep(10)			// Update every second
