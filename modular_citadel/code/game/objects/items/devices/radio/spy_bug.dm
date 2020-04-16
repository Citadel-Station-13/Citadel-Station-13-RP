/obj/item/camerabug
	var/obj/item/radio/radio

/obj/item/camerabug/Destroy()
	. = ..()
	listening_objects -= src
	qdel(src.radio)
	radio = null

/obj/item/camerabug/Initialize()
	. = ..()
	listening_objects += src
	radio = new(src)
	radio.broadcasting = 0
	radio.listening = 0
	radio.canhear_range = 6
	radio.icon = src.icon
	radio.icon_state = src.icon_state
	update_icon()

/obj/item/camerabug/reset()
	. = ..()
	radio.broadcasting = 0

/obj/item/camerabug/attackby(obj/item/W as obj, mob/living/user as mob)
	. = ..()
	if(istype(W, /obj/item/bug_monitor))
		var/obj/item/bug_monitor/SM = W
		if(!linkedmonitor)
			radio.broadcasting = 0
		else if (linkedmonitor == SM)
			radio.broadcasting = 1
			radio.set_frequency(SM.radio.frequency)

/obj/item/bug_monitor
	var/obj/item/radio/radio
	var/global/list/freqblacklist

/obj/item/bug_monitor/Initialize(mapload)
	. = ..()
	listening_objects += src
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

/obj/item/bug_monitor/Destroy()
	. = ..()
	listening_objects -= src
	qdel(src.radio)
	radio = null