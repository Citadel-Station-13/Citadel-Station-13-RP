/datum/job/station/chaplain
	id = JOB_ID_CHAPLAIN
	title = "Chaplain"
	flag = CHAPLAIN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/chaplain
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_chapel_office, access_crematorium)

	outfit_type = /datum/outfit/job/station/chaplain
	desc = "The Chaplain ministers to the spiritual needs of the crew."
	alt_titles = list(
		"Counselor" = /datum/alt_title/counselor,
		"Religious Affairs Advisor" = /datum/alt_title/chaplain/advisor
		)

// Chaplain Alt Titles
/datum/alt_title/counselor
	title = "Counselor"
	title_blurb = "The Counselor attends to the emotional needs of the crew, without a specific medicinal or spiritual focus."

/datum/alt_title/chaplain/advisor
	title = "Religious Affairs Advisor"

/datum/job/station/chaplain/equip(mob/living/carbon/human/H, src)
	. = ..()
	if(H.mind)
		H.mind.isholy = TRUE
/datum/job/station/chaplain/equip(var/mob/living/carbon/human/H, var/alt_title, var/ask_questions = TRUE)
	. = ..()
	if(!.)
		return
	if(!ask_questions)
		return
	var/obj/item/storage/bible/B = locate(/obj/item/storage/bible) in H
	if(!B)
		return
	spawn(0)
		var/religion_name = "Unitarianism"
		var/new_religion = sanitize(input(H, "You are the crew services officer. Would you like to change your religion? Default is Unitarianism", "Name change", religion_name), MAX_NAME_LEN)
		if (!new_religion)
			new_religion = religion_name
		switch(lowertext(new_religion))
			if("unitarianism")
				B.name = "The Talmudic Quran"
			if("christianity")
				B.name = "The Holy Bible"
			if("judaism")
				B.name = "The Torah"
			if("islam")
				B.name = "Quran"
			if("buddhism")
				B.name = "Tripitakas"
			if("hinduism")
				B.name = pick("The Srimad Bhagvatam", "The Four Vedas", "The Shiv Mahapuran", "Devi Mahatmya")
			if("neopaganism")
				B.name = "Neopagan Hymnbook"
			if("phact shintoism")
				B.name = "The Kojiki"
			if("kishari national faith")
				B.name = "The Scriptures of Kishar"
			if("pleromanism")
				B.name = "The Revised Talmudic Quran"
			if("spectralism")
				B.name = "The Book of the Spark"
			if("hauler")
				B.name = "Histories of Captaincy"
			if("nock")
				B.name = "The Book of the First"
			if("singulitarian worship")
				B.name = "The Book of the Precursors"
			if("starlit path of angessa martei")
				B.name = "Quotations of Exalted Martei"
			else
				var/book_name = sanitize(input(H, "What would you like your holy book to be called? Default is The Holy Book of <religion>", "Holy book name", "The Holy Book of [new_religion]"), MAX_NAME_LEN)
				B.name = book_name
				//B.name = "The Holy Book of [new_religion]" -- replaced by the above line
		feedback_set_details("religion_name","[new_religion]")
	spawn(1)
		var/deity_name = "Hashem"
		var/new_deity = sanitize(input(H, "Would you like to change your deity? Default is Hashem", "Name change", deity_name), MAX_NAME_LEN)
		if ((length(new_deity) == 0) || (new_deity == "Hashem") )
			new_deity = deity_name
		B.deity_name = new_deity
		var/accepted = 0
		var/outoftime = 0
		spawn(200) // 20 seconds to choose
			outoftime = 1
		var/new_book_style = "Bible"
		while(!accepted)
			if(!B) break // prevents possible runtime errors
			new_book_style = input(H,"Which bible style would you like?") in list("Bible", "Koran", "Scrapbook", "Pagan", "White Bible", "Holy Light", "Athiest", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon","Orthodox","Torah")
			switch(new_book_style)
				if("Koran")
					B.icon_state = "koran"
					B.item_state = "koran"
				if("Scrapbook")
					B.icon_state = "scrapbook"
					B.item_state = "scrapbook"
				if("White Bible")
					B.icon_state = "white"
					B.item_state = "syringe_kit"
				if("Holy Light")
					B.icon_state = "holylight"
					B.item_state = "syringe_kit"
				if("Athiest")
					B.icon_state = "athiest"
					B.item_state = "syringe_kit"
				if("Tome")
					B.icon_state = "tome"
					B.item_state = "syringe_kit"
				if("The King in Yellow")
					B.icon_state = "kingyellow"
					B.item_state = "kingyellow"
				if("Ithaqua")
					B.icon_state = "ithaqua"
					B.item_state = "ithaqua"
				if("Scientology")
					B.icon_state = "scientology"
					B.item_state = "scientology"
				if("the bible melts")
					B.icon_state = "melted"
					B.item_state = "melted"
				if("Necronomicon")
					B.icon_state = "necronomicon"
					B.item_state = "necronomicon"
				if("Pagan")
					B.icon_state = "shadows"
					B.item_state = "syringe_kit"
				if("Orthodox")
					B.icon_state = "orthodoxy"
					B.item_state = "bible"
				if("Torah")
					B.icon_state = "torah"
					B.item_state = "clipboard"
				else
					B.icon_state = "bible"
					B.item_state = "bible"
			H.update_inv_l_hand() // so that it updates the bible's item_state in his hand
			switch(input(H,"Look at your bible - is this what you want?") in list("Yes","No"))
				if("Yes")
					accepted = 1
				if("No")
					if(outoftime)
						to_chat(H, "Welp, out of time, buddy. You're stuck. Next time choose faster.")
						accepted = 1
		GLOB.religion = religion_name
		GLOB.bible_name = B.name
		GLOB.deity = B.deity_name
		if(SSticker)
			SSticker.Bible_icon_state = B.icon_state
			SSticker.Bible_item_state = B.item_state
			SSticker.Bible_name = B.name
			SSticker.Bible_deity_name = B.deity_name
		feedback_set_details("religion_deity","[new_deity]")
		feedback_set_details("religion_book","[new_book_style]")
	return 1

/datum/outfit/job/station/chaplain
	name = OUTFIT_JOB_NAME("Chaplain")
	uniform = /obj/item/clothing/under/rank/chaplain
	l_hand = /obj/item/storage/bible
	id_type = /obj/item/card/id/civilian/chaplain
	pda_type = /obj/item/pda/chaplain
