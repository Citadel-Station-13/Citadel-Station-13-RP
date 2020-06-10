/datum/unit_test/integrated_circuits/equals_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list("Test", "Test")
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/equals_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list("Test", "Nope")
	expected_outputs = list(FALSE)

/datum/unit_test/integrated_circuits/equals_3
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list(525, 525)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/equals_4
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list(1020, -580)
	expected_outputs = list(FALSE)

/datum/unit_test/integrated_circuits/equals_5
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list(null, null)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/equals_ref
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list()
	expected_outputs = list(TRUE)
	var/turf/A = null

/datum/unit_test/integrated_circuits/equals_ref/arrange()
	A = locate(run_loc_top_right)
	inputs_to_give = list(WEAKREF(A), WEAKREF(A))
	. = ..()

/datum/unit_test/integrated_circuits/equals_ref_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/equals
	inputs_to_give = list()
	expected_outputs = list(FALSE)
	var/turf/A = null
	var/obj/B = null

/datum/unit_test/integrated_circuits/equals_ref_2/arrange()
	A = locate(run_loc_bottom_left)
	B = new /obj/item/tool/crowbar()
	inputs_to_give = list(WEAKREF(A), WEAKREF(B))
	. = ..()

/datum/unit_test/integrated_circuits/equals_ref_2/clean_up()
	qdel(B)
	. = ..()

/datum/unit_test/integrated_circuits/not_equals_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/not_equals
	inputs_to_give = list("Test", "Nope")
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/not_equals_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/not_equals
	inputs_to_give = list("Test", "Test")
	expected_outputs = list(FALSE)

/datum/unit_test/integrated_circuits/not_equals_3
	circuit_type = /obj/item/integrated_circuit/logic/binary/not_equals
	inputs_to_give = list(150, 20)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/not_equals_4
	circuit_type = /obj/item/integrated_circuit/logic/binary/not_equals
	inputs_to_give = list(100, 100)
	expected_outputs = list(FALSE)



/datum/unit_test/integrated_circuits/and_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/and
	inputs_to_give = list("One", "Two")
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/and_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/and
	inputs_to_give = list("One", null)
	expected_outputs = list(FALSE)



/datum/unit_test/integrated_circuits/or_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/or
	inputs_to_give = list("One", null)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/or_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/or
	inputs_to_give = list(null, "Two")
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/or_3
	circuit_type = /obj/item/integrated_circuit/logic/binary/or
	inputs_to_give = list("One", "Two")
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/or_4
	circuit_type = /obj/item/integrated_circuit/logic/binary/or
	inputs_to_give = list(null, null)
	expected_outputs = list(FALSE)



/datum/unit_test/integrated_circuits/less_than_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/less_than
	inputs_to_give = list(50, 100)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/less_than_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/less_than
	inputs_to_give = list(500, 50)
	expected_outputs = list(FALSE)



/datum/unit_test/integrated_circuits/less_than_or_equal_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/less_than_or_equal
	inputs_to_give = list(40, 50)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/less_than_or_equal_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/less_than_or_equal
	inputs_to_give = list(40, 40)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/less_than_or_equal_3
	circuit_type = /obj/item/integrated_circuit/logic/binary/less_than_or_equal
	inputs_to_give = list(40, 30)
	expected_outputs = list(FALSE)


/datum/unit_test/integrated_circuits/greater_than_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/greater_than
	inputs_to_give = list(100, 50)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/greater_than_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/greater_than
	inputs_to_give = list(25, 800)
	expected_outputs = list(FALSE)



/datum/unit_test/integrated_circuits/greater_than_or_equal_1
	circuit_type = /obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	inputs_to_give = list(250, 30)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/greater_than_or_equal_2
	circuit_type = /obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	inputs_to_give = list(30, 30)
	expected_outputs = list(TRUE)

/datum/unit_test/integrated_circuits/greater_than_or_equal_3
	circuit_type = /obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	inputs_to_give = list(-40, 100)
	expected_outputs = list(FALSE)



/datum/unit_test/integrated_circuits/not_1
	circuit_type = /obj/item/integrated_circuit/logic/unary/not
	inputs_to_give = list(TRUE)
	expected_outputs = list(FALSE)

/datum/unit_test/integrated_circuits/not_2
	circuit_type = /obj/item/integrated_circuit/logic/unary/not
	inputs_to_give = list(FALSE)
	expected_outputs = list(TRUE)
