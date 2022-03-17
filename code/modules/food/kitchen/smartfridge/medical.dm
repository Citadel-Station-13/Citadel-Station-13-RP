/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	req_one_access = list(access_medical,access_chemistry)

/obj/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass/))
		return TRUE
	if(istype(O,/obj/item/storage/pill_bottle/))
		return TRUE
	if(istype(O,/obj/item/reagent_containers/pill/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	icon_contents = "misc"
	req_access = list(access_virology)

/obj/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass/beaker/vial/))
		return TRUE
	if(istype(O,/obj/item/virusdish/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/chemistry //Is this used anywhere? It's not secure.
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/storage/pill_bottle) || istype(O,/obj/item/reagent_containers))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/chemistry/virology //Same
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."
