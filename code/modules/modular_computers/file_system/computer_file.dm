var/global/file_uid = 0

/datum/computer_file
	/// Placeholder. No spacebars
	var/filename = "NewFile"
	/// File full names are [filename].[filetype] so like NewFile.XXX in this case.
	var/filetype = "XXX"
	/// File size in GQ. Integers only!
	var/size = 1
	/// Holder that contains this file.
	var/obj/item/computer_hardware/hard_drive/holder
	/// Whether the file may be sent to someone via NTNet transfer or other means.
	var/unsendable = FALSE
	/// Whether the file may be deleted. Setting to 1 prevents deletion/renaming/etc.
	var/undeletable = FALSE
	/// UID of this file.
	var/uid

/datum/computer_file/New()
	..()
	uid = file_uid
	file_uid++

/datum/computer_file/Destroy()
	if(!holder)
		return ..()

	holder.remove_file(src)
	// holder.holder is the computer that has drive installed. If we are Destroy()ing program that's currently running kill it.
	if(holder.holder2 && holder.holder2.active_program == src)
		holder.holder2.kill_program(1)
	holder = null
	..()

/// Returns independent copy of this file.
/datum/computer_file/proc/clone(var/rename = 0)
	var/datum/computer_file/temp = new type
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.size = size
	if(rename)
		temp.filename = filename + "(Copy)"
	else
		temp.filename = filename
	temp.filetype = filetype
	return temp
