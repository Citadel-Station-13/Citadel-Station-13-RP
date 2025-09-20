//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Calculate offset as list(x, y) in meters of a fired round with a given
 * azimuth (clockwise from north) and elevation (upwards from horizontal / flat)
 *
 * @params
 * * azimuth - degrees CW from north
 * * altitude - degrees upwards from horizon
 * * velocity - initial velocity in m/s
 * * elevation - impact elevation, as meter offset up / down from starting position.
 * * gravity - acceleration from gravity in m/s^2
 *
 * @return list(x in meters, y in meters, time in deciseconds)
 */
/proc/math__run_kinematic_trajectory(azimuth, altitude, velocity, elevation, gravity)
	#warn impl

/**
 * Calculate necessary launch parameters to hit a given thing.
 *
 * @params
 * * dx - x-offset from firing position
 * * dy - y-offset from firing position
 * * elevation - impact elevation, as meter offset up / down from starting position.
 * * gravity - acceleration from gravity in m/s^2
 *
 * @return list(azimuth, altitude, velocity)
 */
/proc/math__solve_kinematic_trajectory(dx, dy, elevation, gravity)
	#warn impl
