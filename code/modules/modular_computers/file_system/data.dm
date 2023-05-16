/**
 * /data/ files store data in string format.
 * They don't contain other logic for now.
 */
/datum/computer_file/data
	filetype = "DAT"
	/// Whether the user will be reminded that the file probably shouldn't be edited.
	var/do_not_edit = 0
	/// Stored data in string format.
	var/stored_data = ""
	/// The file size of this bit of data.
	var/block_size = 250

/datum/computer_file/data/clone()
	var/datum/computer_file/data/temp = ..()
	temp.stored_data = stored_data
	return temp

/// Calculates file size from amount of characters in saved string
/datum/computer_file/data/proc/calculate_size()
	size = max(1, round(length(stored_data) / block_size))

/datum/computer_file/data/logfile
	filetype = "LOG"
