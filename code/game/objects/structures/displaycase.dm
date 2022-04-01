/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox"
	desc = "A display case for prized possessions."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE // Dissolving the case would also delete the gun.
	var/alert = TRUE
	var/open = FALSE
	var/openable = TRUE
	var/broken = FALSE
	var/health = 30
	var/destroyed = FALSE
	var/obj/item/showpiece = null
	var/obj/item/showpiece_type = null //This allows for showpieces that can only hold items if they're the same istype as this.
	var/start_showpiece_type = null //add type for items on display
	var/list/start_showpieces = list() //Takes sublists in the form of list("type" = /obj/item/bikehorn, "trophy_message" = "henk")
	var/trophy_message = ""
	var/datum/alarm_handler/alarm_manager

/obj/structure/displaycase/Initialize(mapload)
	. = ..()
	if(start_showpieces.len && !start_showpiece_type)
		var/list/showpiece_entry = pick(start_showpieces)
		if (showpiece_entry && showpiece_entry["type"])
			start_showpiece_type = showpiece_entry["type"]
			if (showpiece_entry["trophy_message"])
				trophy_message = showpiece_entry["trophy_message"]
	if(start_showpiece_type)
		showpiece = new start_showpiece_type (src)
	update_appearance()
	alarm_manager = new(src)

/obj/structure/displaycase/vv_edit_var(vname, vval)
	. = ..()
	if(vname in list(NAMEOF(src, open), NAMEOF(src, showpiece)/*, NAMEOF(src, custom_glass_overlay)*/))
		update_appearance()

/obj/structure/displaycase/handle_atom_del(atom/A)
	if(A == showpiece)
		showpiece = null
		update_appearance()
	return ..()

/obj/structure/displaycase/Destroy()
	QDEL_NULL(showpiece)
	QDEL_NULL(alarm_manager)
	return ..()

/obj/structure/displaycase/examine(mob/user)
	. = ..()
	if(alert)
		. += SPAN_NOTICE("Hooked up with an anti-theft system.")
	if(showpiece)
		. += SPAN_NOTICE("There's \a [showpiece] inside.")
	if(trophy_message)
		. += "The plaque reads:\n [trophy_message]"

/obj/structure/displaycase/proc/dump()
	if(QDELETED(showpiece))
		return
	showpiece.forceMove(drop_location())
	showpiece = null
	update_appearance()
/*
/obj/structure/displaycase/atom_break(damage_flag)
	. = ..()
	if(!broken && !(flags & NODECONSTRUCT))
		set_density(FALSE)
		broken = TRUE
		new /obj/item/material/shard(drop_location())
		playsound(src, SFX_SHATTER, 70, TRUE)
		update_appearance()
		trigger_alarm()
*/
///Anti-theft alarm triggered when broken.
/obj/structure/displaycase/proc/trigger_alarm()
	if(!alert)
		return
/*
	var/area/alarmed = get_area(src)
	alarmed.burglaralert(src)

	SSalarms.camera_alarm.triggerAlarm(loc, src, duration)
	addtimer(CALLBACK(alarm_manager, /datum/alarm_handler/proc/clear_alarm, ALARM_BURGLAR), 1 MINUTES)
*/
	playsound(src, 'sound/effects/alert.ogg', 50, TRUE)

/obj/structure/displaycase/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			density = FALSE
			destroyed = TRUE
			new /obj/item/material/shard(loc)
			playsound(src, "shatter", 70, 1)
			update_appearance()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, TRUE)
	return

/obj/structure/displaycase/update_overlays()
	. = ..()
	if(showpiece)
		var/mutable_appearance/showpiece_overlay = mutable_appearance(showpiece.icon, showpiece.icon_state)
		showpiece_overlay.copy_overlays(showpiece)
		showpiece_overlay.transform *= 0.6
		. += showpiece_overlay
	//if(custom_glass_overlay)
		//return
	if(broken)
		. += "[initial(icon_state)]_broken"
		return
	if(!open)
		. += "[initial(icon_state)]_closed"
		return

/obj/structure/displaycase/attackby(obj/item/W, mob/living/user, params)
	if(W.GetID() && !broken && openable)
		if(allowed(user))
			to_chat(user, SPAN_NOTICE("You [open ? "close":"open"] the [src]."))
			toggle_lock(user)
		else
			to_chat(user, SPAN_ALERT("Access denied."))
	else if(!alert && istype(W,/obj/item/tool/crowbar) && openable)
		if(broken)
			if(showpiece)
				to_chat(user, SPAN_WARNING("Remove the displayed object first!"))
			else
				to_chat(user, SPAN_NOTICE("You remove the destroyed case."))
				qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You start to [open ? "close":"open"] the [src]."))
			if(do_after(user, 20, target = src))
				to_chat(user, SPAN_NOTICE("You [open ? "close":"open"] the [src]."))
				toggle_lock(user)
	else if(open && !showpiece)
		insert_showpiece(W, user)
	else
		return ..()

/obj/structure/displaycase/proc/insert_showpiece(obj/item/wack, mob/user)
	if(showpiece_type && !istype(wack, showpiece_type))
		to_chat(user, SPAN_NOTICE("This doesn't belong in this kind of display."))
		return TRUE
	if(user.transferItemToLoc(wack, src))
		showpiece = wack
		to_chat(user, SPAN_NOTICE("You put [wack] on display."))
		update_appearance()

/obj/structure/displaycase/proc/toggle_lock(mob/user)
	open = !open
	update_appearance()

/obj/structure/displaycase/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(showpiece && (destroyed || open))
		to_chat(user, SPAN_NOTICE("You deactivate the hover field built into the case."))
		//log_combat(user, src, "deactivates the hover field of")
		dump()
		add_fingerprint(user)
		return
	else
		//Prevents remote "kicks" with TK
		if(!Adjacent(user))
			return
		if(!(user.a_intent == INTENT_HARM))
			if(!user.is_blind())
				user.examinate(src)
			return
		to_chat(usr, text(SPAN_WARNING("You kick the display case.")))
		for(var/mob/O in oviewers())
			if((O.client && !( O.blinded )))
				to_chat(O, SPAN_WARNING("[usr] kicks the display case."))
		//log_combat(user, src, "kicks")
		user.do_attack_animation(src, ATTACK_EFFECT_KICK)
		take_damage(2)
		healthcheck()

//The lab cage and captain's display case do not spawn with electronics, which is why req_access is needed.
/obj/structure/displaycase/captain
	name = "antique display case"
	desc = "A glass lab container for storing something old."
	start_showpiece_type = /obj/item/gun/energy/captain
	req_access = list(access_captain) // We're not TG so they can grab it in emergencies.


/obj/structure/displaycase/labcage
	name = "lab cage"
	desc = "A glass lab container for storing interesting creatures."
	start_showpiece_type = /obj/item/clothing/mask/facehugger/lamarr
	req_access = list(access_rd)
