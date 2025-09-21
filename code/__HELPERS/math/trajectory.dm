//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Solves missing variables of a kinematic trajectory.
 *
 * These must be present:
 * * elevation (impact elevation)
 * * gravity

 * 2 of the 3 must be present:
 * * altitude
 * * velocity
 * * distance (from source)
 *
 * If all 3 are present, we will instead verify things are correct.
 *
 * In all cases, the travel time will be computed as well.
 *
 * @params
 * * altitude - degrees upwards from horizon
 * * velocity - initial velocity in m/s
 * * distance - distance from source
 * * elevation - impact elevation, as meter offset up / down from starting position.
 * * gravity - acceleration from gravity in m/s^2
 *
 * @return list(altitude, velocity, distance, travel time), or null if failed
 */
/proc/math__solve_kinematic_trajectory(altitude, velocity, distance, elevation, gravity)
	#warn test the shit out of this proc
	#warn impl

	// g = gravity
	// vx, vy = velocity
	// t = time passed in seconds

	if(altitude)
		if(velocity)
			if(distance)
				// verify
			else
				// solve for dx (distance)
		else
			if(distance)
				// solve for v(0) (velocity)
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got altitude")

	else
		if(velocity)
			if(distance)
				// solve for angle up from horizon (elevation)
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got velocity")
		else
			if(distance)
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got distance")
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, got none of the above")

	// travel time is just when y = elevation

	// vy(t) = vy(0) - g*t
	// y(t) = F(vy(t)) = v(0) - g*t dt
	// y(t) = (vy(0) * t)  - (g * (t^2 / 2))

	// y(t) = elevation
	// solve for t

	// 0 = -(t^2 * g * 0.5) + (t * vy(0)) - elevation
	var/velocity_y_initial = sin(velocity) * elevation
	var/travel_time = SolveQuadratic(-gravity * 0.5, velocity_y_initial, -elevation)

	return list(altitude, velocity, distance, travel_time)
