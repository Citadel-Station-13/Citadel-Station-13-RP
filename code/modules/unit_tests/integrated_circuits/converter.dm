/datum/unit_test/integrated_circuits/num2text
	circuit_type = /obj/item/integrated_circuit/converter/num2text
	inputs_to_give = list(10250)
	expected_outputs = list("10250")

/datum/unit_test/integrated_circuits/text2num
	circuit_type = /obj/item/integrated_circuit/converter/text2num
	inputs_to_give = list("2005")
	expected_outputs = list(2005)


/datum/unit_test/integrated_circuits/lowercase
	circuit_type = /obj/item/integrated_circuit/converter/lowercase
	inputs_to_give = list("Lorem ipsum...")
	expected_outputs = list("lorem ipsum...")

/datum/unit_test/integrated_circuits/uppercase
	circuit_type = /obj/item/integrated_circuit/converter/uppercase
	inputs_to_give = list("Lorem ipsum...")
	expected_outputs = list("LOREM IPSUM...")


/datum/unit_test/integrated_circuits/concatenator
	circuit_type = /obj/item/integrated_circuit/converter/concatenator
	inputs_to_give = list("Lorem", " ", "ipsum", "...")
	expected_outputs = list("Lorem ipsum...")


/datum/unit_test/integrated_circuits/floor/radians2degrees
	circuit_type = /obj/item/integrated_circuit/converter/radians2degrees
	inputs_to_give = list(1.57)
	expected_outputs = list(89) // 89.95437

/datum/unit_test/integrated_circuits/floor/degrees2radians
	circuit_type = /obj/item/integrated_circuit/converter/degrees2radians
	inputs_to_give = list(90)
	expected_outputs = list(1) // 1.570796
