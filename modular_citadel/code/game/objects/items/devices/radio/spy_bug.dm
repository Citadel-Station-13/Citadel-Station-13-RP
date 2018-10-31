/obj/item/device/camerabug
	var/obj/item/device/radio/radio


/obj/item/device/camerabug/New()
	. = ..()
	listening_objects += src


/obj/item/device/camerabug/Destroy()
	. = ..()
	listening_objects -= src
	qdel(src.radio)
	radio = null


/obj/item/device/camerabug/initialize()
	. = ..()
	radio = new(src)
	radio.broadcasting = 0
	radio.listening = 0
	radio.canhear_range = 6
	radio.icon = src.icon
	radio.icon_state = src.icon_state
	update_icon()


/obj/item/device/camerabug/reset()
	. = ..()
	radio.broadcasting = 0

/obj/item/device/camerabug/attackby(obj/item/W as obj, mob/living/user as mob)
	. = ..()
	if(istype(W, /obj/item/device/bug_monitor))
		var/obj/item/device/bug_monitor/SM = W
		if(!linkedmonitor)
			radio.broadcasting = 0
		else if (linkedmonitor == SM)
			radio.broadcasting = 1
			radio.set_frequency(SM.radio.frequency)


/obj/item/device/bug_monitor
	var/obj/item/device/radio/radio
	var/global/list/freqblacklist


/obj/item/device/bug_monitor/New()
	. = ..()
	listening_objects += src


/obj/item/device/bug_monitor/initialize()
	. = ..()
	if(!freqblacklist)
		for (var/chan in radiochannels)
			freqblacklist |= radiochannels[chan]
	radio = new(src)
	radio.broadcasting = 0
	radio.listening = 1
	radio.canhear_range = 0
	do
		radio.set_frequency( rand(RADIO_LOW_FREQ, RADIO_HIGH_FREQ) )
	while (radio.frequency in freqblacklist || (radio.frequency % 2 == 0))


/obj/item/device/bug_monitor/Destroy()
	. = ..()
	listening_objects -= src
	qdel(src.radio)
	radio = null

