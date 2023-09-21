/datum/pai_software/directives
	name = "Directives"
	ram_cost = 0
	id = "directives"
	toggle = 0
	default = 1

/datum/pai_software/directives/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	var/data[0]

	data["master"] = user.master
	data["dna"] = user.master_dna
	data["prime"] = user.pai_law0
	data["supplemental"] = user.pai_laws

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "pai_directives.tmpl", "pAI Directives", 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/pai_software/directives/Topic(href, href_list)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P))
		return

	if(href_list["getdna"])
		var/mob/living/M = P.loc
		var/count = 0

		// Find the carrier
		while(!istype(M, /mob/living))
			if(!M || !M.loc || count > 6)
				//For a runtime where M ends up in nullspace (similar to bluespace but less colourful)
				to_chat(src, "You are not being carried by anyone!")
				return 0
			M = M.loc
			count++

		// Check the carrier
		var/datum/gender/TM = GLOB.gender_datums[M.get_visible_gender()]
		var/answer = input(M, "[P] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[P] Check DNA", "No") in list("Yes", "No")
		if(answer == "Yes")
			var/turf/T = get_turf_or_move(P.loc)
			for (var/mob/v in viewers(T))
				v.show_message("<span class='notice'>[M] presses [TM.his] thumb against [P].</span>", 3, "<span class='notice'>[P] makes a sharp clicking sound as it extracts DNA material from [M].</span>", 2)
			var/datum/dna/dna = M.dna
			to_chat(P, "<font color = red><h3>[M]'s UE string : [dna.unique_enzymes]</h3></font>")
			if(dna.unique_enzymes == P.master_dna)
				to_chat(P, "<b>DNA is a match to stored Master DNA.</b>")
			else
				to_chat(P, "<b>DNA does not match stored Master DNA.</b>")
		else
			to_chat(P, "[M] does not seem like [TM.he] is going to provide a DNA sample willingly.")
		return 1
