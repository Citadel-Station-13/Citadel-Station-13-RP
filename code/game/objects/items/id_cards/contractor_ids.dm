/obj/item/card/id/contractor
	var/employing_coperation = ""
	var/extern_title = ""
	//var/expiry_date = ""
	icon_state = "chit"

/obj/item/card/id/contractor/dat()
	. = ..()
	. += "Employing Company: [employing_coperation]"
	. += "External Job Title: [extern_title]"
	// . += "Expiration Date: [expiry_date]"

/obj/item/card/id/contractor/update_icon()
	return 0

/obj/item/card/id/contractor/update_icon_state()
	. = ..()
	var/datum/role/job/J = SSjob.get_job(rank)
	var/department = lowertext(LAZYACCESS(J?.departments,1))
	switch(department)
		if("security")
			icon_state = "chit_red"
		if("medical")
			icon_state = "chit_blue"
		if("engineering")
			icon_state = "chit_orange"
		if("cargo")
			icon_state = "chit_green"
		if("command")
			icon_state = "chit_white"
		if("science")
			icon_state = "chit_purple"
		else
			icon_state = "chit"
	return 0

/obj/item/card/id/contractor/Initialize(mapload)
	. = ..()

/obj/item/card/id/contractor/set_registered_rank(rank = src.rank, assignment)
	src.rank = rank
	src.extern_title = assignment
	src.assignment = rank
	update_icon_state()
	update_name()

