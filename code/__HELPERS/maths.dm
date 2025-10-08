
/**
 * Formats a number into a list representing the si unit.
 * Access the coefficient with [SI_COEFFICIENT], and access the unit with [SI_UNIT].
 *
 * Supports SI exponents between 1e-15 to 1e15, but properly handles numbers outside that range as well.
 * Arguments:
 * * value - The number to convert to text. Can be positive or negative.
 * * unit - The base unit of the number, such as "Pa" or "W".
 * * maxdecimals - Maximum amount of decimals to display for the final number. Defaults to 1.
 * Returns: [SI_COEFFICIENT = si unit coefficient, SI_UNIT = prefixed si unit.]
 */
/proc/siunit_isolated(value, unit, maxdecimals=1)
	var/static/list/prefixes = list("q","r","y","z","a","f","p","n","μ","m","","k","M","G","T","P","E","Z","Y","R","Q")

	// We don't have prefixes beyond this point
	// and this also captures value = 0 which you can't compute the logarithm for
	// and also byond numbers are floats and doesn't have much precision beyond this point anyway
	if(abs(value) < 1e-30)
		. = list(SI_COEFFICIENT = 0, SI_UNIT = " [unit]")
		return

	var/exponent = clamp(log(10, abs(value)), -30, 30) // Calculate the exponent and clamp it so we don't go outside the prefix list bounds
	var/divider = 10 ** (round(exponent / 3) * 3) // Rounds the exponent to nearest SI unit and power it back to the full form
	var/coefficient = round(value / divider, 10 ** -maxdecimals) // Calculate the coefficient and round it to desired decimals
	var/prefix_index = round(exponent / 3) + 11 // Calculate the index in the prefixes list for this exponent

	// An edge case which happens if we round 999.9 to 0 decimals for example, which gets rounded to 1000
	// In that case, we manually swap up to the next prefix if there is one available
	if(coefficient >= 1000 && prefix_index < 21)
		coefficient /= 1e3
		prefix_index++

	var/prefix = prefixes[prefix_index]
	. = list(SI_COEFFICIENT = coefficient, SI_UNIT = " [prefix][unit]")

/**Format a power value in prefixed watts.
 * Converts from energy if convert is true.
 * Args:
 * - power: The value of power to format.
 * - convert: Whether to convert this from joules.
 * - datum/controller/subsystem/scheduler: used in the conversion
 * Returns: The string containing the formatted power.
 */
/proc/display_power(power, convert = TRUE, datum/controller/subsystem/scheduler = SSmachines)
	power = convert ? energy_to_power(power, scheduler) : power
	return siunit(power, "W", 3)

/**
 * Format an energy value in prefixed joules.
 * Arguments
 *
 * * units - the value t convert
 */
/proc/display_energy(units)
	return siunit(units, "J", 3)

/**
 * Converts the joule to the watt, assuming SSmachines tick rate.
 * Arguments
 *
 * * joules - the value in joules to convert
 * * datum/controller/subsystem/scheduler - the subsystem whos wait time is used in the conversion
 */
/proc/energy_to_power(joules, datum/controller/subsystem/scheduler = SSmachines)
	return joules * (1 SECONDS) / scheduler.wait
