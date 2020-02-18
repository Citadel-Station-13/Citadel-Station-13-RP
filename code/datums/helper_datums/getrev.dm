var/global/datum/getrev/revdata = new()

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo
	var/list/testmerge = list()	//CITADEL CHANGE - adds hooks for TGS3 integration

/datum/getrev/New()
	testmerge = world.TgsTestMerges()	//CITADEL CHANGE - adds hooks for TGS3 testmerge display
	var/list/head_branch = file2list(".git/HEAD", "\n")
	if(head_branch.len)
		branch = copytext(head_branch[1], 17)

	var/list/head_log = file2list(".git/logs/HEAD", "\n")
	for(var/line=head_log.len, line>=1, line--)
		if(head_log[line])
			var/list/last_entry = splittext(head_log[line], " ")
			if(last_entry.len < 2)	continue
			revision = last_entry[2]
			// Get date/time
			if(last_entry.len >= 5)
				var/unix_time = text2num(last_entry[5])
				if(unix_time)
					date = unix2date(unix_time)
			break

	world.log << "Running revision:"
	world.log << branch
	world.log << date
	world.log << revision

	if(testmerge.len)	//CITADEL CHANGES START HERE - TGS3 testmerges
		for(var/line in testmerge)
			if(line)
				var/datum/tgs_revision_information/test_merge/tm = line
				var/tmcommit = tm.commit
				world.log << "Test merge active of PR #[line] commit [tmcommit]"	//END OF CITADEL CHANGES

client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	if(revdata.revision)
		src << "<b>Server revision:</b> [revdata.branch] - [revdata.date]"
		if(config_legacy.githuburl)
			src << "<a href='[config_legacy.githuburl]/commit/[revdata.revision]'>[revdata.revision]</a>"
			if(revdata.testmerge.len)	//CITADEL CHANGE - TGS3 testmerge display
				src << revdata.GetTestMergeInfo()	//CITADEL CHANGE - ditto
		else
			src << revdata.revision
	else
		src << "Revision unknown"

//CITADEL CHANGES START HERE - TGS3 testmerge stuff
/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	if(!testmerge.len)
		return ""
	. = header ? "The following pull requests are currently test merged:<br>" : ""
	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.pull_request_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext(cm, 1, min(length(cm), 11)))
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.holder))
			continue
		. += "<a href=\"[config_legacy.githuburl]/pull/[tm.number]\">#[tm.number][details]</a><br>"
//END OF CITADEL CHANGES
