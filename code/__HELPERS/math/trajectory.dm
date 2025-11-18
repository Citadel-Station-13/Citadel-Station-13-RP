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
 * * In all (valid) cases, the travel time will be computed as well.
 * * If the elevation is higher than 0, we will calculate the second crossing point, not the first.
 *   It's assumed the projectile successfully crosses into the elevation the first time.
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

	var/t_final
	var/x_vel_initial
	var/y_vel_initial
	var/x_pos_final
	var/list/q_results
	if(altitude)
		if(velocity)
			if(distance)
				// verify
				y_vel_initial = sin(altitude) * velocity
				q_results = SolveQuadratic(-gravity * 0.5, y_vel_initial, -elevation)
				// failed to solve
				if(length(q_results) != 2)
					return null
				t_final = q_results[1]
				// invalid?
				if(t_final <= 0)
					return null
				x_vel_initial = cos(altitude) * velocity
				x_pos_final = t_final * x_vel_initial
				if(abs(x_pos_final - distance) > 0.01)
					return null
				return list(altitude, velocity, x_pos_final, t_final)
			else
				// solve for dx (distance)
				y_vel_initial = sin(altitude) * velocity
				q_results = SolveQuadratic(-gravity * 0.5, y_vel_initial, -elevation)
				if(length(q_results) != 2)
					return null
				t_final = q_results[1]
				if(t_final <= 0)
					return null
				x_vel_initial = cos(altitude) * velocity
				x_pos_final = t_final * x_vel_initial
				return list(altitude, velocity, x_pos_final, t_final)
		else
			if(distance)
				// solve for v(0) (velocity)

				// y'(0) = sin(altitude) * v0
				// x' = cos(altitude) * v0
				// t = distance / x'
				// g * t^2 + y'(0) * t - elevation = 0

				// find time to max height
				// 0 = sin(alt) * v0 - g * t
				// sin(alt) * v0 = g * t
				// t = (sin(alt) * v0) / g
				// dist = x' * t
				// dist = cos(altitude) * v0 * t
				// dist = cos(altitude) * v0 * ((sin(alt) * v0) / g)
				// dist * g / cos(alt) = v0 * sin(alt) * v0
				// dist * g = v0 ^ 2 * (sin / cos)
				// dist * g = v0 ^ 2 * tan(alt)
				// v0 ^ 2 = (dist * g) / tan(alt)
				// v0 = sqrt(dist * g / tan(alt))
				velocity = sqrt(distance * gravity / tan(altitude))
				y_vel_initial = sin(altitude) * velocity
				q_results = SolveQuadratic(-gravity * 0.5, y_vel_initial, -elevation)
				if(length(q_results) != 2)
					return null
				t_final = q_results[1]
				if(t_final <= 0)
					return null
				return list(altitude, velocity, distance, t_final)
			else
				CRASH("kinematic trajectory requires altitude/velocity/distance, only got altitude")

	else
		if(velocity)
			if(distance)
				// solve for angle up from horizon (altitude)

				// 0 = sin(alt) * v0 - g * t
				// sin(alt) * v0 = g * t
				// t = (sin(alt) * v0) / g

				// dist = x' * t
				#warn impl
				return list(angle_up, velocity, distance, t_final)
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got velocity")
		else
			if(distance)
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got distance")
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, got none of the above")
