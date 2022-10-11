//! ## This file is meant for autodoc so people know what each var does.

/**
 * A particle set is a special effect, whose computations are handled entirely on the client,
 * that spawns and tracks multiple pixels or icons with a temporary lifespan. Examples of this
 * might be confetti, sparks, rocket exhaust, or rain or snow. Particles are rendered on a special
 * surface and that gets attached to an obj or a mob like an overlay.
 *
 * Particles can exist in 3 dimensions instead of the usual 2, so a particle's position, velocity,
 * and other values may have a z coordinate. To make use of this z coordinate, you can use a projection matrix.
 * (The value of the z coordinate must be between -100 and 100 after projection. Otherwise it's not guaranteed the particle will be displayed.)
 *
 * To create a particle set, use new to create a new /particles datum, and then you can set the datum's vars.
 * The vars can be set to constant values, or generator functions that will allow the client to choose from a
 * range of values when spawning those particles.
 * (The easiest way to handle this is to create your own type that inherits from /particles, and set up the parameters you'll want at compile-time.)
 *
 * After the datum is created, it can be assigned to an obj or mob using their particles var. The particles will appear on the map wherever that obj or mob appears.
 */
/particles
//! ## Particle vars that affect the entire set (generators are not allowed for these)

	/**
	 * Width size of the particle image in pixels.
	 * * Type: number
	 */
	width = null

	/**
	 * Height size of the particle image in pixels.
	 * * Type: number
	 */
	height = null

	/**
	 * Maximum particle count.
	 * * Type: number
	 */
	count = null

	/**
	 * Number of particles to spawn per tick (can be fractional).
	 * * Type: number
	 */
	spawning = null

	/**
	 * Minimum particle position in x,y,z space; defaults to list(-1000,-1000,-1000).
	 * * Type: vector
	 */
	bound1 = null

	/**
	 * Maximum particle position in x,y,z space; defaults to list(1000,1000,1000).
	 * * Type: vector
	 */
	bound2 = null

	/**
	 * Constant acceleration applied to all particles in this set (pixels per squared tick).
	 * * Type: vector
	 */
	gravity = null

	/**
	 * Color gradient used, if any.
	 * * Type: color gradient
	 */
	gradient = null

	/**
	 * Transform done to all particles, if any (can be higher than 2D).
	 * * Type: matrix
	 */
	transform = null

//! ## Vars that apply when a particle spawns

	/**
	 * Maximum life of the particle, in ticks.
	 * * Type: number
	 */
	lifespan = null

	/**
	 * Fade-out time at end of lifespan, in ticks.
	 * * Type: number
	 */
	fade = null

	/**
	 * Fade-in time, in ticks.
	 * * Type: number
	 */
	fadein = 0

//? The icon and icon_state values are special in that they can't be assigned a generator, but they
//? can be assigned a constant icon or string, respectively, or a list of possible values to choose from.

	/**
	 * Icon to use, if any; no icon means this particle will be a dot.
	 * Can be assigned a weighted list of icon files, to choose an icon at random.
	 * * Type: icon
	 */
	icon = null

	/**
	 * Icon state to use, if any.
	 * Can be assigned a weighted list of strings, to choose an icon at random.
	 * * Type: string
	 */
	icon_state = null

	/**
	 * Particle color (not a color matrix); can be a number if a gradient is used.
	 * * Type: num or color
	 */
	color = null

	/**
	 * Color change per tick; only applies if gradient is used.
	 * * Type: number
	 */
	color_change = null

	/**
	 * 	x,y,z position, from center in pixels.
	 * * Type: number
	 */
	position = null

	/**
	 * 	x,y,z velocity, in pixels.
	 * * Type: number
	 */
	velocity = null

	/**
	 * Scale applied to icon, if used; defaults to list(1,1).
	 * * Type: vector(2D)
	 */
	scale = null

	/**
	 * Change in scale per tick; defaults to list(0,0).
	 * * Type: number
	 */
	grow = null

	/**
	 * Angle of rotation (clockwise); applies only if using an icon.
	 * * Type: number
	 */
	rotation = null

	/**
	 * Change in rotation per tick.
	 * * Type: number
	 */
	spin = null

	/**
	 * 	Amount of velocity to shed (0 to 1) per tick, also applied to acceleration from drift.
	 * * Type: number
	 */
	friction = null

//! ## Vars that are evalulated every tick.

	/**
	 * Added acceleration every tick; e.g. a circle or sphere generator can be applied to produce snow or ember effects.
	 * * Type: vector
	 */
	drift = null
