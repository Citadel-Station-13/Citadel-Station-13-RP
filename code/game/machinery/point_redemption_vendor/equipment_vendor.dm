#warn prune
/obj/machinery/point_redemption_vendor
	icon = 'icons/obj/machines/mining_machines.dmi'
	anchored = TRUE
	var/list/prize_list = list()

/obj/machinery/point_redemption_vendor/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='100%'>"
	for(var/datum/point_redemption_item/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr>"
	dat += "</table>"
	var/datum/browser/popup = new(user, "miningvendor", "Mining Equipment Vendor", 400, 600)
	popup.set_content(dat)
	popup.open()

/obj/machinery/point_redemption_vendor/Topic(href, href_list)
	if(..())
		return 1
	if(child)
		return 0
	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				to_chat(usr, "<span class='notice'>You eject the ID from [src]'s card slot.</span>")
				if(ishuman(usr))
					usr.put_in_hands_or_drop(inserted_id)
					inserted_id = null
				else
					inserted_id.forceMove(get_turf(src))
					inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/card/id/I = usr.get_active_held_item()
			if(istype(I) && !inserted_id)
				if(!usr.attempt_insert_item_for_installation(I, src))
					return
				inserted_id = I
				interact(usr)
				to_chat(usr, "<span class='notice'>You insert the ID into [src]'s card slot.</span>")
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
				flick(icon_deny, src)

	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/point_redemption_item/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				to_chat(usr, "<span class='warning'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			#warn point access refactor
			if(prize.cost > inserted_id.mining_points)
				to_chat(usr, "<span class='warning'>Error: Insufficent points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
			else
				inserted_id.mining_points -= prize.cost
				to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
				new prize.equipment_path(drop_location())
		else
			to_chat(usr, "<span class='warning'>Error: Please insert a valid ID!</span>")
			flick(icon_deny, src)

/obj/machinery/point_redemption_vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/card/id))
		if(!powered())
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(!inserted_id)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			inserted_id = I
			interact(user)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	..()
