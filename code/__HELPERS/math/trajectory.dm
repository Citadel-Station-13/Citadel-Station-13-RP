//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Solves missing variables of a kinematic trajectory.
 *
 * These must be present:
 * * gravity

 * 2 of the 3 must be present:
 * * altitude
 * * velocity
 * * distance (from source)
 *
 * If all 3 are present, we will instead verify things are correct.
 *
 * * In all (valid) cases, the travel time will be computed as well.
 *
 * @params
 * * altitude - degrees upwards from horizon
 * * velocity - initial velocity in m/s
 * * distance - distance from source
 * * gravity - acceleration from gravity in m/s^2
 *
 * @return list(altitude, velocity, distance, travel time), or null if failed
 */
// TODO: This doesn't work for solving velocity from altitude and distance. That,
//       and it goes a little too fast for things like mortars.
//       We might be able to revive this, maybe multiply flight time by 20-30 or something,
//       but even then it's a long shot.
//       Investigate this later.
/*
/proc/math__solve_kinematic_trajectory(altitude, velocity, distance, gravity)
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
				q_results = SolveQuadratic(-gravity * 0.5, y_vel_initial, 0)
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
				q_results = SolveQuadratic(-gravity * 0.5, y_vel_initial, 0)
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
				q_results = SolveQuadratic(-gravity * 0.5, y_vel_initial, 0)
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

				// t = xf / x'
				// t = dist / cos(alt)

				// 0 = sin(alt) + grav * (t / 2)
				// 0 = sin(alt) + grav * dist / (2 * cos(alt))
				// -sin(alt) = grav * dist / (2 * cos(alt))
				// 2 sin(alt) = -grav * dist / cos(alt)
				// 2 sin(alt) cos(alt) = -(grav * dist)

				// AAAAAAAAAAAAAA PUTNAM HELPIES
				// jk
				// (sin(2alt) * v^2 ) / (grav) = dist
				// sin(2alt) * velocity^2 = dist * grav
				// sin(2alt) = (dist * grav) / v^2
				// 2alt = arcsin((dist*grav) / v^2)
				// alt = arcsin((dist*grav) / v^2) / 2
				altitude = arcsin((distance * gravity) / (velocity ** 2)) / 2
				x_vel_initial = cos(altitude) * velocity
				t_final = distance / x_vel_initial
				return list(altitude, velocity, distance, t_final)
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got velocity")
		else
			if(distance)
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, only got distance")
			else
				CRASH("kinematic trajectory requires azimuth/altitude/velocity, got none of the above")
*/

/**
 * Solves for angle needed to intercept a target when an interceptor is fired with
 * a given velocity.
 *
 * * Input must include source / target positions.
 * * Input must include source velocity as a scalar
 * * Input must include target velocity as a vector
 * * Returned angle is clockwise of north
 *
 * @return list(angle, predicted time), or null if no solution found
 */
/proc/math__solve_intercept_trajectory(vector/source, vector/target, source_speed, vector/target_vel)
	// 0 = (vt^2 - vs^2) * t^2 + 2 * (pt - ps) * vt * t + (pt - ps)^2
	// with dot product'd as needed to convert into scalars
	// i have no clue why this works yet but it does lol

	var/vector/offset = target - source
	var/a = (target_vel.Dot(target_vel) - source_speed ** 2)
	var/b = 2 * (target_vel.Dot(offset))
	var/c = offset.Dot(offset)

	var/list/results = SolveQuadratic(a, b, c)
	var/time

	// we want the smaller number
	// return null if intercept is impossible
	switch(length(results))
		if(1)
			time = results[1] > 0 ? results[1] : null
		if(2)
			if(results[1] < 0)
				if(results[2] < 0)
					// both invalid
				else
					// 2 valid
					time = results[2]
			else
				if(results[2] < 0)
					// 1 valid
					time = results[1]
				else
					// both valid
					time = results[2] < results[1] ? results[2] : results[1]

	// if we don't have a time, we will never intersect
	if(!time)
		return

	// solve for angle
	var/vector/intersection_point = target + target_vel * time
	return list(arctan(intersection_point[2]), time)
