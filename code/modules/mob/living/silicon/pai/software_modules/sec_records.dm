/datum/pai_software/sec_records
	name = "Security Records"
	ram_cost = 15
	id = "sec_records"
	toggle = 0

/datum/pai_software/sec_records/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	var/data[0]

	var/records[0]
	for(var/datum/data/record/general in sortRecord(data_core.general))
		var/record[0]
		record["name"] = general.fields["name"]
		record["ref"] = "\ref[general]"
		records[++records.len] = record

	data["records"] = records

	var/datum/data/record/G = user.securityActive1
	var/datum/data/record/S = user.securityActive2
	data["general"] = G ? G.fields : null
	data["security"] = S ? S.fields : null
	data["could_not_find"] = user.security_cannotfind

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "pai_secrecords.tmpl", "Security Records", 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/pai_software/sec_records/Topic(href, href_list)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P))
		return

	if(href_list["select"])
		var/datum/data/record/record = locate(href_list["select"])
		if(record)
			var/datum/data/record/R = record
			var/datum/data/record/S = null
			if (!( data_core.general.Find(R) ))
				P.securityActive1 = null
				P.securityActive2 = null
				P.security_cannotfind = 1
			else
				P.security_cannotfind = 0
				for(var/datum/data/record/E in data_core.security)
					if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
						S = E
				P.securityActive1 = R
				P.securityActive2 = S
		else
			P.securityActive1 = null
			P.securityActive2 = null
			P.security_cannotfind = 1
		return 1
