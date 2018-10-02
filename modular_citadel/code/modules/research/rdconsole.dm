/obj/machinery/computer/rdconsole
	req_access = list(access_tox)	//Data and setting manipulation requires scientist access.

/obj/machinery/computer/rdconsole/Topic(href, href_list)
	if((href_list["lock"] || href_list["unlock"] || (screen == 1.6 && href_list["menu"] != "1.0")) && !allowed(usr))
		usr << "Unauthorized Access"
		return;
	..()