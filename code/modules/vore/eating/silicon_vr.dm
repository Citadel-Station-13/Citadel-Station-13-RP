/mob/living/silicon/ai/verb/holo_nom()
	set name = "Hardlight Nom"
	set category = "AI Commands"
	set desc = "Wrap up a person in hardlight holograms."
	set src = usr

	if(!holopad || !hologram)
		to_chat(usr, "<span class='warning'>You can only use this when holo-projecting!</span>")
		return

	if(hologram.vored)
		var/choice = alert("You can only contain one person. [hologram.vored] is in you.","Already Using Hardlight","Drop Mob","Cancel")
		if(choice == "Drop Mob")
			hologram.drop_vored()
		return

	var/mob/living/prey = input(src,"Select a mob to eat","Holonoms") as mob in oview(1, hologram)|null

	if(!prey)
		return

	if(QDELETED(prey))
		to_chat(usr, SPAN_WARNING("Invalid mob choice!"))
		return

	hologram.visible_message("[hologram] starts forming around [prey]!")
	to_chat(src, SPAN_NOTICE("You begin forming hardlight holograms around [prey]."))

	if(!do_after(eyeobj, 50, prey, DO_AFTER_IGNORE_ACTIVE_ITEM ))
		return

	if(!hologram || hologram.vored)
		return

	hologram.vore_someone(prey)
