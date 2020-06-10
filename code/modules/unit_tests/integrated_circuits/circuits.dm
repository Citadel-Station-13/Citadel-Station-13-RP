
/datum/unit_test/integrated_circuits
	var/obj/item/integrated_circuit/circuit_type = null
	var/obj/item/integrated_circuit/IC = null
	var/list/inputs_to_give = list()
	var/list/expected_outputs = list()

/// Set-up the circuit
/datum/unit_test/integrated_circuits/proc/arrange()
	IC = new circuit_type(locate(run_loc_top_right)) // Make the circuit
	IC.cooldown_per_use = 0

/// Delete the circuit (del should clean this up)
/datum/unit_test/integrated_circuits/proc/clean_up()
	qdel(IC)

// Override this if needing special output (e.g. rounding to avoid floating point fun).
/datum/unit_test/integrated_circuits/proc/assess(round = FALSE)
	var/output_wrong = FALSE
	var/i = 1
	for(var/datum/integrated_io/io in IC.outputs)
		var iodata = round ? round(io.data) : io.data
		if(iodata != expected_outputs[i])
			Fail("[io.name] did not match expected output of [expected_outputs[i]].  Output was [isnull(io.data) ? "NULL" : io.data].")
			output_wrong = TRUE
		i++
	return output_wrong

// Useful when doing floating point fun.
/datum/unit_test/integrated_circuits/floor/assess()
	. = ..(TRUE)

/datum/unit_test/integrated_circuits/Run()
	if(!circuit_type)
		Fail("One of the unit test did not supply a circuit_type path.")
		return TRUE

	// Build the circuit
	arrange()

	// Apply input in the input section of the circuit
	var/i = 1
	for(var/input in inputs_to_give)
		var/datum/integrated_io/io = IC.inputs[i]
		io.write_data_to_pin(input)
		i++

	// Act
	IC.do_work()
	assess()
	clean_up()
	return TRUE
