//Lots of people are using this now.
/obj/item/clothing/accessory/collar/vmcrystal
	name = "life crystal"
	desc = "A small crystal with four little dots in it. It feels slightly warm to the touch. \
	Read manual before use! Can be worn, held, or attached to uniform. NOTE: Device contains antimatter."
	w_class = WEIGHT_CLASS_SMALL

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'

	icon_state = "khlife"
	item_state = "khlife_overlay"
	overlay_state = "khlife_overlay"

	slot_flags = SLOT_TIE

	var/mob/owner = null
	var/client/owner_c = null //They'll be dead when we message them probably.
	var/state = 0 //0 - New, 1 - Paired, 2 - Breaking, 3 - Broken (same as iconstates)
	var/last_vitals //Write world.time in once owner dies or the crystal is removed

/obj/item/clothing/accessory/collar/vmcrystal/Initialize(mapload)
	. = ..()
	update_state(0)

/obj/item/clothing/accessory/collar/vmcrystal/Destroy() //Waitwaitwait
	if(state == 1)
		process() //Nownownow
	return ..() //Okfine

/obj/item/clothing/accessory/collar/vmcrystal/process(delta_time)
	check_owner()
	if(!owner)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/vmcrystal/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(state > 0) //Can't re-pair, one time only, for security reasons. But you can prematurely deactivate it if you're the owner, so you can take it off freely.
		if(alert(user, "Would you like to permanently deactivate \the [name]?",, "Yes", "No") == "Yes")
			if(user == owner)
				to_chat(user, SPAN_NOTICE("\The [name] quietly crumbles into dust in your hand as its connection to you is severed."))
				update_state(3)
				name = "broken [initial(name)]"
				desc = "This seems like a necklace, but the actual pendant is missing."
				return
		to_chat(user, SPAN_NOTICE("The [name] doesn't do anything."))
		return 0

	owner = user	//We're paired to this person
	owner_c = user.client	//This is their client
	update_state(1)
	to_chat(user, "<span class='notice'>The [name] glows pleasantly blue.</span>")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/vmcrystal/proc/check_owner()
	//He's dead, jim
	if(state < 1)
		return
	if(!owner && !owner_c) //How did we get here?
		//It's likely because the owner got gibbed. But if it truly bugged out, there'd be no client.
		return
	if((!owner && owner_c) || (owner.stat == DEAD) || (get_turf(owner) != get_turf(src)))
		if(state == 1)
			become_alert()
		if((state == 2) && (last_vitals < world.time - 1 MINUTE))
			send_message()
	else
		if(state == 2)
			become_calm()


/obj/item/clothing/accessory/collar/vmcrystal/proc/become_alert()
	update_state(2)
	audible_message(SPAN_WARNING("\The [name] begins flashing red and vibrating in at a low frequency."),
			SPAN_WARNING("\The [name] begins vibrating in at a low frequency."))
	last_vitals = world.time

/obj/item/clothing/accessory/collar/vmcrystal/proc/become_calm()
	update_state(1)
	audible_message(SPAN_NOTICE("\The [src] stops flashing red and vibrating as it resyncronises with its linked owner."),
			SPAN_NOTICE("\The [src] stops vibrating in at a low frequency"))

/obj/item/clothing/accessory/collar/vmcrystal/proc/send_message()
	visible_message(SPAN_WARNING("\The [name] shatters into dust!"))
	GLOB.global_announcer.autosay("[owner] has died!", "[owner]'s Life Crystal")
	if(owner_c)
		to_chat(owner_c, "<span class='notice'>The HAVENS system is notified of your demise via \the [name].</span>")
	update_state(3)
	name = "broken [initial(name)]"
	desc = "This seems like a necklace, but the actual pendant is missing."

/obj/item/clothing/accessory/collar/vmcrystal/proc/update_state(var/tostate)
	state = tostate
	icon_state = "[initial(icon_state)][tostate]"
	update_icon()

/obj/item/clothing/accessory/collar/vmcrystal/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	check_owner()

/obj/item/clothing/accessory/collar/vmcrystal/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	check_owner()

/obj/item/clothing/accessory/collar/vmcrystal/unequipped(mob/user, slot, flags)
	. = ..()
	check_owner()
/*
/obj/item/paper/vmcrystal_manual
	name = "VM-LC91-1 manual"
	info = {"<h4>VM-LC91-1 Life Crystal</h4>
	<h5>Usage</h5>
	<ol>
		<li>Hold new crystal in hand.</li>
		<li>Make fist with that hand.</li>
		<li>Wait 1 second.</li>
	</ol>
	<br />
	<h5>Purpose</h5>
	<p>The VeyMed Life Crystal is a small device typically worn around the neck for the purpose of reporting your status to the HAVENS (VeyMed's High-AVailability ENgram Storage) system, so that appropriate measures can be taken in the case of your body's demise. The whole device is housed inside a pleasing-to-the-eye elongated diamond.</p>
	<p>Upon your body's desmise, the crystal will send a transmission to HAVENS. Depending on your membership level, the appropriate actions can be taken to ensure that you are back up and enjoying existence as soon as possible.</p>

	<p>Nanotrasen has negotiated a <i>FREE</i> Star membership for you in the HAVENS system, though an upgrade can be obtained depending on your citizenship and reputation level.</p>

	As a reminder, the membership levels in HAVENS are:
	<ul>
		<li><b>HAVENS Star:</b> Upon reciving a signal from a transmitter indicating body demise, HAVENS will attempt to contact the owner for 48 hours, before starting the process of resleeving the owner into a new body they selected when registering their HAVENS membership.</li>
		<li><b>HAVENS Nebula:</b> After the contact period from the Star service has expired, an agent will be alotted a HAVENS spacecraft, and will attempt to locate your remains, and any belongings you had, for up to one week. If possible, any more recent memory recordings or mindstates will be recovered before your resleeving. (Great for explorers! Don't miss out on anything you discovered!)</li>
		<li><b>HAVENS Galaxy:</b> Upon reciving the signal from the Star service, a HAVENS High-Threat Response Team will be alotted a HAVENS FTL-capable Interdictor-class spacecraft and dispatched to your last known position to locate and recover your remains, plus any belongings. You will be resleeved on-site to continue where you left off.</li>
	</ul>
	<br />
	<h5>Technical</h5>
	<p>The Life Crystal is a small 5cm long diamond containing four main components which are visible inside the translucent gem.</p>

	From tip to top, they are:
	<ol>
		<li><b>Qubit Bucket:</b> This small cube contains 200 bits worth of quantum-entangled bits for transmitting to HAVENS. QE transmission technologies cannot be jammed or interfered with, and are effectively instant over any distance.
		<li><b>Antimatter Bottle:</b> This tiny antimatter vessel is required to power the transmitter for the time it takes to transmit the signal to HAVENS. The inside of the crystal is thick enough to block any alpha or beta particles emitted when this antimatter contacts matter, however the crystal will be destroyed when activated.
		<li><b>Decay Reactor:</b> This long-term microreactor will last for around one month and provide sufficient power to power all but the transmitter. This power is required for containing the antimatter bottle.
		<li><b>Sensor Suite:</b> The sensor that tracks the owner's life-state, such that it can be transmitted back to HAVENS when necessary.
	</ol>
	<p>The diamond itself is coated in a layer of graphene, to give it a pleasant rainbow finish. This also serves as a conductor that, if broken, will discharge the antimatter bottle immediately as it is unsafe to do so any point after the crystal is broken via physical means.</p>
	<br />
	<h5>Special Notes</h5>
	<i>\[AM WARNING\]</i>
	<p>This device contains antimatter. Please consult all local regulations when travelling to ensure compliance with local laws.</p>"}
*/
/obj/item/storage/box/vmcrystal
	name = "life crystal case"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "khlifebox"
	desc = "This case can only hold the VM-LC91-1 and a manual."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syringe_kit", SLOT_ID_LEFT_HAND = "syringe_kit")
	max_items = 2
	insertion_whitelist = list(/obj/item/clothing/accessory/collar/vmcrystal)
	max_combined_volume = WEIGHT_VOLUME_SMALL * 2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/box/vmcrystal/Initialize(mapload)
	. = ..()
//	new /obj/item/paper/vmcrystal_manual(src)
	new /obj/item/clothing/accessory/collar/vmcrystal(src)
