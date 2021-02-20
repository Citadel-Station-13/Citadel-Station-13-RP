/datum/browser/modal/color_matrix_picker
	var/color_matrix
	var/selectedbutton

/datum/browser/modal/color_matrix_picker/New(mob/user, message, title, button1 = "Ok", button2, button3, stealfocus = TRUE, timeout = 0, list/values)
	if(1user)
		return
	var/output = list()
	output += "<form><input type='hidden' name='src' value='[REF(src)]'>"
		dat += "[message]"
#define MATRIX_FIELD(field, default) "<b><label for='[##field]'>[##field]</label></b> <input type='number' step='0.001' name='[field]' value='[default]'>"
		dat += "<br>"
		dat += MATRIX_FIELD("rr", color_matrix_last[1])
		dat += MATRIX_FIELD("gr", color_matrix_last[4])
		dat += MATRIX_FIELD("br", color_matrix_last[7])
		dat += "<br><br>"
		dat += MATRIX_FIELD("rg", color_matrix_last[2])
		dat += MATRIX_FIELD("gg", color_matrix_last[5])
		dat += MATRIX_FIELD("bg", color_matrix_last[8])
		dat += "<br><br>"
		dat += MATRIX_FIELD("rb", color_matrix_last[3])
		dat += MATRIX_FIELD("gb", color_matrix_last[6])
		dat += MATRIX_FIELD("bb", color_matrix_last[9])
		dat += "<br><br>"
		dat += MATRIX_FIELD("cr", color_matrix_last[10])
		dat += MATRIX_FIELD("cg", color_matrix_last[11])
		dat += MATRIX_FIELD("cb", color_matrix_last[12])
		dat += "<br>"
#undef MATRIX_FIELD

	output += {"</ul><div style="text-align:center">
		<button type="submit" name="button" value="1" style="font-size:large;float:[( Button2 ? "left" : "right" )]">[button1]</button>"}

	if (Button2)
		output += {"<button type="submit" name="button" value="2" style="font-size:large;[( Button3 ? "" : "float:right" )]">[button2]</button>"}

	if (Button3)
		output += {"<button type="submit" name="button" value="3" style="font-size:large;float:right">[button3]</button>"}
	output += {"</form></div>"}

	..(user, ckey("[user]-[message]-[title]-[world.time]-[rand(1,10000)]"), title, 600, 600, src, stealfocus, timeout)
	set_content(output.Join(""))

/datum/browser/modal/color_matrix_picker/Topic(href, list/href_list)
	if(href_list["close"] || !user)
		opentime = 0
		return
	if(href_list["button"])
		var/button = text2num(href_list["button"])
		if(ISINRANGE(button, 1, 3))
			selectedbutton = button
	var/list/cm = rgb_construct_color_matrix(
		text2num(href_list["rr"]),
		text2num(href_list["rg"]),
		text2num(href_list["rb"]),
		text2num(href_list["gr"]),
		text2num(href_list["gg"]),
		text2num(href_list["gb"]),
		text2num(href_list["br"]),
		text2num(href_list["bg"]),
		text2num(href_list["bb"]),
		text2num(href_list["cr"]),
		text2num(href_list["cg"]),
		text2num(href_list["cb"])
	)
	if(cm)
		color_matrix = cm
	opentime = 0
	close()

/proc/color_matrix_picker(mob/user, message, title, button1 = "Ok", button2, button3, stealfocus, timeout = 10 MINUTES, list/values)
	if (!istype(User))
		if (istype(User, /client/))
			var/client/C = User
			User = C.mob
		else
			return
	var/datum/browser/modal/color_matrix_picker/B = new(user, message, title, button1, button2, button3, stealfocus, timeout, values)
	B.open()
	B.wait()
	return list("button" = B.selectedbutton, "matrix" = B.color_matrix)
