/obj/item/ticket_printer
	name = "ticket printer"
	desc = "It prints security citations!"
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "sec_ticket_printer"
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	var/print_cooldown = 1 MINUTE
	var/last_print
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ticket_printer/attack_self(mob/user)
	. = ..()
	if(last_print + print_cooldown <= world.time)
		print_a_ticket(user)
	else
		to_chat(user, SPAN_WARNING("\The [src] is not ready to print another ticket yet."))

/obj/item/ticket_printer/proc/print_a_ticket(mob/user)

	var/ticket_name = sanitize(tgui_input_text(user, "The Name of the person you are issuing the ticket to.", "Name", max_length = 100))
	if(length(ticket_name) > 100)
		tgui_alert_async(user, "Entered name too long. 100 character limit.","Error")
		return
	if(!ticket_name)
		return
	var/details = sanitize(tgui_input_text(user, "What is the ticket for? Avoid entering personally identifiable information in this section. This information should not be used to harrass or otherwise make the person feel uncomfortable. (Max length: 200)", "Ticket Details", max_length = 200))
	if(length(details) > 200)
		tgui_alert_async(user, "Entered details too long. 200 character limit.","Error")
		return
	if(!details)
		return

	var/turf/our_turf = get_turf(user)

	var/final = "<head><style>body {font-family: Verdana; background-color: #A37F97;}</style></head><center><h3>Nanotrasen Security Citation</h3><hr>This security citation has been issued to <br><big>[capitalize(ticket_name)]</big></center><b>Reason</b>:<br><i>[details]</i><hr><center><small>See your local representative at Central Command after the shift is over to resolve this issue.</small><br></center>"

	var/obj/item/paper/sec_ticket/p = new /obj/item/paper/sec_ticket(our_turf)

	p.info = final
	p.name = "Security Citation: [ticket_name]"
	playsound(user, 'sound/items/ticket_printer.ogg', 75, 1)

/obj/item/paper/sec_ticket
	name = "Security Citation"
	desc = "A citation issued by security for some kind of infraction!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "sec_ticket"

/obj/item/paper/sec_ticket/Initialize(mapload, text, title)
	. = ..()
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "sec_ticket"

/obj/item/paper/sec_ticket/update_icon()
	icon = icon
	icon_state = icon_state
