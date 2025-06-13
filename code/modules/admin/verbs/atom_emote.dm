/proc/atom_emote(atom/A as atom in world)
	set name = "Atom Emote"
	set category = VERB_CATEGORY_OBJECT

	var/message_type_input = tgui_input_list(usr, "Choose Message Type", "Message Type", list("Audible","Visible","All"))
	if(!message_type_input)
		return

	var/message_input = tgui_input_text(usr, "Atom Emote")
	if(!message_input)
		return

	var/message_type
	switch(message_type_input)
		if("Audible")
			message_type = SAYCODE_TYPE_AUDIBLE
		if("Visible")
			message_type = SAYCODE_TYPE_VISIBLE
		if("All")
			message_type = SAYCODE_TYPE_ALWAYS

	A.atom_emote(message_input, message_type)
