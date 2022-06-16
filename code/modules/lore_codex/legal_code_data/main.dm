// Autogenerates a table which will resemble the traditional wiki table.
/datum/lore/codex/page/overview
	name = "Overview"
	data = "This has a table of all the corporate violations and legal crimes contained inside this book.  The 'mandated' area \
	determines the flexibility/strictness allowed in sentencing for violations/crimes."

/datum/lore/codex/page/overview/add_content()
	var/list/law_sources = list(
		/datum/lore/codex/category/corporate_minor_violations,
		/datum/lore/codex/category/corporate_major_violations,
		/datum/lore/codex/category/law_minor_violations,
		/datum/lore/codex/category/law_major_violations
		)
	var/list/table_color_headers = list("#66ffff", "#3399ff", "#ffee55", "#ff8855")
	var/list/table_color_body_even = list("#ccffff", "#66ccff", "#ffee99", "#ffaa99")
	var/list/table_color_body_odd = list("#e6ffff", "#b3e6ff", "#fff6cc", "#ffd5cc")
	spawn(2 SECONDS) // So the rest of the book can finish.
		var/HTML
		HTML += "<div align='center'>"
		var/i
		for(i = 1, i <= law_sources.len, i++)
			var/datum/lore/codex/category/C = holder.get_page_from_type(law_sources[i])
			if(C)
				HTML += "<table style='width:90% text-align:center'>"
				HTML += "<caption>[quick_link(C.name)]</caption>"
				HTML += "	<tr style='background-color:[table_color_headers[i]]'>"
				HTML += "		<th>Incident</th>"
				HTML += "		<th>Description</th>"
				HTML += "		<th>Suggested Punishment</th>"
				HTML += "		<th>Notes</th>"
				HTML += "		<th>Mandated?</th>"
				HTML += "	</tr>"

				var/j = 1 //Used to color rows differently if even or odd.
				for(var/datum/lore/codex/page/law/L in C.children)
					if(!L.name)
						continue // Probably something we don't want to see.
					HTML += "	<tr style='background-color:[j % 2 ? table_color_body_even[i] : table_color_body_odd[i]]'>"
					HTML += "		<td><b>[quick_link(L.name)]</b></td>"
					HTML += "		<td>[L.definition]</td>"
					HTML += "		<td>[L.suggested_punishments]</td>"
					HTML += "		<td>[L.notes]</td>"
					HTML += "		<td>[L.mandated ? "<font color='red'>Yes</font>" : "<font color='green'>No</font>"]</td>"
					HTML += "	</tr>"
					j++

			HTML += "</table>"
			HTML += "<br><br>"
		HTML += "</div>"

		data = data + HTML
		..()
