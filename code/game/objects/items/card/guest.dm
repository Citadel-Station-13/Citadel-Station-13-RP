/obj/item/card/id/guest
	name = "guest pass"
	desc = "Allows temporary access to station areas."
	icon_state = "guest"
	light_color = "#0099ff"

	/// issue time
	var/issue_time
	/// expire time
	var/expire_time
	/// expire timerid
	var/expire_timerid
	/// expired
	var/expired = FALSE
	/// reason
	var/given_reason = "NOT SPECIFIED"
	/// issuer name
	var/giver_name = "Unknown"
	/// issuer rakn
	var/giver_rank = "Unknown"

/obj/item/card/id/guest/proc/prime_for(time, issued = FALSE)
	if(issued)
		issue_time = world.time
	expire_time = world.time + time
	if(expire_timerid)
		deltimer(expire_timerid)
		expire_timerid = null
	expire_timerid = addtimer(CALLBACK(src, PROC_REF(expire)), time, TIMER_STOPPABLE)
	expired = FALSE

/obj/item/card/id/guest/proc/expire()
	visible_message("<span class='warning'>\The [src] flashes a few times before turning red.</span>")
	expire_time = world.time
	expired = TRUE
	update_icon()
	access.len = 0
	if(expire_timerid)
		deltimer(expire_timerid)
		expire_timerid = null

/obj/item/card/id/guest/update_icon_state()
	icon_state = expired ? "guest-invalid" : "guest"
	base_icon_state = expired ? "guest-invalid" : "guest"
	return ..()

// todo: refactor everything below

/obj/item/card/id/guest/examine(mob/user, dist)
	. = ..()
	if (!expired)
		. += "<span class='notice'>This pass expires at [worldtime2stationtime(expire_time)].</span>"
	else
		. += "<span class='warning'>It expired at [worldtime2stationtime(expire_time)].</span>"

/obj/item/card/id/guest/get_description_info()
	. = ..()
	. += "This guest pass provides time-limited access to an area, similar to an ID card. Use it in your hand on harm intent to prematurely deactivate it.<br><br>"
	if (expired)
		. += SPAN_NOTICE("This pass expired at [worldtime2stationtime(expire_time)].<br>")
	else
		. += SPAN_NOTICE("This pass expires at [worldtime2stationtime(expire_time)].<br>")
	. += SPAN_NOTICE("It grants access to following areas:<br>")
	for (var/A in access)
		. += SPAN_NOTICE("[get_access_desc(A)].<br>")
	. += "<br>"
	. += SPAN_NOTICE("Issuing reason: [given_reason].<br>")
	. += SPAN_NOTICE("Issuer name: [giver_name]<br>")
	. += SPAN_NOTICE("Issuer rank: [giver_rank]<br>")

/obj/item/card/id/guest/attack_self(mob/user, datum/event_args/actor/actor)
	if(user.a_intent == INTENT_HARM)
		if(expired)
			to_chat(user, "<span class='warning'>This guest pass is already deactivated!</span>")
			return ..()

		var/confirm = alert("Do you really want to deactivate this guest pass? (you can't reactivate it)", "Confirm Deactivation", "Yes", "No")
		if(confirm == "Yes")
			//rip guest pass </3
			user.visible_message("<span class='notice'>\The [user] deactivates \the [src].</span>")
			expire()
	else return ..()
