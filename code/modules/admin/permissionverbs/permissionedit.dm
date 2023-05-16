/client/proc/edit_admin_permissions()
	set category = "Admin"
	set name = "Permissions Panel"
	set desc = "Edit admin permissions"
	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.edit_admin_permissions()

/datum/admins/proc/edit_admin_permissions()
	if(!check_rights(R_PERMISSIONS))
		return
	var/datum/asset/asset_cache_datum = get_asset_datum(/datum/asset/group/permissions)
	asset_cache_datum.send(usr)

	var/output = {"<!DOCTYPE html>
<html>
<head>
<title>Permissions Panel</title>
<script type='text/javascript' src='[SSassets.transport.get_asset_url("search.js")]'></script>
<link rel='stylesheet' type='text/css' href='panels.css'>
</head>
<body onload='selectTextField();updateSearch();'>
<div id='main'><table id='searchable' cellspacing='0'>
<tr class='title'>
<th style='width:125px;text-align:right;'>CKEY <a class='small' href='?src=\ref[src];editrights=add'>\[+\]</a></th>
<th style='width:125px;'>RANK</th><th style='width:100%;'>PERMISSIONS</th>
</tr>
"}

	for(var/adm_ckey in admin_datums)
		var/datum/admins/D = admin_datums[adm_ckey]
		if(!D)	continue
		var/rank = D.rank ? D.rank : "*none*"
		var/rights = rights2text(D.rights," ")
		if(!rights)	rights = "*none*"

		output += "<tr>"
		output += "<td style='text-align:right;'>[adm_ckey] <a class='small' href='?src=\ref[src];editrights=remove;ckey=[adm_ckey]'>\[-\]</a></td>"
		output += "<td><a href='?src=\ref[src];editrights=rank;ckey=[adm_ckey]'>[rank]</a></td>"
		output += "<td><a class='small' href='?src=\ref[src];editrights=permissions;ckey=[adm_ckey]'>[rights]</a></td>"
		output += "</tr>"

	output += {"
</table></div>
<div id='top'><b>Search:</b> <input type='text' id='filter' value='' style='width:70%;' onkeyup='updateSearch();'></div>
</body>
</html>"}

	usr << browse(output,"window=editrights;size=600x500")

/datum/admins/proc/log_admin_rank_modification(var/adm_ckey, var/new_rank)
	if(config_legacy.admin_legacy_system)	return

	if(!usr.client)
		return

	if(!usr.client.holder || !(usr.client.holder.rights & R_PERMISSIONS))
		to_chat(usr, "<font color='red'>You do not have permission to do this!</font>")
		return


	if(!SSdbcore.Connect())
		to_chat(usr, "<font color='red'>Failed to establish database connection</font>")
		return

	if(!adm_ckey || !new_rank)
		return

	adm_ckey = ckey(adm_ckey)

	if(!adm_ckey)
		return

	if(!istext(adm_ckey) || !istext(new_rank))
		return

	var/datum/db_query/select_query = SSdbcore.RunQuery(
		"SELECT id FROM [format_table_name("admin")] WHERE ckey = :ckey",
		list(
			"ckey" = adm_ckey
		)
	)

	var/new_admin = 1
	var/admin_id
	while(select_query.NextRow())
		new_admin = 0
		admin_id = text2num(select_query.item[1])

	if(new_admin)
		SSdbcore.RunQuery(
			"INSERT INTO [format_table_name("admin")] (id, ckey, rank, level, flags) VALUES (null, :ckey, :rank, -1, 0)",
			list(
				"ckey" = adm_ckey,
				"rank" = new_rank
			)
		)
		SSdbcore.RunQuery(
			"INSERT INTO [format_table_name("admin_log")] (id, datetime, adminckey, adminip, log) VALUES (NULL, NOW(), :ckey, :ip, :logstr)",
			list(
				"ckey" = sanitizeSQL(usr.ckey),
				"ip" = sanitizeSQL(usr.client.address),
				"Added new admin [adm_ckey] to rank [new_rank]"
			)
		)
		to_chat(usr, "<font color=#4F49AF>New admin added.</font>")
	else
		if(!isnull(admin_id) && isnum(admin_id))
			SSdbcore.RunQuery(
				"UPDATE [format_table_name("admin")] SET rank = :rank WHERE id = :id",
				list(
					"rank" = new_rank,
					"id" = admin_id
				)
			)
			SSdbcore.RunQuery(
				"INSERT INTO [format_table_name("admin_log")] (id, datetime, adminckey, adminip, log) VALUES (NULL, Now(), :ckey, :addr, :log)",
				list(
					"ckey" = usr.ckey,
					"addr" = usr.client.address,
					"log" = "Edited the rank of [adm_ckey] to [new_rank]"
				)
			)
			to_chat(usr, "<font color=#4F49AF>Admin rank changed.</font>")

/datum/admins/proc/log_admin_permission_modification(var/adm_ckey, var/new_permission)
	if(config_legacy.admin_legacy_system)	return

	if(!usr.client)
		return

	if(!usr.client.holder || !(usr.client.holder.rights & R_PERMISSIONS))
		to_chat(usr, "<font color='red'>You do not have permission to do this!</font>")
		return

	if(!SSdbcore.Connect())
		to_chat(usr, "<font color='red'>Failed to establish database connection</font>")
		return

	if(!adm_ckey || !new_permission)
		return

	adm_ckey = ckey(adm_ckey)

	if(!adm_ckey)
		return

	if(istext(new_permission))
		new_permission = text2num(new_permission)

	if(!istext(adm_ckey) || !isnum(new_permission))
		return

	var/datum/db_query/select_query = SSdbcore.RunQuery(
		"SELECT id, flags FROM [format_table_name("admin")] WHERE ckey = :ckey",
		list(
			"ckey" = adm_ckey
		)
	)

	var/admin_id
	var/admin_rights
	while(select_query.NextRow())
		admin_id = text2num(select_query.item[1])
		admin_rights = text2num(select_query.item[2])

	if(!admin_id)
		return

	if(admin_rights & new_permission) //This admin already has this permission, so we are removing it.
		SSdbcore.RunQuery(
			"UPDATE [format_table_name("admin")] SET flags = :flags WHERE id = :id",
			list(
				"flags" = admin_rights & ~new_permission,
				"id" = admin_id
			)
		)
		SSdbcore.RunQuery(
			"INSERT INTO [format_table_name("admin_log")] (id, datetime, adminckey, adminip, log) VALUES (NULL, Now(), :ckey, :addr, :log)",
			list(
				"ckey" = usr.ckey,
				"addr" = usr.client.address,
				"log" = "Removed permission [rights2text(new_permission)] (flag = [new_permission]) to admin [adm_ckey]"
			)
		)
		to_chat(usr, "<font color=#4F49AF>Permission removed.</font>")
	else //This admin doesn't have this permission, so we are adding it.
		SSdbcore.RunQuery(
			"UPDATE [format_table_name("admin")] SET flags = :flags WHERE id = :id",
			list(
				"flags" = admin_rights | new_permission,
				"id" = admin_id
			)
		)
		SSdbcore.RunQuery(
			"INSERT INTO [format_table_name("admin_log")] (id, datetime, adminckey, adminip, log) VALUES (NULL, Now(), :ckey, :addr, :log)",
			list(
				"ckey" = usr.ckey,
				"addr" = usr.client.address,
				"log" = "Added permission [rights2text(new_permission)] (flag = [new_permission]) to admin [adm_ckey]"
			)
		)
		to_chat(usr, "<font color=#4F49AF>Permission added.</font>")
