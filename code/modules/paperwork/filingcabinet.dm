/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"

/obj/structure/filingcabinet/chestdrawer/unanchored
	anchored = FALSE

/obj/structure/filingcabinet/tall	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"

/obj/structure/filingcabinet/Initialize(mapload)
	. = ..()
	if(mapload)
		for(var/obj/item/I in loc)
			if(I.w_class < WEIGHT_CLASS_NORMAL) //there probably shouldn't be anything placed ontop of filing cabinets in a map that isn't meant to go in them
				I.forceMove(src)

/obj/structure/filingcabinet/deconstructed(disassembled = TRUE)
	new /obj/item/stack/material/iron(loc, 2)
	for(var/obj/item/obj in src)
		obj.forceMove(loc)

/obj/structure/filingcabinet/attackby(obj/item/P, mob/living/user, params)
	if(P.is_wrench() && user.a_intent != INTENT_HELP)
		to_chat(user, SPAN_NOTICE("You begin to [anchored ? "unwrench" : "wrench"] [src]."))
		if(P.use_tool(src, user, 20, volume=50))
			to_chat(user, SPAN_NOTICE("You successfully [anchored ? "unwrench" : "wrench"] [src]."))
			set_anchored(!anchored)
	else if(P.is_screwdriver() && user.a_intent != INTENT_HELP)
		to_chat(user, SPAN_NOTICE("You begin taking the [name] apart."))
		playsound(src, P.tool_sound, 50, 1)
		if(do_after(user, 10 * P.tool_speed))
			playsound(loc, P.tool_sound, 50, 1)
			deconstruct()
		return
	else if(P.w_class < WEIGHT_CLASS_NORMAL)
		if(!user.transfer_item_to_loc(P, src))
			return
		to_chat(user, SPAN_NOTICE("You put [P] in [src]."))
		icon_state = "[initial(icon_state)]-open"
		sleep(0.5 SECONDS)
		icon_state = initial(icon_state)
	else if(user.a_intent == INTENT_HELP || (P.item_flags & ITEM_NO_BLUDGEON))
		to_chat(user, SPAN_WARNING("You can't put [P] in [src]!"))
	else
		return ..()

/obj/structure/filingcabinet/attack_hand(mob/living/carbon/user)
	. = ..()
	ui_interact(user)

/obj/structure/filingcabinet/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FilingCabinet")
		ui.open()

/obj/structure/filingcabinet/ui_data(mob/user)
	var/list/data = list()

	data["cabinet_name"] = "[name]"
	data["contents"] = list()
	data["contents_ref"] = list()
	for(var/obj/item/content in src)
		data["contents"] += "[content]"
		data["contents_ref"] += "[REF(content)]"

	return data

/obj/structure/filingcabinet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		// Take the object out
		if("remove_object")
			var/obj/item/content = locate(params["ref"]) in src
			if(istype(content) && in_range(src, usr))
				usr.put_in_hands(content)
				icon_state = "[initial(icon_state)]-open"
				addtimer(VARSET_CALLBACK(src, icon_state, initial(icon_state)), 0.5 SECONDS)
				return TRUE

/obj/structure/filingcabinet/attack_tk(mob/user)
	if(anchored)
		return attack_self_tk(user)
	return ..()

/obj/structure/filingcabinet/attack_self_tk(mob/user)
	if(contents.len)
		if(prob(40 + contents.len * 5))
			var/obj/item/I = pick(contents)
			I.forceMove(loc)
			if(prob(25))
				step_rand(I)
			to_chat(user, SPAN_NOTICE("You pull \a [I] out of [src] at random."))
			return
	to_chat(user, SPAN_NOTICE("You find nothing in [src]."))

/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = TRUE

/obj/structure/filingcabinet/security/proc/populate()
	if(!virgin)
		return
	for(var/datum/data/record/G in data_core.general)
		var/datum/data/record/S
		for(var/datum/data/record/R in data_core.security)
			if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
				S = R
				break
		var/obj/item/paper/P = new /obj/item/paper(src)
		P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
		P.info += "Name: [G.fields["name"]] ID: [G.fields["id"]]<BR>\nSex: [G.fields["sex"]]<BR>\nAge: [G.fields["age"]]<BR>\nFingerprint: [G.fields["fingerprint"]]<BR>\nPhysical Status: [G.fields["p_stat"]]<BR>\nMental Status: [G.fields["m_stat"]]<BR>"
		P.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: [S.fields["criminal"]]<BR>\n<BR>\nMinor Crimes: [S.fields["mi_crim"]]<BR>\nDetails: [S.fields["mi_crim_d"]]<BR>\n<BR>\nMajor Crimes: [S.fields["ma_crim"]]<BR>\nDetails: [S.fields["ma_crim_d"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[S.fields["notes"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
		var/counter = 1
		while(S.fields["com_[counter]"])
			P.info += "[S.fields["com_[counter]"]]<BR>"
			counter++
		P.info += "</TT>"
		P.name = "Security Record ([G.fields["name"]])"
		P.update_appearance()
		virgin = FALSE //tabbing here is correct- it's possible for people to try and use it
					//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/security/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	populate()
	return ..()

/obj/structure/filingcabinet/security/attack_tk()
	populate()
	return ..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = TRUE

/obj/structure/filingcabinet/medical/proc/populate()
	if(!virgin)
		return
	for(var/datum/data/record/G in data_core.general)
		var/datum/data/record/M
		for(var/datum/data/record/R in data_core.medical)
			if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
				M = R
				break
		if(M)
			var/obj/item/paper/med_record_paper = new /obj/item/paper(src)
			med_record_paper.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
			med_record_paper.info += "Name: [G.fields["name"]] ID: [G.fields["id"]]<BR>\nSex: [G.fields["sex"]]<BR>\nAge: [G.fields["age"]]<BR>\nFingerprint: [G.fields["fingerprint"]]<BR>\nPhysical Status: [G.fields["p_stat"]]<BR>\nMental Status: [G.fields["m_stat"]]<BR>"

			med_record_paper.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [M.fields["b_type"]]<BR>\nDNA: [M.fields["b_dna"]]<BR>\n<BR>\nMinor Disabilities: [M.fields["mi_dis"]]<BR>\nDetails: [M.fields["mi_dis_d"]]<BR>\n<BR>\nMajor Disabilities: [M.fields["ma_dis"]]<BR>\nDetails: [M.fields["ma_dis_d"]]<BR>\n<BR>\nAllergies: [M.fields["alg"]]<BR>\nDetails: [M.fields["alg_d"]]<BR>\n<BR>\nCurrent Diseases: [M.fields["cdi"]] (per disease info placed in log/comment section)<BR>\nDetails: [M.fields["cdi_d"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[M.fields["notes"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
			var/counter = 1
			while(M.fields["com_[counter]"])
				med_record_paper.info += "[M.fields["com_[counter]"]]<BR>"
				counter++
			med_record_paper.info += "</TT>"
			med_record_paper.name = "Medical Record ([G.fields["name"]])"
			med_record_paper.update_appearance()
		virgin = FALSE //tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/medical/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	populate()
	return ..()

/obj/structure/filingcabinet/medical/attack_tk()
	populate()
	return ..()
