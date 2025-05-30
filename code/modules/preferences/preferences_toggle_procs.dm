
// todo: god fucking damnit why is this in this file?

/mob/living/carbon/human/verb/toggle_pain_msg()
	set name = "Toggle Pain Messages"
	set category = "OOC"
	set desc = "Toggles pain messages."
	set src = usr

	if(painmsg)
		src.painmsg = 0
	else
		src.painmsg = 1
	to_chat(src,"You will [ (painmsg) ? "now" : "no longer"] see your own pain messages.")
