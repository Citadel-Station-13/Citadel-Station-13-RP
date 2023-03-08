/proc/investigate_subject2file(subject)
	return file("[GLOB.log_directory]/investigate/[subject].html")

/atom/proc/investigate_log(message, subject)
	if(!message)
		return
	var/F = investigate_subject2file(subject)
	if(!F)
		CRASH("invalid file / no file")
	F << "<small>[time2text(world.timeofday,"hh:mm")] \ref[src] ([x],[y],[z])</small> || [src] [message]<br>"

//ADMINVERBS
/client/proc/investigate_show()
	set name = "Investigate"
	set category = "Admin"
	if(!holder)
		return

	var/static/list/subjects = ALL_INVESTIGATE_SUBJECTS
	var/subject = input(usr, "Choose a subject", "Investigate") as null|anything in subjects

	if(!(subject in subjects))
		to_chat(src, SPAN_DANGER("Invalid subject: [subject]"))
		return
	var/F = investigate_subject2file(subject)
	if(!F)
		to_chat(src, "<font color='red'>Error: admin_investigate: [F? F : "!!NO PATH - CHECK RUNTIMES!!"] is an invalid path or cannot be accessed.</font>")
		return
	src << browse(F,"window=investigate[subject];size=800x300")
