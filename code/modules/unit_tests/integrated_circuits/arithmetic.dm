/*
 * Addition
 */
/datum/unit_test/integrated_circuits/additon_single
	circuit_type = /obj/item/integrated_circuit/arithmetic/addition
	inputs_to_give = list(25, 75)
	expected_outputs = list(100)

/datum/unit_test/integrated_circuits/additon_multiple
	circuit_type = /obj/item/integrated_circuit/arithmetic/addition
	inputs_to_give = list(7, 5, 3, 26, 974, -51, 77, 0)
	expected_outputs = list(1041)

/*
 * Subtraction
 */
/datum/unit_test/integrated_circuits/subtraction_single
	circuit_type = /obj/item/integrated_circuit/arithmetic/subtraction
	inputs_to_give = list(20, 15)
	expected_outputs = list(5)

/datum/unit_test/integrated_circuits/subtraction_multiple
	circuit_type = /obj/item/integrated_circuit/arithmetic/subtraction
	inputs_to_give = list(5, 50, 30)
	expected_outputs = list(-75)

/*
 * Multiplication
 */
/datum/unit_test/integrated_circuits/multiplication_single
	circuit_type = /obj/item/integrated_circuit/arithmetic/multiplication
	inputs_to_give = list(5, 20)
	expected_outputs = list(100)

/datum/unit_test/integrated_circuits/multiplication_multiple
	circuit_type = /obj/item/integrated_circuit/arithmetic/multiplication
	inputs_to_give = list(2, 10, 20)
	expected_outputs = list(400)

/datum/unit_test/integrated_circuits/multiplication_float
	circuit_type = /obj/item/integrated_circuit/arithmetic/multiplication
	inputs_to_give = list(100, 0.5)
	expected_outputs = list(50)

/*
 * Division
 */
/datum/unit_test/integrated_circuits/division_single
	circuit_type = /obj/item/integrated_circuit/arithmetic/division
	inputs_to_give = list(100, 5)
	expected_outputs = list(20)

/datum/unit_test/integrated_circuits/division_multiple
	circuit_type = /obj/item/integrated_circuit/arithmetic/division
	inputs_to_give = list(500, 100, 10)
	expected_outputs = list(0.5)

/datum/unit_test/integrated_circuits/division_float
	circuit_type = /obj/item/integrated_circuit/arithmetic/division
	inputs_to_give = list(100, 0.5)
	expected_outputs = list(200)

/*
 * Exponent/Power
 */
/datum/unit_test/integrated_circuits/exponent_single_1
	circuit_type = /obj/item/integrated_circuit/arithmetic/exponent
	inputs_to_give = list(20, 2)
	expected_outputs = list(400)

/datum/unit_test/integrated_circuits/exponent_single_2
	circuit_type = /obj/item/integrated_circuit/arithmetic/exponent
	inputs_to_give = list(5, 4)
	expected_outputs = list(625)

/*
 * Sign
 */
/datum/unit_test/integrated_circuits/sign_positive
	circuit_type = /obj/item/integrated_circuit/arithmetic/sign
	inputs_to_give = list(5)
	expected_outputs = list(1)

/datum/unit_test/integrated_circuits/sign_negative
	circuit_type = /obj/item/integrated_circuit/arithmetic/sign
	inputs_to_give = list(-500)
	expected_outputs = list(-1)

/datum/unit_test/integrated_circuits/sign_zero
	circuit_type = /obj/item/integrated_circuit/arithmetic/sign
	inputs_to_give = list(0)
	expected_outputs = list(0)

/*
 * Round
 */
/datum/unit_test/integrated_circuits/round_basic
	circuit_type = /obj/item/integrated_circuit/arithmetic/round
	inputs_to_give = list(4.25)
	expected_outputs = list(4)

/datum/unit_test/integrated_circuits/round_floor
	circuit_type = /obj/item/integrated_circuit/arithmetic/round
	inputs_to_give = list(8.95)
	expected_outputs = list(8)

/datum/unit_test/integrated_circuits/round_to_n
	circuit_type = /obj/item/integrated_circuit/arithmetic/round
	inputs_to_give = list(45.68, 0.1)
	expected_outputs = list(45.7)

/*
 * Absolute
 */
/datum/unit_test/integrated_circuits/abs_positive
	circuit_type = /obj/item/integrated_circuit/arithmetic/absolute
	inputs_to_give = list(50)
	expected_outputs = list(50)

/datum/unit_test/integrated_circuits/abs_negative
	circuit_type = /obj/item/integrated_circuit/arithmetic/absolute
	inputs_to_give = list(-20)
	expected_outputs = list(20)

/datum/unit_test/integrated_circuits/abs_zero
	circuit_type = /obj/item/integrated_circuit/arithmetic/absolute
	inputs_to_give = list(0)
	expected_outputs = list(0)

/*
 * Average
 */
/datum/unit_test/integrated_circuits/average_1
	circuit_type = /obj/item/integrated_circuit/arithmetic/average
	inputs_to_give = list(8, 20, 14, 6)
	expected_outputs = list(12)

/datum/unit_test/integrated_circuits/average_2
	circuit_type = /obj/item/integrated_circuit/arithmetic/average
	inputs_to_give = list(30, -5, 8, -50, 4)
	expected_outputs = list(-2.6)


/*
 * Square Root
 */
/datum/unit_test/integrated_circuits/sqrt_1
	circuit_type = /obj/item/integrated_circuit/arithmetic/square_root
	inputs_to_give = list(64)
	expected_outputs = list(8)

/*
 * Modulo
 */
/datum/unit_test/integrated_circuits/mod_1
	circuit_type = /obj/item/integrated_circuit/arithmetic/modulo
	inputs_to_give = list(8, 5)
	expected_outputs = list(3)

/datum/unit_test/integrated_circuits/mod_2
	circuit_type = /obj/item/integrated_circuit/arithmetic/modulo
	inputs_to_give = list(20, 5)
	expected_outputs = list(0)
