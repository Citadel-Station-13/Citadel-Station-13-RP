//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* global balancing defines *//

/// unlike explosions, emp use a uniform maximum and minimum nominal power
/// and handle themselves via falloff.
///
/// this is because we inherently expect EMPs to be spammed.
/// * code may go above / below if needed, when emitting emps
/// * receiving code may ignore values above / below freely.
/// * power should never be below 0.

#define EMP_NOMINAL_POWER_MAX 100
#define EMP_NOMINAL_POWER_MIN 0

/**
 * max nominal power is 100, min is 0
 */
#define EMP_GET_POWER_PERCENT(POWER) ((POWER / 100) * 100)
/**
 * max nominal power is 1, min is 0
 */
#define EMP_GET_POWER_RATIO(POWER) (POWER / 100)

/**
 * Fast lookup for legacy emp severity to power
 */
#define EMP_LEGACY_SEVERITY_TO_POWER(SEVERITY) global._legacy_emp_severity_to_power[SEVERITY]
/**
 * Fast lookup for legacy emp severity to power
 */
GLOBAL_REAL_LIST(_legacy_emp_severity_to_power) = list(
	100,
	70,
	42.5,
	12.5,
	6.5,
	0,
	0,
	0,
	0,
	0,
	0,
)
