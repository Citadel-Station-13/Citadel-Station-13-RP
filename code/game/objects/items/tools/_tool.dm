/**
 * just a tool supertype
 *
 * the tool system is implemented at /item level
 */
/obj/item/tool
	item_flags = ITEM_CAREFUL_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD

/obj/item/tool/get_description_info()
	. = ..()
	. += "It appears to work at [(TOOL_SPEED_DEFAULT/tool_speed)*100]% speed."
