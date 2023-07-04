
GLOBAL_LIST_EMPTY(telecomms_list)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/radio/intercom/omni, new)
