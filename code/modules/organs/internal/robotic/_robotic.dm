/obj/item/organ/internal/robotic
	name = "FBP component"
	desc = "A complex piece of a much more complex machine."

	icon_state = "eyes-prosthetic"
	// It's a robotic part. Why would it reject.
	can_reject = FALSE
	// Ditto. Rust takes a while.
	decays = FALSE
	// Well of course this organ is of the robotic type.
	robotic = ORGAN_ROBOT
	// I'd like to see you try to butcher a robot.
	butcherable = FALSE
